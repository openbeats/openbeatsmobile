import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:openbeatsmobile/pages/bugReportPage.dart';
import 'package:openbeatsmobile/pages/msgDevsPage.dart';
import 'package:openbeatsmobile/pages/suggestionsPage.dart';
import './pages/authPage.dart';
import './pages/homePage.dart';
import './pages/settingsPage.dart';
import './pages/yourPlaylistsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/aboutPage.dart';
import 'package:package_info/package_info.dart';
import './actions/globalVarsA.dart' as globalVarsA;
import './globalFun.dart' as globalFun;
import './globalVars.dart' as globalVars;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // recovers login information from sharedPreferences
  void getLoginInfo() async {
    // creating sharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loginStatus = prefs.getBool("loginStatus");
    if (loginStatus != null && loginStatus == true) {
      String userEmail = prefs.getString("userEmail");
      String userName = prefs.getString("userName");
      String userId = prefs.getString("userId");
      String userAvatar = prefs.getString("userAvatar");
      String userToken = prefs.getString("userToken");
      Map<String, dynamic> loginParameters = {
        "loginStatus": true,
        "userEmail": userEmail,
        "userName": userName,
        "userId": userId,
        "userAvatar": userAvatar,
        "userToken": userToken,
      };
      globalVarsA.modifyLoginInfo(loginParameters, false);
    } else {
      prefs.setBool("loginStatus", false);
    }
  }

  void verifyAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    try {
      Response response =
          await Dio().get("http://yagupdtserver.000webhostapp.com/api/");
      print(response.data["versionName"]);
      if (response.data["versionName"] != versionName ||
          response.data["versionCode"] != versionCode) {}
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getLoginInfo();
    globalFun.getSearchHistory();
    //verifyAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OpenBeats",
      color: Colors.red,
      home: HomePage(),
      theme: ThemeData(
        fontFamily: "lineto-circular-pro-medium",
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
      ),
      routes: {
        '/homePage': (context) => HomePage(),
        '/authPage': (context) => AuthPage(),
        '/yourPlaylistsPage': (context) => YourPlaylistsPage(),
        '/settingsPage': (context) => SettingsPage(),
        '/aboutPage': (context) => AboutPage(),
        '/bugReportingPage': (context) => BugReportPage(),
        '/suggestionsPage': (context) => SuggestionsPage(),
        '/msgDevsPage' : (context) => MsgDevsPage(),
      },
    );
  }
}
