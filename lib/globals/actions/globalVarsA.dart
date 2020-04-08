import 'package:flutter/material.dart';
import '../globalVars.dart' as globalVars;

// homePage.dart
// used to set the videoList for persistency of search results
void setPersistentVideoList(var videosResponseList) {
  globalVars.videosResponseList = videosResponseList;
}
