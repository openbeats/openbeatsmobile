import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './globalVars.dart' as globalVars;
import './globalFun.dart' as globalFun;

// snackBar to show network error
SnackBar networkErrorSBar = new SnackBar(
  content: Text(
    "Not able to connect to the internet",
    style: TextStyle(color: globalVars.accentGrey),
  ),
  backgroundColor: globalVars.accentOrange,
  duration: Duration(hours: 10),
);

Widget noInternetView(refreshFunction) {
  return Container(
      margin: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Icon(
                FontAwesomeIcons.redo,
                size: 40.0,
                color: globalVars.accentRed,
              ),
              onPressed: () {
                refreshFunction();
              },
              color: Colors.transparent,
              textColor: globalVars.accentBlue,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text("Not able to connect to\nserver",
                textAlign: TextAlign.center,
                style: TextStyle(color: globalVars.accentGrey, fontSize: 22.0)),
          ],
        ),
      ));
}

// used to fade transition to search page
class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;
  FadeRouteBuilder({@required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
}

// holds the flutterActor for showing the current playing media
Widget nowPlayingFlutterActor(bool isPlaying) {
  return FlareActor(
    'assets/flareAssets/analysis_new.flr',
    animation: isPlaying
        ? null
        : 'ana'
            'lysis'
            '',
    fit: BoxFit.scaleDown,
  );
}

// holds the loadingAnimation for the current playing media file
Widget nowPlayingLoadingAnimation() {
  return Container(
      margin: EdgeInsets.all(20.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(globalVars.accentWhite),
      ));
}

// shows the actual thumbnail of the media
Widget showActualThumbnail(String thumbnail) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(5.0),
    child: CachedNetworkImage(
      imageUrl: thumbnail,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        margin: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(globalVars.accentRed),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    ),
  );
}