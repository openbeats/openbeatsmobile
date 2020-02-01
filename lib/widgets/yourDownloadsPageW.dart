import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../globalVars.dart' as globalVars;

// holds the appBar for the homePage
Widget appBarW(
    context, GlobalKey<ScaffoldState> _yourDownloadsPageScaffoldKey) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Text("Your Playlists"),
    leading: IconButton(
      icon: Icon(FontAwesomeIcons.alignLeft),
      iconSize: 22.0,
      onPressed: () {
        _yourDownloadsPageScaffoldKey.currentState.openDrawer();
      },
    ),
  );
}
