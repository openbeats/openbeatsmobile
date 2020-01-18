import 'package:flutter/material.dart';
import '../globalVars.dart' as globalVars;

// holds the appBar 
Widget appBarW() {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Image.asset(
      "assets/images/logo/logotext.png",
      height: 40.0,
    ),
  );
}