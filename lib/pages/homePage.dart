import 'package:flutter/material.dart';
import 'package:openbeatsmobile/pages/tabs/searchTab/searchNowView.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import './tabs/searchTab/searchHomeView.dart';
import './tabs/playlistsTab/playlistsTab.dart';
import './tabs/settingsTab/settingsTab.dart';
import './tabs/trendingTab/trendingTab.dart';
import './tabs/exploreTab/exploreTab.dart';
import '../widgets/homePageW.dart' as homePageW;
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalVars.dart' as globalVars;
import '../globals/globalStyles.dart' as globalStyles;
import '../globals/globalWids.dart' as globalWids;
import '../globals/globalScaffoldKeys.dart' as globalScaffoldKeys;

class HomePage extends StatefulWidget {
  // behaviourSubject to monitor and control the seekBar
  BehaviorSubject<double> dragPositionSubject;
  // custom audioService control methods
  Function startSinglePlayback, audioServicePlayPause;
  HomePage(this.dragPositionSubject, this.startSinglePlayback,
      this.audioServicePlayPause);
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
  AnimationController _hideBottomNavBarAnimController;
  // controls the animation of the play_pause button
  AnimationController playPauseAnimationController;
  // flag to indicate the last known stable position of the SlidingUpPanel
  // true - open && false - closed
  bool _slidingPanelLKSState;
  // flag used to indicate if the SlidingUpPanelCollapsedView should be shown
  bool _showSlideUpPanelCollpasedView = true;

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

  // hides or reveals the SlidingUpPanel
  void hideOrRevealSlidingUpPanel(showSlidingUpPanel) {
    setState(() {
      _showSlideUpPanelCollpasedView = showSlidingUpPanel;
    });
  }

  // handles the onWillPop callback
  Future<bool> _onWillPopCallbackHandler() async {
    // checking if the SlidingUpPanel is open
    if (_slidingUpPanelController.isPanelOpen) {
      _slidingUpPanelController.close();
      return false;
    }
    // if SlideUpPanel is closed
    else {
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
  }

  @override
  void initState() {
    super.initState();
    // initiating controller for the TabView in SlidingUpPanel Body
    _slidingUpPanelBodyTabViewController = new TabController(
        length: globalWids.bottomNavBarIcons.length, vsync: this);
    // initiating animation controller to hide the BottomNavBar
    _hideBottomNavBarAnimController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    // initiating animation controller for play_pause button in the collapsed slideUpPanel
    playPauseAnimationController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    // showing the BottomNavBar
    _hideBottomNavBarAnimController.forward();

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
      sizeFactor: _hideBottomNavBarAnimController,
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
        minHeight: (_showSlideUpPanelCollpasedView)
            ? MediaQuery.of(context).size.height * 0.075
            : 0,
        maxHeight: MediaQuery.of(context).size.height,
        collapsed: homePageW.collapsedSlidingUpPanel(context,
            widget.audioServicePlayPause, playPauseAnimationController),
        panel: homePageW.expandedSlidingUpPanel(widget.dragPositionSubject,
            playPauseAnimationController, widget.audioServicePlayPause),
        body: _slidingUpPanelBody(),
        onPanelOpened: () => _hideBottomNavBarAnimController.reverse(),
        onPanelClosed: () => _hideBottomNavBarAnimController.forward(),
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
                return SearchHomeView(widget.startSinglePlayback);
              case "/searchNow":
                return SearchNowView(hideOrRevealSlidingUpPanel);
              default:
                return SearchHomeView(widget.startSinglePlayback);
            }
          },
          transitionDuration: Duration(milliseconds: 400),
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
