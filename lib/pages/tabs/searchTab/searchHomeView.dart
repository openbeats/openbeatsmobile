import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../../../widgets/tabW/searchTab/searchHomeViewW.dart'
    as searchHomeViewW;
import 'package:http/http.dart' as http;
import '../../../globals/globalFun.dart' as globalFun;
import '../../../globals/globalVars.dart' as globalVars;
import '../../../globals/globalScaffoldKeys.dart' as globalScaffoldKeys;
import '../../../globals/globalWids.dart' as globalWids;
import '../../../globals/globalColors.dart' as globalColors;

class SearchHomeView extends StatefulWidget {
  // custom AudioService methods
  Function startSinglePlayback;
  SearchHomeView(this.startSinglePlayback);
  @override
  _SearchHomeViewState createState() => _SearchHomeViewState();
}

class _SearchHomeViewState extends State<SearchHomeView>
    with AutomaticKeepAliveClientMixin<SearchHomeView> {
  // flag used to indicate that the search results are loading
  bool searchResultLoading = false;
  // holds the videos received for query
  List videosResponseList = new List();
  // flag for recursion calls for the getVideosforQuery function
  bool _recursionCountFlag = false;

  // navigate to searchNowView
  void navigateToSearchNowView() async {
    // getting the latest search result history into the global variable
    globalFun.getSearchHistorySharedPrefs();
    // navigating to searchNowView.dart and waiting for search query
    var selectedSearchString =
        await Navigator.of(context).pushNamed('/searchNow');

    // checking if the user has returned something
    if (selectedSearchString != null &&
        selectedSearchString.toString().length > 0) {
      // set the page to loading animation
      setState(() {
        searchResultLoading = true;
      });
      // adding the query to the search results history
      globalFun.addToSearchHistorySharedPrefs(selectedSearchString);
      // calling function to get videos for query
      getVideosForQuery(selectedSearchString);
    }
  }

  // gets list of videos for query
  void getVideosForQuery(String query) async {
    // sanitizing query to prevent rogue characters
    query = query.replaceAll(new RegExp(r'[^\w\s]+'), '');
    // constructing url to send request to to get list of videos
    String url = globalVars.apiHostAddress + "/ytcat?q=" + query + " audio";
    try {
      // sending http get request
      var response = await http.get(url);
      // decoding to json
      var responseJSON = jsonDecode(response.body);
      // checking if proper response is received
      if (responseJSON["status"] == true && responseJSON["data"].length != 0) {
        setState(() {
          // resetting recursion count flag
          _recursionCountFlag = false;
          // response as list to iterate over
          videosResponseList = responseJSON["data"] as List;

          // removing loading animation from screen
          searchResultLoading = false;

          // removing any snackbar
          globalScaffoldKeys.searchHomeViewScaffoldKey.currentState
              .hideCurrentSnackBar();
        });
      } else {
        setState(() {
          // removing loading animation from screen
          searchResultLoading = false;
        });
        if (!_recursionCountFlag) {
          // resetting recursion count flag
          _recursionCountFlag = true;
          getVideosForQuery(query);
        }

        // globalFun.showSnackBars(
        //   globalScaffoldKeys.searchHomeViewScaffoldKey,
        //   context,
        //   "Could not get proper response from server. Please try another query",
        //   Colors.orange,
        //   Duration(seconds: 3),
        // );
      }
    } catch (e) {
      // removing previous snackBar
      globalScaffoldKeys.searchHomeViewScaffoldKey.currentState
          .removeCurrentSnackBar();
      globalFun.showSnackBars(
        globalScaffoldKeys.searchHomeViewScaffoldKey,
        context,
        "Not able to connect to internet",
        Colors.orange,
        Duration(seconds: 5),
      );
      // removing the loading animation
      setState(() {
        // removing loading animation from screen
        searchResultLoading = false;
      });
    }
  }

  void startSinglePlaybackOnTap(int index) {
    // constructing the mediaParameters object
    Map<String, dynamic> mediaParameters = {
      "title": videosResponseList[index]["title"],
      "thumbnail": videosResponseList[index]["thumbnail"],
      "duration": videosResponseList[index]["duration"],
      "durationInMilliSeconds": globalFun.reformatTimeStampToMilliSeconds(
          videosResponseList[index]["duration"]),
      "videoId": videosResponseList[index]["videoId"],
      "channelName": videosResponseList[index]["channelName"],
      "views": globalFun.reformatViews(videosResponseList[index]["views"]),
    };
    // calling method to start media playback
    widget.startSinglePlayback(mediaParameters);
  }

  // connects to the audio_service
  void connect() async {
    await AudioService.connect();
  }

  // disconnects from the audio_service
  void disconnect() {
    AudioService.disconnect();
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  // override function to instruct the app to preserve state of page
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: globalScaffoldKeys.searchHomeViewScaffoldKey,
      appBar: searchHomeViewW.appBar(navigateToSearchNowView),
      body: searchHomeViewBody(),
    );
  }

  // holds the searchHomeView Body implementation
  Widget searchHomeViewBody() {
    return Container(
      color: globalColors.backgroundClr,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: (searchResultLoading)
            ? searchHomeViewW.searchResultLoadingW(context)
            : searchHomeViewContentInstructionSwitcher(),
      ),
    );
  }

  // holds the content and searchInstruction switcher
  Widget searchHomeViewContentInstructionSwitcher() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: (videosResponseList.length > 0)
          ? searchResultListBuilder()
          : searchHomeViewW.searchHomeViewSearchInstruction(context),
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
        return searchHomeViewW.listOfBodyContents(context, videosResponseList,
            currentPlayingMediaThumbnail, startSinglePlaybackOnTap);
      },
    );
  }
}
