import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../globalVars.dart' as globalVars;

Widget appBar() {
  return AppBar(
    title: Text("Add to Playlist"),
    centerTitle: true,
    elevation: 0,
    backgroundColor: globalVars.primaryDark,
  );
}

Widget playListImageView() {
  return SizedBox(
    height: 70.0,
    width: 70.0,
    child: Icon(FontAwesomeIcons.list),
  );
}

