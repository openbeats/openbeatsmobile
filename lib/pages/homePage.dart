import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:openbeatsmobile/pages/searchPage.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/subjects.dart';
import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:openbeatsmobile/widgets/homePageW.dart' as homePageW;
import 'package:shared_preferences/shared_preferences.dart';
import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;
import '../globalWids.dart' as globalWids;
import '../actions/globalVarsA.dart' as globalVarsA;
import '../audioServiceGlobalFun.dart' as audioServiceGlobalFun;

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

  // initiates the app update verification process
  void verifyAppVersion() async {
    // setting callHandler to show rational dialog to get storage permissions
    globalVars.platformMethodChannel.setMethodCallHandler(
        (MethodCall methodCall) =>
            globalFun.nativeMethodCallHandler(methodCall, context));
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    try {
      Response response = await Dio().get(" http://yagupdtserver.000webhostapp.com/api/");
      if (response.data["versionName"] != versionName ||
          response.data["versionCode"] != versionCode) {
        globalVars.updateResponse = response;
        globalFun.showUpdateAvailableDialog(response, context);
      }
    } catch (e) {
      print(e);
    }
  }

  // navigates to the search page
  void navigateToSearchPage() async {
    // getting the search result history
    globalFun.getSearchHistory();
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
      // adding the query to the search results history
      globalFun.addToSearchHistory(selectedSearchResult);
      // calling function to get videos for query
      getVideosForQuery(selectedSearchResult);
    }
  }

  // gets list of videos for query
  void getVideosForQuery(String query) async {
    // sanitizing query
    query = query.replaceAll(new RegExp(r'[^\w\s]+'), '');
    // constructing url to send request to to get list of videos
    String url = "https://api.openbeats.live/ytcat?q=" + query + " audio";
    try {
      // sending http get request
      var response = await Dio().get(url);
      // decoding to json
      var responseJSON = response.data;
      // checking if proper response is received
      if (responseJSON["status"] == true && responseJSON["data"].length != 0) {
        setState(() {
          // response as list to iterate over
          videosResponseList = responseJSON["data"] as List;
          // calling function to set the videoResponseList globally for persistency
          globalVarsA.setPersistentVideoList(videosResponseList);
          // removing loading animation from screen
          searchResultLoading = false;
          // removing any snackbar
          _homePageScaffoldKey.currentState.hideCurrentSnackBar();
        });
      } else {
        setState(() {
          // removing loading animation from screen
          searchResultLoading = false;
        });
        globalFun.showToastMessage(
            "Could not get proper response from server. Please try another query",
            Colors.orange,
            Colors.white);
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

  // starts the snackbar and also initiates the audio service and calls the customAction
  void getMp3URL(String videoId, int index, bool repeatSong) async {
    // getting the current mp3 duration in milliseconds
    int audioDuration =
        globalFun.getDurationMillis(videosResponseList[index]["duration"]);

    MediaItem currMediaItem = MediaItem(
      id: videoId,
      album: "OpenBeats Music",
      duration: audioDuration,
      title: videosResponseList[index]["title"],
      artist: videosResponseList[index]["channelName"],
      artUri: videosResponseList[index]["thumbnail"].toString(),
    );

    if (AudioService.playbackState != null) {
      await AudioService.stop();
      Timer(Duration(milliseconds: 500), () async {
        await audioServiceStart(currMediaItem, repeatSong, index);
      });
    } else {
      await audioServiceStart(currMediaItem, repeatSong, index);
    }

    // refreshing the UI build to update the thumbnail for now platying music
    setState(() {});
  }

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
          backgroundColor: globalVars.primaryDark,
          context: context,
          elevation: 10.0,
          builder: (BuildContext bc) {
            return globalWids.bottomSheet(context, _dragPositionSubject);
          });
    }
  }

  // starts the audio service with notification
  Future audioServiceStart(
      MediaItem currMediaItem, bool repeatSong, int index) async {
    setState(() {
      // setting the page that is handling the audio service
      globalVars.audioServicePage = "home";
    });
    // start the AudioService
    await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      resumeOnClick: true,
      androidStopOnRemoveTask: true,
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
    (repeatSong)
        ? await AudioService.customAction(
            'repeatSong', videosResponseList[index])
        : await AudioService.customAction('playMedia2', parameters);
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

  // checks if there is persistent video result values to be inserted and insert if there are
  void checkForVidResultPersistency() {
    if (globalVars.videosResponseList.length != 0) {
      setState(() {
        videosResponseList = globalVars.videosResponseList;
      });
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
                  borderRadius: BorderRadius.circular(globalVars.borderRadius)),
              title: new Text('Are you sure?'),
              content: new Text('This action will exit OpenBeats'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('Return to app'),
                ),
                new FlatButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: new Text(
                    'Exit app',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ) ??
          true;
    else
      setState(() {
        globalVarsA.setPersistentVideoList([]);
        videosResponseList = [];
      });
  }

  @override
  void initState() {
    super.initState();
    if(globalVars.chechForUpdate){
      // starts app version checking functionality
      verifyAppVersion();
      // setting to false to prevent retriggering until the app is restarted
      globalVars.chechForUpdate = false;
    }
    // checks if there is persistent video result values to be inserted and insert if there are
    checkForVidResultPersistency();
    // getting authStatus to refresh app after restart
    getAuthStatus();
    connect();
    // setting callHandler to show rational dialog to get storage permissions
    globalVars.platformMethodChannel.setMethodCallHandler(
        (MethodCall methodCall) =>
            globalFun.nativeMethodCallHandler(methodCall, context));
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
          floatingActionButton:
              globalWids.fabView(settingModalBottomSheet, _homePageScaffoldKey),
          appBar: homePageW.appBarW(
              context, navigateToSearchPage, _homePageScaffoldKey),
          drawer: globalFun.drawerW(1, context),
          body: homePageBody(),
        ),
      ),
    );
  }

  Widget homePageBody() {
    return Container(
        alignment: Alignment.center,
        child: (searchResultLoading)
            ? CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
              )
            : (videosResponseList.length == 0)
                ? homePageW.homePageView()
                : videoListView());
  }

  // listView builder to construct list of videos
  Widget videoListView() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return globalWids.homePageVidResultContainerW(
            context,
            videosResponseList[index],
            index,
            getMp3URL,
            settingModalBottomSheet,
            videosResponseList.length);
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
  // holds one attribute of the contents of MediaItems in _queue
  var _queueMeta = <String>[];
  int _queueIndex = 0;
  AudioPlayer _audioPlayer = new AudioPlayer();
  Completer _completer = Completer();
  BasicPlaybackState _skipState;
  bool _playing;
  bool _shouldRepeat = true;
  // used to differentiate normal pause from pause caused by audio focus lost
  bool _isPaused = true;
  // temporary mediaItem object to overcome parameter restrictons
  MediaItem temp;

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

  void _handlePlaybackCompleted() {
    if (hasNext) {
      onSkipToNext();
    } else {
      if (_shouldRepeat) {
        _queueIndex = -1;
        onSkipToNext();
      } else {
        onStop();
      }
    }
  }

  void playPause() {
    print("PlayPause clicked");
    if (AudioServiceBackground.state.basicState == BasicPlaybackState.playing) {
      onPause();
    } else
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
      _queueIndex = _queue.length;
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
      _isPaused = false;
      _audioPlayer.play();
    }
  }

  @override
  void onPause() {
    if (_skipState == null) {
      _playing = false;
      _isPaused = true;
      _audioPlayer.pause();
    }
  }

  void onPauseAudioFocus() {
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
    onPauseAudioFocus();
  }

  @override
  void onAudioBecomingNoisy() {
    onPauseAudioFocus();
  }

  @override
  void onAudioFocusLostTransient() async {
    onPauseAudioFocus();
  }

  @override
  void onAudioFocusLostTransientCanDuck() async {
    _audioPlayer.setVolume(0);
  }

  @override
  void onAudioFocusGained() async {
    _audioPlayer.setVolume(1.0);
    if (!_isPaused) onPlay();
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

  @override
  void onCustomAction(String action, var parameters) async {
    // if condition to play current media
    if (action == "playMedia2") {
      var state = BasicPlaybackState.connecting;
      var position = 0;
      AudioServiceBackground.setState(
          controls: getControls(state), basicState: state, position: position);
      _shouldRepeat = false;
      getMp3URL(parameters['mediaID'], parameters);
    } else if (action == "addItemToQueue") {
      _shouldRepeat = true;
      addItemToQueue(parameters);
    } else if (action == "removeItemFromQueue") {
      removeItemFromQueue(parameters);
    } else if (action == "updateQueueOrder") {
      updateQueueOrder(parameters);
    } else if (action == "repeatSong") {
      _shouldRepeat = true;
      // true for repeating single song
      // last parameter is if the song should be make now playing in queue
      getMp3URLToQueue(parameters, true, false);
    } else if (action == "addItemToQueueFront") {
      // false cause this is not repeating single song
      // last parameter is if the song should be make now playing in queue
      getMp3URLToQueue(parameters["song"], false, true);
    } else if (action == "addSongListToQueue") {
      addSongListToQueue(parameters);
    } else if (action == "jumpToQueueItem") {
      jumpToQueueItem(parameters);
    }
  }

  // customAction functions
  void addItemToQueue(parameters) {
    // false cause this is not repeating single song
    // last parameter is if the song should be make now playing in queue
    getMp3URLToQueue(parameters["song"], false, false);
  }

  void removeItemFromQueue(parameters) async {
    // checking if the item to be removed is the current playing item
    if (parameters["currentArtURI"] == _queue[_queueIndex].artUri) {
      _queueMeta.remove(_queue[parameters["index"]].artUri);
      _queue.removeAt(parameters["index"]);
      AudioServiceBackground.setQueue(_queue);
      await onSkipToNext();
    } else {
      _queueMeta.remove(_queue[parameters["index"]].artUri);
      _queue.removeAt(parameters["index"]);
      AudioServiceBackground.setQueue(_queue);
      var state = AudioServiceBackground.state.basicState;
      var position = _audioPlayer.playbackEvent.position.inMilliseconds;
      AudioServiceBackground.setState(
          controls: getControls(state), basicState: state, position: position);
      // correcting the queue index of the current playing song
      for (int i = 0; i < _queue.length; i++) {
        if (parameters["currentArtURI"] == _queue[i].artUri) {
          _queueIndex = i;
        }
      }
    }
  }

  void updateQueueOrder(parameters) {
    // checks if the rearrangement is upqueue or downqueue
    if (parameters["newIndex"] < parameters["oldIndex"]) {
      _queue.insert(parameters["newIndex"], _queue[parameters["oldIndex"]]);
      _queue.removeAt(parameters["oldIndex"] + 1);
    } else if (parameters["newIndex"] > parameters["oldIndex"]) {
      _queue.insert(parameters["newIndex"], _queue[parameters["oldIndex"]]);
      _queue.removeAt(parameters["oldIndex"]);
    }

    // correcting the queue index of the current playing song
    for (int i = 0; i < _queue.length; i++) {
      if (parameters["currentArtURI"] == _queue[i].artUri) {
        print("New Queue Index: " + i.toString());
        _queueIndex = i;
      }
    }
    AudioServiceBackground.setQueue(_queue);
    // refreshing the audioService state
    var state = AudioServiceBackground.state.basicState;
    var position = _audioPlayer.playbackEvent.position.inMilliseconds;
    AudioServiceBackground.setState(
        controls: getControls(state), basicState: state, position: position);
  }

  void addSongListToQueue(parameters) async {
    // checking if queue is empty
    if (_queue.length == 0) {
      var state = BasicPlaybackState.connecting;
      var position = 0;
      AudioServiceBackground.setState(
          controls: getControls(state), basicState: state, position: position);
    }
    await audioServiceGlobalFun.addSongListToQueue(
        parameters, getMp3URLSpecial, _queue);
  }

  void jumpToQueueItem(parameters) async {
    int index = parameters["index"];
    if (index == _queue.length)
      _queueIndex = index - 1;
    else if (index == 0)
      _queueIndex = _queue.length - 1;
    else
      _queueIndex = index - 1;

    await onSkipToNext();
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

  // gets the mp3URL using videoID and add to the queue
  void getMp3URLToQueue(
      parameter, bool singleSongRepeat, bool shouldBeNowPlaying) async {
    // checking if media is present in the queueMeta list
    if (!_queueMeta.contains(parameter["thumbnail"])) {
      globalFun.showToastMessage(
          "Adding song to queue...", Colors.orange, Colors.white);
      // adding song thumbnail to the queueMeta list
      _queueMeta.add(parameter['thumbnail']);
      print("Added " + parameter['thumbnail']);
      // holds the responseJSON for checking link validity
      var responseJSON;
      // getting the mp3URL
      try {
        // checking for link validity
        String url =
            "https://api.openbeats.live/opencc/" + parameter["videoId"];
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
        temp = MediaItem(
          id: responseJSON.data["link"],
          album: "OpenBeats Music",
          title: parameter['title'],
          artist: parameter['channelName'],
          duration: globalFun.getDurationMillis(parameter['duration']),
          artUri: parameter['thumbnail'],
        );

        (shouldBeNowPlaying)
            ? _queue.insert(_queueIndex, temp)
            : _queue.add(temp);

        AudioServiceBackground.setQueue(_queue);
        if (shouldBeNowPlaying) {
          int indexOfItem;
          // finding the index of the element to play
          for (int i = 0; i < _queue.length; i++) {
            if (_queue[i].id == temp.id) indexOfItem = i;
          }
          _queueIndex = indexOfItem + 1;
          onSkipToPrevious();
        } else {
          if (singleSongRepeat) onSkipToNext();
        }
        var state = AudioServiceBackground.state.basicState;
        var position = (_audioPlayer.playbackEvent != null)
            ? _audioPlayer.playbackEvent.position.inMilliseconds
            : 0;
        AudioServiceBackground.setState(
            controls: getControls(state),
            basicState: state,
            position: position);
        globalFun.showQueueBasedToasts(1);
      } else {
        onStop();
      }
    } else {
      // index buffer to prevent modifying the _queueIndex value
      int tempIndex = -1;
      // finding index of the song clicked
      for (int i = 0; i < _queue.length; i++) {
        if (parameter["thumbnail"] == _queue[i].artUri) {
          tempIndex = i;
        }
      }
      // checking if song exists in queue
      if (tempIndex != -1) {
        _queueIndex = tempIndex + 1;
        onSkipToPrevious();
      }
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
        onStop();
        return;
      }
    }
    if (responseJSON.data["status"] == true &&
        responseJSON.data["link"] != null) {
      MediaItem temp = MediaItem(
        id: responseJSON.data["link"],
        album: "OpenBeats Music",
        title: parameter['mediaTitle'],
        artist: parameter['channelID'],
        duration: parameter['duration'],
        artUri: parameter['thumbnailURI'],
      );
      // adding song thumbnail to the queueMeta list
      _queueMeta.add(parameter['thumbnailURI']);
      // setting the current mediaItem
      await AudioServiceBackground.setMediaItem(temp);
      // setting URL for audio player
      await _audioPlayer.setUrl(responseJSON.data["link"]);
      _queue.add(temp);

      AudioServiceBackground.setQueue(_queue);
      if (_playing == null) {
        // First time, we want to start playing
        _playing = true;
      }
      // playing audio
      onPlay();
    } else {
      onStop();
    }
    // refreshing the audioService state
    var state = AudioServiceBackground.state.basicState;
    var position = _audioPlayer.playbackEvent.position.inMilliseconds;
    AudioServiceBackground.setState(
        controls: getControls(state), basicState: state, position: position);
  }

  // gets the mp3URL using videoID and i parameter to start playback on true
  Future getMp3URLSpecial(parameter, bool shouldPlay) async {
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
      // adding song thumbnail to the queueMeta list
      _queueMeta.add(parameter['thumbnail']);
      _queue.add(mediaItem);
      AudioServiceBackground.setQueue(_queue);

      if (shouldPlay) {
        await onSkipToNext();
      }
    } else {
      onStop();
    }
    if (AudioService.playbackState != null) {
      // refreshing the audioService state
      var state = AudioServiceBackground.state.basicState;
      var position = _audioPlayer.playbackEvent.position.inMilliseconds;
      AudioServiceBackground.setState(
          controls: getControls(state), basicState: state, position: position);
    }
  }
}
