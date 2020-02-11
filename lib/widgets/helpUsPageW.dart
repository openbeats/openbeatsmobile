import 'package:flutter/material.dart';
import '../globalVars.dart' as globalVars;

Widget bugReportAppBarW(){
  return AppBar(
    title: Text("Bug Reporting"),
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
  );
}

