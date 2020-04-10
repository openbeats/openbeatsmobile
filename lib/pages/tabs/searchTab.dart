import 'package:flutter/material.dart';
import '../../widgets/tabsw/searchTabW.dart' as searchTabW;
import '../../globals/globalWids.dart' as globalWids;
import '../../globals/globalFun.dart' as globalFun;

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
  void startSinglePlaybackOnTap(int index) {
    // constructing the mediaParameters object
    Map<String, dynamic> mediaParameters = {
      "title": widget.videosResponseList[index]["title"],
      "thumbnail": widget.videosResponseList[index]["thumbnail"],
      "duration": widget.videosResponseList[index]["duration"],
      "durationInMilliSeconds": globalFun.reformatTimeStampToMilliSeconds(
          widget.videosResponseList[index]["duration"]),
      "videoId": widget.videosResponseList[index]["videoId"],
      "channelName": widget.videosResponseList[index]["channelName"],
      "views": widget.videosResponseList[index]["views"],
    };
    // calling method to start media playback
    widget.startSinglePlayback(mediaParameters);
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: GestureDetector(
              child: globalWids.audioThumbnailW(
                  widget.videosResponseList[index]["thumbnail"], context),
              onTap: () => startSinglePlaybackOnTap(index),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          Flexible(
            flex: 8,
            fit: FlexFit.tight,
            child: GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  globalWids.audioTitleW(
                      widget.videosResponseList[index]["title"], context),
                  globalWids.audioDetailsW(
                      widget.videosResponseList[index]["views"],
                      widget.videosResponseList[index]["duration"])
                ],
              ),
              onTap: () => startSinglePlaybackOnTap(index),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: searchTabW.searchResultExtraOptions(),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
        ],
      ),
    );
  }
}
