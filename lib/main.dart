import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './pages/homePage.dart';

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
      title: "OpenBeats Music",
      color: Colors.black,
      theme: ThemeData(
        fontFamily: "Helvetica-Normal",
        brightness: Brightness.light,
        primarySwatch: Colors.red,
      ),
      home: HomePage(routeObserver),
    );
  }
}
