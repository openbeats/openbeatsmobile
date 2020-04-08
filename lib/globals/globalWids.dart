import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import '../globals/globalStrings.dart' as globalStrings;

// homePage.dart
Widget homePageLogo = Container(
  margin: EdgeInsets.only(left: 15.0),
  height: 36.0,
  child: FlareActor(
    "assets/flareAssets/logoanim.flr",
    animation: "rotate",
    alignment: Alignment.centerLeft,
  ),
);
