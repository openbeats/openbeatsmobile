import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../globalVars.dart' as globalVars;

Widget appBar() {
  return AppBar(
    title: Text("Add to Playlist"),
    centerTitle: true,
    elevation: 0,
    backgroundColor: globalVars.primaryDark,
  );
}

Widget playListImageView() {
  return SizedBox(
    height: 70.0,
    width: 70.0,
    child: Icon(FontAwesomeIcons.list),
  );
}

Widget playListsView(_isLoading, dataResponse, videosResponseItem,
    addSongToPlayList, _addingSongFlag) {
  return Center(
    child: Container(
      child: (_isLoading)
          ? SizedBox(
              height: 30.0,
              width: 30.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(globalVars.accentRed),
              ),
            )
          : (dataResponse != null && dataResponse["data"].length != 0)
              ? playListsListView(dataResponse, videosResponseItem,
                  addSongToPlayList, _addingSongFlag)
              : Container(
                  margin: EdgeInsets.only(top: 50.0),
                  child: Text(
                    "You seem to have no playlists,\nwhy not try creating one?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 20.0),
                  ),
                ),
    ),
  );
}

Widget playListsListView(
    dataResponse, videosResponseItem, addSongToPlayList, _addingSongFlag) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: dataResponse["data"].length,
    itemBuilder: (context, index) => playListsListViewBody(context, index,
        dataResponse, videosResponseItem, addSongToPlayList, _addingSongFlag),
  );
}

Widget playListsListViewBody(context, index, dataResponse, videosResponseItem,
    addSongToPlayList, _addingSongFlag) {
  return Container(
    child: ListTile(
      enabled: _addingSongFlag,
      leading: Icon(
        FontAwesomeIcons.thList,
        color: globalVars.accentWhite,
      ),
      title: Text(dataResponse["data"][index]["name"], style: TextStyle(color: Colors.white),),
      onTap: () {
        print("hi");
        addSongToPlayList(
            dataResponse["data"][index]["playlistId"], videosResponseItem);
      },
    ),
  );
}

Widget createPlaylistsBtn() {
  return RaisedButton(
    onPressed: () {},
    shape: StadiumBorder(),
    textColor: globalVars.accentRed,
    color: globalVars.accentWhite,
    child: Text(
      "Create Playlist",
      style: TextStyle(fontSize: 18.0),
    ),
    padding: EdgeInsets.all(20.0),
  );
}
