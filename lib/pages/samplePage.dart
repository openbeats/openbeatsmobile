import 'package:flutter/material.dart';

class SamplePage extends StatefulWidget {
  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Center(
            child: Text("Sample Page"),
          ),
        ),
        onWillPop: () {
          Navigator.pop(context);
        });
  }
}
