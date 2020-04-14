import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import '../pages/searchPage.dart';
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalWids.dart' as globalWids;
import '../globals/globalStrings.dart' as globalStrings;
import '../globals/globalFun.dart' as globalFun;
import '../globals/globalVars.dart' as globalVars;

// holds the homePage appBar
Widget homePageAppBar(
    context, Function navigateToSearchPage, TabController tabController) {
  return AppBar(
    elevation: 0,
    titleSpacing: 0.0,
    title: globalWids.homePageLogo,
    actions: <Widget>[
      searchActBtn(context, navigateToSearchPage),
      moreOptionsBtn(),
    ],
    bottom: TabBar(
      controller: tabController,
      isScrollable: true,
      indicatorColor: globalColors.hPTabIndicatorColor,
      unselectedLabelColor: globalColors.subtitleTextColor,
      labelColor: globalColors.hpTabLabelColor,
      unselectedLabelStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
      ),
      labelStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
      ),
      tabs: globalStrings.homePageTabTitles
          .map(
            (String title) => new Tab(
              child: Text(title),
            ),
          )
          .toList(),
    ),
  );
}

// holds the search Action button for the AppBar
Widget searchActBtn(context, Function navigateToSearchPage) {
  return IconButton(
    icon: Icon(Icons.search),
    onPressed: () {
      navigateToSearchPage();
    },
  );
}

// holds the moreOptionsBtn for the AppBar
Widget moreOptionsBtn() {
  return IconButton(
    icon: Icon(Icons.more_vert),
    onPressed: () {},
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
        ? globalColors.iconDisabledColor
        : globalColors.iconColor,
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
        ? globalColors.iconDisabledColor
        : globalColors.iconColor,
    icon: Icon(Icons.queue_music),
    onPressed: () {},
  );
}

// holds the row widget showing now playing media details in collapsed slideUpPanel
Widget nowPlayingCollapsed(
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
        child: globalWids.audioThumbnailW(
            audioThumbnail, context, 0.15, globalVars.borderRadius),
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

// holds the panel title for the slideUpPanelExpanded
Widget slideUpPanelExpandedPanelTitle() {
  return Container(
    child: Text(
      "NOW PLAYING",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget slideUpPanelExpandedMediaViews(String views, BuildContext context) {
  return Container(
    child: RichText(
      text: TextSpan(
          style: TextStyle(
            color: globalColors.textDisabledColor,
            fontSize: 16.0,
          ),
          children: [
            WidgetSpan(
                child: Icon(
              Icons.play_circle_filled,
              size: 20.0,
              color: globalColors.textDisabledColor,
            )),
            TextSpan(text: " " + views),
          ]),
      textAlign: TextAlign.center,
    ),
  );
}

// holds the sliderWidget to show the audio play progress slideUpPanelExpanded
Widget slideUpPanelExpandedPositionIndicator(MediaItem mediaItem,
    PlaybackState state, dragPositionSubject, BuildContext context) {
  double seekPos;
  double position;
  double duration;
  String currentTimeStamp;
  String durationInString;
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.05,
    ),
    child: StreamBuilder(
      stream: Rx.combineLatest2<double, double, double>(
          dragPositionSubject.stream,
          Stream.periodic(Duration(milliseconds: 200)),
          (dragPosition, _) => dragPosition),
      builder: (context, snapshot) {
        if (state != null && state.basicState != BasicPlaybackState.none) {
          position = snapshot.data ?? state.currentPosition.toDouble();
          duration = mediaItem?.duration?.toDouble();
          currentTimeStamp =
              globalFun.getCurrentTimeStamp(state.currentPosition / 1000);
          durationInString = mediaItem.extras["durationString"];
        } else {
          position = 0;
          duration = 1000;
          currentTimeStamp = "00:00";
          durationInString = "--:--";
        }

        return Column(
          children: [
            if (duration != null)
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                    trackHeight: 6.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0)),
                child: Slider(
                  min: 0.0,
                  max: duration,
                  value: seekPos ?? max(0.0, min(position, duration)),
                  onChanged: (value) {
                    dragPositionSubject.add(value);
                  },
                  onChangeEnd: (value) {
                    AudioService.seekTo(value.toInt());
                    seekPos = value;
                    dragPositionSubject.add(null);
                  },
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(currentTimeStamp),
                  Text(durationInString),
                ],
              ),
            )
          ],
        );
      },
    ),
  );
}

// holds the mainControls for the audio play in the slideUpPanelExpanded
Widget mainAudioControlsW(AnimationController playPauseAnimationController,
    PlaybackState state, Function audioServicePlayPause) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        playPauseIconMainAudioControlsW(
            playPauseAnimationController, state, audioServicePlayPause)
      ],
    ),
  );
}

// holds the playPauseIcon for the mainAudioControlsW in slideUpPanelExpande
Widget playPauseIconMainAudioControlsW(
    AnimationController playPauseAnimationController,
    PlaybackState state,
    Function audioServicePlayPause) {
  bool noAudioPlaying = true;
  if (state != null &&
      (state.basicState == BasicPlaybackState.paused ||
          state.basicState == BasicPlaybackState.playing)) {
    // setting no audioPlaying to false
    noAudioPlaying = false;
    if (state.basicState == BasicPlaybackState.paused)
      playPauseAnimationController.reverse();
    else
      playPauseAnimationController.forward();
  } else {
    playPauseAnimationController.reverse();
  }
  return Container(
      child: ClipOval(
    child: Material(
      color: (noAudioPlaying)
          ? globalColors.iconDisabledColor
          : globalColors.hPSlideUpPanelPlayBtnBG, // button color
      child: InkWell(
        child: SizedBox(
            width: 65,
            height: 65,
            child: Center(
              child: AnimatedIcon(
                size: 40.0,
                icon: AnimatedIcons.play_pause,
                progress: playPauseAnimationController,
                color: globalColors.hPSlideUpPanelPlayBtnColor,
              ),
            )),
        onTap: () {
          audioServicePlayPause();
        },
      ),
    ),
  ));
}
