import 'package:openbeatsmobile/screens/pages/search/searchSuggestions.dart';

import '../imports.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen>
    with TickerProviderStateMixin {
  // controls the slideUp Panel
  PanelController _panelController = new PanelController();
  // animation controller to hide BottomNavBar
  AnimationController _hideBottomNavBarAnimController;

  @override
  void initState() {
    super.initState();
    // initiating animation controller to hide the BottomNavBar
    _hideBottomNavBarAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _hideBottomNavBarAnimController.forward();
  }

  @override
  Widget build(BuildContext context) {
    print("==============BUILT INDEX============-");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ApplicationState>(
          create: (_) => ApplicationState(),
        ),
        ChangeNotifierProvider<Streaming>(
          create: (_) => Streaming(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: _indexPageBody(),
        ),
        bottomNavigationBar: _bottomNavBar(),
      ),
    );
  }

  Widget _bottomNavBar() {
    return Consumer<ApplicationState>(
      builder: (context, data, _) => SizeTransition(
        sizeFactor: _hideBottomNavBarAnimController,
        axisAlignment: -1.0,
        child: BottomNavigationBar(
          onTap: (tappedIndex) =>
              Provider.of<ApplicationState>(context, listen: false)
                  .setBottomNavBarCurrentIndex(tappedIndex),
          currentIndex: Provider.of<ApplicationState>(context)
              .getBottomNavBarCurrentIndex(),
          backgroundColor:
              Provider.of<ApplicationTheme>(context).getBottomAppBarColor(),
          items: allDestinations.map((Destination destination) {
            return BottomNavigationBarItem(
                icon: Icon(destination.icon),
                backgroundColor: destination.color,
                title: Text(destination.title));
          }).toList(),
        ),
      ),
    );
  }

  Widget _indexPageBody() {
    return Container(
      child: SlidingUpPanel(
        controller: _panelController,
        color: Provider.of<ApplicationTheme>(context).getBottomAppBarColor(),
        minHeight: 60.0,
        maxHeight: MediaQuery.of(context).size.height,
        panel: _slideUpPanel(),
        onPanelSlide: (slidePosition) => manageBottomNavVisibility(
            slidePosition, _hideBottomNavBarAnimController),
        body: Consumer<ApplicationState>(
          builder: (context, data, _) => Container(
            child: _slideUpBody(),
          ),
        ),
      ),
    );
  }

  Widget _slideUpPanel() {
    return Center(
      child: Text("This is the sliding Widget"),
    );
  }

  Widget _slideUpBody() {
    return Container(
      child: Center(
        child: Consumer<Streaming>(
          builder: (context, data, _) => IndexedStack(
            index: Provider.of<ApplicationState>(context)
                .getBottomNavBarCurrentIndex(),
            children: <Widget>[
              ExplorePage(),
              _searchPageNavigator(),
              LibraryPage(),
              ProfilePage()
            ],
          ),
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
                return SearchSuggestions();
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
