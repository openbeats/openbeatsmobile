import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../globalFun.dart' as globalFun;
import '../globalVars.dart' as globalVars;
import '../globalWids.dart' as globalWids;

// holds the appBar for the homePage
Widget appBarW(
    context, GlobalKey<ScaffoldState> _settingsPageScaffoldKey) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Text("App Settings"),
    
  );
}

Widget closeAudioService(){
  return Container(
    child: ListTile(
      leading: Icon(Icons.close, color: globalVars.accentRed,),
      title: Text("Close foreground audio service", style: TextStyle(color: globalVars.accentRed),),
      subtitle: Text("Close the black persistence notification in case of unresponsive server"),
      onTap: (){
        AudioService.stop();
      },
    ),
  );
}