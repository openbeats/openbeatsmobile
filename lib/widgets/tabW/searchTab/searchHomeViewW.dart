import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import '../../../globals/globalColors.dart' as globalColors;
import '../../../globals/globalWids.dart' as globalWids;

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

// holds the listview containing the list of body contents in searchHomeView
Widget listOfBodyContents(BuildContext context, List videosResponseList,
    currentPlayingMediaThumbnail) {
  return ListView(
    physics: BouncingScrollPhysics(),
    children: <Widget>[
      SizedBox(
        height: 15.0,
      ),
      ListView.separated(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemBuilder: (BuildContext context, int index) => searchResultListTile(
            context, index, currentPlayingMediaThumbnail, videosResponseList),
        itemCount: videosResponseList.length,
      ),
      // space to compensate for the slideUpPanel
      SizedBox(
        height: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? MediaQuery.of(context).size.height * 0.22
            : MediaQuery.of(context).size.height * 0.33,
      )
    ],
  );
}

// holds the listtile for the searchResults
Widget searchResultListTile(BuildContext context, int index,
    String currentPlayingMediaThumbnail, List videosResponseList) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.035,
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: GestureDetector(
            child: globalWids.audioThumbnailW(
                videosResponseList[index]["thumbnail"], context, 0.15, 5),
            // onTap: () => startSinglePlaybackOnTap(index),
            onTap: () {},
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        Flexible(
          flex: 9,
          fit: FlexFit.tight,
          child: GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                globalWids.audioTitleW(
                    videosResponseList[index]["title"],
                    context,
                    (currentPlayingMediaThumbnail ==
                            videosResponseList[index]["thumbnail"])
                        ? true
                        : false,
                    false),
                globalWids.audioDetailsW(videosResponseList[index]["views"],
                    videosResponseList[index]["duration"])
              ],
            ),
            // onTap: () => startSinglePlaybackOnTap(index),
            onTap: () {},
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: searchResultExtraOptions(),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.04,
        ),
      ],
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
