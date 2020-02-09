import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../globalVars.dart' as globalVars;

// holds the appBar
Widget appBarW(
    context, GlobalKey<ScaffoldState> _aboutPageScaffoldKey) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Text("About"),
    leading: IconButton(
      icon: Icon(FontAwesomeIcons.alignLeft),
      iconSize: 22.0,
      onPressed: () {
        _aboutPageScaffoldKey.currentState.openDrawer();
      },
    ),
  );
}
