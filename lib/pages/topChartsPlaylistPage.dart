import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
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

class TopChartPlaylistPage extends StatefulWidget {
  String playlistName, playlistId, playlistThumbnail;
  TopChartPlaylistPage(
      this.playlistName, this.playlistId, this.playlistThumbnail);

  @override
  _TopChartPlaylistPageState createState() => _TopChartPlaylistPageState();
}

class _TopChartPlaylistPageState extends State<TopChartPlaylistPage> {
  final GlobalKey<ScaffoldState> _topChartPlaylistPageScaffoldKey =
      new GlobalKey<ScaffoldState>();
  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);

  // holds the flag to mark the page as loading or loaded
  bool _isLoading = true, _noInternet = false;
  // holds the response data from playlist songs request
  var dataResponse;

  // function that calls the bottomSheet
  void settingModalBottomSheet(context) async {
    if (AudioService.currentMediaItem != null) {
      // bottomSheet definition
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(globalVars.borderRadius),
            topRight: Radius.circular(globalVars.borderRadius),
          )),
          context: context,
          elevation: 10.0,
          builder: (BuildContext bc) {
            return globalWids.bottomSheet(context, _dragPositionSubject);
          });
    }
  }

  // function to monitor the playback start point to remove snackbar
  void monitorPlaybackStart() async {
    Timer.periodic(
        Duration(milliseconds: 500),
        (Timer t) => {
              if (AudioService.playbackState != null &&
                  AudioService.playbackState.basicState ==
                      BasicPlaybackState.playing &&
                  _topChartPlaylistPageScaffoldKey.currentState != null &&
                  _topChartPlaylistPageScaffoldKey
                      .currentState.hasFloatingActionButton)
                {
                  t.cancel(),
                  _topChartPlaylistPageScaffoldKey.currentState
                      .removeCurrentSnackBar()
                }
            });
  }

  // gets all the music in the playlist
  void getPlaylistContents() async {
    setState(() {
      _isLoading = true;
      _noInternet = false;
    });
    try {
      var response = await http.get(
          "https://api.openbeats.live/playlist/topcharts/" + widget.playlistId);
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
    // show link-fetching snackBar
    globalFun.showSnackBars(7, _topChartPlaylistPageScaffoldKey, context);
    // monitoring playback state to close the snackbar when playback starts
    monitorPlaybackStart();
    if (AudioService.playbackState != null) {
      await AudioService.stop();
      Timer(Duration(milliseconds: 500), () async {
        await startAudioService();
        var parameters = {
          "currIndex": index,
          "allSongs": dataResponse["chart"]["songs"]
        };
        await AudioService.customAction(
            "startMusicPlaybackAndCreateQueue", parameters);
      });
    } else {
      await startAudioService();
      var parameters = {
        "currIndex": index,
        "allSongs": dataResponse["chart"]["songs"]
      };
      await AudioService.customAction(
          "startMusicPlaybackAndCreateQueue", parameters);
    }
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
      child: Scaffold(
        key: _topChartPlaylistPageScaffoldKey,
        floatingActionButton: globalWids.fabView(
            settingModalBottomSheet, _topChartPlaylistPageScaffoldKey),
        backgroundColor: globalVars.primaryDark,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              playlistPageW.appBarW(context, _topChartPlaylistPageScaffoldKey,
                  widget.playlistName, widget.playlistThumbnail),
            ];
          },
          body: Container(
              child: (_noInternet)
                  ? globalWids.noInternetView(getPlaylistContents)
                  : (_isLoading)
                      ? playlistPageW.playlistsLoading()
                      : (dataResponse != null &&
                              dataResponse["chart"]["songs"].length != 0)
                          ? playlistPageBody()
                          : playlistPageW.noSongsMessage()),
        ),
      ),
    );
  }

  Widget playlistPageBody() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        shuffleAllBtn(),
        SizedBox(
          height: 30.0,
        ),
        playlistPageListViewBody(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
      ],
    );
  }

  Widget playlistPageListViewBody() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: dataResponse["chart"]["songs"].length,
      itemBuilder: (context, index) {
        return globalWids.topChartsPlaylistPageVidResultContainerW(
            context,
            dataResponse["chart"]["songs"][index],
            index,
            startPlaylistFromMusic);
      },
    );
  }

  Widget shuffleAllBtn() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: RaisedButton(
        onPressed: () async {
          try {
            final result = await InternetAddress.lookup('example.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              // show link-fetching snackBar
              globalFun.showSnackBars(
                  7, _topChartPlaylistPageScaffoldKey, context);
              // monitoring playback state to close the snackbar when playback starts
              monitorPlaybackStart();
              if (AudioService.playbackState != null) {
                await AudioService.stop();
                Timer(Duration(milliseconds: 500), () async {
                  await startAudioService();
                  // calling method to add songs to the background list
                  await AudioService.customAction(
                      "addSongsToList", dataResponse["chart"]["songs"]);
                });
              } else {
                await startAudioService();
                // calling method to add songs to the background list
                await AudioService.customAction(
                    "addSongsToList", dataResponse["chart"]["songs"]);
              }
            }
          } on SocketException catch (_) {
            globalFun.showNoInternetToast();
          }
        },
        padding: EdgeInsets.all(20.0),
        shape: StadiumBorder(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.shuffle,
              size: 20.0,
            ),
            SizedBox(width: 10.0),
            Text(
              "Shuffle All",
              style: TextStyle(fontSize: 20.0),
            )
          ],
        ),
        color: globalVars.accentGreen,
        textColor: globalVars.accentWhite,
      ),
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
      _queueIndex = -1;
      onSkipToNext();
      // onStop();
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
    if (_queueIndex == (_queue.length - 1) && offset == 1) {
      _queueIndex = -1;
    } else if (_queueIndex == 0 && offset == -1) {
      _queueIndex = _queue.length - 1;
    }
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
    // if condition to add all songs to the list and start playback
    if (action == "addSongsToList") {
      List<dynamic> songsList = parameters;
      for (int i = 0; i < songsList.length; i++) {
        if (i == 0)
          getMp3URL(songsList[i], true);
        else
          getMp3URL(songsList[i], false);
      }
    } else if (action == "startMusicPlaybackAndCreateQueue") {
      // getting parameters passed
      var passedParameters = parameters;
      // finding the index of the song that needs to be played first
      int currIndex = passedParameters["currIndex"];
      // get the URL of the song and start playback and add it to queue
      await getMp3URL(
          passedParameters["allSongs"][passedParameters["currIndex"]], true);
      currIndex += 1;
      for (int i = 0; i < passedParameters["allSongs"].length - 1; i++) {
        if (currIndex >= passedParameters["allSongs"].length) currIndex = 0;
        await getMp3URL(passedParameters["allSongs"][currIndex], false);
        currIndex += 1;
      }
    } else if (action == "addItemToQueue") {
      getMp3URLToQueue(parameters["song"]);
    } else if (action == "removeItemFromQueue") {
      _queue.removeAt(parameters["index"]);
      AudioServiceBackground.setQueue(_queue);
      var state = AudioServiceBackground.state.basicState;
      var position = _audioPlayer.playbackEvent.position.inMilliseconds;
      AudioServiceBackground.setState(
          controls: getControls(state), basicState: state, position: position);
      // correcting the queue index of the current playing song
      for (int i = 0; i < _queue.length; i++) {
        if (parameters["currArtURI"] == _queue[i].artUri) {
          _queueIndex = i;
        }
      }
    } else if (action == "updateQueueOrder") {
      _queue.insert(parameters["newIndex"], _queue[parameters["oldIndex"]]);
      _queue.removeAt(parameters["oldIndex"] + 1);
      AudioServiceBackground.setQueue(_queue);
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
    if (responseJSON.data["status"] == true &&
        responseJSON.data["link"] != null) {
      MediaItem mediaItem = MediaItem(
        id: responseJSON.data["link"],
        album: "OpenBeats Music",
        title: parameter['title'],
        duration: globalFun.getDurationMillis(parameter["duration"]),
        artist: parameter['channelName'],
        artUri: parameter['thumbnail'],
      );

      _queue.add(mediaItem);
      AudioServiceBackground.setQueue(_queue);
      if (shouldPlay) {
        await onSkipToNext();
      }
    } else {
      onStop();
    }
  }

  // gets the mp3URL using videoID and add to the queue
  void getMp3URLToQueue(parameter) async {
    // holds the responseJSON for checking link validity
    var responseJSON;
    // getting the mp3URL
    try {
      // checking for link validity
      String url = "https://api.openbeats.live/opencc/" + parameter["videoId"];
      // sending GET request
      responseJSON = await Dio().get(url);
    } catch (e) {
      // catching dio error
      if (e is DioError) {
        globalFun.showToastMessage(
            "Cannot connect to the server", Colors.red, Colors.white);
        onStop();
        return;
      }
    }
    if (responseJSON.data["status"] == true &&
        responseJSON.data["link"] != null) {
      // setting the current mediaItem
      MediaItem temp = MediaItem(
        id: responseJSON.data["link"],
        album: "OpenBeats Music",
        title: parameter['title'],
        artist: parameter['channelName'],
        duration: globalFun.getDurationMillis(parameter['duration']),
        artUri: parameter['thumbnail'],
      );
      _queue.add(temp);
      AudioServiceBackground.setQueue(_queue);
      var state = AudioServiceBackground.state.basicState;
      var position = _audioPlayer.playbackEvent.position.inMilliseconds;
      AudioServiceBackground.setState(
          controls: getControls(state), basicState: state, position: position);
      globalFun.showQueueBasedToasts(1);
    } else {
      onStop();
    }
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
    if (_queue.length == 1) {
      if (_playing != null && _playing) {
        return [
          pauseControl,
          stopControl,
        ];
      } else {
        return [
          playControl,
          stopControl,
        ];
      }
    } else {
      if (_playing != null && _playing) {
        return [
          skipToPreviousControl,
          pauseControl,
          skipToNextControl,
          stopControl,
        ];
      } else {
        return [
          skipToPreviousControl,
          playControl,
          skipToNextControl,
          stopControl,
        ];
      }
    }
  }
}
