import 'package:flutter/material.dart';
import '../widgets/explorePageW.dart' as explorePageW;

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          recentlyPlayedW(),
        ],
      ),
    );
  }

  Widget recentlyPlayedW() {
    return Container(
      child: Column(
        children: <Widget>[
          explorePageW.recentlyPlayedSectionTitle(),
        ],
      ),
    );
  }
}
