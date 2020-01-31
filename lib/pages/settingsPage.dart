import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import '../widgets/settingsPageW.dart' as settingsPageW;
import '../globalFun.dart' as globalFun;
import '../globalVars.dart' as globalVars;
import '../globalWids.dart' as globalWids;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _settingsPageScaffoldKey =
      new GlobalKey<ScaffoldState>();

  void connect() async {
    await AudioService.connect();
  }

  void disconnect() {
    AudioService.disconnect();
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _settingsPageScaffoldKey,
          appBar: settingsPageW.appBarW(context, _settingsPageScaffoldKey),
          drawer: globalFun.drawerW(9, context),
          backgroundColor: globalVars.primaryDark,
          body: settingsPageBody(),
        ),
    );
  }

  Widget settingsPageBody() {
    return Container(
      child: ListView(
        children: <Widget>[settingsPageW.closeAudioService()],
      ),
    );
  }
}
