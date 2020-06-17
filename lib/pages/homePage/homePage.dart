import 'package:obsmobile/imports.dart';
import './widgets.dart' as widgets;
import 'package:obsmobile/functions/homePageFun.dart';
import 'package:obsmobile/models/homePageModels/bottomNavBarDest.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // changing the status bar color
    changeStatusBarColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _homePageBody(),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  // holds the body of the homePage
  Widget _homePageBody() {
    return Container(
      child: Center(
        child: Text("HomePage"),
      ),
    );
  }

  // holds the bottomNavBar for the homePage
  Widget _bottomNavBar() {
    return BottomNavigationBar(
      items: allDestinations
          .map(
            (destination) => widgets.bottomNavBarItem(destination),
          )
          .toList(),
    );
  }
}
