import 'package:flutter/material.dart';

import '../globals/globalVars.dart' as globalVars;
import '../globals/globalWids.dart' as globalWids;
import '../globals/globalStrings.dart' as globalStrings;
import '../globals/globalColors.dart' as globalColors;

// row of widgets for BottomNavBar
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
