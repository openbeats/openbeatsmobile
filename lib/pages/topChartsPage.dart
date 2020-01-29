import 'package:flutter/material.dart';
import 'package:openbeatsmobile/pages/homePage.dart';
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
  
  bool _isLoading = true;

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

  Widget topChartsPageBody(){
    return Container(
      child: (_isLoading)?topChartsPageW.loadingPageAnimation():null,
    );
  }

}
