import 'package:flutter/material.dart';
import '../../widgets/tabsw/searchTabW.dart' as searchTabW;

class SearchTab extends StatefulWidget {
  // recieving passed values
  bool searchResultLoading;
  // audioService functions
  Function startSinglePlayback;
  // holds the videos received for query
  List videosResponseList = new List();
  SearchTab(this.searchResultLoading, this.videosResponseList,
      this.startSinglePlayback);
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  // reformats the views count to plays in the B,M,K format
  String reformatViews(String views) {
    // string to return the final count
    String plays = "";
    // removing the trailing text, and commas
    views = views.replaceFirst(" views", "").replaceAll(",", "");
    // formating number based on its string length
    if (views.length > 10) {
      plays = views[0] + views[1] + "B plays";
    } else if (views.length > 9) {
      plays = views[0] + "B plays";
    } else if (views.length > 8) {
      plays = views[0] + views[1] + views[2] + "M plays";
    } else if (views.length > 7) {
      plays = views[0] + views[1] + "M plays";
    } else if (views.length > 6) {
      plays = views[0] + "M plays";
    } else if (views.length > 5) {
      plays = views[0] + views[1] + views[2] + "K plays";
    } else if (views.length > 4) {
      plays = views[0] + views[1] + "K plays";
    } else if (views.length > 3) {
      plays = views[0] + "K plays";
    }

    return plays;
  }

  // reformats timestamp into seconds
  int reformatTimeStampToMilliSeconds(String timeStamp) {
    // holds the seconds in integer format
    int totalSeconds = 0;
    // converting timeStamp into list of digits in integer format
    List<int> timeStampLst = timeStamp
        .split(":")
        .map((digitString) => int.parse(digitString))
        .toList();
    if (timeStampLst.length == 2) {
      // adding minutes and seconds to total seconds
      totalSeconds += (timeStampLst[0] * 60000) + (timeStampLst[1] * 1000);
    } else if (timeStampLst.length == 3) {
      // adding hours and minutes and seconds to total seconds
      totalSeconds += (timeStampLst[0] * 3600 * 1000) +
          (timeStampLst[1] * 60) +
          timeStampLst[2];
    }
    // return the total seconds
    return (totalSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: (widget.searchResultLoading)
          ? searchTabW.searchResultLoadingW()
          : searchTabBody(),
    );
  }

  // holds the body of the serachTab
  Widget searchTabBody() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: (widget.videosResponseList.length > 0)
          ? searchResultListBuilder()
          : searchTabW.searchTabDefault(context),
    );
  }

  // holds the listview builder to build the search results
  Widget searchResultListBuilder() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: searchResultListTile,
          itemCount: widget.videosResponseList.length,
        ),
        // space to compensate for the slideUpPanel
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        )
      ],
    );
  }

  // holds the listtile for the searchResults
  Widget searchResultListTile(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(),
      child: ListTile(
        leading: searchTabW.searchResultThumbnail(
            widget.videosResponseList[index]["thumbnail"], context),
        title: searchTabW.searchResultTitle(
            widget.videosResponseList[index]["title"], context),
        subtitle: searchTabW.searchResultSubtitles(
            reformatViews,
            widget.videosResponseList[index]["views"],
            widget.videosResponseList[index]["duration"]),
        trailing: searchTabW.searchResultExtraOptions(),
        onTap: () async {
          // constructing the mediaParameters object
          Map<String, dynamic> mediaParameters = {
            "title": widget.videosResponseList[index]["title"],
            "thumbnail": widget.videosResponseList[index]["thumbnail"],
            "duration": widget.videosResponseList[index]["duration"],
            "durationInMilliSeconds": reformatTimeStampToMilliSeconds(
                widget.videosResponseList[index]["duration"]),
            "videoId": widget.videosResponseList[index]["videoId"],
            "channelName": widget.videosResponseList[index]["channelName"],
            "views": widget.videosResponseList[index]["views"],
          };
          // calling method to start media playback
          widget.startSinglePlayback(mediaParameters);
        },
      ),
    );
  }
}
