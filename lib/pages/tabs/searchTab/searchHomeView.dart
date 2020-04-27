import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import '../../../widgets/tabW/searchTab/searchHomeViewW.dart'
    as searchHomeViewW;

class SearchHomeView extends StatefulWidget {
  @override
  _SearchHomeViewState createState() => _SearchHomeViewState();
}

class _SearchHomeViewState extends State<SearchHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchHomeViewW.appBar(),
      body: searchHomeViewBody(),
    );
  }

  // holds the searchHomeView Body implementation
  Widget searchHomeViewBody() {
    return Container(
      child: Center(
        child: searchInstructionFlareActor(),
      ),
    );
  }

  // holds the searchHomeView search instruction FlareActor
  Widget searchInstructionFlareActor() {
    return SizedBox(
      height: 300.0,
      child: FlareActor(
        "assets/flareAssets/searchforsong.flr",
        animation: "Searching",
      ),
    );
  }
}
