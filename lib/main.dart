import 'package:flutter/material.dart';
import './pages/authPage.dart';
import './pages/homePage.dart';
import './pages/settingsPage.dart';
import './pages/yourPlaylistsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/aboutPage.dart';
import './actions/globalVarsA.dart' as globalVarsA;
import './globalFun.dart' as globalFun;

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

  @override
  void initState() {
    super.initState();
    getLoginInfo();
    globalFun.getSearchHistory();
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
        '/aboutPage': (context) => AboutPage()
      },
    );
  }
}
