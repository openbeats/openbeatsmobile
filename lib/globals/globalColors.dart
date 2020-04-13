import 'package:flutter/material.dart';

// holds static properties
Color _staticPrimaryDark = Color(0xFF14161c);
Color _staticPrimaryLight = Color(0xFFFFFFFF);

// holds the app global properties
Brightness appBrightness = Brightness.light;
Color appBackgroundColor = _staticPrimaryLight;
Color appTextColor = _staticPrimaryDark;
Color appIconColor = _staticPrimaryDark;
Color snackBarErrorMsgColor = Colors.red;
Color snackBarWarningMsgColor = Colors.orange;
Color resultDefaultTextColor = Colors.black;
Color resultNowPlayingTextColor = Colors.red;
Color resultNoAudioPlayingTextColor = Colors.grey;
Color resultNoAudioPlayingIconColor = Colors.grey;
Color openBeatsRed = Color(0xFFF32C2C);

// main.dart
Color mainAppTitleColor = Colors.red;
Color mainPrimarySwatch = Colors.red;
// homePage.dart
Color homePageSlideUpCollapsedBG = appBackgroundColor;
Color homePageSlideUpExpandedViewsDisabledTextColor = Colors.grey;
Color homePageSlideUpExpandedViewsDisabledIconColor = Colors.grey;
Color homePageSlideUpExpandedViewsTextColor = _staticPrimaryDark;
Color homePageSlideUpExpandedViewsIconColor = _staticPrimaryDark;
Color homePageSlideUpExpandedViewsPlayPauseIconColor = _staticPrimaryLight;
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
