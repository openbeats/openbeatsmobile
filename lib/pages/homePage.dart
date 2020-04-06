import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../widgets/homePageW.dart' as homePageW;
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalStrings.dart' as globalStrings;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        backgroundColor: globalColors.appBackgroundColor,
        appBar: homePageW.homePageAppBar(context),
        body: TabBarView(
          children: homePageTabBody,
        ),
      ),
    );
  }
}
