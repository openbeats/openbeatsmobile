import 'package:flutter/material.dart';
import '../widgets/authPageW.dart' as authPageW;
import '../globalVars.dart' as globalVars;

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: authPageW.appBarW(),
        backgroundColor: globalVars.primaryDark,
        body: null,
      ),
    );
  }
}