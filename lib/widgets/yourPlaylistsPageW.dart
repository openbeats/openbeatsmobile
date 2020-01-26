import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../globalVars.dart' as globalVars;

// holds the appBar for the homePage
Widget appBarW(
    context, GlobalKey<ScaffoldState> _yourPlaylistsPageScaffoldKey) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Text("Your Playlists"),
    leading: IconButton(
      icon: Icon(FontAwesomeIcons.alignLeft),
      iconSize: 22.0,
      onPressed: () {
        _yourPlaylistsPageScaffoldKey.currentState.openDrawer();
      },
    ),
  );
}

// holds the loading animation for the page
Widget playlistsLoading() {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(globalVars.accentRed),
    ),
  );
}

// holds the button to help create the playlists
Widget createPlaylistsBtn(showCreateOrRenamePlayListBox) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    child: RaisedButton(
      onPressed: () {
        showCreateOrRenamePlayListBox(1, 0);
      },
      shape: StadiumBorder(),
      textColor: globalVars.accentRed,
      color: globalVars.accentWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(FontAwesomeIcons.plus, size: 20.0,),
          SizedBox(width: 10.0,),
          Text(
            "Create Playlist",
            style: TextStyle(fontSize: 20.0),
          )
        ],
      ),
      padding: EdgeInsets.all(20.0),
    ),
  );
}

// holds the no playlists message
Widget noPlaylistsMessage() {
  return Container(
    margin: EdgeInsets.all(20.0),
    child: Center(
        child: Text(
      "Oops!\nNo playlists found...\nWhy not create one?",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey, fontSize: 25.0),
    )),
  );
}
