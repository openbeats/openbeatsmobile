import 'package:flutter/material.dart';

import '../widgets/nowPlayingPageW.dart' as nowPlayingPageW;

import '../globalFun.dart' as globalFun;
import '../globalVars.dart' as globalVars;
import '../globalWids.dart' as globalWids;

class NowPlayingPage extends StatefulWidget {
  @override
  _NowPlayingPageState createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: nowPlayingPageW.appBar(),
        backgroundColor: globalVars.primaryDark,
        body: nowPlayingPageBody(),
      ),
    );
  }

  Widget nowPlayingPageBody() {
    return Container(
      child: Column(
        children: <Widget>[],
      ),
    );
  }
}
