import 'package:flutter/material.dart';

import '../widgets/homePageW.dart' as homePageW;
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalVars.dart' as globalVars;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // holds the current index of the BottomNavBar
  int _bottomNavBarCurrIndex = 0;

  // handles tapping of BottomNavBar item
  void bottomNavBarItemTap(int itemIndex) {
    setState(() {
      _bottomNavBarCurrIndex = itemIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: homePageBottomNavBar(),
      body: homePageBody(),
    );
  }

  // holds the homePage BottomNavBar
  Widget homePageBottomNavBar() {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: _bottomNavBarCurrIndex,
      backgroundColor: globalColors.backgroundClr,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: globalColors.iconActiveClr,
      unselectedItemColor: globalColors.iconDefaultClr,
      iconSize: globalVars.bottomNavBarIconSize,
      type: BottomNavigationBarType.fixed,
      items: homePageW.bottomNavBarItems(),
      onTap: bottomNavBarItemTap,
    );
  }

  // holds the homePageBody
  Widget homePageBody() {
    return SafeArea(
      child: Container(
        child: null,
      ),
    );
  }
}
