import 'package:flutter/material.dart';
import '../globalVars.dart' as globalVars;

Widget appBarW(){
  return AppBar(
    title: Text("Playing Queue"),
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    elevation: 0,
  );
}