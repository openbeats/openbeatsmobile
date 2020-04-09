import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import './globalStrings.dart' as globalStrings;
import './globalVars.dart' as globalVars;
import './globalFun.dart' as globalFun;

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

// holds the thumbnail in audioTile listing view
Widget audioThumbnailW(String thumbnailURL, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.15,
    height: MediaQuery.of(context).size.width * 0.15,
    decoration: BoxDecoration(boxShadow: [
      new BoxShadow(
        color: Colors.black,
        blurRadius: 2.0,
        offset: new Offset(1.0, 1.0),
      ),
    ], borderRadius: BorderRadius.circular(globalVars.borderRadius)),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(globalVars.borderRadius),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: thumbnailURL,
        placeholder: (context, url) => Center(
          child: Container(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    ),
  );
}

// holds the audio title in audioTile listing view
Widget audioTitleW(String title, BuildContext context) {
  return Container(
    child: Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    ),
  );
}

// holds the audio details in audioTile listing view
Widget audioDetailsW(String views, String duration) {
  return Container(
    margin: EdgeInsets.only(top: 5.0),
    child: Text(duration + " | " + globalFun.reformatViews(views)),
  );
}

// holds the timing details to show under the title in collapsed slideUpPanel
Widget audioDetailsTimingW(int seconds, String duration) {
  return Text(
    globalFun.getCurrentTimeStamp(seconds / 1000) + " / " + duration,
    style: TextStyle(
      fontSize: 12.0,
      color: Colors.grey,
    ),
  );
}
