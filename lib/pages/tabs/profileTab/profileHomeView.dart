import 'package:flutter/material.dart';

import '../../../widgets/tabW/profileTab/profileHomeViewW.dart'
    as profileHomeViewW;

class ProfileHomeView extends StatefulWidget {
  @override
  _ProfileHomeViewState createState() => _ProfileHomeViewState();
}

class _ProfileHomeViewState extends State<ProfileHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileHomeViewW.appBar(),
      body: Container(
        child: null,
      ),
    );
  }
}
