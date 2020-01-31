import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openbeatsmobile/pages/AddSongsToPlaylistPage.dart';

import '../globalFun.dart' as globalFun;
import '../globalVars.dart' as globalVars;
import '../globalWids.dart' as globalWids;

// holds the appBar for the homePage
Widget appBarW(context, navigateToSearchPage,
    GlobalKey<ScaffoldState> _homePageScaffoldKey) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Image.asset(
      "assets/images/logo/logotext.png",
      height: 40.0,
    ),
    leading: IconButton(
      icon: Icon(FontAwesomeIcons.alignLeft),
      iconSize: 22.0,
      onPressed: () {
        _homePageScaffoldKey.currentState.openDrawer();
      },
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(
          FontAwesomeIcons.search,
          size: 22.0,
        ),
        onPressed: () {
          navigateToSearchPage();
        },
        color: globalVars.primaryLight,
      ),
    ],
  );
}

Widget homePageView() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[hiText(), welcomeText()],
  );
}

Widget hiText() {
  return Text("Hi!", style: TextStyle(fontSize: 70.0, color: Colors.grey));
}

Widget welcomeText() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15.0),
    child: Text(
      "Try searching for any \nsong, podcast or audiobook you like",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey, fontSize: 20.0),
    ),
  );
}

