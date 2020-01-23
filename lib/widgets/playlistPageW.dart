import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../globalVars.dart' as globalVars;

// holds the appBar for the plaistPage
Widget appBarW(
    context, GlobalKey<ScaffoldState> _playlistsPageScaffoldKey, String playlistName) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Text(playlistName),
    leading: IconButton(
      icon: Icon(FontAwesomeIcons.alignLeft),
      iconSize: 22.0,
      onPressed: () {
        _playlistsPageScaffoldKey.currentState.openDrawer();
      },
    ),
  );
}

// holds the loading animation for the page
Widget playlistsLoading() {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(globalVars.accentRed),
    ),
  );
}