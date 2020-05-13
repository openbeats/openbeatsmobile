import 'package:flutter/material.dart';

// holds static properties
Color _staticPrimaryDark = Color(0xFF14161c);
Color _staticPrimaryLight = Color(0xFFFFFFFF);
Color _openBeatsRed = Color(0xFFF32C2C);
Color _offWhite = Color(0xFFE6E6E6);
Color _lighterDark = Color(0xFF212229);

// holds common global colors
Brightness appBrightness = Brightness.dark;
Color backgroundClr = _staticPrimaryDark;
Color mainAccentColor = _lighterDark;
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
  Color(0xFF14161c),
  Color(0xFF17191f),
  Color(0xFF1a1c22),
  Color(0xFF1e1f26),
  Color(0xFF212229)
];

// homePage.dart
Color darkBgIconClr = _staticPrimaryLight;

// profileHomeViewW.dart
Color mainBtnClr = _openBeatsRed;
Color mainBtnTextClr = _staticPrimaryLight;
Color darkBgTextClr = _staticPrimaryLight;
