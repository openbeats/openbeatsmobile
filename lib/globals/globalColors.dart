import 'package:flutter/material.dart';

//? holds static properties
Color _staticPrimaryDark = Color(0xFF202124);
Color _staticPrimaryLight = Color(0xFFFFFFFF);
Color _openBeatsRed = Color(0xFFF32C2C);
Color _offWhite = Color(0xFFE6E6E6);

//? holds the app global properties
Brightness appBrightness = Brightness.light;
Color backgroundColor = _staticPrimaryLight;
Color textColor = _staticPrimaryDark;
Color textDisabledColor = Colors.grey;
Color subtitleTextColor = Colors.grey;
Color iconColor = _staticPrimaryDark;
Color iconDisabledColor = Colors.grey;
Color subtitleIconColor = Colors.grey;
Color textNowPlayingColor = _openBeatsRed;
Color snackBarErrorMsgColor = Colors.red;
Color snackBarWarningMsgColor = Colors.orange;
Color appTitleColor = _openBeatsRed;

//? homePage.dart
Color hPSlideUpPanelPlayBtnBG = _openBeatsRed;
Color hPSlideUpPanelPlayBtnColor = _staticPrimaryLight;
Color hPSlideUpPanelTimingColor = _openBeatsRed;
Color hpSelectedBottomNavItemColor = _openBeatsRed;
Color hpSelectedBottomNavTextColor = _openBeatsRed;

//? searchPage.dart
Color sPTextFieldBGColor = _offWhite;
