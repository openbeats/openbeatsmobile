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
  Color(0xFFf12711),
  Color(0xFFAAFFA9),
  Color(0xFF8E2DE2),
  Color(0xFF00d2ff),
  Color(0xFF0575E6),
  Color(0xFFf953c6),
  Color(0xFFec008c),
  Color(0xFF757F9A),
];
List<Color> gradientListSec = [
  Color(0xFFf5af19),
  Color(0xFF11FFBD),
  Color(0xFF4A00E0),
  Color(0xFF00d2ff),
  Color(0xFF0575E6),
  Color(0xFFf953c6),
  Color(0xFFfc6767),
  Color(0xFFD7DDE8),
];

// holds the login information of the user
Map<String, dynamic> loginInfo = {
  "loginStatus": false,
  "userEmail": "example@examplemail.com",
  "userName": "user_name",
  "userId": "user_id",
  "userAvatar":"user_avatar",
  "userToken":"user_token"
};

// NOT MAINTAINED BY ACTIONS
// holds the current searched text
String currSearchText = "";
List<String> searchHistory = new List();

// holds the method channel variable
const platformMethodChannel = const MethodChannel('com.yag.openbeatsmobile');

