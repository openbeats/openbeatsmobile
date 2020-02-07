import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../globalVars.dart' as globalVars;

// holds the appBar
Widget appBarW(_tabController,) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Image.asset(
      "assets/images/logo/logotext.png",
      height: 40.0,
    ),
    bottom: TabBar(
      controller: _tabController,
      indicatorColor: globalVars.accentWhite,
      tabs: [
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(FontAwesomeIcons.user,size: 20.0,),
              SizedBox(width: 10.0,),
              Text("Login")
            ],
          ),
        ),
        Tab(
         child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(FontAwesomeIcons.userPlus,size: 20.0,),
              SizedBox(width: 10.0,),
              Text("Sign Up")
            ],
          ),
        ),
      ],
    ),
  );
}

Widget loginImageView(context) {
  return Container(
    height: MediaQuery.of(context).size.height*0.43,
    alignment: Alignment.center,
    child: Image.asset("assets/images/supplementary/authpage1.png",height: MediaQuery.of(context).size.height*0.30),
  );
}

Widget welcomeText(){
  return Container(
    child: Text("Welcome\nto OpenBeats!",textAlign: TextAlign.center, style: TextStyle(
      color: Colors.white, fontSize: 30.0, 
    ),),
  );
}