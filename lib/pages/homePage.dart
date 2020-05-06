import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openbeatsmobile/pages/tabs/profileTab/profileHomeView.dart';
import 'package:openbeatsmobile/pages/tabs/searchTab/searchNowView.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import './tabs/searchTab/searchHomeView.dart';
import './tabs/playlistsTab/playlistsTab.dart';

import './tabs/trendingTab/trendingTab.dart';
import './tabs/exploreTab/exploreTab.dart';
import '../widgets/homePageW.dart' as homePageW;
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalVars.dart' as globalVars;
import '../globals/globalStyles.dart' as globalStyles;
import '../globals/globalWids.dart' as globalWids;
import '../globals/globalScaffoldKeys.dart' as globalScaffoldKeys;
import '../globals/globalFun.dart' as globalFun;
import '../globals/actions/globalColorsW.dart' as globalColorsW;

class HomePage extends StatefulWidget {
  // behaviourSubject to monitor and control the seekBar
  BehaviorSubject<double> dragPositionSubject;
  // custom audioService control methods
  Function startSinglePlayback,
      audioServicePlayPause,
      toggleRepeatSong,
      refreshAppState;
  HomePage(this.dragPositionSubject, this.startSinglePlayback,
      this.audioServicePlayPause, this.refreshAppState, this.toggleRepeatSong);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // holds the current index of the BottomNavBar
  int _bottomNavBarCurrIndex = 0;
  // controller for the SlidingUpPanel
  PanelController _slidingUpPanelController = new PanelController();

  // animation controller to hide BottomNavBar
  AnimationController _hideBottomNavBarAnimController;
  // controls the animation of the play_pause button
  AnimationController playPauseAnimationController;
  // controls the animation of the SlideUpPanel collapsedView depending on audioPlayback
  AnimationController _slideUpPanelCollapsedHeightController;
  // animation to move between values for SlideUpPanel collapsedView depending on audioPlayback
  Animation _slideUpPanelCollapsedHeightAnimation;
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

    // checking if SlidingUpPanel is open
    if (_slidingUpPanelController.isPanelOpen)
      _slidingUpPanelController.close();
  }

  // hides or reveals the SlidingUpPanel
  void hideOrRevealSlidingUpPanel(showSlidingUpPanel) {
    if (showSlidingUpPanel)
      _slideUpPanelCollapsedHeightController.forward();
    else
      _slideUpPanelCollapsedHeightController.reverse();
  }

  // opens the slideUpPanel completely (on tap of the collapsed panel)
  void openSlideUpPanelToExpanded() {
    _slidingUpPanelController.open();
  }

  // set status and navbar color
  void _setStatusNavbarColor() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          globalColors.backgroundClr, // navigation bar color
      statusBarColor: globalColors.backgroundClr, // status bar color
      statusBarIconBrightness: (globalColors.appBrightness == Brightness.dark)
          ? Brightness.light
          : Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness:
          (globalColors.appBrightness == Brightness.dark)
              ? Brightness.light
              : Brightness.dark,
    ));
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

// connects to the audio_service
  void connect() async {
    await AudioService.connect();
  }

  // disconnects from the audio_service
  void disconnect() {
    AudioService.disconnect();
  }

  @override
  void initState() {
    super.initState();

    connect();
    // initiating animation controller to hide the BottomNavBar
    _hideBottomNavBarAnimController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    // initiating animation controller for play_pause button in the collapsed slideUpPanel
    playPauseAnimationController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    // initiating the animation controller for SlideUpPanel collapsedView height depending on audioPlayback
    _slideUpPanelCollapsedHeightController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    // showing the BottomNavBar
    _hideBottomNavBarAnimController.forward();

    // initiating the tween animation and values for SlideUpPanel collapsedView height depending on audioPlayback
    _slideUpPanelCollapsedHeightAnimation =
        Tween<double>(begin: 0.0, end: 100.0)
            .animate(_slideUpPanelCollapsedHeightController);

    // checking playback state and hiding the SlidePanel
    if (AudioService.playbackState == null ||
        AudioService.playbackState.basicState == BasicPlaybackState.none)
      hideOrRevealSlidingUpPanel(false);

    // adding state listeners to audio service to bring the SlideUpPanel into view if needed when the app starts
    AudioService.playbackStateStream.listen((PlaybackState state) {
      if (state == null || state.basicState == BasicPlaybackState.none) {
        hideOrRevealSlidingUpPanel(false);
      } else {
        hideOrRevealSlidingUpPanel(true);
      }
    });

    // adding state refresh listener for the controller to refresh the state everytime it runs
    _slideUpPanelCollapsedHeightController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // execute function after build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // setting the color of pheripheral components
      _setStatusNavbarColor();
      // initiating the tween animation and values for SlideUpPanel collapsedView height depending on audioPlayback
      _slideUpPanelCollapsedHeightAnimation = Tween<double>(
              begin: 0.0, end: MediaQuery.of(context).size.height * 0.075)
          .animate(_slideUpPanelCollapsedHeightController);
      // getting login details
      await globalFun.getUserDetailsSharedPrefs();
    });

    return WillPopScope(
      onWillPop: _onWillPopCallbackHandler,
      child: Scaffold(
        key: globalScaffoldKeys.homePageScaffoldKey,
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
      child: Theme(
        data: new ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _bottomNavBarCurrIndex,
          backgroundColor: globalColors.backgroundClr,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedItemColor: globalColors.iconActiveClr,
          unselectedItemColor: globalColors.iconDefaultClr,
          selectedLabelStyle: globalStyles.bottomNavBarItemLabelStyle,
          unselectedLabelStyle: globalStyles.bottomNavBarItemLabelStyle,
          iconSize: globalVars.bottomNavBarIconSize,
          type: BottomNavigationBarType.shifting,
          items: homePageW.bottomNavBarItems(),
          onTap: _bottomNavBarItemTap,
        ),
      ),
    );
  }

  // holds the homePageBody
  Widget _homePageBody() {
    return SafeArea(
      child: SlidingUpPanel(
        controller: _slidingUpPanelController,
        defaultPanelState: PanelState.CLOSED,
        minHeight: _slideUpPanelCollapsedHeightAnimation.value,
        maxHeight: MediaQuery.of(context).size.height,
        collapsed: homePageW.collapsedSlidingUpPanel(
            context,
            widget.audioServicePlayPause,
            playPauseAnimationController,
            openSlideUpPanelToExpanded,
            hideOrRevealSlidingUpPanel),
        panel: homePageW.expandedSlidingUpPanel(
            widget.dragPositionSubject,
            playPauseAnimationController,
            widget.audioServicePlayPause,
            widget.toggleRepeatSong),
        body: _slidingUpPanelBody(),
        onPanelOpened: () => _hideBottomNavBarAnimController.reverse(),
        onPanelClosed: () => _hideBottomNavBarAnimController.forward(),
      ),
    );
  }

  // holds the SlidingUpPanel body
  Widget _slidingUpPanelBody() {
    return IndexedStack(
      index: _bottomNavBarCurrIndex,
      children: [
        _exploreTab(),
        _trendingTab(),
        _searchTab(),
        _playlistsTab(),
        _profileTab(),
      ],
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
                return SearchNowView();
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
  Widget _profileTab() {
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
                return ProfileHomeView(widget.refreshAppState);
              default:
                return ProfileHomeView(widget.refreshAppState);
            }
          },
          transitionDuration: Duration(milliseconds: 400),
        );
      },
    );
  }
}
