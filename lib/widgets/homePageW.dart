import 'package:flutter/material.dart';
import '../globals/globalVars.dart' as globalVars;

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
    backgroundColor: globalVars.primaryLight,
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
    color: globalVars.primaryDark,
    onPressed: () {},
    icon: Icon(Icons.search),
  );
}

Widget moreOptionsBtn() {
  return IconButton(
    color: globalVars.primaryDark,
    onPressed: () {},
    icon: Icon(Icons.more_vert),
  );
}
