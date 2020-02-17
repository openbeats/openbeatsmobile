import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:openbeatsmobile/pages/homePage.dart';
import 'package:package_info/package_info.dart';
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

  void getVersionInfo()  async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      globalVars.appVersion = packageInfo.version+"+"+packageInfo.buildNumber;
    });
  }

  @override
  void initState() {
    super.initState();
    getVersionInfo();
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
            body: aboutPageBody(),
          ),
        ));
  }

  Widget aboutPageBody() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          aboutPageW.aboutAppCard(context),
          aboutPageW.helpCard(context)
        ],
      ),
    );
  }
}
