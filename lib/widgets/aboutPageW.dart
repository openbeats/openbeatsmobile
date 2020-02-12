import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openbeatsmobile/pages/bugReportPage.dart';
import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;
import '../globalWids.dart' as globalWids;

// holds the appBar
Widget appBarW(context, GlobalKey<ScaffoldState> _aboutPageScaffoldKey) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Text("About"),
    leading: IconButton(
      icon: Icon(FontAwesomeIcons.alignLeft),
      iconSize: 22.0,
      onPressed: () {
        _aboutPageScaffoldKey.currentState.openDrawer();
      },
    ),
  );
}

Widget aboutAppCard(context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.45,
    child: Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          appNameListTile(),
          SizedBox(
            height: 10.0,
          ),
          versionListTile(),
          appDescListTile()
        ],
      ),
    ),
  );
}

Widget appNameListTile() {
  return ListTile(
    leading: Image.asset(
      "assets/images/logo/logoicon.png",
    ),
    title: Text(
      "OpenBeats",
      style: TextStyle(fontFamily: "Helvetica-Normal", fontSize: 30.0),
    ),
    subtitle: Text("Free music, Forever"),
    dense: true,
  );
}

Widget versionListTile() {
  return Container(
    margin: EdgeInsets.only(left: 12.0),
    child: ListTile(
      leading: Icon(Icons.info_outline),
      title: Text(
        "Version",
        style: TextStyle(fontFamily: "Helvetica-Normal", fontSize: 20.0),
      ),
      subtitle: Text("2.0.0+1"),
    ),
  );
}

Widget appDescListTile() {
  return Container(
    margin: EdgeInsets.only(left: 12.0),
    child: ListTile(
      leading: Icon(
        FontAwesomeIcons.question,
        size: 20.0,
      ),
      title: Text(
        "Description",
        style: TextStyle(fontFamily: "Helvetica-Normal", fontSize: 20.0),
      ),
      subtitle: Text(
        "A free, opensource, crowd funded music streaming service with the largest library of music from all over the world.\nThis app is an attempt at ending the tyranny held by the streaming applications of today with their incessant adverts and limited libraries",
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 14.0),
      ),
      dense: true,
    ),
  );
}

Widget helpCard(context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.4,
    padding: EdgeInsets.all(10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        youCanHelpUsText(),
        SizedBox(
          height: 10.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            bugReportBtn(context),
            suggestFeaturesBtn(context),
            msgDevsBtn(context)
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    ),
  );
}

Widget youCanHelpUsText() {
  return Container(
    padding: EdgeInsets.all(10.0),
    margin: EdgeInsets.symmetric(horizontal: 20.0),
    child: Text(
      "You can help us too!",
      style: TextStyle(fontSize: 25.0),
    ),
  );
}

Widget bugReportBtn(context) {
  return OutlineButton(
    padding: EdgeInsets.all(15.0),
    borderSide: BorderSide(color: globalVars.accentWhite, width: 2.0),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(globalVars.borderRadius)),
    onPressed: () {
      if (globalVars.loginInfo["loginStatus"]) {
        Navigator.pushNamed(context, '/bugReportingPage');
      } else {
        globalFun.showToastMessage(
            "Please login to use feature", Colors.black, Colors.white);
        Navigator.pushNamed(context, '/authPage');
      }
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.bug_report),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "Report\nBugs",
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}

Widget suggestFeaturesBtn(context) {
  return OutlineButton(
    padding: EdgeInsets.all(15.0),
    borderSide: BorderSide(color: globalVars.accentWhite, width: 2.0),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(globalVars.borderRadius)),
    onPressed: () {
      if (globalVars.loginInfo["loginStatus"]) {
        Navigator.pushNamed(context, '/suggestionsPage');
      } else {
        globalFun.showToastMessage(
            "Please login to use feature", Colors.black, Colors.white);
        Navigator.pushNamed(context, '/authPage');
      }
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.stars),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "Suggest\nFeatures",
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}

Widget msgDevsBtn(context) {
  return OutlineButton(
    padding: EdgeInsets.all(15.0),
    borderSide: BorderSide(color: globalVars.accentWhite, width: 2.0),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(globalVars.borderRadius)),
    onPressed: () {
      if (globalVars.loginInfo["loginStatus"]) {
        Navigator.pushNamed(context, '/msgDevsPage');
      } else {
        globalFun.showToastMessage(
            "Please login to use feature", Colors.black, Colors.white);
        Navigator.pushNamed(context, '/authPage');
      }
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.message),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "Message\nDevs",
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}
