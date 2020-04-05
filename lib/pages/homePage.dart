import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../tabs/exploreTab.dart';
import '../tabs/searchTab.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../widgets/homePageW.dart' as homePageW;
import '../globals/globalVars.dart' as globalVars;
import '../globals/globalColors.dart' as globalColors;

class HomePage extends StatefulWidget {
  // inheriting routeObserver instance
  RouteObserver<PageRoute> routeObserver;
  HomePage(this.routeObserver);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // holds the list of tab pages for homePage body
  List<Widget> homePageTabBody = [
    ExploreTab(startAudioService),
    Center(
      child: Text("Page 2"),
    ),
    SearchTab(),
    Center(
      child: Text("Page 4"),
    ),
    Center(
      child: Text("Page 5"),
    ),
  ];

  ///////////////////////// AudioService Methods - Start

  static void startAudioService() {
    AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      androidNotificationChannelName: 'Audio Service Demo',
      notificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      enableQueue: true,
    );
  }

  //////////////////////// AudioService Methods - End

  // connects to the audioService
  void audioServiceConnect() async {
    await AudioService.connect();
  }

  // disconnects from the audioService
  void audioServiceDisconnect() {
    AudioService.disconnect();
  }

  @override
  void initState() {
    super.initState();
    // connect to the audioService when homePage initiates
    audioServiceConnect();
  }

  @override
  void dispose() {
    // disconnecting from audioService
    audioServiceDisconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globalColors.primaryLight,
      body: SafeArea(
        child: homePageWidgets(),
      ),
    );
  }

  Widget homePageWidgets() {
    return SlidingUpPanel(
      maxHeight: MediaQuery.of(context).size.height,
      minHeight: MediaQuery.of(context).size.height * 0.09,
      collapsed: slideUpCollapsedW(),
      panel: slideUpPanelW(),
      body: homePageScaffold(),
    );
  }

  Widget slideUpCollapsedW() {
    return Container(
      decoration: BoxDecoration(
        color: globalColors.primaryLight,
      ),
      child: null,
    );
  }

  Widget slideUpPanelW() {
    return Container(
      child: Center(
        child: Text("This is the sliding Widget"),
      ),
    );
  }

  Widget homePageScaffold() {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: globalColors.primaryLight,
        appBar: homePageW.homePageAppBar(),
        body: TabBarView(
          children: homePageTabBody,
        ),
      ),
    );
  }
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioPlayerTask extends BackgroundAudioTask {
  final _queue = <MediaItem>[
    MediaItem(
      id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
      album: "Science Friday",
      title: "A Salute To Head-Scratching Science",
      artist: "Science Friday and WNYC Studios",
      duration: 5739820,
      artUri:
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    ),
    MediaItem(
      id: "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3",
      album: "Science Friday",
      title: "From Cat Rheology To Operatic Incompetence",
      artist: "Science Friday and WNYC Studios",
      duration: 2856950,
      artUri:
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    ),
  ];
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
      // case AudioPlaybackState.buffering:
      //   return BasicPlaybackState.buffering;
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

    AudioServiceBackground.setQueue(_queue);
    await onSkipToNext();
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
        homePageW.skipToPreviousControl,
        homePageW.pauseControl,
        homePageW.stopControl,
        homePageW.skipToNextControl
      ];
    } else {
      return [
        homePageW.skipToPreviousControl,
        homePageW.playControl,
        homePageW.stopControl,
        homePageW.skipToNextControl
      ];
    }
  }
}
