import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import './globalStrings.dart' as globalStrings;
import './globalColors.dart' as globalColors;
import './globalFun.dart' as globalFun;

// holds the list of BottomNaBar icons
List<IconData> bottomNavBarIcons = [
  Icons.explore,
  Icons.whatshot,
  Icons.search,
  Icons.library_music,
  Icons.person_pin
];

// holds the thumbnail in audioTile listing view
Widget audioThumbnailW(String thumbnailURL, BuildContext context,
    double sizeFactor, double borderRadius) {
  return Container(
    width: MediaQuery.of(context).size.width * sizeFactor,
    height: MediaQuery.of(context).size.width * sizeFactor,
    decoration: BoxDecoration(boxShadow: [
      new BoxShadow(
        color: Colors.black,
        blurRadius: 2.5,
        offset: new Offset(1.0, 1.0),
      ),
    ], borderRadius: BorderRadius.circular(borderRadius)),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: (thumbnailURL != "placeholder")
          ? CachedNetworkImage(
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
            )
          : Image.asset(
              "assets/images/supplementary/dummyimage.png",
              fit: BoxFit.cover,
            ),
    ),
  );
}

// holds the audio title in audioTile listing view
Widget audioTitleW(
    String title,
    BuildContext context,
    bool currentlyPlaying,
    bool shouldScroll,
    bool shouldCenter,
    bool audioPlaying,
    bool showBiggerLoadingAnimation) {
  return AnimatedSwitcher(
    duration: kThemeAnimationDuration,
    child: (audioPlaying)
        ? (shouldScroll)
            ? Container(
                margin: EdgeInsets.symmetric(
                  horizontal: (shouldScroll)
                      ? MediaQuery.of(context).size.width * 0.15
                      : 0.0,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  primary: true,
                  physics: BouncingScrollPhysics(),
                  child: audioTitleTextW(title, currentlyPlaying, shouldScroll),
                ),
              )
            : audioTitleTextW(
                title,
                currentlyPlaying,
                shouldScroll,
              )
        : connectingWidget(shouldCenter, showBiggerLoadingAnimation),
  );
}

// holds the Connecting widget to show instead of the title
Widget connectingWidget(bool shouldCenter, bool showBiggerLoadingAnimation) {
  return Container(
    height: (showBiggerLoadingAnimation) ? 40.0 : 30.0,
    child: FlareActor(
      "assets/flareAssets/logoanim.flr",
      animation: "rotate",
      alignment: (shouldCenter) ? Alignment.center : Alignment.centerLeft,
    ),
  );
}

// holds the text widget for audioTitleW
Widget audioTitleTextW(String title, bool currentlyPlaying, bool shouldScroll) {
  return Container(
    margin: (shouldScroll) ? EdgeInsets.only(bottom: 6.0) : null,
    child: Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (shouldScroll) ? 24.0 : 16.0,
        color: (title != globalStrings.noAudioPlayingString)
            ? (currentlyPlaying)
                ? globalColors.textActiveClr
                : globalColors.textDefaultClr
            : globalColors.textDisabledClr,
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
