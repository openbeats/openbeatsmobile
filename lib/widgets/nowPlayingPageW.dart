import 'package:flutter/material.dart';

import '../globalVars.dart' as globalVars;

Widget appBar() {
  return AppBar(
    title: Text("Now Playing"),
    centerTitle: true,
    elevation: 0,
    backgroundColor: globalVars.primaryDark,
  );
}