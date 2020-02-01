import 'package:flutter/material.dart';
import 'package:openbeatsmobile/pages/homePage.dart';
import '../widgets/yourDownloadsPageW.dart' as yourDownloadsPageW;
import '../globalWids.dart' as globalWids;

class YourDownloadsPage extends StatefulWidget {
  @override
  _YourDownloadsPageState createState() => _YourDownloadsPageState();
}

class _YourDownloadsPageState extends State<YourDownloadsPage> {
  final GlobalKey<ScaffoldState> _yourDownloadsPageScaffoldKey =
      new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .push(globalWids.FadeRouteBuilder(page: HomePage()));
        //we need to return a future
        return Future.value(false);
      },
      child: SafeArea(child: Scaffold(
        appBar: yourDownloadsPageW.appBarW(context, _yourDownloadsPageScaffoldKey),
        body: null,
      ))
    );
  }
}