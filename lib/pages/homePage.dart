import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:openbeatsmobile/pages/searchPage.dart';
import 'package:rxdart/subjects.dart';
import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flare_flutter/flare_actor.dart';

import 'package:openbeatsmobile/widgets/homePageW.dart' as homePageW;
import 'package:shared_preferences/shared_preferences.dart';
import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;
import '../globalWids.dart' as globalWids;

// media item to indicate the current playing audio
MediaItem currMediaItem;

// media control objects for the various functionalities of the app
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);

  final GlobalKey<ScaffoldState> _homePageScaffoldKey =
      new GlobalKey<ScaffoldState>();

  // tells if the query requests have finished downloading
  bool searchResultLoading = false;
  // holds the videos received for query
  var videosResponseList = new List();
  // holds the flag indicating that the media streaming is loading
  bool streamLoading = false;

  // navigates to the search page
  void navigateToSearchPage() async {
    // setting navResult value to know if it has changed
    String selectedSearchResult = "";
    // Navigate to the search page and wait for response
    selectedSearchResult = await Navigator.of(context)
        .push(globalWids.FadeRouteBuilder(page: SearchPage()));
    // checking if the user has returned something
    if (selectedSearchResult != null && selectedSearchResult.length > 0) {
      // set the page to loading animation
      setState(() {
        searchResultLoading = true;
      });
      // calling function to get videos for query
      getVideosForQuery(selectedSearchResult);
    }
  }

  // gets list of videos for query
  void getVideosForQuery(String query) async {
    // constructing url to send request to to get list of videos
    String url = "https://api.openbeats.live/ytcat?q=" + query;
    try {
      // sending http get request
      var response = await Dio().get(url);
      // decoding to json
      var responseJSON = response.data;
      // checking if proper response is received
      if (responseJSON["status"] == true) {
        setState(() {
          // response as list to iterate over
          videosResponseList = responseJSON["data"] as List;
          // removing loading animation from screen
          searchResultLoading = false;
        });
      }
    } catch (e) {
      // catching dio error
      if (e is DioError) {
        // removing previous snackBar
        _homePageScaffoldKey.currentState.removeCurrentSnackBar();
        // showing snackBar to alert user about network status
        _homePageScaffoldKey.currentState
            .showSnackBar(globalWids.networkErrorSBar);
        // removing the loading animation
        setState(() {
          // removing loading animation from screen
          searchResultLoading = false;
        });
      }
    }
  }

  // function to monitor the playback start point to remove snackbar
  void monitorPlaybackStart() async {
    Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => {
              if (AudioService.playbackState != null &&
                  AudioService.playbackState.basicState ==
                      BasicPlaybackState.playing &&
                  _homePageScaffoldKey.currentState.hasFloatingActionButton)
                {
                  t.cancel(),
                  _homePageScaffoldKey.currentState.removeCurrentSnackBar()
                }
            });
  }

  // sets the sharedPreferences values
  void setSharedPrefs(index, audioDuration) async {
    // creating sharedPreferences instance to set media values
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // setting the thumbnail link in shared preferences
    prefs.setString("nowPlayingThumbnail",
        videosResponseList[index]["thumbnail"].toString());

    // setting the current mp3 title
    prefs.setString("nowPlayingTitle", videosResponseList[index]["title"]);
    // setting the current channel name
    prefs.setString(
        "nowPlayingChannel", videosResponseList[index]["channelName"]);
    //   // setting the current mp3 duration in minutes
    prefs.setString("nowPlayingDurationMin",
        videosResponseList[index]["duration"].toString());

    // setting the duration shared preferences
    prefs.setInt("nowPlayingDuration", audioDuration);
    // setting the current mp3 ID
    prefs.setString("nowPlayingVideoID", videosResponseList[index]["videoId"]);
    // setting that isPlaying flag for showing playback after app closes
    prefs.setBool("isPlaying", true);
    // setting that isStopped flag
    prefs.setBool("isStopped", false);
  }

  // sets the shared preferences and starts the audio service after stopping previous one
  void getMp3URL(String videoId, int index) async {
    // monitoring playback state to close the snackbar when playback starts
    monitorPlaybackStart();
    // show link-fetching snackBar
    globalFun.showSnackBars(0, _homePageScaffoldKey, context);
    // // holds the responseJSON for checking link validity

    // getting the current mp3 duration in milliseconds
    int audioDuration =
        getDurationMillis(videosResponseList[index]["duration"]);
    // sets the sharedPreferences values
    setSharedPrefs(index, audioDuration);
    //   // show link obtained snackBar
    //   showSnackBarMessage(3);
    if (AudioService.playbackState != null) {
      // stopping previous audio service
      await AudioService.stop();
    }

    MediaItem currMediaItem = MediaItem(
      id: videoId,
      album: "OpenBeats Free Music",
      duration: audioDuration,
      title: videosResponseList[index]["title"],
      artist: videosResponseList[index]["channelName"],
      artUri: videosResponseList[index]["thumbnail"].toString(),
    );

    Timer(Duration(seconds: 1), () {
      audioServiceStart(currMediaItem);
      
    });
    // refreshing the UI build to update the thumbnail for now platying music
    setState(() {});
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
    // creating sharedPreferences instance to get media metadata values
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // getting thumbNail image
    String audioThumbnail = prefs.getString("nowPlayingThumbnail");
    // getting audioTitle set by getMp3URL()
    String audioTitle = prefs.getString("nowPlayingTitle");
    // getting audioDuration in Min set by getMp3URL()
    String audioDurationMin = prefs.getString("nowPlayingDurationMin");
    // getting audioDuration set by getMp3URL()
    int audioDuration = prefs.getInt("nowPlayingDuration");
    // getting audioViews set by getMp3URL()
    String audioViews = prefs.getString("nowPlayingViews");
    // getting audioChannel set by getMp3URL()
    String audioChannel = prefs.getString("nowPlayingChannel");
    // getting now playing video ID
    String videoID = prefs.getString("nowPlayingVideoID");
    // bottomSheet definition
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        )),
        context: context,
        elevation: 10.0,
        builder: (BuildContext bc) {
          return bottomSheet(audioTitle, audioDuration, audioViews,
              audioChannel, audioThumbnail, audioDurationMin, videoID, context);
        });
  }

  Widget bottomSheet(audioTitle, audioDuration, audioViews, audioChannel,
      audioThumbnail, audioDurationMin, videoID, context) {
    return Container(
        height: 300.0,
        child: StreamBuilder(
            stream: AudioService.playbackStateStream,
            builder: (context, snapshot) {
              PlaybackState state = snapshot.data;
              return Stack(
                children: <Widget>[
                  homePageW.bottomSheetBGW(audioThumbnail),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        homePageW.bottomSheetTitleW(audioTitle),
                        positionIndicator(
                            audioDuration, state, audioDurationMin),
                        homePageW.bufferingIndicator(),
                        homePageW.bNavPlayControlsW(context, state),
                      ],
                    ),
                  )
                ],
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
                    homePageW.mediaTimingW(
                        state, getCurrentTimeStamp, context, audioDurationMin)
                  ],
                )
              : null,
        );
      },
    );
  }

  // starts the audio service with notification
  Future audioServiceStart(MediaItem currMediaItem) async {
    // start the AudioService
    await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      resumeOnClick: true,
      androidNotificationOngoing: true,
      androidNotificationChannelName: 'OpenBeats Notification Channel',
      notificationColor: 0xFF09090E,
      enableQueue: true,
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'drawable/ic_stat_logoicon2',
    );

    Map<String, dynamic> parameters = {
      'mediaID': currMediaItem.id,
      'mediaTitle': currMediaItem.title,
      'channelID': currMediaItem.artist,
      'duration': currMediaItem.duration,
      'thumbnailURI': currMediaItem.artUri
    };
    await AudioService.customAction('playMedia2', parameters);
  }

  // sets the status and navigation bar themes
  void setStatusNaviThemes() async {
    await FlutterStatusbarcolor.setStatusBarColor(globalVars.primaryDark);
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    await FlutterStatusbarcolor.setNavigationBarColor(globalVars.primaryDark);
    await FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
  }

  void getAuthStatus() async {
    // creating sharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loginStatus = prefs.getBool("loginStatus");
    if (loginStatus != null && loginStatus) {
      setState(() {});
    }
  }

  // handles the back button press from exiting the app
  Future<bool> _onWillPop() {
    if (videosResponseList.length == 0)
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              backgroundColor: globalVars.primaryDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: new Text('Are you sure?'),
              content: new Text('This action will exit OpenBeats'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('Return to app'),
                ),
                new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop(true);
                  },
                  child: new Text(
                    'Exit app',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ) ??
          false;
    else
      setState(() {
        videosResponseList = [];
      });
  }

  @override
  void initState() {
    super.initState();
    // getting authStatus to refresh app after restart
    getAuthStatus();
    connect();

    // sets the status and navigation bar themes
    setStatusNaviThemes();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  // connects to the audio service
  void connect() async {
    await AudioService.connect();
  }

  // disconnects from the audio service
  void disconnect() {
    AudioService.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Scaffold(
            key: _homePageScaffoldKey,
            backgroundColor: globalVars.primaryDark,
            floatingActionButton: homePageW.fabView(
                settingModalBottomSheet, _homePageScaffoldKey),
            appBar: homePageW.appBarW(
                context, navigateToSearchPage, _homePageScaffoldKey),
            drawer: globalFun.drawerW(1, context),
            body: homePageBody(),
          ),
        ));
  }

  Widget homePageBody() {
    return Container(
      child: Center(
          child: (searchResultLoading)
              ? CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                )
              : (videosResponseList.length == 0)
                  ? homePageW.homePageView()
                  : videoListView()),
    );
  }

  // listView builder to construct list of videos
  Widget videoListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return homePageW.vidResultContainerW(context, videosResponseList[index],
            index, getMp3URL, settingModalBottomSheet);
      },
      itemCount: videosResponseList.length,
    );
  }
}
/* --------------------------
Audio Service implementation
-----------------------------*/

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioPlayerTask extends BackgroundAudioTask {
  var _queue = <MediaItem>[];
  int _queueIndex = 0;
  AudioPlayer _audioPlayer = new AudioPlayer();
  Completer _completer = Completer();
  BasicPlaybackState _skipState;
  bool _playing;

  Map<String, dynamic> mediaIdParameters = {
    'mediaID': null,
    'mediaTitle': null,
    'channelID': null,
    'duration': null,
    'thumbnailURI': null,
  };

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
  void onSeekTo(int position) {
    _audioPlayer.seek(Duration(milliseconds: position));
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
  void onCustomAction(String action, var parameter) async {
    // if condition to play current media
    if (action == "playMedia2") {
      getMp3URL(parameter['mediaID'], parameter);
    }
  }

  @override
  void onAddQueueItem(MediaItem mediaItem) {
    _queue.add(mediaItem);
    AudioServiceBackground.setQueue(_queue);
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
  }

  // gets the mp3URL using videoID
  void getMp3URL(videoId, parameter) async {
    // holds the responseJSON for checking link validity
    var responseJSON;
    // getting the mp3URL
    try {
      // checking for link validity
      String url = "https://api.openbeats.live/opencc/" + videoId.toString();
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
      // setting the current mediaItem
      await AudioServiceBackground.setMediaItem(MediaItem(
        id: responseJSON.data["link"],
        album: "OpenBeats Free Music",
        title: parameter['mediaTitle'],
        artist: parameter['channelID'],
        duration: parameter['duration'],
        artUri: parameter['thumbnailURI'],
      ));
      // setting URL for audio player
      await _audioPlayer.setUrl(responseJSON.data["link"]);
      if (_playing == null) {
        // First time, we want to start playing
        _playing = true;
      }
      // playing audio
      onPlay();
      // setting sharedPreferences values
      settingSharedPrefs(parameter, responseJSON.data["link"]);
    }
  }

  void settingSharedPrefs(parameter, String link) async {
    // creating sharedPreferences instance to set media values
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // setting the url in shared preferences
    prefs.setString("nowPlayingURL", link.toString());
  }
}
