import 'package:flutter/material.dart';
import '../../../globals/globalColors.dart' as globalColors;

class ExploreTab extends StatefulWidget {
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: globalColors.backgroundClr,
        child: Center(
          child: Text("Explore Tab"),
        ),
      ),
    );
  }
}
