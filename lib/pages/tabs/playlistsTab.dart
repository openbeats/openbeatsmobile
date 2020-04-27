import 'package:flutter/material.dart';

class PlaylistsTab extends StatefulWidget {
  @override
  _PlaylistsTabState createState() => _PlaylistsTabState();
}

class _PlaylistsTabState extends State<PlaylistsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Playlists Tab"),
        ),
      ),
    );
  }
}
