import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../globals/globalVars.dart' as globalVars;
import '../globals/globalWids.dart' as globalWids;
import '../globals/globalStrings.dart' as globalStrings;
import '../globals/globalColors.dart' as globalColors;

// BottomNavBar items for BottomNavBar
List<BottomNavigationBarItem> bottomNavBarItems() {
  // holds list of bottomNavBarItems
  List<BottomNavigationBarItem> bottomNavItemList = [];
  // creating bottomNavBarItems and adding them to the list
  globalWids.bottomNavBarIcons.asMap().forEach(
        (int index, IconData icon) => bottomNavItemList.add(
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.only(bottom: 4.0),
              child: Icon(icon),
            ),
            backgroundColor: globalColors.backgroundClr,
            title: Text(globalStrings.bottomNavBarItemLabels[index]),
          ),
        ),
      );
  return bottomNavItemList;
}

// collapsed widget for the SlidingUpPanel
Widget collapsedSlidingUpPanel(
    BuildContext context,
    Function audioServicePlayPause,
    AnimationController playPauseAnimationController) {
  // setting default values
  String audioThumbnail = "placeholder",
      audioTitle = globalStrings.noAudioPlayingString;
  return StreamBuilder(
      stream: AudioService.playbackStateStream,
      builder: (context, snapshot) {
        PlaybackState state = snapshot.data;

        if (state != null &&
            state.basicState != BasicPlaybackState.none &&
            state.basicState != BasicPlaybackState.stopped) {
          if (AudioService.currentMediaItem != null &&
              state.basicState != BasicPlaybackState.connecting) {
            // getting thumbNail image
            audioThumbnail = AudioService.currentMediaItem.artUri;
            // getting audioTitle
            audioTitle = AudioService.currentMediaItem.title;
          }
          // if the audio is connecting
          else if (AudioService.currentMediaItem != null &&
              state.basicState == BasicPlaybackState.connecting) {
            // getting thumbNail image
            audioThumbnail = AudioService.currentMediaItem.artUri;
            audioTitle = "Connecting...";
          }
        } else {
          // resetting values
          audioThumbnail = "placeholder";
          audioTitle = globalStrings.noAudioPlayingString;
        }

        return Container(
            decoration: BoxDecoration(
              color: globalColors.backgroundClr,
            ),
            child: nowPlayingCollapsedContent(state, audioThumbnail, audioTitle,
                context, audioServicePlayPause, playPauseAnimationController));
      });
}

// holds the row widget showing now playing media details in collapsed slideUpPanel
Widget nowPlayingCollapsedContent(
    PlaybackState state,
    String audioThumbnail,
    String audioTitle,
    BuildContext context,
    Function audioServicePlayPause,
    AnimationController playPauseAnimationController) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.03,
      ),
      Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: globalWids.audioThumbnailW(audioThumbnail, context, 0.15, 5.0),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.03,
      ),
      Flexible(
        flex: 3,
        fit: FlexFit.tight,
        child: globalWids.audioTitleW(audioTitle, context, false, false),
      ),
      Flexible(
        flex: 2,
        fit: FlexFit.tight,
        child: collapsedSlideUpControls(
            state,
            context,
            audioServicePlayPause,
            playPauseAnimationController,
            (audioThumbnail == "placeholder") ? true : false),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.03,
      ),
    ],
  );
}

// holds the play controls for the collapsed slide up panel
Widget collapsedSlideUpControls(
    PlaybackState state,
    BuildContext context,
    Function audioServicePlayPause,
    AnimationController playPauseAnimationController,
    bool noAudioPlaying) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.2,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        playPauseBtn(state, audioServicePlayPause, playPauseAnimationController,
            noAudioPlaying),
        queueBtn(noAudioPlaying),
      ],
    ),
  );
}

// holds th play&pause btn for collapsed slideUpPanel
Widget playPauseBtn(PlaybackState state, Function audioServicePlayPause,
    AnimationController playPauseAnimationController, bool noAudioPlaying) {
  // decides the animation for the animated icon
  if (state != null &&
      (state.basicState == BasicPlaybackState.paused ||
          state.basicState == BasicPlaybackState.playing)) {
    if (state.basicState == BasicPlaybackState.paused)
      playPauseAnimationController.reverse();
    else
      playPauseAnimationController.forward();
  } else {
    playPauseAnimationController.reverse();
  }
  return IconButton(
    iconSize: 35.0,
    color: (noAudioPlaying)
        ? globalColors.iconDisabledClr
        : globalColors.iconDefaultClr,
    icon: AnimatedIcon(
      icon: AnimatedIcons.play_pause,
      progress: playPauseAnimationController,
    ),
    onPressed: () {
      audioServicePlayPause();
    },
  );
}

// holds the queue button for the collapsed slideUpPanel
Widget queueBtn(bool noAudioPlaying) {
  return IconButton(
    iconSize: 35.0,
    color: (noAudioPlaying)
        ? globalColors.iconDisabledClr
        : globalColors.iconDefaultClr,
    icon: Icon(Icons.queue_music),
    onPressed: () {},
  );
}

//  expanded widget for the SlidingUpPanel
Widget expandedSlidingUpPanel() {
  return Container(
    child: null,
  );
}
