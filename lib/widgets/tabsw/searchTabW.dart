import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import '../../globals/globalColors.dart' as globalColors;
import '../../globals/globalVars.dart' as globalVars;

// holds the searchTab default widget
Widget searchTabDefault(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.8,
          child: FlareActor(
            "assets/flareAssets/searchforsong.flr",
            animation: "Searching",
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
                color: globalColors.subtitleTextColor, fontSize: 25.0),
            children: [
              TextSpan(
                text: "Click on ",
              ),
              WidgetSpan(
                child: Icon(
                  Icons.search,
                  color: globalColors.subtitleIconColor,
                  size: 30.0,
                ),
              ),
              TextSpan(text: " to search\nfor your favorite songs")
            ],
          ),
        ),
      ],
    ),
  );
}

// holds the widget to show when the search results are loading
Widget searchResultLoadingW(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
      ),
      SizedBox(
        height: 100.0,
        child: FlareActor(
          "assets/flareAssets/loadinganim.flr",
          animation: "loadnew",
        ),
      )
    ],
  );
}

// holds the audio title to show in searchResults
Widget searchResultTitle(String title, BuildContext context) {
  return Container(
    child: Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// holds the extra options for searchResults
Widget searchResultExtraOptions() {
  return Container(
    child: IconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () {},
    ),
  );
}
