import 'package:flutter/material.dart';

class TrendingTab extends StatefulWidget {
  @override
  _TrendingTabState createState() => _TrendingTabState();
}

class _TrendingTabState extends State<TrendingTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Trending Tab"),
        ),
      ),
    );
  }
}
