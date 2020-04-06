import 'package:flutter/material.dart';
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalWids.dart' as globalWids;
import '../globals/globalStrings.dart' as globalStrings;

// holds the homePage appBar
Widget homePageAppBar(context) {
  return AppBar(
    elevation: 0,
    backgroundColor: globalColors.homePageAppBarBG,
    actionsIconTheme:
        IconThemeData(color: globalColors.homePageAppBarIconColor),
    title: globalWids.homePageLogo,
    actions: <Widget>[
      searchActBtn(context),
      moreOptionsBtn(),
    ],
    bottom: TabBar(
      isScrollable: true,
      indicatorColor: globalColors.homePageAppBarIndicatorColor,
      unselectedLabelColor: globalColors.homePageAppBarUnselectedLabelColor,
      labelColor: globalColors.homePageAppBarLabelColor,
      unselectedLabelStyle: TextStyle(
        fontSize: 26.0,
        fontWeight: FontWeight.bold,
      ),
      labelStyle: TextStyle(
        fontSize: 26.0,
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

Widget searchActBtn(context) {
  return IconButton(
    icon: Icon(Icons.search),
    onPressed: () {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (BuildContext context) => SearchPage(),
      //     ));
    },
  );
}

Widget moreOptionsBtn() {
  return IconButton(
    icon: Icon(Icons.more_vert),
    onPressed: () {},
  );
}
