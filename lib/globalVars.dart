import 'package:flutter/material.dart';

// variables holding the color scheme for the application
// holds the background colors for the themes
Color primaryDark = Color(0xFF14161c);
Color primaryLight = Color(0xFFf1edf7);
// holds the accent colors for the application
Color accentRed = Color(0xFFDB5461);
Color accentBlue = Color(0xFF386FA4);
Color accentGreen = Color(0xFF20A39E);
Color accentWhite = Color(0xFFfbfafd);
Color accentGrey = Colors.grey;
Color accentOrange = Colors.orange;

// holds the color scheme for the drawer
Color leadingIconColor = Colors.white;
Color titleTextColor = Colors.white;
Color subtitleTextColor = Colors.white;

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