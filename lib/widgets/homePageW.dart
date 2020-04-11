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
    backgroundColor: globalColors.homePageAppBarBG,
    actionsIconTheme:
        IconThemeData(color: globalColors.homePageAppBarIconColor),
    titleSpacing: 0.0,
    title: globalWids.homePageLogo,
    actions: <Widget>[
      searchActBtn(context, navigateToSearchPage),
      moreOptionsBtn(),
    ],
    bottom: TabBar(
      controller: tabController,
      isScrollable: true,
      indicatorColor: globalColors.homePageAppBarIndicatorColor,
      unselectedLabelColor: globalColors.homePageAppBarUnselectedLabelColor,
      labelColor: globalColors.homePageAppBarLabelColor,
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
    AnimationController playPauseAnimationController) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.2,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        playPauseBtn(
            state, audioServicePlayPause, playPauseAnimationController),
        queueBtn(),
      ],
    ),
  );
}

// holds th play&pause btn for collapsed slideUpPanel
Widget playPauseBtn(PlaybackState state, Function audioServicePlayPause,
    AnimationController playPauseAnimationController) {
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
Widget queueBtn() {
  return IconButton(
    iconSize: 35.0,
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
        child: globalWids.audioThumbnailW(audioThumbnail, context, 0.15, globalVars.borderRadius),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.03,
      ),
      Flexible(
        flex: 3,
        fit: FlexFit.tight,
        child: globalWids.audioTitleW(audioTitle, context, false),
      ),
      Flexible(
        flex: 2,
        fit: FlexFit.tight,
        child: collapsedSlideUpControls(state, context, audioServicePlayPause,
            playPauseAnimationController),
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

// holds the title of the current playing media for the slideUpPanelExpanded
Widget slideUpPanelExpandedMediaTitle(String title, BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.15,
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      primary: true,
      physics: BouncingScrollPhysics(),
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
      ),
    ),
  );
}

// holds the view count of the current playing media for the slideUpPanelExpanded
Widget slideUpPanelExpandedMediaViews(String views, BuildContext context) {
  return Container(
    child: RichText(
      text: TextSpan(
          style: TextStyle(
            color: globalColors.homePageSlideUpExpandedViewsTextColor,
            fontSize: 16.0,
          ),
          children: [
            WidgetSpan(
                child: Icon(
              Icons.play_circle_filled,
              size: 20.0,
              color: globalColors.homePageSlideUpExpandedViewsIconColor,
            )),
            TextSpan(text: " " + views),
          ]),
      textAlign: TextAlign.center,
    ),
  );
}
