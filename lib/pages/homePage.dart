import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openbeatsmobile/pages/searchPage.dart';
import 'package:openbeatsmobile/pages/tabs/searchTab.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../widgets/homePageW.dart' as homePageW;
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalStrings.dart' as globalStrings;
import '../globals/globalFun.dart' as globalFun;
import '../globals/actions/globalVarsA.dart' as globalVarsA;
import '../globals/globalWids.dart' as globalWids;

class HomePage extends StatefulWidget {
  Function startAudioService, startSinglePlayback;
  BehaviorSubject<double> dragPositionSubject;
  HomePage(this.startAudioService, this.startSinglePlayback,
      this.dragPositionSubject);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // homePageScaffold key for the Scaffold containing the tabs
  final GlobalKey<ScaffoldState> tabScaffoldKey =
      new GlobalKey<ScaffoldState>();

  // flag to mark that the search results are loading
  bool searchResultLoading = false;
  // tab controller to help control the tabs in code
  TabController tabController;
  // holds the videos received for query
  List videosResponseList = new List();

  // navigating to the searchPage
  void navigateToSearchPage() async {
    // getting the latest search result history into the global variable
    globalFun.getSearchHistory();
    // setting navResult value to know if it has changed
    String selectedSearchResult = "";
    // Navigate to the search page and wait for response
    selectedSearchResult = await Navigator.push(
      context,
      PageTransition(
        child: SearchPage(),
        type: PageTransitionType.fade,
      ),
    );
    // checking if the user has returned something
    if (selectedSearchResult != null && selectedSearchResult.length > 0) {
      // set the page to loading animation
      setState(() {
        searchResultLoading = true;
      });
      // bringing the searchTab into view
      tabController.animateTo(2);
      // adding the query to the search results history
      globalFun.addToSearchHistory(selectedSearchResult);
      // calling function to get videos for query
      getVideosForQuery(selectedSearchResult);
    }
  }

  // gets list of videos for query
  void getVideosForQuery(String query) async {
    // sanitizing query to prevent rogue characters
    query = query.replaceAll(new RegExp(r'[^\w\s]+'), '');
    // constructing url to send request to to get list of videos
    String url = "https://api.openbeats.live/ytcat?q=" + query + " audio";
    try {
      // sending http get request
      var response = await Dio().get(url);
      // decoding to json
      var responseJSON = response.data;
      // checking if proper response is received
      if (responseJSON["status"] == true && responseJSON["data"].length != 0) {
        setState(() {
          // response as list to iterate over
          videosResponseList = responseJSON["data"] as List;
          // calling function to set the videoResponseList globally for persistency
          globalVarsA.setPersistentVideoList(videosResponseList);
          // removing loading animation from screen
          searchResultLoading = false;
          // removing any snackbar
          tabScaffoldKey.currentState.hideCurrentSnackBar();
        });
      } else {
        setState(() {
          // removing loading animation from screen
          searchResultLoading = false;
        });
        globalFun.showSnackBars(
            tabScaffoldKey,
            context,
            "Could not get proper response from server. Please try another query",
            globalColors.snackBarWarningMsgColor,
            Duration(seconds: 3));
      }
    } catch (e) {
      // catching dio error
      if (e is DioError) {
        // removing previous snackBar
        tabScaffoldKey.currentState.removeCurrentSnackBar();
        globalFun.showSnackBars(
            tabScaffoldKey,
            context,
            "Not able to connect to internet",
            globalColors.snackBarErrorMsgColor,
            Duration(seconds: 5));
        // removing the loading animation
        setState(() {
          // removing loading animation from screen
          searchResultLoading = false;
        });
      }
    }
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
    tabController = new TabController(
        vsync: this, length: globalStrings.homePageTabTitles.length);
    connect();
  }

  @override
  void dispose() {
    disconnect();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globalColors.appBackgroundColor,
      body: SafeArea(
        child: homePageWidgets(),
      ),
    );
  }

  // holds the slidingUpPanel implementation
  Widget homePageWidgets() {
    return SlidingUpPanel(
      maxHeight: MediaQuery.of(context).size.height,
      minHeight: (MediaQuery.of(context).orientation == Orientation.portrait)
          ? MediaQuery.of(context).size.height * 0.09
          : MediaQuery.of(context).size.height * 0.25,
      collapsed: slideUpCollapsedW(),
      panel: slideUpPanelW(),
      body: homePageScaffold(),
    );
  }

  // holds the widget to display when slideUp is collapsed
  Widget slideUpCollapsedW() {
    String audioThumbnail = "https://via.placeholder.com/150/000000/FFFFFF",
        audioTitle = "No audio playing";
    // getting instance of audioService playbackState
    PlaybackState playbackState = AudioService.playbackState;
    return StreamBuilder(
        stream: AudioService.playbackStateStream,
        builder: (context, snapshot) {
          PlaybackState state = snapshot.data;

          if (state != null &&
              state.basicState != BasicPlaybackState.none &&
              state.basicState != BasicPlaybackState.stopped) {
            if (AudioService.currentMediaItem != null) {
              // getting thumbNail image
              audioThumbnail = AudioService.currentMediaItem.artUri;
              // getting audioTitle
              audioTitle = AudioService.currentMediaItem.title;
            }
          } else {
            // resetting values
            audioThumbnail = "https://via.placeholder.com/150/000000/FFFFFF";
            audioTitle = "No audio playing";
          }
          return Container(
              decoration: BoxDecoration(
                color: globalColors.homePageSlideUpCollapsedBG,
              ),
              child: homePageW.nowPlayingCollapsed(audioThumbnail, audioTitle,
                  context, widget.dragPositionSubject));
        });
  }

  // holds the widget in the slide up panel
  Widget slideUpPanelW() {
    return Container(
      child: Center(
        child: Text("This is the sliding Widget"),
      ),
    );
  }

  Widget homePageScaffold() {
    return DefaultTabController(
      length: globalStrings.homePageTabTitles.length,
      child: Scaffold(
        key: tabScaffoldKey,
        backgroundColor: globalColors.appBackgroundColor,
        appBar: homePageW.homePageAppBar(
            context, navigateToSearchPage, tabController),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            Center(
              child: FlatButton(
                onPressed: () => widget.startAudioService(),
                child: Text("Start"),
              ),
            ),
            Center(
              child: Text("Page 2"),
            ),
            SearchTab(searchResultLoading, videosResponseList,
                widget.startSinglePlayback),
            Center(
              child: Text("Page 4"),
            ),
            Center(
              child: Text("Page 5"),
            )
          ],
        ),
      ),
    );
  }
}
