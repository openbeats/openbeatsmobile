import 'package:flutter/material.dart';
import 'package:openbeatsmobile/pages/tabs/searchTab/searchNowView.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import './tabs/searchTab/searchHomeView.dart';
import './tabs/playlistsTab.dart';
import './tabs/searchTab.dart';
import './tabs/settingsTab.dart';
import './tabs/trendingTab.dart';
import './tabs/exploreTab.dart';
import '../widgets/homePageW.dart' as homePageW;
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalVars.dart' as globalVars;
import '../globals/globalStyles.dart' as globalStyles;
import '../globals/globalWids.dart' as globalWids;
import '../globals/globalScaffoldKeys.dart' as globalScaffoldKeys;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // holds the current index of the BottomNavBar
  int _bottomNavBarCurrIndex = 0;
  // controller for the SlidingUpPanel
  PanelController _slidingUpPanelController = new PanelController();
  // controller for the TabView in SlidingUpPanel Body
  TabController _slidingUpPanelBodyTabViewController;
  // animation controller to hide BottomNavBar
  AnimationController _hideBottomNavBar;
  // flag to indicate the last known stable position of the SlidingUpPanel
  // true - open && false - closed
  bool _slidingPanelLKSState;

  // handles tapping of BottomNavBar item
  void _bottomNavBarItemTap(int itemIndex) {
    setState(() {
      // setting the current BottomNavBar Item
      _bottomNavBarCurrIndex = itemIndex;
    });
    // animating the body pages to the desired page
    _slidingUpPanelBodyTabViewController.animateTo(itemIndex);
    // checking if SlidingUpPanel is open
    if (_slidingUpPanelController.isPanelOpen)
      _slidingUpPanelController.close();
  }

  // handles the onWillPop callback
  Future<bool> _onWillPopCallbackHandler() async {
    // checking which tab is in view
    switch (_bottomNavBarCurrIndex) {
      // if searchTab is in view
      case 2:
        // checking if searchNowView is still in use
        if (globalScaffoldKeys.searchNowViewScaffoldKey.currentContext !=
            null) {
          Navigator.of(
                  globalScaffoldKeys.searchNowViewScaffoldKey.currentContext)
              .pop();
          return false;
        } else {
          return true;
        }
        break;
      default:
        return true;
    }
  }

  @override
  void initState() {
    super.initState();
    // initiating controller for the TabView in SlidingUpPanel Body
    _slidingUpPanelBodyTabViewController = new TabController(
        length: globalWids.bottomNavBarIcons.length, vsync: this);
    // initiating animation controller to hide the BottomNavBar
    _hideBottomNavBar =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    // showing the BottomNavBar
    _hideBottomNavBar.forward();
    // marking the last known stable position as closed
    _slidingPanelLKSState = false;
  }

  @override
  void dispose() {
    // disposing controller for the TabView in SlidingUpPanel Body
    _slidingUpPanelBodyTabViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPopCallbackHandler,
      child: Scaffold(
        bottomNavigationBar: _homePageBottomNavBar(),
        body: _homePageBody(),
      ),
    );
  }

  // holds the homePage BottomNavBar
  Widget _homePageBottomNavBar() {
    return SizeTransition(
      sizeFactor: _hideBottomNavBar,
      axisAlignment: -1.0,
      child: BottomNavigationBar(
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
      ),
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
        onPanelOpened: () => _hideBottomNavBar.reverse(),
        onPanelClosed: () => _hideBottomNavBar.forward(),
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
    return TrendingTab();
  }

  // holds the SearchTab widget
  Widget _searchTab() {
    return Navigator(
      onGenerateRoute: (RouteSettings routeSettings) {
        return PageRouteBuilder(
          maintainState: true,
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return new FadeTransition(opacity: animation, child: child);
          },
          pageBuilder: (BuildContext context, _, __) {
            switch (routeSettings.name) {
              case '/':
                return SearchHomeView();
              case "/searchNow":
                return SearchNowView();
              default:
                return SearchHomeView();
            }
          },
          transitionDuration: Duration(milliseconds: 300),
        );
      },
    );
  }

  // holds the PlaylistsTab widget
  Widget _playlistsTab() {
    return PlaylistsTab();
  }

  // holds the SettingsTab widget
  Widget _settingsTab() {
    return SettingsTab();
  }
}
