import 'package:flutter/material.dart';
import './pages/homePage.dart';
import './globals/globalColors.dart' as globalColors;
import './globals/globalStrings.dart' as globalStrings;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: globalStrings.mainAppTitleString,
      color: globalColors.mainAppTitleColor,
      theme: ThemeData(
        brightness: globalColors.appBrightness,
        primarySwatch: globalColors.mainPrimarySwatch,
      ),
      home: HomePage(),
    );
  }
}
