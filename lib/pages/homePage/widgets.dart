import 'package:obsmobile/imports.dart';
import 'package:obsmobile/models/homePageModels/bottomNavBarDest.dart';
import 'package:rxdart/rxdart.dart';

// holds the bottomNavBarItem for the homePage
BottomNavigationBarItem bottomNavBarItem(
    Destination destination, UserModel userdata) {
  // getting the current avatar and user name
  String _currAvatar = userdata.getUserDetails()["avatar"];
  String _userName = userdata.getUserDetails()["name"];
  return BottomNavigationBarItem(
      icon: (destination.icon == Icons.person && _currAvatar != null)
          ? Container(
              child: cachedNetworkImageW(_currAvatar),
              height: 30.0,
              width: 30.0,
              margin: EdgeInsets.only(bottom: 3.0),
            )
          : Icon(destination.icon),
      title: (destination.icon == Icons.person && _currAvatar != null)
          ? Text(
              _userName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : Text(destination.title),
      backgroundColor: destination.color);
}

// holds the widget to show in SlidingUpPanelCollapsed when no audio is playing
Widget slidingUpPanelCollapsedDefault() {
  return Center(
    child: Container(
      height: 35.0,
      child: FlareActor(
        "assets/flareAssets/logoanimwhite.flr",
        animation: "rotate",
      ),
    ),
  );
}

// holds the nowPlayingTitleHolder
Widget nowPlayingTitleHolder(MediaItem _currMediaItem) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        (_currMediaItem != null)
            ? _currMediaItem.title
            : "Welcome to\nOpenBeats",
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
      ));
}

// holds the play pause icon in the collapsed slideUpPanel
Widget collapsedPanelSlideUpPanel() {
  // sets the parameters
  Icon _icon;
  AudioProcessingState _processingState;
  if (AudioService.playbackState != null) {
    _processingState = AudioService.playbackState.processingState;
    if (AudioService.playbackState.playing)
      _icon = Icon(Icons.pause);
    else
      _icon = Icon(Icons.play_arrow);
  } else
    _icon = Icon(Icons.play_arrow);

  // used to check if a queue is playing
  bool _isQueue = (AudioService.queue != null && AudioService.queue.length > 1)
      ? true
      : false;

  return Container(
    width: (_isQueue) ? 60.0 : 40.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          child: (_processingState != AudioProcessingState.connecting ||
                  _processingState != AudioProcessingState.buffering)
              ? _icon
              : Container(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(),
                ),
          onTap: () {
            if (AudioService.playbackState != null) {
              if (AudioService.playbackState.playing)
                AudioService.pause();
              else
                AudioService.play();
            }
          },
        ),
        SizedBox(width: 5.0),
        Container(
          margin: EdgeInsets.only(left: 5.0),
          child: (_isQueue)
              ? InkWell(
                  child: (_processingState != AudioProcessingState.connecting ||
                          _processingState != AudioProcessingState.buffering)
                      ? Icon(Icons.skip_next)
                      : Container(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(),
                        ),
                  onTap: () {
                    AudioService.skipToNext();
                  },
                )
              : null,
        )
      ],
    ),
  );
}

// holds the slideUpPanel thumbnail viewer
Widget slideUpPanelThumbnail(BuildContext context, MediaItem _currMediaItem) {
  Orientation _currOrientation = MediaQuery.of(context).orientation;
  double _dimensions = (_currOrientation == Orientation.portrait)
      ? MediaQuery.of(context).size.height * 0.35
      : MediaQuery.of(context).size.height * 0.25;
  return Container(
    height: _dimensions,
    width: _dimensions,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: cachedNetworkImageW(_currMediaItem?.artUri),
    ),
  );
}

// holds the slideUpPanel title viewer
Widget slideUpPanelTitle(BuildContext context, MediaItem _currMediaItem) {
  // holds the title to show to users
  String _title = "Welcome to OpenBeats";
  if (_currMediaItem != null) _title = _currMediaItem.title;
  double _containerWidth = MediaQuery.of(context).size.width;
  Orientation _currOrientation = MediaQuery.of(context).orientation;
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 30.0),
    width: (_currOrientation == Orientation.portrait)
        ? null
        : _containerWidth * 0.5,
    child: Text(
      _title,
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

// holds the slideUpPanel seek bar viewer
Widget slideUpPanelSeekBar(BuildContext context, PlaybackState _state,
    MediaItem _mediaItem, BehaviorSubject<double> _dragPositionSubject) {
  // compiling values
  double _position =
      (_state != null) ? _state.currentPosition.inMilliseconds.toDouble() : 0.0;
  double _audioDuration = (_mediaItem != null)
      ? _mediaItem.duration.inMilliseconds.toDouble()
      : 0.0;
  String _currPositionTimeStamp = getCurrentTimeStamp(_position / 1000);
  String _currDurationTimeStamp = getCurrentTimeStamp(_audioDuration / 1000);
  double seekPos;
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15.0),
    child: Column(
      children: <Widget>[
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 5.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
          ),
          child: Slider(
            min: 0.0,
            max: _audioDuration,
            value: seekPos ?? max(0.0, min(_position, _audioDuration)),
            onChanged: (value) {
              _dragPositionSubject.add(value);
            },
            onChangeEnd: (value) {
              AudioService.seekTo(Duration(milliseconds: value.toInt()));

              seekPos = value;
              _dragPositionSubject.add(null);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _currPositionTimeStamp,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _currDurationTimeStamp,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

// holds the major controls of the slideUpPanel
Widget slideUpPanelMajorControls(BuildContext context, PlaybackState _state) {
  // filtering required values
  bool _isPlaying = (_state != null) ? _state.playing : null;
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _slideUpPanelSeekBackwardBtn(),
        _slideUpPanelPreviousSong(),
        _slideUpPanelPlayPauseBtn(_isPlaying),
        _slideUpPanelNextSong(),
        _slideUpPanelSeekForwardBtn()
      ],
    ),
  );
}

// holds the minor controls for the slideUpPanel
Widget slideUpPanelMinorControls(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 40.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _slideUpPanelFavBtn(),
        _slideUpPanelShuffleBtn(),
        _slideUpPanelRepeatBtn(),
        _slideUpPanelQueueBtn()
      ],
    ),
  );
}

// holds the main play/pause button for slideUpPanel
Widget _slideUpPanelPlayPauseBtn(bool _isPlaying) {
  return Container(
    child: ClipOval(
      child: Material(
        color: (_isPlaying != null) ? Colors.red : Colors.grey, // button color
        child: GestureDetector(
          child: SizedBox(
            width: 70,
            height: 70,
            child: Center(
              child: IconButton(
                icon:
                    Icon((_isPlaying == true) ? Icons.pause : Icons.play_arrow),
                onPressed: (_isPlaying == null)
                    ? null
                    : () {
                        if (_isPlaying)
                          AudioService.pause();
                        else
                          AudioService.play();
                      },
                iconSize: 40.0,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// holds the main nextsong button for slideUpPanel
Widget _slideUpPanelNextSong() {
  return Container(
    child: IconButton(
      icon: Icon(Icons.skip_next),
      onPressed: (AudioService.running && AudioService.queue.length > 1)
          ? () {
              AudioService.skipToNext();
            }
          : null,
      iconSize: 30.0,
    ),
  );
}

// holds the main previoussong button for slideUpPanel
Widget _slideUpPanelPreviousSong() {
  return Container(
    child: IconButton(
      icon: Icon(Icons.skip_previous),
      onPressed: (AudioService.running && AudioService.queue.length > 1)
          ? () {
              AudioService.skipToPrevious();
            }
          : null,
      iconSize: 30.0,
    ),
  );
}

// holds the main seekforward button for slideUpPanel
Widget _slideUpPanelSeekForwardBtn() {
  return Container(
    child: IconButton(
      icon: Icon(Icons.forward_10),
      onPressed: (AudioService.running)
          ? () {
              // getting current position
              int _currPosition =
                  AudioService.playbackState.currentPosition.inMilliseconds;
              // seeking 10 seconds forward
              AudioService.seekTo(
                  Duration(milliseconds: (_currPosition + 10000)));
            }
          : null,
      iconSize: 30.0,
    ),
  );
}

// holds the main seekbackward button for slideUpPanel
Widget _slideUpPanelSeekBackwardBtn() {
  return Container(
    child: IconButton(
      icon: Icon(Icons.replay_10),
      onPressed: (AudioService.running)
          ? () {
              // getting current position
              int _currPosition =
                  AudioService.playbackState.currentPosition.inMilliseconds;
              // seeking 10 seconds forward
              AudioService.seekTo(
                  Duration(milliseconds: (_currPosition - 10000)));
            }
          : null,
      iconSize: 30.0,
    ),
  );
}

// holds the minor repeatsong button for slideUpPanel
Widget _slideUpPanelRepeatBtn() {
  return Consumer<MediaModel>(
    builder: (context, data, child) {
      // repeat option currently in action
      String _repeatStatus = "noRepeat";
      // print(data.getRepeatQueue());
      // print(data.getRepeatSong());
      if (data.getRepeatQueue()) _repeatStatus = "repeatAll";
      if (data.getRepeatSong()) _repeatStatus = "repeatSong";
      return IconButton(
        icon: Icon(
            (_repeatStatus == "repeatSong") ? Icons.repeat_one : Icons.repeat),
        onPressed: (_repeatStatus != "noRepeat")
            ? () {
                if (_repeatStatus == "repeatAll") {
                  Provider.of<MediaModel>(context, listen: false)
                      .setRepeatQueue(true);
                  Provider.of<MediaModel>(context, listen: false)
                      .setRepeatSong(false);
                } else if (_repeatStatus == "repeatSong") {
                  Provider.of<MediaModel>(context, listen: false)
                      .setRepeatSong(true);
                  Provider.of<MediaModel>(context, listen: false)
                      .setRepeatQueue(false);
                }
              }
            : null,
      );
    },
  );
}

// holds the minor favorite button for slideUpPanel
Widget _slideUpPanelFavBtn() {
  return IconButton(icon: Icon(Icons.favorite_border), onPressed: null);
}

// holds the minor shuffle button for slideUpPanel
Widget _slideUpPanelShuffleBtn() {
  return IconButton(icon: Icon(Icons.shuffle), onPressed: null);
}

// holds the minor queue button for slideUpPanel
Widget _slideUpPanelQueueBtn() {
  return IconButton(icon: Icon(Icons.queue_music), onPressed: null);
}
