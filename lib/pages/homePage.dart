import 'package:openbeatsmobile/imports.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // controls the slideUp Panel
  PanelController _panelController = new PanelController();
  // animation controller to hide BottomNavBar
  AnimationController _bottomNavBarAnimController;

  @override
  void initState() {
    super.initState();
    // initiating ani`mation controller to hide the BottomNavBar
    _bottomNavBarAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _bottomNavBarAnimController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // print debug message
    DebugFunctions().printMessage("=======HOMEPAGE BUILD=======");
    return Scaffold(
      key: homePageScaffoldKey,
      body: _homePageBody(),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  // holds the bottomNavBar of the application
  Widget _bottomNavBar() {
    // getting required values
    int _bottomNavBarCurrIndex =
        Provider.of<AppState>(context).getBottomNavBarCurrentIndex();
    return BottomNavigationBar(
      onTap: (tappedIndex) => Provider.of<AppState>(context, listen: false)
          .setBottomNavBarCurrentIndex(tappedIndex),
      currentIndex: _bottomNavBarCurrIndex,
      items: allDestinations.map((Destination destination) {
        return BottomNavigationBarItem(
            icon: Icon(destination.icon),
            backgroundColor: destination.color,
            title: Text(destination.title));
      }).toList(),
    );
  }

  // holds the homePage body
  Widget _homePageBody() => Container(
        child: Container(
          child: SlidingUpPanel(
            controller: _panelController,
            color: ThemeComponents().getAppTheme().bottomAppBarColor,
            minHeight: 60.0,
            maxHeight: MediaQuery.of(context).size.height,
            panel: _slideUpPanel(),
            onPanelSlide: (slidePosition) => manageBottomNavVisibility(
                slidePosition, _bottomNavBarAnimController),
            body: _slideUpBack(),
          ),
        ),
      );

  // contains the content in the slideUpPanel
  Widget _slideUpPanel() {
    return Center(
      child: Text("This is the sliding Widget"),
    );
  }

  // contains the content behind the slideUpPanel
  Widget _slideUpBack() {
    return Container(
      child: Center(
        child: IndexedStack(
          index: Provider.of<AppState>(context).getBottomNavBarCurrentIndex(),
          children: <Widget>[
            ExplorePage(),
            _searchPageNavigator(),
            LibraryPage(),
            ProfilePage()
          ],
        ),
      ),
    );
  }

  // holds the custom navigator instance for SearchPage
  Widget _searchPageNavigator() {
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
                return SearchPage();
              case "/searchNow":
                return SearchNow();
              default:
                return SearchPage();
            }
          },
          transitionDuration: Duration(milliseconds: 400),
        );
      },
    );
  }
}
