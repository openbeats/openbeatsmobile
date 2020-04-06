import 'package:flutter/material.dart';

// holds static properties
Color _staticPrimaryDark = Color(0xFF14161c);
Color _staticPrimaryLight = Color(0xFFFFFFFF);

// holds the app global properties
Brightness appBrightness = Brightness.light;
Color appBackgroundColor = _staticPrimaryLight;
Color appIconColor = _staticPrimaryDark;

// main.dart
Color mainAppTitleColor = Colors.red;
Color mainPrimarySwatch = Colors.red;
// homePage.dart
Color homePageSlideUpCollapsedBG = appBackgroundColor;
Color homePageAppBarBG = appBackgroundColor;
Color homePageAppBarIconColor = appIconColor;
Color homePageAppBarIndicatorColor = Colors.transparent;
Color homePageAppBarUnselectedLabelColor = Colors.grey;
Color homePageAppBarLabelColor = Colors.red;
// searchPage.dart
Color searchPageScaffoldBG = appBackgroundColor;
Color searchPageTextFieldBGColor = Colors.grey;
Color searchPageAppBarIconColor = appIconColor;
Color searchPageAppBarTextColor = Colors.black;
Color searchPageAppBarHintColor = Colors.grey;
Color searchPageCursorColor = Colors.red;
