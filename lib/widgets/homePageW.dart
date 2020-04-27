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
Widget collapsedSlidingUpPanel() {
  return Container(
    child: null,
  );
}

//  expanded widget for the SlidingUpPanel
Widget expandedSlidingUpPanel() {
  return Container(
    color: Colors.red,
    child: null,
  );
}
