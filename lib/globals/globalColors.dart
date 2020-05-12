import 'package:flutter/material.dart';

// holds static properties
Color _staticPrimaryDark = Color(0xFF202124);
Color _staticPrimaryLight = Color(0xFFFFFFFF);
Color _openBeatsRed = Color(0xFFF32C2C);
Color _offWhite = Color(0xFFE6E6E6);
Color _lightGrey = Color(0xFF38383C);

// holds common global colors
Brightness appBrightness = Brightness.dark;
Color backgroundClr = _staticPrimaryDark;
Color mainAccentColor = _lightGrey;
Color primarySwatch = Colors.red;
Color iconDefaultClr = _staticPrimaryLight;
Color iconActiveClr = _openBeatsRed;
Color textDefaultClr = _staticPrimaryLight;
Color textActiveClr = _openBeatsRed;
Color textDisabledClr = Colors.grey;
Color iconDisabledClr = Colors.grey;
Color errorClr = Colors.red;
Color warningClr = Colors.orange;
Color successClr = Colors.green;
List<Color> statusBarColorChangeLst = [
  Color(0xFF202124),
  Color(0xFF26272a),
  Color(0xFF2c2c30),
  Color(0xFF323236),
  Color(0xFF38383c)
];

// homePage.dart
Color darkBgIconClr = _staticPrimaryLight;

// profileHomeViewW.dart
Color mainBtnClr = _openBeatsRed;
Color mainBtnTextClr = _staticPrimaryLight;
Color darkBgTextClr = _staticPrimaryLight;
