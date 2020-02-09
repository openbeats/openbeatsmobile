import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../globalVars.dart' as globalVars;

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
    height: MediaQuery.of(context).size.height*0.45,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(globalVars.borderRadius),
      // gradient: LinearGradient(
      //   begin: Alignment.bottomRight,
      //   end: Alignment.topLeft,
      //   colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
      // ),
    ),
    child: Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            leading: Image.asset("assets/images/logo/logoicon.png",),
            title: Text(
              "OpenBeats",
              style: TextStyle(fontFamily: "Helvetica-Normal", fontSize: 30.0),
            ),
            subtitle: Text("openbeatsmobile"),
            dense: true,
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            margin: EdgeInsets.only(left: 12.0),
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(
                "Version",
                style:
                    TextStyle(fontFamily: "Helvetica-Normal", fontSize: 20.0),
              ),
              subtitle: Text("1.19"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 12.0),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.question,
                size: 20.0,
              ),
              title: Text(
                "Description",
                style:
                    TextStyle(fontFamily: "Helvetica-Normal", fontSize: 20.0),
              ),
              subtitle: Text(
                "A free, opensource, crowd funded music streaming service with the largest library of music from all over the world.\nThis app is an attempt at ending the tyranny held by the streaming applications of today with their incessant adverts and limited libraries",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14.0),
              ),
              dense: true,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget helpCard(context) {
  return Container(
    height: MediaQuery.of(context).size.height*0.4,
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(globalVars.borderRadius),
      // gradient: LinearGradient(
      //   begin: Alignment.bottomRight,
      //   end: Alignment.topLeft,
      //   colors: [
      //     Color(0xFF8E2DE2),
      //     Color(0xFF4A00E0),
      //   ],
      // ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "You can help us too!",
            style: TextStyle(fontSize: 25.0),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            OutlineButton(
              padding: EdgeInsets.all(15.0),
              borderSide: BorderSide(color: globalVars.accentWhite, width: 2.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(globalVars.borderRadius)),
              onPressed: () {},
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
            ),
            OutlineButton(
              padding: EdgeInsets.all(15.0),
              borderSide: BorderSide(color: globalVars.accentWhite, width: 2.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(globalVars.borderRadius)),
              onPressed: () {},
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
            ),
            OutlineButton(
              padding: EdgeInsets.all(15.0),
              borderSide: BorderSide(color: globalVars.accentWhite, width: 2.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(globalVars.borderRadius)),
              onPressed: () {},
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
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    ),
  );
}
