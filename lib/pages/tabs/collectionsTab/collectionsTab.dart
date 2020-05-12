import 'package:flutter/material.dart';

class CollectionsTab extends StatefulWidget {
  @override
  _CollectionsTabState createState() => _CollectionsTabState();
}

class _CollectionsTabState extends State<CollectionsTab> {
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
