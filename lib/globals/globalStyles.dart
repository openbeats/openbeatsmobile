import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './globalColors.dart' as globalColors;

// holds the styles for the BottomNavBar items
TextStyle bottomNavBarItemLabelStyle = TextStyle(
  fontSize: 12.0,
);

// holds the appBar theme for main.dart
AppBarTheme mainAppBarTheme = AppBarTheme(
  elevation: 0,
  color: globalColors.backgroundClr,
  textTheme: TextTheme(
    title: GoogleFonts.poppins(
      textStyle: TextStyle(
        color: globalColors.textDefaultClr,
        fontSize: 26.0,
      ),
      fontWeight: FontWeight.w600,
    ),
  ),
  iconTheme: IconThemeData(
    color: globalColors.iconDefaultClr,
  ),
  actionsIconTheme: IconThemeData(
    color: globalColors.iconDefaultClr,
  ),
);

// holds the ThemeData for the application
ThemeData applicationThemeData = ThemeData(
  brightness: globalColors.appBrightness,
  primarySwatch: globalColors.primarySwatch,
  scaffoldBackgroundColor: globalColors.backgroundClr,
  appBarTheme: mainAppBarTheme,
);
