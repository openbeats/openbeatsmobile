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
        Text(
          "Try searching for any song\nof your liking",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: globalColors.searchTabDefaultTextColor, fontSize: 25.0),
        )
      ],
    ),
  );
}

// holds the widget to show when the search results are loading
Widget searchResultLoadingW() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      SizedBox(
        height: 50.0,
        width: 50.0,
        child: CircularProgressIndicator(),
      )
    ],
  );
}

// holds the thumbnail to show in searchResults
Widget searchResultThumbnail(String thumbnailURL, BuildContext context) {
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

// holds the subtitles for searchResults
Widget searchResultSubtitles(
    Function reformatViews, String views, String duration) {
  return Container(
    margin: EdgeInsets.only(top: 5.0),
    child: Text(duration + " | " + reformatViews(views)),
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
