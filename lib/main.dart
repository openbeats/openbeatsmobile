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
  // routeObserver instance to control connection to audio service
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: globalStrings.appTitleString,
      color: globalColors.appTitleColor,
      theme: ThemeData(
        fontFamily: "Helvetica-Normal",
        brightness: globalColors.appBrightness,
        primarySwatch: globalColors.appSwatchColor,
      ),
      home: HomePage(routeObserver),
    );
  }
}
