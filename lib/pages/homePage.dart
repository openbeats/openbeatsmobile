import 'package:flutter/material.dart';
import 'package:openbeatsmobile/pages/searchPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../widgets/homePageW.dart' as homePageW;
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalStrings.dart' as globalStrings;
import '../globals/globalFun.dart' as globalFun;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // homePageScaffold key for the Scaffold containing the tabs
  final GlobalKey<ScaffoldState> tabScaffoldkey =
      new GlobalKey<ScaffoldState>();

  // holds the list of tab pages
  List<Widget> homePageTabBody = [
    Center(
      child: Text("Page 1"),
    ),
    Center(
      child: Text("Page 2"),
    ),
    Center(
      child: Text("Page 3"),
    ),
    Center(
      child: Text("Page 4"),
    ),
    Center(
      child: Text("Page 5"),
    ),
  ];
  // flag to mark that the search results are loading
  bool searchResultLoading = false;
  // tab controller to help control the tabs in code
  TabController tabController;

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
      // getVideosForQuery(selectedSearchResult);
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = new TabController(
        vsync: this, length: globalStrings.homePageTabTitles.length);
  }

  @override
  void dispose() {
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
      minHeight: MediaQuery.of(context).size.height * 0.09,
      collapsed: slideUpCollapsedW(),
      panel: slideUpPanelW(),
      body: homePageScaffold(),
    );
  }

  // holds the widget to display when slideUp is collapsed
  Widget slideUpCollapsedW() {
    return Container(
      decoration: BoxDecoration(
        color: globalColors.homePageSlideUpCollapsedBG,
      ),
      child: null,
    );
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
        key: tabScaffoldkey,
        backgroundColor: globalColors.appBackgroundColor,
        appBar: homePageW.homePageAppBar(
            context, navigateToSearchPage, tabController),
        body: TabBarView(
          controller: tabController,
          children: homePageTabBody,
        ),
      ),
    );
  }
}
