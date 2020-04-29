import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import '../../../globals/globalColors.dart' as globalColors;

// holds the AppBar for the searchHomeView
Widget appBar(Function navigateToSearchNowView) {
  return AppBar(
    title: Text("Search"),
    actions: <Widget>[searchButtonAppBar(navigateToSearchNowView)],
  );
}

// holds the search button for the AppBar
Widget searchButtonAppBar(Function navigateToSearchNowView) {
  return IconButton(
    icon: Icon(
      Icons.search,
      size: 30.0,
    ),
    onPressed: navigateToSearchNowView,
  );
}

// holds the searchHomeView search instruction widgets
Widget searchHomeViewSearchInstruction(BuildContext context) {
  return ListView(
    physics: BouncingScrollPhysics(),
    children: <Widget>[
      searchInstructionFlareActor(context),
      SizedBox(
        height: 10.0,
      ),
      searchInstructionText(context),
    ],
  );
}

// holds the searchHomeView search instruction FlareActor
Widget searchInstructionFlareActor(BuildContext context) {
  return Container(
    margin: (MediaQuery.of(context).orientation == Orientation.portrait)
        ? EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.11)
        : null,
    height: MediaQuery.of(context).size.height * 0.4,
    child: FlareActor(
      "assets/flareAssets/searchforsong.flr",
      animation: "Searching",
    ),
  );
}

// holds the searchHomeView search instruction text
Widget searchInstructionText(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    child: (MediaQuery.of(context).orientation == Orientation.portrait)
        ? RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                  color: globalColors.textDisabledClr, fontSize: 25.0),
              children: [
                TextSpan(
                  text: "Click on ",
                ),
                WidgetSpan(
                  child: Icon(
                    Icons.search,
                    color: globalColors.textDisabledClr,
                    size: 30.0,
                  ),
                ),
                TextSpan(text: " to search\nfor your favorite songs")
              ],
            ),
          )
        : null,
  );
}
