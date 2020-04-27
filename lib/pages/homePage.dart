import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:openbeatsmobile/pages/tabs/exploreTab.dart';
import '../widgets/homePageW.dart' as homePageW;
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalVars.dart' as globalVars;
import '../globals/globalStyles.dart' as globalStyles;
import '../globals/globalWids.dart' as globalWids;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // holds the current index of the BottomNavBar
  int _bottomNavBarCurrIndex = 0;
  // controller for the SlidingUpPanel
  PanelController _slidingUpPanelController = new PanelController();
  // controller for the TabView in SlidingUpPanel Body
  TabController _slidingUpPanelBodyTabViewController;
  // controls if the BottomNavBar should be shown
  bool _showBottomNavBar = true;

  // handles tapping of BottomNavBar item
  void _bottomNavBarItemTap(int itemIndex) {
    setState(() {
      // setting the current BottomNavBar Item
      _bottomNavBarCurrIndex = itemIndex;
      // animating the body pages to the desired page
      _slidingUpPanelBodyTabViewController.animateTo(itemIndex);
    });
  }

  @override
  void initState() {
    super.initState();
    // initiating controller for the TabView in SlidingUpPanel Body
    _slidingUpPanelBodyTabViewController = new TabController(
        length: globalWids.bottomNavBarIcons.length, vsync: this);
  }

  @override
  void dispose() {
    // disposing controller for the TabView in SlidingUpPanel Body
    _slidingUpPanelBodyTabViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: _homePageBottomNavBar(),
      ),
      body: _homePageBody(),
    );
  }

  // holds the homePage BottomNavBar
  Widget _homePageBottomNavBar() {
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
  Widget _homePageBody() {
    return SafeArea(
      child: SlidingUpPanel(
        controller: _slidingUpPanelController,
        defaultPanelState: PanelState.CLOSED,
        minHeight: 60.0,
        maxHeight: MediaQuery.of(context).size.height,
        collapsed: homePageW.collapsedSlidingUpPanel(),
        panel: homePageW.expandedSlidingUpPanel(),
        body: _slidingUpPanelBody(),
      ),
    );
  }

  // holds the SlidingUpPanel body
  Widget _slidingUpPanelBody() {
    return Container(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _slidingUpPanelBodyTabViewController,
        children: [
          _exploreTab(),
          _trendingTab(),
          _searchTab(),
          _playlistsTab(),
          _settingsTab(),
        ],
      ),
    );
  }

  // holds the ExploreTab widget
  Widget _exploreTab() {
    return ExploreTab();
  }

  // holds the TrendingTab widget
  Widget _trendingTab() {
    return ExploreTab();
  }

  // holds the SearchTab widget
  Widget _searchTab() {
    return ExploreTab();
  }

  // holds the PlaylistsTab widget
  Widget _playlistsTab() {
    return ExploreTab();
  }

  // holds the SettingsTab widget
  Widget _settingsTab() {
    return ExploreTab();
  }
}
