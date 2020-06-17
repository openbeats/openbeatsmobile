import 'package:obsmobile/imports.dart';
import './widgets.dart' as widgets;
import 'package:obsmobile/functions/homePageFun.dart';
import 'package:obsmobile/models/homePageModels/bottomNavBarDest.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // temp audioService testing function
  void _audioServiceTest() {

    

  }

  @override
  void initState() {
    super.initState();
    // changing the status bar color
    changeStatusBarColor();
  }

  @override
  Widget build(BuildContext context) {
    print("homePage REBUILT");
    return Scaffold(
      body: _homePageBody(),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  // holds the body of the homePage
  Widget _homePageBody() {
    return Container(
      child: Center(
        child: RaisedButton(
          onPressed: () => _audioServiceTest(),
          child: Text("Start Audio"),
        ),
      ),
    );
  }

  // holds the bottomNavBar for the homePage
  Widget _bottomNavBar() {
    // getting required data from data models
    int _currIndex = Provider.of<HomePageData>(context).getBNavBarCurrIndex();
    return BottomNavigationBar(
      currentIndex: _currIndex,
      onTap: (index) => Provider.of<HomePageData>(context, listen: false)
          .setBNavBarCurrIndex(index),
      items: allDestinations
          .map(
            (destination) => widgets.bottomNavBarItem(destination),
          )
          .toList(),
    );
  }
}
