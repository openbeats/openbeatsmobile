import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import './pages/homePage.dart';
import './globals/globalColors.dart' as globalColors;
import './globals/globalStrings.dart' as globalStrings;
import './globals/globalFun.dart' as globalFun;

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

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final BehaviorSubject<double> dragPositionSubject =
      BehaviorSubject.seeded(null);

  // starts single playback of audio
  void startSinglePlayback(Map<String, dynamic> mediaParameters) async {
    // getting instance of audioService playbackState
    PlaybackState playbackState = AudioService.playbackState;
    // check if the audioService is already running
    if (playbackState != null &&
        playbackState.basicState != BasicPlaybackState.none) {
      await AudioService.customAction("startSinglePlayback", mediaParameters);
    } else {
      // if audioService isn't running, start it
      await startAudioService(false);
      // giving time for audioService to startup
      Timer(Duration(seconds: 1), () async {
        // calling custom action to start single audio playback
        await AudioService.customAction("startSinglePlayback", mediaParameters);
      });
    }
  }

  // audioService playAndPause control callback
  void audioServicePlayPause() {
    // getting instance of audioService playbackState
    PlaybackState playbackState = AudioService.playbackState;
    // checking state of audioService
    if (playbackState != null) {
      // checking playbackState
      if (playbackState.basicState == BasicPlaybackState.playing)
        // pausing playback
        AudioService.pause();
      else if (playbackState.basicState == BasicPlaybackState.paused)
        // resuming playback
        AudioService.play();
    }
  }

  // initiates the audioService
  Future<void> startAudioService(bool enableQueue) async {
    await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      androidNotificationChannelName: 'OpenBeats Notification Channel',
      notificationColor: 0xFF09090E,
      androidNotificationIcon: 'mipmap/ic_launcher',
      enableQueue: enableQueue,
    );
  }

  // connects to the audio_service
  void connect() async {
    await AudioService.connect();
  }

  // disconnects from the audio_service
  void disconnect() {
    AudioService.disconnect();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: globalStrings.mainAppTitleString,
      color: globalColors.appTitleColor,
      theme: ThemeData(
        brightness: globalColors.appBrightness,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: globalColors.backgroundColor,
        appBarTheme: AppBarTheme(
          actionsIconTheme: IconThemeData(
            color: globalColors.iconColor,
          ),
          iconTheme: IconThemeData(
            color: globalColors.iconColor,
          ),
          color: globalColors.backgroundColor,
          elevation: 0,
        ),
      ),
      home: HomePage(startAudioService, startSinglePlayback,
          dragPositionSubject, audioServicePlayPause),
    );
  }
}

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
    if (_queue.length <= 1) {
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

  @override
  void onCustomAction(String action, arguments) async {
    super.onCustomAction(action, arguments);
    if (action == "startSinglePlayback") {
      // calling method to start playback with no repeat
      startSinglePlayback(arguments, false);
    }
  }

  // starts playback of single song
  void startSinglePlayback(arguments, bool shouldRepeat) async {
    // pausing any current playback
    if (!_isPaused) {
      onPause();
    }
    var state = BasicPlaybackState.connecting;
    var position = 0;
    // setting repeat status
    _shouldRepeat = shouldRepeat;
    // clearing current queue
    _queue.clear();
    AudioServiceBackground.setState(
        controls: getControls(state), basicState: state, position: position);
    // creating mediaItem instance to immidiately show response to user
    MediaItem tempMediaItem = MediaItem(
        id: arguments["videoId"],
        album: "OpenBeats Music",
        title: arguments['title'],
        duration: arguments['durationInMilliSeconds'],
        artUri: arguments['thumbnail'],
        extras: {
          "views": arguments["views"],
          "durationString": arguments["duration"],
        });
    // setting the current mediaItem
    await AudioServiceBackground.setMediaItem(tempMediaItem);
    // refreshing state to update mediaItem details
    AudioServiceBackground.setState(
        controls: getControls(state), basicState: state, position: position);
    // gets the mediaItem for the song to play with the valid streamingURL
    String streamingURL = await getStreamingURL(arguments);
    // creating updatedMediaItemInstance
    MediaItem updatedMediaItem = MediaItem(
        id: streamingURL,
        album: "OpenBeats Music",
        title: arguments['title'],
        duration: arguments['durationInMilliSeconds'],
        artUri: arguments['thumbnail'],
        extras: {
          "views": arguments["views"],
          "durationString": arguments["duration"],
        });
    // setting the current mediaItem
    await AudioServiceBackground.setMediaItem(updatedMediaItem);
    // adding mediaITem to queue
    _queue.add(updatedMediaItem);
    // setting URL for audio player
    await _audioPlayer.setUrl(streamingURL);
    // playing audio
    onPlay();
  }

  // function to get the streaming URL for the audio
  Future<String> getStreamingURL(mediaParamters) async {
    // holds the responseJSON containing the streaming URL
    var responseJSON;
    try {
      // checking for link validity
      String url =
          "https://api.openbeats.live/opencc/" + mediaParamters["videoId"];
      // sending GET request
      responseJSON = await Dio().get(url);
      // checking conditions to make sure the streamingURL has been recieved
      if (responseJSON.data["status"] == true &&
          responseJSON.data["link"] != null) {
        return responseJSON.data["link"];
      }
    } on DioError {
      globalFun.showToastMessage(
          "Sorry, not able to connect to OpenBeats server. Please try again",
          Colors.red,
          Colors.white,
          true);
      onStop();
    }
    return null;
  }
}
