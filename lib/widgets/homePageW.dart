import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import '../globals/globalVars.dart' as globalVars;
import '../globals/globalColors.dart' as globalColors;

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);
MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);

// holds the list of tabs as widgets
List<Widget> homePageTabs = [
  Tab(
    text: "Explore",
  ),
  Tab(
    text: "Trending",
  ),
  Tab(
    text: "Search",
  ),
  Tab(
    text: "Library",
  ),
  Tab(
    text: "User",
  ),
];

// holds the app bar for the homePage Appbar
Widget homePageAppBar() {
  return AppBar(
    backgroundColor: globalColors.primaryLight,
    elevation: 0,
    title: Image.asset(
      "assets/images/logo/logotextblack.png",
      height: 36.0,
    ),
    actions: <Widget>[
      searchActBtn(),
      moreOptionsBtn(),
    ],
    bottom: TabBar(
      isScrollable: true,
      indicatorColor: Colors.transparent,
      unselectedLabelColor: Colors.grey,
      unselectedLabelStyle: TextStyle(
        fontSize: 16.0,
        fontFamily: "Poppins-SemiBold",
        fontWeight: FontWeight.bold,
      ),
      labelColor: Colors.black,
      labelStyle: TextStyle(
        fontSize: 30.0,
        fontFamily: "Poppins-SemiBold",
        fontWeight: FontWeight.bold,
      ),
      tabs: homePageTabs,
    ),
  );
}

Widget searchActBtn() {
  return IconButton(
    color: globalColors.primaryDark,
    onPressed: () {},
    icon: Icon(Icons.search),
  );
}

Widget moreOptionsBtn() {
  return IconButton(
    color: globalColors.primaryDark,
    onPressed: () {},
    icon: Icon(Icons.more_vert),
  );
}
