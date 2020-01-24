import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './globalVars.dart' as globalVars;

// snackBar to show network error
SnackBar networkErrorSBar = new SnackBar(
  content: Text(
    "Not able to connect to the internet",
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.orange,
  duration: Duration(seconds: 2),
);

Widget noInternetView(refreshFunction) {
  return Container(
      margin: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Icon(FontAwesomeIcons.redo, size: 40.0, color: globalVars.accentRed,),
            onPressed: (){
              refreshFunction();
            },
            color: Colors.transparent,
            textColor: globalVars.accentBlue,
          ),
          SizedBox(
            height: 20.0,
          ),
          Text("Not able to connect to\nserver",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 22.0)),
        ],
      ),
      ));
}


// used to fade transition to search page
class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;
  FadeRouteBuilder({@required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
}
