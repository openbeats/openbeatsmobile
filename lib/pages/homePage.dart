import 'package:flutter/material.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../widgets/homePageW.dart' as homePageW;
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalVars.dart' as globalVars;
import '../globals/globalStyles.dart' as globalStyles;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // holds the current index of the BottomNavBar
  int _bottomNavBarCurrIndex = 0;
  // controller for the SlidingUpPanel
  PanelController _slidingUpPanelController = new PanelController();
  // controls if the BottomNavBar should be shown
  bool _showBottomNavBar = true;

  // handles tapping of BottomNavBar item
  void _bottomNavBarItemTap(int itemIndex) {
    setState(() {
      _bottomNavBarCurrIndex = itemIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: homePageBottomNavBar(),
      ),
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
      selectedLabelStyle: globalStyles.bottomNavBarItemLabelStyle,
      unselectedLabelStyle: globalStyles.bottomNavBarItemLabelStyle,
      iconSize: globalVars.bottomNavBarIconSize,
      type: BottomNavigationBarType.shifting,
      items: homePageW.bottomNavBarItems(),
      onTap: _bottomNavBarItemTap,
    );
  }

  // holds the homePageBody
  Widget homePageBody() {
    return SafeArea(
      child: Container(
        child: SlidingUpPanel(
          controller: _slidingUpPanelController,
          defaultPanelState: PanelState.CLOSED,
          minHeight: 60.0,
          maxHeight: MediaQuery.of(context).size.height,
          collapsed: homePageW.collapsedSlidingUpPanel(),
          panel: homePageW.expandedSlidingUpPanel(),
        ),
      ),
    );
  }

  // holds the SlidingUpPanel body
  Widget slidingUpPanelBody() {
    return null;
  }
}
