import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../globalVars.dart' as globalVars;

// holds the appBar for the homePage
Widget appBarW(
    context, GlobalKey<ScaffoldState> _downloadsPageScaffoldKey) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Text("Your Downloads"),
    leading: IconButton(
      icon: Icon(FontAwesomeIcons.alignLeft),
      iconSize: 22.0,
      onPressed: () {
        _downloadsPageScaffoldKey.currentState.openDrawer();
      },
    ),
  );
}

// holds the loading animation
Widget loadingAnimation() {
  return Center(
      child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(globalVars.accentRed),
  ));
}
