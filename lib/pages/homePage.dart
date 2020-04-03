import 'package:flutter/material.dart';
import 'package:openbeatsmobile/pages/explorePage.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../widgets/homePageW.dart' as homePageW;
import '../globals/globalVars.dart' as globalVars;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // holds the margin and border radius of the slide up panel
  double slideUpPanelMarginRadius = 10.0;
  // holds the placeholder to help calculate the measurements for slideUpPanel
  double slideUpPlaceholder = 10.0;

  // holds the list of tab pages for homePage body
  List<Widget> homePageTabBody = [
    ExplorePage(),
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

  // calculates the measurementes for the slide up panel
  void calcSlideUpPanelMeasurements(double position) {
    setState(() {
      slideUpPanelMarginRadius =
          slideUpPlaceholder - slideUpPlaceholder * position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globalVars.primaryLight,
      body: SafeArea(
        child: homePageWidgets(),
      ),
    );
  }

  Widget homePageWidgets() {
    return SlidingUpPanel(
      maxHeight: MediaQuery.of(context).size.height,
      minHeight: MediaQuery.of(context).size.height * 0.1,
      borderRadius: BorderRadius.circular(slideUpPanelMarginRadius),
      margin: EdgeInsets.only(
        left: slideUpPanelMarginRadius,
        right: slideUpPanelMarginRadius,
        bottom: slideUpPanelMarginRadius,
      ),
      onPanelSlide: (double position) => calcSlideUpPanelMeasurements(position),
      collapsed: slideUpCollapsedW(),
      panel: slideUpPanelW(),
      body: homePageScaffold(),
    );
  }

  Widget slideUpCollapsedW() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: globalVars.primaryLight,
      ),
      child: null,
    );
  }

  Widget slideUpPanelW() {
    return Container(
      child: Center(
        child: Text("This is the sliding Widget"),
      ),
    );
  }

  Widget homePageScaffold() {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: globalVars.primaryLight,
        appBar: homePageW.homePageAppBar(),
        body: TabBarView(
          children: homePageTabBody,
        ),
      ),
    );
  }
}
