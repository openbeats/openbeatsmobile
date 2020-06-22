import 'package:obsmobile/imports.dart';
import 'package:obsmobile/models/homePageModels/bottomNavBarDest.dart';
import 'package:rxdart/rxdart.dart';

// holds the bottomNavBarItem for the homePage
BottomNavigationBarItem bottomNavBarItem(Destination destination) {
  return BottomNavigationBarItem(
      icon: Icon(destination.icon),
      title: Text(destination.title),
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

  return IconButton(
      icon: (_processingState != AudioProcessingState.connecting ||
              _processingState != AudioProcessingState.buffering)
          ? _icon
          : Container(
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator(),
            ),
      onPressed: () {
        if (AudioService.playbackState != null) {
          if (AudioService.playbackState.playing)
            AudioService.pause();
          else
            AudioService.play();
        }
      });
}

// holds the slideUpPanel thumbnail viewer
Widget slideUpPanelThumbnail(BuildContext context, MediaItem _currMediaItem) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.4,
    width: MediaQuery.of(context).size.height * 0.4,
    child: cachedNetworkImageW(_currMediaItem?.artUri),
  );
}

// holds the slideUpPanel title viewer
Widget slideUpPanelTitle(BuildContext context, MediaItem _currMediaItem) {
  // holds the title to show to users
  String _title = "Welcome to OpenBeats";
  if (_currMediaItem != null) _title = _currMediaItem.title;
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 30.0),
    child: Text(
      _title,
      style: TextStyle(
        fontSize: 24.0,
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
    margin: EdgeInsets.symmetric(horizontal: 35.0),
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
        Row(
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
        )
      ],
    ),
  );
}

// holds the major controls of the slideUpPanel
Widget slideUpPanelMajorControls(BuildContext context, PlaybackState _state) {
  // filtering required values
  bool _isPlaying = (_state != null) ? _state.playing : null;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[_slideUpPanelPlayPauseBtn(_isPlaying)],
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
