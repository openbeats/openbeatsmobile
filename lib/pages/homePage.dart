import 'package:flutter/material.dart';

import '../widgets/homePageW.dart' as homePageW;
import '../globals/globalColors.dart' as globalColors;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: homePageBottomAppBar(),
      body: homePageBody(),
    );
  }

  // holds the homePage BottomAppBar
  Widget homePageBottomAppBar() {
    return BottomAppBar(
      child: homePageW.bottomAppBarRow(),
    );
  }

  // holds the homePageBody
  Widget homePageBody() {
    return SafeArea(
      child: Container(
        child: null,
      ),
    );
  }
}
