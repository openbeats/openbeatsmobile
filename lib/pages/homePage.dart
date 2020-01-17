import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
    selectedSearchResult =
        await Navigator.of(context).push(FadeRouteBuilder(page: SearchPage()));
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

  // shows status snackBars
  // 0 - Getting Mp3 link | 1 - validating link | 2 - invalid link
  // 3 - playback start
  void showSnackBarMessage(int mode) {
    // holds the message to display
    String snackBarMessage;
    // flag to indicate if snackbar action has to be shown
    // 1 - permission action / 2 - download cancel
    int showAction = 0;
    // flag to indicate if CircularProgressIndicatior must be shown
    bool showLoadingAnim = true;
    // holds color of snackBar
    Color snackBarColor;
    // duration of snackBar
    Duration snackBarDuration = Duration(minutes: 1);
    switch (mode) {
      case 0:
        snackBarMessage = "Fetching your song...";
        snackBarColor = Colors.orange;
        break;
      case 2:
        snackBarMessage = "Please try another link...";
        snackBarColor = Colors.redAccent;
        showLoadingAnim = false;
        snackBarDuration = Duration(seconds: 5);
        break;
      case 3:
        snackBarMessage = "Initializing playback...";
        snackBarColor = Colors.green;
        snackBarDuration = Duration(seconds: 5);
        break;
      case 4:
        snackBarMessage = "Under development 😄";
        snackBarColor = Colors.blueGrey;
        showLoadingAnim = false;
        snackBarDuration = Duration(seconds: 5);
        break;
      case 5:
        snackBarMessage = "Getting your download ready";
        snackBarColor = Colors.indigo;
        snackBarDuration = Duration(seconds: 5);
        break;
      case 6:
        snackBarMessage = "Initializing download...";
        snackBarColor = Colors.indigo;
        snackBarDuration = Duration(seconds: 3);
        break;
      case 7:
        snackBarMessage = "Please allow storage permissions in settings";
        snackBarColor = Colors.indigo;
        showAction = 1;
        showLoadingAnim = false;
        snackBarDuration = Duration(seconds: 3);
        break;
      case 8:
        snackBarMessage = "An error occurred. Please try again...";
        snackBarColor = Colors.red;
        showLoadingAnim = false;
        snackBarDuration = Duration(seconds: 3);
        break;
      case 9:
        snackBarMessage = "Please wait for the current download to complete...";
        snackBarColor = Colors.teal;
        showLoadingAnim = false;
        showAction = 2;
        snackBarDuration = Duration(seconds: 3);
        break;
    }
    // constructing snackBar
    SnackBar statusSnackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              child: (showLoadingAnim)
                  ? Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    )
                  : SizedBox(
                      child: null,
                    )),
          Container(
            width: MediaQuery.of(context).size.width * 0.50,
            child: Text(
              snackBarMessage,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      backgroundColor: snackBarColor,
      duration: snackBarDuration,
    );
    // removing any previous snackBar
    _homePageScaffoldKey.currentState.removeCurrentSnackBar();
    // showing new snackBar
    _homePageScaffoldKey.currentState.showSnackBar(statusSnackBar);
  }

  void getMp3URL(String videoId, int index) async {
    // holds the responseJSON for checking link validity
    var responseJSON;
    // checking for internet connectivity
    String url = "https://www.google.com";

    try {
      // sending GET request
      await Dio().get(url);
    } catch (e) {
      // catching dio error
      if (e is DioError) {
        // removing previous snackBar
        _homePageScaffoldKey.currentState.removeCurrentSnackBar();
        // showing snackBar to alert user about network status
        _homePageScaffoldKey.currentState
            .showSnackBar(globalWids.networkErrorSBar);
        return;
      }
    }

    // creating sharedPreferences instance to set media values
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // show link-fetching snackBar
    showSnackBarMessage(0);

    // checking if link is working
    try {
      // checking for link validity
      String url = "https://api.openbeats.live/opencc/" + videoId.toString();
      // sending GET request
      responseJSON = await Dio().get(url);
    } catch (e) {
      // catching dio error
      if (e is DioError) {
        // removing previous snackBar
        _homePageScaffoldKey.currentState.removeCurrentSnackBar();
        // showing snackBar to alert user about network status
        _homePageScaffoldKey.currentState
            .showSnackBar(globalWids.networkErrorSBar);
        return;
      }
    }

    if (responseJSON.data["status"] == true) {
      // setting the streamLoading flag to indicate start of stream loading
      streamLoading = true;
      // setting the thumbnail link in shared preferences
      prefs.setString("nowPlayingThumbnail",
          videosResponseList[index]["thumbnail"].toString());
      // storing the thumbnail locally to help identify which media is playing now
      //nowPlayingThumbNail = videosResponseList[index]["thumbnail"].toString();
      // setting the url in shared preferences
      prefs.setString("nowPlayingURL", responseJSON.data["link"].toString());
      // setting the current mp3 URL
      prefs.setString("nowPlayingTitle", videosResponseList[index]["title"]);
      // setting the current channel name
      prefs.setString(
          "nowPlayingChannel", videosResponseList[index]["channelName"]);
      // setting the current mp3 duration in minutes
      prefs.setString(
          "nowPlayingDurationMin", videosResponseList[index]["duration"]);
      // getting the current mp3 duration in milliseconds
      String audioDuration =
          getDurationMillis(videosResponseList[index]["duration"]);
      // setting the current mp3 duration in milliseconds
      prefs.setString("nowPlayingDuration", audioDuration.toString());
      // setting the current mp3 ID
      prefs.setString(
          "nowPlayingVideoID", videosResponseList[index]["videoId"]);
      // setting that isPlaying flag for showing playback after app closes
      prefs.setBool("isPlaying", true);
      // setting that isStopped flag
      prefs.setBool("isStopped", false);
      // show link obtained snackBar
      showSnackBarMessage(3);
      // stopping previous audio service
      AudioService.stop();
      MediaItem currMediaItem = MediaItem(
        id: responseJSON.data["link"].toString(),
        album: "OpenBeats Free Music",
        title: videosResponseList[index]["title"],
        artist: videosResponseList[index]["channelName"],
        artUri: videosResponseList[index]["thumbnail"].toString(),
      );
      // starting new service after some delay to let the previous player stop
      Timer(Duration(seconds: 1), () {
        audioServiceStart(currMediaItem);
        streamLoading = true;
      });
    } else {
      // showing snackbar indicating error in link
      showSnackBarMessage(2);
    }
    // refreshing the UI build to update the thumbnail for now platying music
    setState(() {});
  }

  // returns the max duration of the media in milliseconds
  String getDurationMillis(String audioDuration) {
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
    return maxVal.toString();
  }

  // starts the audio service with notification
  void audioServiceStart(MediaItem currMediaItem) async {
    // start the AudioService
    await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      resumeOnClick: true,
      androidNotificationOngoing: true,
      androidNotificationChannelName: 'OpenBeats Notification Channel',
      notificationColor: 0xFF09090E,
      enableQueue: true,
      androidNotificationIcon: 'mipmap/ic_launcher',
    );

    Map<String, dynamic> parameters = {
      'mediaID': currMediaItem.id,
      'mediaTitle': currMediaItem.title,
      'channelID': currMediaItem.artist,
      'thumbnailURI': currMediaItem.artUri
    };
    await AudioService.customAction('playMedia', parameters);
    
  }

  @override
  void initState() {
    super.initState();
    connect();
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
    return SafeArea(
      child: Scaffold(
        key: _homePageScaffoldKey,
        backgroundColor: globalVars.primaryDark,
        appBar: homePageW.appBarW(
            context, navigateToSearchPage, _homePageScaffoldKey),
        drawer: globalFun.drawerW(1, context),
        body: homePageBody(),
      ),
    );
  }

  Widget homePageBody() {
    return Container(
      child: Center(
          child: (searchResultLoading)
              ? CircularProgressIndicator()
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
            index, getMp3URL, showSnackBarMessage);
      },
      itemCount: videosResponseList.length,
    );
  }
}

// used to fade transition to search page
class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;
  FadeRouteBuilder({@required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
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
  void onCustomAction(String action, var parameter) async{
    if (action == "playMedia") {
      await AudioServiceBackground.setMediaItem(MediaItem(
        id: parameter['mediaID'],
        album: "OpenBeats Free Music",
        title: parameter['mediaTitle'],
        artist: parameter['channelID'],
        artUri: parameter['thumbnailURI'],
      ));
      await _audioPlayer.setUrl(parameter['mediaID']);
      onPlay();
      // print("Hi there!");
      // print(parameter['mediaID']);
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
