import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../pages/searchPage.dart';
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalWids.dart' as globalWids;
import '../globals/globalStrings.dart' as globalStrings;

// holds the homePage appBar
Widget homePageAppBar(
    context, Function navigateToSearchPage, TabController tabController) {
  return AppBar(
    elevation: 0,
    backgroundColor: globalColors.homePageAppBarBG,
    actionsIconTheme:
        IconThemeData(color: globalColors.homePageAppBarIconColor),
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

Widget searchActBtn(context, Function navigateToSearchPage) {
  return IconButton(
    icon: Icon(Icons.search),
    onPressed: () {
      navigateToSearchPage();
    },
  );
}

Widget moreOptionsBtn() {
  return IconButton(
    icon: Icon(Icons.more_vert),
    onPressed: () {},
  );
}
