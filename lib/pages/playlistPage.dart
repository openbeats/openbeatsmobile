import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../widgets/playlistPageW.dart' as playlistPageW;
import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;

class PlaylistPage extends StatefulWidget {
  String playlistName, playlistId;
  PlaylistPage(this.playlistName, this.playlistId);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final GlobalKey<ScaffoldState> _playlistsPageScaffoldKey =
      new GlobalKey<ScaffoldState>();

  // holds the flag to mark the page as loading or loaded
  bool _isLoading = true;
  // holds the response data from playlist songs request
  var dataResponse;

  // gets all the music in the playlist
  void getPlaylistContents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await http.get(
          "https://api.openbeats.live/playlist/userplaylist/getplaylist/" +
              widget.playlistId);
      dataResponse = json.decode(response.body);
      if (dataResponse["status"] == true) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      print(err);
      globalFun.showToastMessage(
          "Apologies, some error occurred", Colors.red, Colors.white);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: _playlistsPageScaffoldKey,
      child: Scaffold(
        appBar: playlistPageW.appBarW(
            context, _playlistsPageScaffoldKey, widget.playlistName),
        backgroundColor: globalVars.primaryDark,
        body: Container(
          child: (_isLoading) ? playlistPageW.playlistsLoading() : playlistPageBody(),
        ),
      ),
    );
  }

  Widget playlistPageBody(){
    return ListView.builder(
      itemCount: dataResponse["data"]["songs"].length,
      itemBuilder: (context, index) => playlistPageListView(context, index), 
    );
  }

  Widget playlistPageListView(context, index){
    return ListTile(
      
    );
  }
}
