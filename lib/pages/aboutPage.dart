import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:openbeatsmobile/pages/homePage.dart';
import 'package:rxdart/subjects.dart';
import '../widgets/aboutPageW.dart' as aboutPageW;
import '../globalVars.dart' as globalVars;
import '../globalWids.dart' as globalWids;
import '../globalFun.dart' as globalFun;

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final GlobalKey<ScaffoldState> _aboutPageScaffoldKey =
      new GlobalKey<ScaffoldState>();
  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);

  // function that calls the bottomSheet
  void settingModalBottomSheet(context) async {
    if (AudioService.currentMediaItem != null) {
      // bottomSheet definition
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(globalVars.borderRadius),
            topRight: Radius.circular(globalVars.borderRadius),
          )),
          context: context,
          elevation: 10.0,
          builder: (BuildContext bc) {
            return globalWids.bottomSheet(context, _dragPositionSubject);
          });
    }
  }

  void connect() async {
    await AudioService.connect();
  }

  void disconnect() {
    AudioService.disconnect();
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context)
              .push(globalWids.FadeRouteBuilder(page: HomePage()));
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            key: _aboutPageScaffoldKey,
            backgroundColor: globalVars.primaryDark,
            appBar: aboutPageW.appBarW(context, _aboutPageScaffoldKey),
            drawer: globalFun.drawerW(10, context),
            floatingActionButton: globalWids.fabView(
                settingModalBottomSheet, _aboutPageScaffoldKey),
          ),
        ));
  }
}
