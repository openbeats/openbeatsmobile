import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// variables holding the color scheme for the application
// holds the background colors for the themes
Color primaryDark = Color(0xFF14161c);
Color primaryLight = Color(0xFFf1edf7);
// holds the accent colors for the application
Color accentRed = Color(0xFFDB5461);
Color accentBlue = Color(0xFF386FA4);
Color accentGreen = Color(0xFF20A39E);
Color accentWhite = Color(0xFFfbfafd);

// holds the color scheme for the drawer
Color leadingIconColor = Colors.white;
Color titleTextColor = Colors.white;
Color subtitleTextColor = Colors.white;

// holds the gradient information for the TopCharts page
List<Color> gradientListPrimary = [
  Color(0xFF434343), // English
  Color(0xFF00cdac), // Bangla
  Color(0xFF667eea), // Kannada
  Color(0xFFfa709a), // Punjabi
  Color(0xFF209cff), // Tamil
  Color(0xFF50cc7f), // Telugu
  Color(0xFF1e3c72), // Malayalam
  Color(0xFF243949), // Marathi
  Color(0xFF13547a), // Hindi
  Color(0xFF1e3c72),
  Color(0xFF243949),
  Color(0xFF243949),
];
List<Color> gradientListSec = [
  Color(0xFF000000), // English
  Color(0xFF8ddad5), // Bangla
  Color(0xFF764ba2), // Kannada
  Color(0xFFfee140), // Punjabi
  Color(0xFF68e0cf), // Tamil
  Color(0xFFf5d100), // Telugu
  Color(0xFF2a5298), // Malayalam
  Color(0xFF517fa4), // Marathi
  Color(0xFF80d0c7), // Hindi
  Color(0xFF2a5298),
  Color(0xFF517fa4),
  Color(0xFF517fa4),
];

// holds the login information of the user
Map<String, dynamic> loginInfo = {
  "loginStatus": false,
  "userEmail": "example@examplemail.com",
  "userName": "user_name",
  "userId": "user_id",
  "userAvatar": "user_avatar",
  "userToken": "user_token"
};

// NOT MAINTAINED BY ACTIONS
// holds the current searched text
String currSearchText = "";
List<String> searchHistory = new List();

// holds the method channel variable
const platformMethodChannel = const MethodChannel('com.yag.openbeatsmobile');

// holds the borderRadius for widget
double borderRadius = 10.0;

// holds the videoList obtained after searching for persistent data 
var videosResponseList = new List();

// holds data on which page is controlling the audio service
String audioServicePage = "";

// flag variable to notify if the update check has to be done
// used to prevent rechecking everytime the app is launched
bool chechForUpdate = true;

// holds a copy of the update parameters
Response updateResponse;