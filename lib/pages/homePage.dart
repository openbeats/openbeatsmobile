import 'package:openbeatsmobile/models/AppState/appState.dart';

import '../imports.dart';

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
        child: Center(
          child: Text("Hi there"),
        ),
      );
}
