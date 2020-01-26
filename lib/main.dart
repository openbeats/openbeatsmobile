import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openbeatsmobile/pages/mainAppPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './actions/globalVarsA.dart' as globalVarsA;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // getting user authentication status information
  void getLoginInfo() async {
    // sharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loginStatus = prefs.getBool("loginStatus");
    if (loginStatus != null && loginStatus) {
      Map<String, dynamic> authParameters = {
        "loginStatus": true,
        "userEmail": prefs.getString("userEmail"),
        "userName": prefs.getString("userName"),
        "userId": prefs.getString("userId"),
        "userAvatar": prefs.getString("userAvatar"),
        "userToken": prefs.getString("userToken"),
      };

      globalVarsA.modifyLoginInfo(authParameters, false);
    } else {
      prefs.setBool("loginStatus", false);
    }
  }

  @override
  void initState() {
    super.initState();
    // getting user authentication status information
    getLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OpenBeats",
      debugShowCheckedModeBanner: false,
      home: MainAppPage(),
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "opensans",
        primarySwatch: Colors.red,
      ),
      routes: {},
    );
  }
}
