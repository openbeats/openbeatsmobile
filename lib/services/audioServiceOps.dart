import 'package:obsmobile/imports.dart';

class AudioServiceOps {
  // starts the audioService
  Future<bool> _startAudioService() async {
    return await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      androidNotificationChannelName: 'OBSMobile',
      androidStopForegroundOnPause: true,
      androidNotificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidEnableQueue: true,
    );
  }

  // used to start a single song playback
  Future<void> startSingleSongPlayback(Map<String, String> songObject) async {
    // starting audio service if it is not started
    if (await _startAudioService() == true ||
        await _startAudioService() == false) {
      AudioService.customAction("startSinglePlayback", songObject)
          .then((value) => {print("Hi there!")});
    }
  }
}

// NOTE: Your entrypoint MUST be a top-level function.
void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioPlayerTask extends BackgroundAudioTask {
  final _queue = <MediaItem>[];
  int _queueIndex = -1;
  AudioPlayer _audioPlayer = new AudioPlayer();
  AudioProcessingState _skipState;
  bool _playing;
  bool _interrupted = false;

  bool get hasNext => _queueIndex + 1 < _queue.length;

  bool get hasPrevious => _queueIndex > 0;

  MediaItem get mediaItem => _queue[_queueIndex];

  StreamSubscription<AudioPlaybackState> _playerStateSubscription;
  StreamSubscription<AudioPlaybackEvent> _eventSubscription;

  @override
  void onStart(Map<String, dynamic> params) {
    _playerStateSubscription = _audioPlayer.playbackStateStream
        .where((state) => state == AudioPlaybackState.completed)
        .listen((state) {
      _handlePlaybackCompleted();
    });
    _eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      final bufferingState =
          event.buffering ? AudioProcessingState.buffering : null;
      switch (event.state) {
        case AudioPlaybackState.paused:
          _setState(
            processingState: bufferingState ?? AudioProcessingState.ready,
            position: event.position,
          );
          break;
        case AudioPlaybackState.playing:
          _setState(
            processingState: bufferingState ?? AudioProcessingState.ready,
            position: event.position,
          );
          break;
        case AudioPlaybackState.connecting:
          _setState(
            processingState: _skipState ?? AudioProcessingState.connecting,
            position: event.position,
          );
          break;
        default:
          break;
      }
    });

    AudioServiceBackground.setQueue(_queue);
    onSkipToNext();
  }

  void _handlePlaybackCompleted() {
    if (hasNext) {
      onSkipToNext();
    } else {
      onStop();
    }
  }

  void playPause() {
    if (AudioServiceBackground.state.playing)
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
        ? AudioProcessingState.skippingToNext
        : AudioProcessingState.skippingToPrevious;
    await _audioPlayer.setUrl(mediaItem.id);
    _skipState = null;
    // Resume playback if we were playing
    if (_playing) {
      onPlay();
    } else {
      _setState(processingState: AudioProcessingState.ready);
    }
  }

  @override
  void onPlay() {
    if (_skipState == null) {
      _playing = true;
      _audioPlayer.play();
      AudioServiceBackground.sendCustomEvent('just played');
    }
  }

  @override
  void onPause() {
    if (_skipState == null) {
      _playing = false;
      _audioPlayer.pause();
      AudioServiceBackground.sendCustomEvent('just paused');
    }
  }

  @override
  void onSeekTo(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void onClick(MediaButton button) {
    playPause();
  }

  @override
  Future<void> onFastForward() async {
    await _seekRelative(fastForwardInterval);
  }

  @override
  Future<void> onRewind() async {
    await _seekRelative(rewindInterval);
  }

  Future<void> _seekRelative(Duration offset) async {
    var newPosition = _audioPlayer.playbackEvent.position + offset;
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > mediaItem.duration) newPosition = mediaItem.duration;
    await _audioPlayer.seek(_audioPlayer.playbackEvent.position + offset);
  }

  @override
  Future<void> onStop() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
    _playing = false;
    _playerStateSubscription.cancel();
    _eventSubscription.cancel();
    await _setState(processingState: AudioProcessingState.stopped);
    // Shut down this task
    await super.onStop();
  }

  /* Handling Audio Focus */
  @override
  void onAudioFocusLost(AudioInterruption interruption) {
    if (_playing) _interrupted = true;
    switch (interruption) {
      case AudioInterruption.pause:
      case AudioInterruption.temporaryPause:
      case AudioInterruption.unknownPause:
        onPause();
        break;
      case AudioInterruption.temporaryDuck:
        _audioPlayer.setVolume(0.5);
        break;
    }
  }

  @override
  void onAudioFocusGained(AudioInterruption interruption) {
    switch (interruption) {
      case AudioInterruption.temporaryPause:
        if (!_playing && _interrupted) onPlay();
        break;
      case AudioInterruption.temporaryDuck:
        _audioPlayer.setVolume(1.0);
        break;
      default:
        break;
    }
    _interrupted = false;
  }

  @override
  void onAudioBecomingNoisy() {
    onPause();
  }

  Future<void> _setState({
    AudioProcessingState processingState,
    Duration position,
    Duration bufferedPosition,
  }) async {
    if (position == null) {
      position = _audioPlayer.playbackEvent.position;
    }
    await AudioServiceBackground.setState(
      controls: getControls(),
      systemActions: [MediaAction.seekTo],
      processingState:
          processingState ?? AudioServiceBackground.state.processingState,
      playing: _playing,
      position: position,
      bufferedPosition: bufferedPosition ?? position,
      speed: _audioPlayer.speed,
    );
  }

  @override
  Future<dynamic> onCustomAction(String name, dynamic args) async {
    super.onCustomAction(name, args);
    print("REached here");
    // creating updatedMediaItemInstance
    MediaItem updatedMediaItem1 = MediaItem(
      id: "https://r2---sn-cvh76nez.googlevideo.com/videoplayback?expire=1592415801&ei=2QHqXuW7LIri4-EPwPGRmAU&ip=15.206.204.126&id=o-AJkJhs3toPb0U-oYH7vpX8PJaLNQ9udRXM0BqfQ03UbZ&itag=251&source=youtube&requiressl=yes&mh=Ql&mm=31%2C29&mn=sn-cvh76nez%2Csn-cvh7knez&ms=au%2Crdu&mv=m&mvi=1&pl=18&initcwndbps=765000&vprv=1&mime=audio%2Fwebm&gir=yes&clen=4172349&dur=263.241&lmt=1574660327680872&mt=1592394097&fvip=6&keepalive=yes&c=WEB&txp=5531432&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRQIgebUvHpphdMb0_bMJFKA7hkUTDMSyEaXMUmv-KSxIThICIQCUPRji2qbMUwlZl9xyLg3fVlwqe0pNJdz2zCpS6yj0dg%3D%3D&ratebypass=yes&sig=AOq0QJ8wRAIgXj7rOQO3CnWa3RndrSymi_fv6rKmmmom3g8w6oi0EuICIB_VDKKN2UEvD9ZQpKWyucTVjqAMqFHryWvdwNIumaQ2",
      album: "OpenBeats Music",
      title: "Hi there",
    );
    MediaItem updatedMediaItem2 = MediaItem(
      id: "https://r2---sn-cvh76nez.googlevideo.com/videoplayback?expire=1592415801&ei=2QHqXuW7LIri4-EPwPGRmAU&ip=15.206.204.126&id=o-AJkJhs3toPb0U-oYH7vpX8PJaLNQ9udRXM0BqfQ03UbZ&itag=251&source=youtube&requiressl=yes&mh=Ql&mm=31%2C29&mn=sn-cvh76nez%2Csn-cvh7knez&ms=au%2Crdu&mv=m&mvi=1&pl=18&initcwndbps=765000&vprv=1&mime=audio%2Fwebm&gir=yes&clen=4172349&dur=263.241&lmt=1574660327680872&mt=1592394097&fvip=6&keepalive=yes&c=WEB&txp=5531432&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRQIgebUvHpphdMb0_bMJFKA7hkUTDMSyEaXMUmv-KSxIThICIQCUPRji2qbMUwlZl9xyLg3fVlwqe0pNJdz2zCpS6yj0dg%3D%3D&ratebypass=yes&sig=AOq0QJ8wRAIgXj7rOQO3CnWa3RndrSymi_fv6rKmmmom3g8w6oi0EuICIB_VDKKN2UEvD9ZQpKWyucTVjqAMqFHryWvdwNIumaQ2",
      album: "OpenBeats Music",
      title: "Hi there",
    );
    // setting the current mediaItem
    await AudioServiceBackground.setMediaItem(updatedMediaItem1);
    // adding mediaITem to queue
    _queue.add(updatedMediaItem1);
    _queue.add(updatedMediaItem2);
    // setting URL for audio player
    await _audioPlayer.setUrl(
        "https://r2---sn-cvh76nez.googlevideo.com/videoplayback?expire=1592415801&ei=2QHqXuW7LIri4-EPwPGRmAU&ip=15.206.204.126&id=o-AJkJhs3toPb0U-oYH7vpX8PJaLNQ9udRXM0BqfQ03UbZ&itag=251&source=youtube&requiressl=yes&mh=Ql&mm=31%2C29&mn=sn-cvh76nez%2Csn-cvh7knez&ms=au%2Crdu&mv=m&mvi=1&pl=18&initcwndbps=765000&vprv=1&mime=audio%2Fwebm&gir=yes&clen=4172349&dur=263.241&lmt=1574660327680872&mt=1592394097&fvip=6&keepalive=yes&c=WEB&txp=5531432&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRQIgebUvHpphdMb0_bMJFKA7hkUTDMSyEaXMUmv-KSxIThICIQCUPRji2qbMUwlZl9xyLg3fVlwqe0pNJdz2zCpS6yj0dg%3D%3D&ratebypass=yes&sig=AOq0QJ8wRAIgXj7rOQO3CnWa3RndrSymi_fv6rKmmmom3g8w6oi0EuICIB_VDKKN2UEvD9ZQpKWyucTVjqAMqFHryWvdwNIumaQ2");
    // playing audio
    onPlay();
  }

  List<MediaControl> getControls() {
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
