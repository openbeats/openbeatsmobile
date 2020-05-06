import 'package:flutter/material.dart';

import '../globalColors.dart' as globalColors;
import '../globalScaffoldKeys.dart' as globalScaffoldKeys;

// holds static properties
Color _staticPrimaryDark = Color(0xFF202124);
Color _staticPrimaryLight = Color(0xFFFFFFFF);
Color _openBeatsRed = Color(0xFFF32C2C);
Color _offWhite = Color(0xFFE6E6E6);

// switch app brightness
void switchAppBrightness(Brightness newBrightness) {
  if (newBrightness == Brightness.dark) {
    globalColors.appBrightness = Brightness.dark;
    globalColors.backgroundClr = _staticPrimaryDark;
    globalColors.iconDefaultClr = _staticPrimaryLight;
    globalColors.textDefaultClr = _staticPrimaryLight;
  } else {
    globalColors.appBrightness = Brightness.light;
    globalColors.backgroundClr = _staticPrimaryLight;
    globalColors.iconDefaultClr = _staticPrimaryDark;
    globalColors.textDefaultClr = _staticPrimaryDark;
  }
}
