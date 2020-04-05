import 'package:flutter/material.dart';
import '../widgets/exploreTabW.dart' as ExploreTabW;

class ExploreTab extends StatefulWidget {
  var startAudioService;
  ExploreTab(this.startAudioService);
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
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
          ExploreTabW.recentlyPlayedSectionTitle(),
          Container(
            child: RaisedButton(
              onPressed: () {
                widget.startAudioService();
              },
              child: Text("Start Playback"),
            ),
          ),
        ],
      ),
    );
  }
}
