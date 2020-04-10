import 'package:flutter/material.dart';

// holds static properties
Color _staticPrimaryDark = Color(0xFF14161c);
Color _staticPrimaryLight = Color(0xFFFFFFFF);

// holds the app global properties
Brightness appBrightness = Brightness.light;
Color appBackgroundColor = _staticPrimaryLight;
Color appIconColor = _staticPrimaryDark;
Color snackBarErrorMsgColor = Colors.red;
Color snackBarWarningMsgColor = Colors.orange;
Color resultDefaultTextColor = Colors.black;
Color resultNowPlayingTextColor = Colors.red;

// main.dart
Color mainAppTitleColor = Colors.red;
Color mainPrimarySwatch = Colors.red;
// homePage.dart
Color homePageSlideUpCollapsedBG = appBackgroundColor;
Color homePageSlideUpExpandedViewsTextColor = Colors.grey;
Color homePageSlideUpExpandedViewsIconColor = Colors.grey;
Color homePageAppBarBG = appBackgroundColor;
Color homePageAppBarIconColor = appIconColor;
Color homePageAppBarIndicatorColor = Colors.transparent;
Color homePageAppBarUnselectedLabelColor = Colors.grey;
Color homePageAppBarLabelColor = Colors.red;
// searchPage.dart
Color searchPageScaffoldBG = appBackgroundColor;
Color searchPageTextFieldBGColor = Color(0xFFE6E6E6);
Color searchPageAppBarIconColor = appIconColor;
Color searchPageAppBarTextColor = Colors.black;
Color searchPageAppBarHintColor = Colors.grey;
Color searchPageCursorColor = Colors.red;
Color searchPageSuggestionsColor = Colors.grey;
Color searchPageSuggestionsIconColor = Colors.grey;
// searchTab.dart
Color searchTabDefaultTextColor = Colors.grey;
