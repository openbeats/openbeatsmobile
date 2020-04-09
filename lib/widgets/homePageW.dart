import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import '../pages/searchPage.dart';
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalWids.dart' as globalWids;
import '../globals/globalStrings.dart' as globalStrings;
import '../globals/globalFun.dart' as globalFun;

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
Widget collapsedSlideUpControls(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.2,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        playPauseBtn(),
        queueBtn(),
      ],
    ),
  );
}

// holds th play&pause btn for collapsed slideUpPanel
Widget playPauseBtn() {
  return IconButton(
    icon: Icon(Icons.play_arrow),
    onPressed: () {},
  );
}

// holds the queue button for the collapsed slideUpPanel
Widget queueBtn() {
  return IconButton(
    icon: Icon(Icons.queue_music),
    onPressed: () {},
  );
}

// holds the row widget showing now playing media details in collapsed slideUpPanel
Widget nowPlayingCollapsed(String audioThumbnail, String audioTitle,
    BuildContext context, BehaviorSubject<double> dragPositionSubject) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.03,
      ),
      Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: globalWids.audioThumbnailW(audioThumbnail, context),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.03,
      ),
      Flexible(
        flex: 3,
        fit: FlexFit.tight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            globalWids.audioTitleW(audioTitle, context),
            Container(
              child: (AudioService.playbackState != null &&
                      AudioService.currentMediaItem != null)
                  ? StreamBuilder(
                      stream: Rx.combineLatest2<double, double, double>(
                          dragPositionSubject.stream,
                          Stream.periodic(Duration(milliseconds: 200)),
                          (dragPosition, _) => dragPosition),
                      builder: (context, snapshot) {
                        // getting audioDuration in Min
                        String audioTimeStamp = globalFun.getCurrentTimeStamp(
                            AudioService.currentMediaItem.duration / 1000);
                        // getting the current audio position
                        int audioPosition = AudioService.playbackState.position;
                        return globalWids.audioDetailsTimingW(
                            audioPosition, audioTimeStamp);
                      },
                    )
                  : null,
            ),
          ],
        ),
      ),
      Flexible(
        flex: 2,
        fit: FlexFit.tight,
        child: collapsedSlideUpControls(context),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.03,
      ),
    ],
  );
}
