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
  Color(0xFFff758c),
  Color(0xFF00cdac),
  Color(0xFFc79081),
  Color(0xFFfa709a),
  Color(0xFF209cff),
  Color(0xFF50cc7f),
  Color(0xFF1e3c72),
  Color(0xFF243949),
  Color(0xFF243949),
  Color(0xFF1e3c72),
  Color(0xFF243949),
  Color(0xFF243949),
];
List<Color> gradientListSec = [
  Color(0xFFff7eb3),
  Color(0xFF8ddad5),
  Color(0xFFdfa579),
  Color(0xFFfee140),
  Color(0xFF68e0cf),
  Color(0xFFf5d100),
  Color(0xFF2a5298),
  Color(0xFF517fa4),
  Color(0xFF517fa4),
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