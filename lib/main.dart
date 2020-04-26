import 'package:flutter/material.dart';

import 'package:openbeatsmobile/pages/homePage.dart';
import './globals/globalColors.dart' as globalColors;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        brightness: globalColors.appBrightness,
        primarySwatch: globalColors.primarySwatch,
        scaffoldBackgroundColor: globalColors.backgroundClr,
        bottomAppBarTheme: BottomAppBarTheme(
          color: globalColors.backgroundClr,
          elevation: 0,
        ),
      ),
    );
  }
}
