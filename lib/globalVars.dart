import 'package:audio_service/audio_service.dart';
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
  "userToken":"user_token"
};

// holds the queue of audio to play
List<MediaItem> audioQueue = <MediaItem>[];

// holds the current searched text
String currSearchText = "";
