import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './globalVars.dart' as globalVars;
import './globalFun.dart' as globalFun;

// snackBar to show network error
SnackBar networkErrorSBar = new SnackBar(
  content: Text(
    "Not able to connect to the internet",
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.orange,
  duration: Duration(hours: 10),
);

Widget noInternetView(refreshFunction) {
  return Container(
      margin: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Icon(
                FontAwesomeIcons.redo,
                size: 40.0,
                color: globalVars.accentRed,
              ),
              onPressed: () {
                refreshFunction();
              },
              color: Colors.transparent,
              textColor: globalVars.accentBlue,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text("Not able to connect to\nserver",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 22.0)),
          ],
        ),
      ));
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

// holds the flutterActor for showing the current playing media
Widget nowPlayingFlutterActor(bool isPlaying) {
  return FlareActor(
    'assets/flareAssets/analysis_new.flr',
    animation: isPlaying
        ? null
        : 'ana'
            'lysis'
            '',
    fit: BoxFit.scaleDown,
  );
}

// holds the loadingAnimation for the current playing media file
Widget nowPlayingLoadingAnimation() {
  return Container(
      margin: EdgeInsets.all(20.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(globalVars.accentWhite),
      ));
}

// shows the actual thumbnail of the media
Widget showActualThumbnail(String thumbnail) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(5.0),
    child: CachedNetworkImage(
      imageUrl: thumbnail,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        margin: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(globalVars.accentRed),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    ),
  );
}

// holds the background for the bottom sheet
Widget bottomSheetBGW(audioThumbnail) {
  return Opacity(
    child: Container(
        height: 300.0,
        color: Colors.black,
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(20.0),
          child: CachedNetworkImage(
            imageUrl: audioThumbnail,
            fit: BoxFit.cover,
            placeholder: (context, url) => null,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        )),
    opacity: 0.3,
  );
}

// holds the title for the bottomSheet
Widget bottomSheetTitleW(audioTitle) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.all(10.0),
    child: Text(
      audioTitle,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    ),
  );
}

// holds the playback control buttons
Widget bNavPlayControlsW(context, state) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      bNavSkipPrevious(),
      SizedBox(
        width: 10.0,
      ),
      bNavPlayBtn(state),
      SizedBox(
        width: 10.0,
      ),
      bNavSkipNext()
    ],
  );
}

// button to hold the play and pause Button
// mode 1 - music stopped, 2 - music playing
Widget bNavPlayBtn(state) {
  return Container(
    child: (AudioService.playbackState != null)
        ? (AudioService.playbackState.basicState ==
                    BasicPlaybackState.playing ||
                AudioService.playbackState.basicState ==
                    BasicPlaybackState.paused ||
                AudioService.playbackState.basicState ==
                    BasicPlaybackState.skippingToNext ||
                AudioService.playbackState.basicState ==
                    BasicPlaybackState.skippingToPrevious)
            ? IconButton(
                onPressed: () {
                  if (AudioService.playbackState != null &&
                      AudioService.playbackState.basicState !=
                          BasicPlaybackState.playing)
                    AudioService.play();
                  else
                    AudioService.pause();
                },
                iconSize: 45.0,
                icon: (AudioService.playbackState.basicState !=
                        BasicPlaybackState.playing)
                    ? Icon(FontAwesomeIcons.solidPlayCircle)
                    : Icon(FontAwesomeIcons.solidPauseCircle),
              )
            : null
        : null,
  );
}

// holds the skip previous
Widget bNavSkipPrevious() {
  return Container(
    child: (AudioService.playbackState != null && AudioService.queue.length > 0)
        ? (AudioService.playbackState.basicState ==
                    BasicPlaybackState.playing ||
                AudioService.playbackState.basicState ==
                    BasicPlaybackState.paused ||
                AudioService.playbackState.basicState ==
                    BasicPlaybackState.skippingToNext ||
                AudioService.playbackState.basicState ==
                    BasicPlaybackState.skippingToPrevious)
            ? IconButton(
                onPressed: () {
                  AudioService.skipToPrevious();
                },
                iconSize: 30.0,
                icon: Icon(FontAwesomeIcons.stepBackward))
            : null
        : null,
  );
}

// holds the skip previous
Widget bNavSkipNext() {
  return Container(
    child: (AudioService.playbackState != null && AudioService.queue.length > 0)
        ? (AudioService.playbackState.basicState ==
                    BasicPlaybackState.playing ||
                AudioService.playbackState.basicState ==
                    BasicPlaybackState.paused ||
                AudioService.playbackState.basicState ==
                    BasicPlaybackState.skippingToNext ||
                AudioService.playbackState.basicState ==
                    BasicPlaybackState.skippingToPrevious)
            ? IconButton(
                onPressed: () {
                  AudioService.skipToNext();
                },
                iconSize: 30.0,
                icon: Icon(FontAwesomeIcons.stepForward))
            : null
        : null,
  );
}

Widget fabView(settingModalBottomSheet, scaffoldKey) {
  return StreamBuilder(
      stream: AudioService.playbackStateStream,
      builder: (context, snapshot) {
        PlaybackState state = snapshot.data;
        if (state != null && state.basicState == BasicPlaybackState.error) {
          // stopping audio playback if an error has been detected
          AudioService.stop();
        }
        return (state != null &&
                (state.basicState == BasicPlaybackState.connecting ||
                    state.basicState == BasicPlaybackState.playing ||
                    state.basicState == BasicPlaybackState.buffering ||
                    state.basicState == BasicPlaybackState.paused))
            ? (state.basicState == BasicPlaybackState.buffering ||
                    state.basicState == BasicPlaybackState.connecting)
                ? fabBtnW(
                    settingModalBottomSheet, context, false, false, scaffoldKey)
                : (state.basicState == BasicPlaybackState.paused)
                    ? fabBtnW(settingModalBottomSheet, context, true, true,
                        scaffoldKey)
                    : fabBtnW(settingModalBottomSheet, context, true, false,
                        scaffoldKey)
            : Container();
      });
}

// holds the floating action button
Widget fabBtnW(settingModalBottomSheet, context, bool isPlaying, bool isPaused,
    scaffoldKey) {
  return FloatingActionButton(
    onPressed: () {
      settingModalBottomSheet(context);
    },
    child: (isPlaying)
        ? FlareActor(
            'assets/flareAssets/analysis_new.flr',
            animation: (isPaused)
                ? null
                : 'ana'
                    'lysis'
                    '',
            fit: BoxFit.scaleDown,
          )
        : CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ),
    backgroundColor: Color(0xFFFF5C5C),
    foregroundColor: Colors.white,
  );
}

// holds the media timing widgets
Widget mediaTimingW(state, context, audioDurationMin) {
  return Container(
    margin: EdgeInsets.only(left: 10.0, right: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Text(
              (state != null)
                  ? globalFun.getCurrentTimeStamp(state.currentPosition / 1000)
                  : "00:00",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.start),
          width: MediaQuery.of(context).size.width * 0.5,
        ),
        Container(
          child: Text(
            audioDurationMin,
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.end,
          ),
          width: MediaQuery.of(context).size.width * 0.3,
        )
      ],
    ),
  );
}

// holds the buffering indicator
Widget bufferingIndicator() {
  return SizedBox(
    height: 20.0,
    child: Container(
      child: (AudioService.playbackState != null)
          ? (AudioService.playbackState.basicState ==
                  BasicPlaybackState.buffering)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                      width: 10.0,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(globalVars.accentRed),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "Buffering...",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                )
              : null
          : null,
    ),
  );
}
