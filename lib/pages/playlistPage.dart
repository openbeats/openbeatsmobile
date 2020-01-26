import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/playlistPageW.dart' as playlistPageW;
import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;
import '../globalWids.dart' as globalWids;

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);
MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);

class PlaylistPage extends StatefulWidget {
  String playlistName, playlistId;
  PlaylistPage(this.playlistName, this.playlistId);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final GlobalKey<ScaffoldState> _playlistsPageScaffoldKey =
      new GlobalKey<ScaffoldState>();

  // holds the flag to mark the page as loading or loaded
  bool _isLoading = true, _noInternet = false;
  // holds the response data from playlist songs request
  var dataResponse;

  // gets all the music in the playlist
  void getPlaylistContents() async {
    setState(() {
      _isLoading = true;
      _noInternet = false;
    });
    try {
      var response = await http.get(
          "https://api.openbeats.live/playlist/userplaylist/getplaylist/" +
              widget.playlistId);
      dataResponse = json.decode(response.body);
      if (dataResponse["status"] == true) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        _noInternet = true;
      });
      print(err);
      globalFun.showToastMessage(
          "Not able to connect to server", Colors.red, Colors.white);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future startAudioService() async {
    await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      resumeOnClick: true,
      androidNotificationChannelName: 'OpenBeats Notification Channel',
      notificationColor: 0xFF000000,
      enableQueue: true,
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'drawable/ic_stat_logoicon2',
    );
  }

  // function to start selected music and add the rest to playlist
  // index is the index of the clicked item
  Future startPlaylistFromMusic(index) async {
    await AudioService.stop();
    await startAudioService();
    var parameters = {
      "currIndex": index,
      "allSongs": dataResponse["data"]["songs"]
    };
    await AudioService.customAction(
        "startMusicPlaybackAndCreateQueue", parameters);
  }

  void connect() async {
    await AudioService.connect();
  }

  void disconnect() {
    AudioService.disconnect();
  }

  @override
  void initState() {
    super.initState();
    connect();
    getPlaylistContents();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: _playlistsPageScaffoldKey,
      child: Scaffold(
        appBar: playlistPageW.appBarW(
            context, _playlistsPageScaffoldKey, widget.playlistName),
        backgroundColor: globalVars.primaryDark,
        body: Container(
            width: MediaQuery.of(context).size.height * 0.99,
            child: (_noInternet)
                ? globalWids.noInternetView(getPlaylistContents)
                : (_isLoading)
                    ? playlistPageW.playlistsLoading()
                    : playlistPageBody()),
      ),
    );
  }

  Widget playlistPageBody() {
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: RaisedButton(
            onPressed: () async {
              await AudioService.stop();
              await startAudioService();
              // calling method to add songs to the background list
              await AudioService.customAction(
                  "addSongsToList", dataResponse["data"]["songs"]);
            },
            padding: EdgeInsets.all(20.0),
            shape: StadiumBorder(),
            child: Text("Shuffle All"),
            color: globalVars.accentGreen,
            textColor: globalVars.accentWhite,
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: dataResponse["data"]["songs"].length,
          itemBuilder: (context, index) {
            return playlistPageW.vidResultContainerW(
                context,
                dataResponse["data"]["songs"][index],
                index,
                startPlaylistFromMusic);
          },
        )
      ],
    );
  }
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioPlayerTask extends BackgroundAudioTask {
  final _queue = <MediaItem>[];
  int _queueIndex = -1;
  AudioPlayer _audioPlayer = new AudioPlayer();
  Completer _completer = Completer();
  BasicPlaybackState _skipState;
  bool _playing;

  bool get hasNext => _queueIndex + 1 < _queue.length;

  bool get hasPrevious => _queueIndex > 0;

  MediaItem get mediaItem => _queue[_queueIndex];

  BasicPlaybackState _stateToBasicState(AudioPlaybackState state) {
    switch (state) {
      case AudioPlaybackState.none:
        return BasicPlaybackState.none;
      case AudioPlaybackState.stopped:
        return BasicPlaybackState.stopped;
      case AudioPlaybackState.paused:
        return BasicPlaybackState.paused;
      case AudioPlaybackState.playing:
        return BasicPlaybackState.playing;
      case AudioPlaybackState.buffering:
        return BasicPlaybackState.buffering;
      case AudioPlaybackState.connecting:
        return _skipState ?? BasicPlaybackState.connecting;
      case AudioPlaybackState.completed:
        return BasicPlaybackState.stopped;
      default:
        throw Exception("Illegal state");
    }
  }

  @override
  Future<void> onStart() async {
    var playerStateSubscription = _audioPlayer.playbackStateStream
        .where((state) => state == AudioPlaybackState.completed)
        .listen((state) {
      _handlePlaybackCompleted();
    });
    var eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      final state = _stateToBasicState(event.state);
      if (state != BasicPlaybackState.stopped) {
        _setState(
          state: state,
          position: event.position.inMilliseconds,
        );
      }
    });

    // AudioServiceBackground.setQueue(_queue);
    // await onSkipToNext();
    await _completer.future;
    playerStateSubscription.cancel();
    eventSubscription.cancel();
  }

  void _handlePlaybackCompleted() {
    if (hasNext) {
      onSkipToNext();
    } else {
      onStop();
    }
  }

  void playPause() {
    if (AudioServiceBackground.state.basicState == BasicPlaybackState.playing)
      onPause();
    else
      onPlay();
  }

  @override
  Future<void> onSkipToNext() => _skip(1);

  @override
  Future<void> onSkipToPrevious() => _skip(-1);

  Future<void> _skip(int offset) async {
    final newPos = _queueIndex + offset;
    if (!(newPos >= 0 && newPos < _queue.length)) return;
    if (_playing == null) {
      // First time, we want to start playing
      _playing = true;
    } else if (_playing) {
      // Stop current item
      await _audioPlayer.stop();
    }
    // Load next item
    _queueIndex = newPos;
    AudioServiceBackground.setMediaItem(mediaItem);
    _skipState = offset > 0
        ? BasicPlaybackState.skippingToNext
        : BasicPlaybackState.skippingToPrevious;
    await _audioPlayer.setUrl(mediaItem.id);
    _skipState = null;
    // Resume playback if we were playing
    if (_playing) {
      onPlay();
    } else {
      _setState(state: BasicPlaybackState.paused);
    }
  }

  @override
  void onPlay() {
    if (_skipState == null) {
      _playing = true;
      _audioPlayer.play();
    }
  }

  @override
  void onPause() {
    if (_skipState == null) {
      _playing = false;
      _audioPlayer.pause();
    }
  }

  @override
  void onAudioFocusLost() async {
    onPause();
  }

  @override
  void onAudioBecomingNoisy() {
    onPause();
  }

  @override
  void onAudioFocusLostTransient() async {
    _audioPlayer.setVolume(0);
  }

  @override
  void onAudioFocusLostTransientCanDuck() async {
    _audioPlayer.setVolume(0);
  }

  @override
  void onAudioFocusGained() async {
    _audioPlayer.setVolume(1.0);
  }

  @override
  void onCustomAction(String action, var parameters) async {
    // if condition to add all songs to the list
    if (action == "addSongsToList") {
      List<dynamic> songsList = parameters;
      for (int i = 0; i < songsList.length; i++) {
        await getMp3URL(songsList[i], true);
      }
    } else if (action == "startMusicPlaybackAndCreateQueue") {
      var passedParameters = parameters;
      await getMp3URL(
          passedParameters["allSongs"][passedParameters["currIndex"]], true);
      for (int i = 0; i < passedParameters["allSongs"].length; i++) {
        if (i == passedParameters["currIndex"]) continue;
        await getMp3URL(passedParameters["allSongs"][i], false);
      }
    }
  }

  // gets the mp3URL using videoID and i parameter to start playback on true
  Future getMp3URL(parameter, bool shouldPlay) async {
    // holds the responseJSON for checking link validity
    var responseJSON;
    // getting the mp3URL
    try {
      // checking for link validity
      String url = "https://api.openbeats.live/opencc/" +
          parameter["videoId"].toString();
      // sending GET request
      responseJSON = await Dio().get(url);
    } catch (e) {
      // catching dio error
      if (e is DioError) {
        globalFun.showToastMessage(
            "Cannot connect to the server", Colors.red, Colors.white);
        return;
      }
    }
    if (responseJSON.data["status"] == true) {
      MediaItem mediaItem = MediaItem(
        id: responseJSON.data["link"],
        album: "OpenBeats Free Music",
        title: parameter['title'],
        duration: getDurationMillis(parameter["duration"]),
        artist: parameter['channelName'],
        artUri: parameter['thumbnail'],
      );
      _queue.add(mediaItem);
      AudioServiceBackground.setQueue(_queue);
      if (shouldPlay) {
        await onSkipToNext();
      }
    }
  }

  // returns the max duration of the media in milliseconds
  int getDurationMillis(String audioDuration) {
    // variable holding max value
    double maxVal = 0;
    // holds the integerDurationList
    List durationLst = new List();
    // converting duration value into list
    List durationStringLst = audioDuration.toString().split(':');
    // converting list into integer
    durationStringLst.forEach((f) {
      durationLst.add(int.parse(f));
    });
    // creating seconds value based on the durationLst
    // looping through each value from last value
    for (int i = durationLst.length - 1; i > -1; i--) {
      // add seconds just as they are
      if (i == durationLst.length - 1)
        maxVal += durationLst[i] * 1000;
      // add minutes by multiplying with 60
      else if (i == durationLst.length - 2)
        maxVal += (60000 * durationLst[i]);
      // add hours by multiplying twice with 60
      else if (i == durationLst.length - 3)
        maxVal += (3600000 * durationLst[i]);
    }
    return maxVal.toInt();
  }

  @override
  void onSeekTo(int position) {
    _audioPlayer.seek(Duration(milliseconds: position));
  }

  @override
  void onClick(MediaButton button) {
    playPause();
  }

  @override
  void onStop() {
    _audioPlayer.stop();
    _setState(state: BasicPlaybackState.stopped);
    _completer.complete();
  }

  void _setState({@required BasicPlaybackState state, int position}) {
    if (position == null) {
      position = _audioPlayer.playbackEvent.position.inMilliseconds;
    }
    AudioServiceBackground.setState(
      controls: getControls(state),
      systemActions: [MediaAction.seekTo],
      basicState: state,
      position: position,
    );
  }

  List<MediaControl> getControls(BasicPlaybackState state) {
    if (_playing) {
      return [
        skipToPreviousControl,
        pauseControl,
        stopControl,
        skipToNextControl
      ];
    } else {
      return [
        skipToPreviousControl,
        playControl,
        stopControl,
        skipToNextControl
      ];
    }
  }
}
