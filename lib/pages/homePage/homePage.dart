import 'package:obsmobile/imports.dart';
import 'package:rxdart/rxdart.dart';
import './widgets.dart' as widgets;
import './functions.dart' as functions;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // controller for the bottomAppBarSizeTransition
  AnimationController _bottomAppBarAnimController;
  Animation<double> _bottomNavAnimation;

  /// Tracks the position while the user drags the seek bar.
  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);
  // holds the height of the bottomAppBar
  double _collapsedSlideUpPanelHeight = 70.0;

  // used to modify the height of the slidingUpPanelCollapsed
  void _modifyCollapsedPanel() {
    if (AudioService.running && AudioService.currentMediaItem != null) {
      if (_collapsedSlideUpPanelHeight == 0.0)
        setState(() {
          _collapsedSlideUpPanelHeight = 70.0;
        });
    } else {
      if (_collapsedSlideUpPanelHeight == 70.0)
        setState(() {
          _collapsedSlideUpPanelHeight = 0.0;
        });
    }
  }

  @override
  void initState() {
    super.initState();
    // after initstate is initialized
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // fetching all data stored in sharedPrefs
      getAllSharedPrefsData(context);
      Timer(Duration(seconds: 1), () {
        _modifyCollapsedPanel();
        getMyCollections(
            context,
            Provider.of<UserModel>(context, listen: false)
                .getUserDetails()["token"]);
        getMyPlaylists(
            context,
            Provider.of<UserModel>(context, listen: false)
                .getUserDetails()["token"]);
        // getting recently played data
        getRecentlyPlayed(context);
        // getting the repeat song status
        AudioServiceOps().getMediaRepeatStatus();
        // setting the user token in audio service
        String _userToken = Provider.of<UserModel>(context, listen: false)
            .getUserDetails()["token"];
        if (_userToken != null)
          AudioServiceOps().setUserToken(_userToken);
        else
          AudioServiceOps().setUserToken("");
        // setting up the audio servie custom event listener
        AudioService.customEventStream.listen((event) {
          if (event == "repeatSongTrue")
            Provider.of<MediaModel>(context, listen: false).setRepeatSong(true);
          else if (event == "repeatSongFalse")
            Provider.of<MediaModel>(context, listen: false)
                .setRepeatSong(false);
          else if (event == "repeatQueueTrue")
            Provider.of<MediaModel>(context, listen: false)
                .setRepeatQueue(true);
          else if (event == "repeatQueueFalse")
            Provider.of<MediaModel>(context, listen: false)
                .setRepeatQueue(false);
        });
      });
    });
    // changing the status bar color
    functions.changeStatusBarColor();
    // instantiating animation controllers
    _bottomAppBarAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _bottomNavAnimation = CurvedAnimation(
      parent: _bottomAppBarAnimController,
      curve: Curves.ease,
    );
    _bottomAppBarAnimController.forward();

    AudioService.playbackStateStream.listen((event) {
      _modifyCollapsedPanel();
    });
    _modifyCollapsedPanel();
  }

  @override
  void dispose() {
    _bottomAppBarAnimController.dispose();
    _dragPositionSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _modifyCollapsedPanel();

    return WillPopScope(
      child: KeyboardSizeProvider(
        child: Scaffold(
          key: homePageScaffoldKey,
          body: _homePageBody(),
          bottomNavigationBar: _bottomNavBar(),
        ),
      ),
      onWillPop: () => functions.willPopScopeHandler(context),
    );
  }

  // holds the bottomNavBar for the homePage
  Widget _bottomNavBar() {
    // getting required data from data models
    return SizeTransition(
      sizeFactor: _bottomNavAnimation,
      axisAlignment: -1.0,
      child: Theme(
        data: new ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Consumer2<HomePageData, UserModel>(
          builder: (context, data, userdata, child) => BottomNavigationBar(
            currentIndex: data.getBNavBarCurrIndex(),
            type: BottomNavigationBarType.fixed,
            backgroundColor: GlobalThemes().getAppTheme().bottomAppBarColor,
            selectedItemColor: GlobalThemes().getAppTheme().primaryColor,
            unselectedItemColor: Colors.white,
            showUnselectedLabels: false,
            onTap: (index) async {
              vibrateDevice(context);
              // perform page specific actions
              await functions.pageSpecificBottomNavActions(context, index);
              // closing any open instance of slidingUpPanel
              if (getSlidingUpPanelController().isPanelOpen)
                getSlidingUpPanelController().close();
              // calling method to handle tab change content refreshes
              functions.handleTabChangeContentRefreshes(context, index);

              data.setBNavBarCurrIndex(index);
            },
            items: allDestinations
                .map(
                  (destination) =>
                      widgets.bottomNavBarItem(destination, userdata),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  // holds the body of the homePage
  Widget _homePageBody() {
    _modifyCollapsedPanel();
    return Consumer<ScreenHeight>(
      builder: (context, _res, child) {
        return SlidingUpPanel(
          controller: getSlidingUpPanelController(),
          minHeight: (_res.isOpen) ? 0.0 : _collapsedSlideUpPanelHeight,
          maxHeight: MediaQuery.of(context).size.height,
          parallaxEnabled: true,
          collapsed: _slideUpPanelCollapsed(),
          panel: _slideUpPanel(),
          body: _underneathSlideUpPanel(),
          onPanelSlide: (double position) {
            if (position > 0.4) {
              _bottomAppBarAnimController.reverse();
            } else if (position < 0.4) {
              _bottomAppBarAnimController.forward();
            }
          },
        );
      },
    );
  }

  // holds the collapsed SlideUpPanel
  Widget _slideUpPanelCollapsed() {
    PlaybackState _playbackState;
    MediaItem _currMediaItem;
    return SizeTransition(
      sizeFactor: _bottomNavAnimation,
      axisAlignment: -1.0,
      child: StreamBuilder(
        stream: Rx.combineLatest3(
          AudioService.playbackStateStream,
          AudioService.currentMediaItemStream,
          Stream.periodic(Duration(milliseconds: 200)),
          (_state, _mediaItem, c) {
            _playbackState = _state;
            _currMediaItem = _mediaItem;
          },
        ),
        builder: (context, snapshot) {
          // holds the properties of the collapsed container
          String _thumnbNailUrl =
              (_currMediaItem == null) ? null : _currMediaItem.artUri;
          String _title = (_currMediaItem == null)
              ? "Welcome to OpenBeats"
              : _currMediaItem.title;
          String _subtitle = (_playbackState == null)
              ? "Free music, forever"
              : getCurrentTimeStamp(
                      _playbackState?.currentPosition?.inSeconds?.toDouble()) +
                  " | " +
                  getCurrentTimeStamp(
                      _currMediaItem?.duration?.inSeconds?.toDouble());
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 100),
            child: (_thumnbNailUrl == null)
                ? Container(
                    key: ValueKey<int>(1),
                    color: GlobalThemes().getAppTheme().bottomAppBarColor,
                    child: null,
                  )
                : Container(
                    key: ValueKey<int>(2),
                    color: GlobalThemes().getAppTheme().bottomAppBarColor,
                    child: ListTile(
                      onTap: () {
                        getSlidingUpPanelController().open();
                      },
                      leading: cachedNetworkImageW(_thumnbNailUrl, 60.0),
                      title: Text(
                        _title,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(_subtitle),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      trailing: widgets.collapsedPanelSlideUpPanel(),
                    ),
                  ),
          );
        },
      ),
    );
  }

  // holds the SlideUpPanel
  Widget _slideUpPanel() {
    PlaybackState _playbackState;
    MediaItem _currMediaItem;
    return StreamBuilder(
        stream: Rx.combineLatest3(
          AudioService.playbackStateStream,
          AudioService.currentMediaItemStream,
          Stream.periodic(Duration(milliseconds: 200)),
          (_state, _mediaItem, c) {
            _playbackState = _state;
            _currMediaItem = _mediaItem;
          },
        ),
        builder: (context, snapshot) {
          Orientation _currOrientation = MediaQuery.of(context).orientation;
          return Container(
            color: GlobalThemes().getAppTheme().bottomAppBarColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 35.0),
                Container(
                  child: (_currOrientation == Orientation.portrait)
                      ? widgets.slideUpPanelThumbnail(context, _currMediaItem)
                      : null,
                ),
                Container(
                  child: (_currOrientation == Orientation.portrait)
                      ? widgets.slideUpPanelTitle(context, _currMediaItem)
                      : null,
                ),
                Container(
                  child: (_currOrientation == Orientation.landscape)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            widgets.slideUpPanelThumbnail(
                                context, _currMediaItem),
                            widgets.slideUpPanelTitle(context, _currMediaItem)
                          ],
                        )
                      : null,
                ),
                widgets.slideUpPanelSeekBar(context, _playbackState,
                    _currMediaItem, _dragPositionSubject),
                widgets.slideUpPanelMajorControls(context, _playbackState),
                widgets.slideUpPanelMinorControls(context)
              ],
            ),
          );
        });
  }

  // holds the widget underneath SlideUpPanel
  Widget _underneathSlideUpPanel() {
    return Consumer<HomePageData>(
      builder: (context, data, child) => Container(
          child: IndexedStack(
        index: data.getBNavBarCurrIndex(),
        children: <Widget>[
          _exploreTabNavigator(),
          _searchTabNavigator(),
          _libraryTabNavigator(),
          _profileTabNavigator()
        ],
      )),
    );
  }

  // holds the navigator for SearchTab
  Widget _searchTabNavigator() {
    return Navigator(onGenerateRoute: (RouteSettings routeSettings) {
      return PageRouteBuilder(
          maintainState: true,
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return new FadeTransition(opacity: animation, child: child);
          },
          pageBuilder: (BuildContext context, _, __) {
            switch (routeSettings.name) {
              case '/':
                return SearchTab();
              case '/searchNowPage':
                return SearchNowPage();
              default:
                return SearchTab();
            }
          });
    });
  }

  // holds the navigator for exploreTab
  Widget _exploreTabNavigator() {
    return ExploreTab();
  }

  // holds the navigator for the profileTab
  Widget _profileTabNavigator() {
    return ProfileTab();
  }

  // holds the navigator for teh libraryTab
  Widget _libraryTabNavigator() {
    return Navigator(onGenerateRoute: (RouteSettings routeSettings) {
      return PageRouteBuilder(
          maintainState: true,
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return new FadeTransition(opacity: animation, child: child);
          },
          pageBuilder: (BuildContext context, _, __) {
            switch (routeSettings.name) {
              case '/':
                return LibraryTab();
              case '/playlistView':
                return PlaylistView(routeSettings.arguments);
              default:
                return LibraryTab();
            }
          });
    });
  }
}
