import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:openbeatsmobile/pages/addSongsToPlaylistPage.dart';
import '../globalVars.dart' as globalVars;
import '../widgets/addSongsToPlaylistW.dart' as addSongsToPlaylistW;

class AddSongsToPlaylistPage extends StatefulWidget {
  var videosResponseItem;
  AddSongsToPlaylistPage(this.videosResponseItem);
  @override
  _AddSongsToPlaylistPageState createState() => _AddSongsToPlaylistPageState();
}

class _AddSongsToPlaylistPageState extends State<AddSongsToPlaylistPage> {
  // holds the boolean to decide if the the playlists are loading
  bool _isLoading = true, _addingSongFlag = false;
  // holds the response data from the playlist server
  var dataResponse;

  // adds the song to the playlist
  void addSongToPlayList(playListId, videoResponseItem) {
    setState(() {
      _addingSongFlag = true;
    });
  }

  // gets the playlists of the user
  void getListofPlayLists() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await http.get(
          "https://api.openbeats.live/playlist/userplaylist/getallplaylistmetadata/" +
              globalVars.loginInfo["userId"]);
      dataResponse = json.decode(response.body);
      print(dataResponse.toString());
      if (dataResponse["status"] == true) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      print(err);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListofPlayLists();
    print(widget.videosResponseItem.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: globalVars.primaryDark,
        appBar: addSongsToPlaylistW.appBar(),
        body: addSongsToPlaylistPageBody(),
      ),
    );
  }

  Widget addSongsToPlaylistPageBody() {
    return Container(
      color: globalVars.primaryDark,
      padding: EdgeInsets.all(20.0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          addSongsToPlaylistW.createPlaylistsBtn(),
          SizedBox(
            height: 40.0,
          ),
          Center(
            child: Container(
                child:
                    (dataResponse != null && dataResponse["data"].length != 0)
                        ? Text(
                            "Your Playlists",
                            style: TextStyle(color: Colors.grey),
                          )
                        : null),
          ),
          SizedBox(
            height: 10.0,
          ),
          addSongsToPlaylistW.playListsView(_isLoading, dataResponse,
              widget.videosResponseItem, addSongToPlayList, _addingSongFlag)
        ],
      ),
    );
  }
}
