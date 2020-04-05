import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          noSearchResultsW(),
        ],
      ),
    );
  }

  Widget noSearchResultsW() {
    return Container(
      child: Column(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.search,
            color: Colors.grey,
            size: MediaQuery.of(context).size.width * 0.15,
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            "Search for songs,\naudiobook or remixes",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
