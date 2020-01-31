import 'dart:async';
import 'dart:convert';
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

class PlaylistPage extends StatefulWidget {
  String playlistName, playlistId, playlistThumbnail;
  PlaylistPage(this.playlistName, this.playlistId, this.playlistThumbnail);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final GlobalKey<ScaffoldState> _playlistsPageScaffoldKey =
      new GlobalKey<ScaffoldState>();
  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);

  // holds the flag to mark the page as loading or loaded
  bool _isLoading = true, _noInternet = false;
  // holds the response data from playlist songs request
  var dataResponse;

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

  // return the current duration string in min:sec for bottomSheet slider
  String getCurrentTimeStamp(double totalSeconds) {
    // variables holding separated time
    String min, sec, hour;
    // check if it is greater than one hour
    if (totalSeconds > 3600) {
      // getting number of hours
      hour = ((totalSeconds % (24 * 3600)) / 3600).floor().toString();
      totalSeconds %= 3600;
    }
    // getting number of minutes
    min = (totalSeconds / 60).floor().toString();
    totalSeconds %= 60;
    // getting number of seconds
    sec = (totalSeconds).floor().toString();
    // adding the necessary zeros
    if (int.parse(sec) < 10) sec = "0" + sec;
    // if the duration is greater than 1 hour, return with hour
    if (totalSeconds > 3600)
      return (hour.toString() + ":" + min.toString() + ":" + sec.toString());
    else
      return (min.toString() + ":" + sec.toString());
  }

  // function that calls the bottomSheet
  void settingModalBottomSheet(context) async {
    if (AudioService.currentMediaItem != null) {
      // bottomSheet definition
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(globalVars.borderRadius), topRight: Radius.circular(globalVars.borderRadius),
          )),
          context: context,
          elevation: 10.0,
          builder: (BuildContext bc) {
            return bottomSheet(context);
          });
    }
  }

  Widget bottomSheet(context) {
    String audioThumbnail, audioTitle, audioDurationMin;
    int audioDuration;
    return Container(
        height: 300.0,
        color: globalVars.primaryDark,
        child: StreamBuilder(
            stream: AudioService.playbackStateStream,
            builder: (context, snapshot) {
              PlaybackState state = snapshot.data;
              if (AudioService.currentMediaItem != null) {
                // getting thumbNail image
                audioThumbnail = AudioService.currentMediaItem.artUri;
                // getting audioTitle
                audioTitle = AudioService.currentMediaItem.title;
                // getting audioDuration in Min
                audioDurationMin = getCurrentTimeStamp(
                    AudioService.currentMediaItem.duration / 1000);
                // getting audioDuration
                audioDuration = AudioService.currentMediaItem.duration;
              }
              return (state != null &&
                      AudioService.playbackState.basicState !=
                          BasicPlaybackState.stopped)
                  ? Stack(
                      children: <Widget>[
                        globalWids.bottomSheetBGW(audioThumbnail),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              globalWids.bottomSheetTitleW(audioTitle),
                              positionIndicator(
                                  audioDuration, state, audioDurationMin),
                              globalWids.bufferingIndicator(),
                              globalWids.bNavPlayControlsW(context, state),
                            ],
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: Text("No Audio playing"),
                    );
            }));
  }

  Widget positionIndicator(
      int audioDuration, PlaybackState state, String audioDurationMin) {
    double seekPos;
    return StreamBuilder(
      stream: Rx.combineLatest2<double, double, double>(
          _dragPositionSubject.stream,
          Stream.periodic(Duration(milliseconds: 200)),
          (dragPosition, _) => dragPosition),
      builder: (context, snapshot) {
        double position = (state != null)
            ? snapshot.data ?? state.currentPosition.toDouble()
            : 0.0;
        double duration = audioDuration.toDouble();
        return Container(
          child: (state != null)
              ? Column(
                  children: [
                    if (duration != null)
                      Slider(
                        min: 0.0,
                        max: duration,
                        value: seekPos ?? max(0.0, min(position, duration)),
                        onChanged: (value) {
                          _dragPositionSubject.add(value);
                        },
                        onChangeEnd: (value) {
                          AudioService.seekTo(value.toInt());
                          // Due to a delay in platform channel communication, there is
                          // a brief moment after releasing the Slider thumb before the
                          // new position is broadcast from the platform side. This
                          // hack is to hold onto seekPos until the next state update
                          // comes through.
                          // TODO: Improve this code.
                          seekPos = value;
                          _dragPositionSubject.add(null);
                        },
                      ),
                    globalWids.mediaTimingW(
                        state, getCurrentTimeStamp, context, audioDurationMin)
                  ],
                )
              : null,
        );
      },
    );
  }

  // function to monitor the playback start point to remove snackbar
  void monitorPlaybackStart() async {
    Timer.periodic(
        Duration(milliseconds: 500),
        (Timer t) => {
              if (AudioService.playbackState != null &&
                  AudioService.playbackState.basicState ==
                      BasicPlaybackState.playing && _playlistsPageScaffoldKey.currentState != null && 
                  _playlistsPageScaffoldKey
                      .currentState.hasFloatingActionButton)
                {
                  t.cancel(),
                  _playlistsPageScaffoldKey.currentState.removeCurrentSnackBar()
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

  // shows the delete playlists confirmation dialog
  void showRemoveSongConfirmationBox(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              backgroundColor: globalVars.primaryDark,
              title: Text("Are you sure?"),
              content:
                  Text("This action will remove the song from this playlist"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(globalVars.borderRadius)),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.transparent,
                  textColor: globalVars.accentGreen,
                ),
                FlatButton(
                  child: Text("Remove Song"),
                  onPressed: () {
                    removeSongFromPlaylist(index);
                    Navigator.pop(context);
                  },
                  color: Colors.transparent,
                  textColor: globalVars.accentRed,
                ),
              ],
            ));
  }

  void removeSongFromPlaylist(index) async {
    setState(() {
      _isLoading = true;
      _noInternet = false;
    });
    try {
      var response = await http.post(
          "https://api.openbeats.live/playlist/userplaylist/deletesong",
          body: {
            "playlistId": widget.playlistId,
            "songId": dataResponse["data"]["songs"][index]["_id"],
          });
      dataResponse = json.decode(response.body);
      if (dataResponse["status"] == true) {
        getPlaylistContents();
      } else {
        globalFun.showToastMessage(
            "Response error from server", Colors.red, Colors.white);
      }
    } catch (err) {
      setState(() {
        _noInternet = true;
      });
      print(err);
      globalFun.showToastMessage(
          "Not able to connect to server", Colors.red, Colors.white);
    }
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
    globalFun.showSnackBars(7, _playlistsPageScaffoldKey, context);
    // monitoring playback state to close the snackbar when playback starts
    monitorPlaybackStart();
    if (AudioService.playbackState != null) {
      await AudioService.stop();
      Timer(Duration(milliseconds: 500), () async {
        await startAudioService();
        var parameters = {
          "currIndex": index,
          "allSongs": dataResponse["data"]["songs"]
        };
        await AudioService.customAction(
            "startMusicPlaybackAndCreateQueue", parameters);
      });
    } else {
      await startAudioService();
      var parameters = {
        "currIndex": index,
        "allSongs": dataResponse["data"]["songs"]
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
        key: _playlistsPageScaffoldKey,
        floatingActionButton: playlistPageW.fabView(
            settingModalBottomSheet, _playlistsPageScaffoldKey),
        backgroundColor: globalVars.primaryDark,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              playlistPageW.appBarW(context, _playlistsPageScaffoldKey,
                  widget.playlistName, widget.playlistThumbnail),
            ];
          },
          body: Container(
              child: (_noInternet)
                  ? globalWids.noInternetView(getPlaylistContents)
                  : (_isLoading)
                      ? playlistPageW.playlistsLoading()
                      : (dataResponse != null &&
                              dataResponse["data"]["songs"].length != 0)
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
      itemCount: dataResponse["data"]["songs"].length,
      itemBuilder: (context, index) {
        return globalWids.playlistPageVidResultContainerW(
            context,
            dataResponse["data"]["songs"][index],
            index,
            startPlaylistFromMusic,
            showRemoveSongConfirmationBox);
      },
    );
  }

  Widget shuffleAllBtn() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: RaisedButton(
        onPressed: () async {
          // show link-fetching snackBar
          globalFun.showSnackBars(7, _playlistsPageScaffoldKey, context);
          // monitoring playback state to close the snackbar when playback starts
          monitorPlaybackStart();
          if (AudioService.playbackState != null) {
            await AudioService.stop();
            Timer(Duration(milliseconds: 500), () async {
              await startAudioService();
              // calling method to add songs to the background list
              await AudioService.customAction(
                  "addSongsToList", dataResponse["data"]["songs"]);
            });
          } else {
            await startAudioService();
            // calling method to add songs to the background list
            await AudioService.customAction(
                "addSongsToList", dataResponse["data"]["songs"]);
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
      var passedParameters = parameters;
      int currIndex = passedParameters["currIndex"];
      await getMp3URL(
          passedParameters["allSongs"][passedParameters["currIndex"]], true);
      currIndex += 1;
      for (int i = 0; i < passedParameters["allSongs"].length; i++) {
        if (currIndex >= passedParameters["allSongs"].length) currIndex = 0;
        await getMp3URL(passedParameters["allSongs"][currIndex], false);
        currIndex += 1;
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
