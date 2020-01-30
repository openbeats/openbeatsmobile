import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:openbeatsmobile/pages/homePage.dart';
import 'package:http/http.dart' as http;
import '../widgets/topChartsPageW.dart' as topChartsPageW;
import '../globalFun.dart' as globalFun;
import '../globalVars.dart' as globalVars;
import '../globalWids.dart' as globalWids;

class TopChartsPage extends StatefulWidget {
  @override
  _TopChartsPageState createState() => _TopChartsPageState();
}

class _TopChartsPageState extends State<TopChartsPage> {
  final GlobalKey<ScaffoldState> _topChartsPageScaffoldKey =
      new GlobalKey<ScaffoldState>();

  bool _isLoading = true, _noInternet = false;

  // holds the response data from the server
  var dataResponse;

  // gets the metadata regarding all the topCharts
  void getTopChartsMetaData() async {
    setState(() {
      _isLoading = true;
      _noInternet = false;
    });
    try {
      var response = await http
          .get("https://api.openbeats.live/playlist/topcharts/metadata");
      dataResponse = json.decode(response.body);
      if (dataResponse["status"] == true) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        _noInternet = true;
      });
      print(err);
      globalFun.showToastMessage(
          "Not able to connect to server", Colors.red, Colors.white);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getTopChartsMetaData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .push(globalWids.FadeRouteBuilder(page: HomePage()));
        //we need to return a future
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          key: _topChartsPageScaffoldKey,
          appBar: topChartsPageW.appBarW(context, _topChartsPageScaffoldKey),
          backgroundColor: globalVars.primaryDark,
          drawer: globalFun.drawerW(2, context),
          body: topChartsPageBody(),
        ),
      ),
    );
  }

  Widget topChartsPageBody() {
    return Container(
      child: (_noInternet)
          ? globalWids.noInternetView(getTopChartsMetaData)
          : (_isLoading)
              ? topChartsPageW.loadingPageAnimation()
              : topChartsGrid(),
    );
  }

  Widget topChartsGrid() {
    return Container(
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) =>
            topChartsPageW.gridViewBuilder(context, index, dataResponse),
        itemCount: dataResponse["allcharts"].length,
      ),
    );
  }
}
