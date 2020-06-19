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

  @override
  void initState() {
    super.initState();
    // after initstate is initialized
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // fetching all data stored in sharedPrefs
      getAllSharedPrefsData(context);
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
  }

  @override
  Widget build(BuildContext context) {
    print("homePage REBUILT");
    return WillPopScope(
      child: KeyboardSizeProvider(
        child: Scaffold(
          key: homePageScaffoldKey,
          body: _homePageBody(),
          bottomNavigationBar: _bottomNavBar(),
        ),
      ),
      onWillPop: () => functions.willPopScopeHandler(),
    );
  }

  // holds the bottomNavBar for the homePage
  Widget _bottomNavBar() {
    // getting required data from data models
    int _currIndex = Provider.of<HomePageData>(context).getBNavBarCurrIndex();
    return SizeTransition(
      sizeFactor: _bottomNavAnimation,
      axisAlignment: -1.0,
      child: Theme(
        data: new ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: GlobalThemes().getAppTheme().bottomAppBarColor,
          selectedItemColor: GlobalThemes().getAppTheme().primaryColor,
          unselectedItemColor: Colors.white,
          onTap: (index) {
            if (getSlidingUpPanelController().isPanelOpen)
              getSlidingUpPanelController().close();
            Provider.of<HomePageData>(context, listen: false)
                .setBNavBarCurrIndex(index);
          },
          items: allDestinations
              .map(
                (destination) => widgets.bottomNavBarItem(destination),
              )
              .toList(),
        ),
      ),
    );
  }

  // holds the body of the homePage
  Widget _homePageBody() {
    return Consumer<ScreenHeight>(
      builder: (context, _res, child) {
        return SlidingUpPanel(
          controller: getSlidingUpPanelController(),
          minHeight: (_res.isOpen) ? 0.0 : 70.0,
          maxHeight: MediaQuery.of(context).size.height,
          parallaxEnabled: true,
          collapsed: _slideUpPanelCollapsed(),
          panel: _slideUpPanel(),
          body: _underneathSlideUpPanel(),
          onPanelSlide: (double position) {
            if (position > 0.4)
              _bottomAppBarAnimController.reverse();
            else if (position < 0.4) _bottomAppBarAnimController.forward();
          },
        );
      },
    );
  }

  // holds the collapsed SlideUpPanel
  Widget _slideUpPanelCollapsed() {
    PlaybackState _state;
    MediaItem _currMediaItem;
    return StreamBuilder(
      stream: Rx.combineLatest3(
          AudioService.currentMediaItemStream,
          AudioService.playbackStateStream,
          Stream.periodic(Duration(milliseconds: 200)),
          (mediaItemStream, playbackStream, perodic) {
        _state = playbackStream;
        _currMediaItem = mediaItemStream;
      }),
      builder: (context, snapshot) {
        double _position = _state?.currentPosition?.inSeconds?.toDouble();
        double _duration = _currMediaItem?.duration?.inSeconds?.toDouble();
        return Container(
          color: GlobalThemes().getAppTheme().bottomAppBarColor,
          child: AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: (_currMediaItem != null)
                ? ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                    leading: cachedNetworkImageW(_currMediaItem.artUri),
                    onTap: () => getSlidingUpPanelController().open(),
                    title: Text(
                      _currMediaItem.title,
                      maxLines: 2,
                    ),
                    subtitle: Container(
                      margin: EdgeInsets.only(top: 3.0),
                      child: Text(getCurrentTimeStamp(_position) +
                          "  |  " +
                          getCurrentTimeStamp(_duration)),
                    ),
                    trailing: IconButton(
                      icon: Icon((_state != null && _state.playing)
                          ? Icons.pause
                          : Icons.play_arrow),
                      onPressed: () => (_state != null && _state.playing)
                          ? AudioService.pause()
                          : AudioService.play(),
                    ),
                  )
                : widgets.slidingUpPanelCollapsedDefault(),
          ),
        );
      },
    );
  }

  // holds the SlideUpPanel
  Widget _slideUpPanel() {
    PlaybackState _state;
    MediaItem _currMediaItem;
    return StreamBuilder(
      stream: Rx.combineLatest3(
          AudioService.currentMediaItemStream,
          AudioService.playbackStateStream,
          Stream.periodic(Duration(seconds: 1)),
          (mediaItemStream, playbackStream, perodic) {
        _state = playbackStream;
        _currMediaItem = mediaItemStream;
      }),
      builder: (context, snapshot) {
        double _position = _state?.currentPosition?.inSeconds?.toDouble();
        double _duration = _currMediaItem?.duration?.inSeconds?.toDouble();
        return Container(
          color: GlobalThemes().getAppTheme().bottomAppBarColor,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              widgets.nowPlayingThumbnailHolder(_currMediaItem, context),
              SizedBox(
                height: 20.0,
              ),
              widgets.nowPlayingTitleHolder(_currMediaItem)
            ],
          ),
        );
      },
    );
  }

  // holds the widget underneath SlideUpPanel
  Widget _underneathSlideUpPanel() {
    return Container(
        child: IndexedStack(
      index: Provider.of<HomePageData>(context).getBNavBarCurrIndex(),
      children: <Widget>[
        _exploreTabNavigator(),
        _searchTabNavigator(),
        _libraryTabNavigator(),
        _profileTabNavigator()
      ],
    ));
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
    return LibraryTab();
  }
}
