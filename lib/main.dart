import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:openbeatsmobile/pages/homePage.dart';
import './globals/globalColors.dart' as globalColors;
import './globals/globalStyles.dart' as globalStyles;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OpenBeats",
      home: HomePage(),
      theme: ThemeData(
        brightness: globalColors.appBrightness,
        primarySwatch: globalColors.primarySwatch,
        scaffoldBackgroundColor: globalColors.backgroundClr,
        appBarTheme: globalStyles.mainAppBarTheme,
      ),
    );
  }
}
