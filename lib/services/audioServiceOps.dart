import 'package:obsmobile/imports.dart';

class AudioServiceOps {
  // starts the audioService
  Future<bool> _startAudioService() async {
    return await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      androidNotificationChannelName: 'OBSPlayback',
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'drawable/ic_stat_logoicon2',
      androidEnableQueue: true,
    );
  }

  // used to start a single song playback
  Future<void> startSingleSongPlayback(mediaParameters) async {
    // starting audio service if it is not started
    if (await _startAudioService() == true ||
        await _startAudioService() == false) {
      AudioService.customAction("startSinglePlayback", mediaParameters);
    }
  }

  // used to start playlist playback
  Future<void> startPlaylistPlayback(mediaParameterList) async {
    // starting audio service if it is not started
    if (await _startAudioService() == true ||
        await _startAudioService() == false) {
      AudioService.customAction("startPlaylistPlayback", mediaParameterList);
    }
  }

  // used to fetch the mediaRepeat status from audioBackgroundService
  Future<void> getMediaRepeatStatus() async {
    // starting audio service if it is not started
    if (await _startAudioService() == true ||
        await _startAudioService() == false) {
      AudioService.customAction("checkSongRepeatStatus");
      AudioService.customAction("checkQueueRepeatStatus");
    }
  }

  // set repeat status in AudioBackgroundService
  void setAudioServiceRepeat(String _repeatStatus) async {
    // starting audio service if it is not started
    if (await _startAudioService() == true ||
        await _startAudioService() == false) {
      AudioService.customAction("setSongRepeatStatus", {
        "repeatStatus": _repeatStatus,
      });
    }
  }

  // used to set the user token on sign in or on application start
  void setUserToken(String token) async {
    // starting audio service if it is not started
    if (await _startAudioService() == true ||
        await _startAudioService() == false) {
      AudioService.customAction("setUserToken", {
        "userToken": token,
      });
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
  // repeat flag
  bool _repeatSong = false;
  bool _repeatQueue = false;
  // stores the user's auth token if they are signed in
  String _userToken = "";

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
    if (_repeatSong) {
      onSkipToNext();
    } else if (_repeatQueue) {
      onSkipToNext();
    } else {
      if (hasNext) {
        onSkipToNext();
      } else {
        onStop();
      }
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
    // holds the new position of the queueIndex after offset
    int newPos = _queueIndex + offset;

    // conditionals for the repeat queue and repeat song management
    // if repeat song is activated
    if (_repeatSong) {
      // nullifying the effect of the skip
      newPos -= offset;
    } else if (_repeatQueue) {
      // check if the queue has more than one element
      if (_queue.length > 1) {
        // check if it is the right corner of the queue
        if (newPos == _queue.length)
          newPos = 0;
        // check if it is the left corner of queue
        else if (newPos < 0) newPos = _queue.length - 1;
      }
      // if the queue has only one element
      else {
        // nullifying the effect of the skip
        newPos -= offset;
      }
    }

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
    AudioServiceBackground.setMediaItem(_queue[_queueIndex]);

    _skipState = offset > 0
        ? AudioProcessingState.skippingToNext
        : AudioProcessingState.skippingToPrevious;
    await _audioPlayer.setUrl(_queue[_queueIndex].id);
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
    // execute function based on name
    if (name == "startSinglePlayback") {
      // clearing queue
      _queue.clear();
      startSinglePlayback(args, false);
    } else if (name == "startPlaylistPlayback") {
      _queue.clear();
      startPlaylistPlayback(args);
    } else if (name == "setUserToken") _userToken = args["userToken"];

    // repeat status conditionals
    if (name == "checkSongRepeatStatus") {
      if (_repeatSong)
        AudioServiceBackground.sendCustomEvent("repeatSongTrue");
      else
        AudioServiceBackground.sendCustomEvent("repeatSongFalse");
    } else if (name == "checkQueueRepeatStatus") {
      if (_repeatQueue)
        AudioServiceBackground.sendCustomEvent("repeatQueueTrue");
      else
        AudioServiceBackground.sendCustomEvent("repeatQueueFalse");
    } else if (name == "setSongRepeatStatus") setSongRepeatStatus(args);
  }

  // used to set the song repeat status
  void setSongRepeatStatus(dynamic args) {
    // print(args["repeatStatus"]);
    if (args["repeatStatus"] == "noRepeat") {
      _repeatSong = false;
      _repeatQueue = false;
    } else if (args["repeatStatus"] == "repeatAll") {
      _repeatSong = false;
      _repeatQueue = true;
    } else if (args["repeatStatus"] == "repeatSong") {
      _repeatSong = true;
      _repeatQueue = false;
    }
    // print("RepeatSong: " + _repeatSong.toString());
    // print("RepeatQueue: " + _repeatQueue.toString());
  }

  // starts playlistPlayback of audio
  Future<void> startPlaylistPlayback(dynamic params) async {
    var songs = params["_songObj"];

    // iterating through the songs in the playlist
    for (int i = 0; i < songs.length; i++) {
      var args = songs[i];

      // for the first song
      if (i == 0) {
        await startSinglePlayback(
            {"token": params["token"], "_songObj": args}, true);
      } else {
        // setting default thumbnail url
        String _defaultThumbnailUrl =
            "https://img.youtube.com/vi/" + args["videoId"] + "/mqdefault.jpg";

        // getting streaming url for the song
        String streamingUrl = await getStreamingUrl(
            {"token": params["token"], "_songObj": args}, true, _userToken);

        _defaultThumbnailUrl =
            await checkHighResThumbnailAvailability(args["videoId"]);

        // constructing media item
        MediaItem _songMediaItem = MediaItem(
            id: streamingUrl,
            album: "OpenBeats Music",
            title: args['title'],
            duration: Duration(
                milliseconds:
                    reformatTimeStampToMilliSeconds(args["duration"])),
            artUri: _defaultThumbnailUrl,
            extras: {
              "vidId": args["videoId"],
              "playlist": "true",
              "durationString": args["duration"],
            });

        // adding mediaItem to queue
        _queue.add(_songMediaItem);

        // print(i.toString());
        // print(i.toString() + " " + _queue[i].title);

        await AudioServiceBackground.setQueue(_queue);
      }
    }
  }

  // starts singleplayback of audio
  Future<void> startSinglePlayback(dynamic params, bool _isPlaylist) async {
    // pausing playback if already playing
    if (_playing != null) onPause();

    // getting the song object from the parameters passed
    var args = params["_songObj"];

    // setting default thumbnail
    String _defaultThumbnailUrl =
        "https://img.youtube.com/vi/" + args["videoId"] + "/mqdefault.jpg";

    // creating temporary mediaItem instance
    MediaItem _songMediaItem = MediaItem(
        id: args["videoId"],
        album: "OpenBeats Music",
        title: args['title'],
        duration: Duration(
            milliseconds: reformatTimeStampToMilliSeconds(args["duration"])),
        artUri: _defaultThumbnailUrl,
        extras: {
          "vidId": args["videoId"],
          "playlist": _isPlaylist.toString(),
          "durationString": args["duration"],
        });

    // setting temporary media item to show response to user
    await AudioServiceBackground.setMediaItem(_songMediaItem);

    if (_playing == null) {
      // First time, we want to start playing
      _playing = true;
    } else if (_playing) {
      // Stop current item
      await _audioPlayer.stop();
    }
    // Load next item
    _queueIndex = 0;
    await AudioServiceBackground.setMediaItem(_songMediaItem);

    String streamingUrl = await getStreamingUrl(params, true, _userToken);

    _defaultThumbnailUrl =
        await checkHighResThumbnailAvailability(args["videoId"]);

    _songMediaItem = MediaItem(
        id: streamingUrl,
        album: "OpenBeats Music",
        title: args['title'],
        duration: Duration(
            milliseconds: reformatTimeStampToMilliSeconds(args["duration"])),
        artUri: _defaultThumbnailUrl,
        // used to mark if this is a playlist or not
        playable: _isPlaylist,
        extras: {
          "vidId": args["videoId"],
          "playlist": _isPlaylist.toString(),
          "durationString": args["duration"],
        });

    await AudioServiceBackground.setMediaItem(_songMediaItem);

    await _audioPlayer.setUrl(_songMediaItem.id);

    // adding mediaItem to queue
    _queue.add(_songMediaItem);
    await AudioServiceBackground.setQueue(_queue);

    onPlay();
  }

  List<MediaControl> getControls() {
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
}
