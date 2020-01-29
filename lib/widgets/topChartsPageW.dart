import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;
import '../globalWids.dart' as globalWids;

// holds the appBar for the homePage
Widget appBarW(context, GlobalKey<ScaffoldState> _topChartsPageScaffoldKey) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Text("Top Charts"),
    leading: IconButton(
      icon: Icon(FontAwesomeIcons.alignLeft),
      iconSize: 22.0,
      onPressed: () {
        _topChartsPageScaffoldKey.currentState.openDrawer();
      },
    ),
  );
}

Widget loadingPageAnimation() {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(globalVars.accentRed),
    ),
  );
}
