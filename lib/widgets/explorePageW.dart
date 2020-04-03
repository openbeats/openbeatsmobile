import 'package:flutter/material.dart';

// holds the title for RecentlyPlayed
Widget recentlyPlayedSectionTitle() {
  return Container(
    alignment: Alignment.centerLeft,
    child: Text(
      "Recently Played",
      style: TextStyle(
        fontFamily: "Poppins-SemiBold",
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
