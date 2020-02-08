import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openbeatsmobile/pages/topChartsPlaylistPage.dart';
import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;
import '../globalWids.dart' as globalWids;

// holds the appBar for the homePage
Widget appBarW(context, GlobalKey<ScaffoldState> _topChartsPageScaffoldKey) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Text("Top Charts"),
    leading: IconButton(
      icon: Icon(FontAwesomeIcons.alignLeft),
      iconSize: 22.0,
      onPressed: () {
        _topChartsPageScaffoldKey.currentState.openDrawer();
      },
    ),
  );
}

Widget loadingPageAnimation() {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(globalVars.accentRed),
    ),
  );
}

Widget gridViewBuilder(BuildContext context, int index, var dataResponse) {
  
  // setting proper names for all charts
  String chartLang = dataResponse["allcharts"][index]["language"];
  chartLang = "${chartLang[0].toUpperCase()}${chartLang.substring(1).toLowerCase()}";

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TopChartPlaylistPage(
                chartLang,
                dataResponse["allcharts"][index]["_id"],
                dataResponse["allcharts"][index]["thumbnail"])),
      );
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
          borderRadius:
              new BorderRadius.all(Radius.circular(globalVars.borderRadius)),
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                globalVars.gradientListPrimary[index],
                globalVars.gradientListSec[index]
              ])),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0.5,
            child: gridViewTitle(chartLang,
                dataResponse["allcharts"][index]["totalSongs"], context),
          ),
        ],
      ),
    ),
  );
}

Widget gridViewTitle(String chartName, int totalSongs, context) {
  return Container(
      child: RichText(
    text: TextSpan(
        text: "Top " + totalSongs.toString() + "\n",
        style: TextStyle(
          fontFamily: "Comfortaa-Bold",
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        children: <TextSpan>[
          TextSpan(
              text: chartName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Comfortaa-Bold",
                  fontSize: MediaQuery.of(context).size.width * 0.065)),
        ]),
  ));
}
