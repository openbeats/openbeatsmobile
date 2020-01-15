import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:openbeatsmobile/pages/homePage.dart';
import 'package:openbeatsmobile/pages/searchPage.dart';

import './globalVars.dart' as globalVars;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // sets the status and navigation bar themes
    setStatusNaviThemes();
  }

  // sets the status and navigation bar themes
  void setStatusNaviThemes() async {
    await FlutterStatusbarcolor.setStatusBarColor(globalVars.primaryDark);
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    await FlutterStatusbarcolor.setNavigationBarColor(globalVars.primaryDark);
    await FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OpenBeats",
      home: HomePage(),
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "montserrat",
      ),
      routes: {'/searchPage': (context) => SearchPage()},
    );
  }
}
