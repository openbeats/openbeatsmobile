import 'package:audio_service/audio_service.dart';
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
      "views":
          globalFun.reformatViews(widget.videosResponseList[index]["views"]),
    };
    // calling method to start media playback
    widget.startSinglePlayback(mediaParameters);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: (widget.searchResultLoading)
          ? searchTabW.searchResultLoadingW(context)
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
  // using stream to notify search result of currently playing media item
  Widget searchResultListBuilder() {
    // holds the thumbnailURL of the current playing media (empty if no media is playing)
    String currentPlayingMediaThumbnail;
    return StreamBuilder(
        stream: AudioService.playbackStateStream,
        builder: (context, snapshot) {
          // setting default value for the thumbnail
          currentPlayingMediaThumbnail = "";
          PlaybackState state = snapshot.data;
          // getting the title of the current playing media
          if (state != null && AudioService.currentMediaItem != null) {
            currentPlayingMediaThumbnail = AudioService.currentMediaItem.artUri;
          }
          return ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              ListView.separated(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemBuilder: (BuildContext context, int index) =>
                    searchResultListTile(
                        context, index, currentPlayingMediaThumbnail),
                itemCount: widget.videosResponseList.length,
              ),
              // space to compensate for the slideUpPanel
              SizedBox(
                height:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? MediaQuery.of(context).size.height * 0.2
                        : MediaQuery.of(context).size.height * 0.3,
              )
            ],
          );
        });
  }

  // holds the listtile for the searchResults
  Widget searchResultListTile(
      BuildContext context, int index, String currentPlayingMediaThumbnail) {
    return Container(
      decoration: BoxDecoration(),
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
                  widget.videosResponseList[index]["thumbnail"], context),
              onTap: () => startSinglePlaybackOnTap(index),
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
                      widget.videosResponseList[index]["title"],
                      context,
                      (currentPlayingMediaThumbnail ==
                              widget.videosResponseList[index]["thumbnail"])
                          ? true
                          : false),
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
            width: MediaQuery.of(context).size.width * 0.04,
          ),
        ],
      ),
    );
  }
}
