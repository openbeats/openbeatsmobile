import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;
import '../globalWids.dart' as globalWids;
import '../widgets/addSongsToPlaylistW.dart' as addSongsToPlaylistW;

class AddSongsToPlaylistPage extends StatefulWidget {
  var videosResponseItem;
  AddSongsToPlaylistPage(this.videosResponseItem);
  @override
  _AddSongsToPlaylistPageState createState() => _AddSongsToPlaylistPageState();
}

class _AddSongsToPlaylistPageState extends State<AddSongsToPlaylistPage> {
  bool _isLoading = true,
      _addingSongFlag = false,
      createPlaylistValidate = false,
      _noInternet = false;
  final GlobalKey<ScaffoldState> _addSongsToPlaylistPageScaffoldKey =
      new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _newPlaylistFormKey = GlobalKey<FormState>();
  // holds the response data from the playlist server
  var dataResponse;
  // holds the name of playList to be created
  String newPlaylistName;

  // shows the createPlaylist Box
  void showCreatePlayListBox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: globalVars.primaryDark,
            title: Text("Create Playlist"),
            content: Form(
              key: _newPlaylistFormKey,
              child: TextFormField(
                autofocus: true,
                onSaved: (String val) {
                  newPlaylistName = val;
                },
                decoration: InputDecoration(
                  hintText: "Playlist Name",
                ),
                autovalidate: createPlaylistValidate,
                validator: (String args) {
                  if (args.length == 0)
                    return "Please enter a name for your playlist";
                  else
                    return null;
                },
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  setState(() {
                    createPlaylistValidate = false;
                  });
                  Navigator.pop(context);
                },
                color: Colors.transparent,
                textColor: globalVars.accentRed,
              ),
              FlatButton(
                child: Text("Proceed"),
                onPressed: () {
                  validateCreatePlayListField();
                },
                color: Colors.transparent,
                textColor: globalVars.accentGreen,
              ),
            ],
          );
        });
  }

  // validates the createPlaylistField
  void validateCreatePlayListField() {
    if (_newPlaylistFormKey.currentState.validate()) {
      _newPlaylistFormKey.currentState.save();
      sendCreatePlaylistReq();
      Navigator.pop(context);
    } else {
      setState(() {
        createPlaylistValidate = true;
      });
    }
  }

  // sends createPlaylist request
  void sendCreatePlaylistReq() async {
    setState(() {
      _noInternet = false;
      _isLoading = true;
    });
    try {
      var response = await http.post(
          "https://api.openbeats.live/playlist/userplaylist/create",
          body: {
            "name": "$newPlaylistName",
            "userId": "${globalVars.loginInfo["userId"]}"
          });
      var responseJSON = json.decode(response.body);
      if (responseJSON["status"] == true) {
        getListofPlayLists();

        globalFun.showToastMessage(
            "Created playlist " + newPlaylistName, Colors.green, Colors.white);
      } else {
        globalFun.showToastMessage(
            "Apologies, response error", Colors.red, Colors.white);
      }
    } catch (err) {
      print(err);
      setState(() {
        _noInternet = true;
      });
      globalFun.showToastMessage(
          "No able to connect to server", Colors.red, Colors.white);
    }
  }

  // adds the song to the playlist
  void addSongToPlayList(playListId, playListName, videoResponseItem) async {
    setState(() {
      _noInternet = false;
    });
    List<dynamic> songsList = new List();
    songsList.add(videoResponseItem);
    setState(() {
      _addingSongFlag = true;
      globalFun.showSnackBars(1, _addSongsToPlaylistPageScaffoldKey, context);
    });
    try {
      var response = await http.post(
          "https://api.openbeats.live/playlist/userplaylist/addsongs",
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: jsonEncode({
            "playlistId": playListId,
            "songs": songsList,
          }));
      var responseJSON = json.decode(response.body);

      if (responseJSON["status"] == true) {
        Navigator.pop(context);
        globalFun.showToastMessage(
            "Added to " + playListName, Colors.green, Colors.white);
      } else if (responseJSON["status"] == false &&
          responseJSON["data"] == "Song already added") {
        globalFun.showSnackBars(9, _addSongsToPlaylistPageScaffoldKey, context);
      }
    } catch (err) {
      setState(() {
        _noInternet = true;
      });
      print(err);
      globalFun.showToastMessage(
          "Not able to connect to server", Colors.red, Colors.white);
    }
  }

  // gets the playlists of the user
  void getListofPlayLists() async {
    setState(() {
      _isLoading = true;
      _noInternet = false;
    });
    try {
      var response = await http.get(
          "https://api.openbeats.live/playlist/userplaylist/getallplaylistmetadata/" +
              globalVars.loginInfo["userId"]);
      dataResponse = json.decode(response.body);
      if (dataResponse["status"] == true) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        _noInternet = true;
      });
      print(err);
      globalFun.showToastMessage(
          "Not able to connect to server", Colors.red, Colors.white);
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _addSongsToPlaylistPageScaffoldKey,
        backgroundColor: globalVars.primaryDark,
        appBar: addSongsToPlaylistW.appBar(),
        body: addSongsToPlaylistPageBody(),
      ),
    );
  }

  Widget addSongsToPlaylistPageBody() {
    return (_noInternet)
        ? globalWids.noInternetView(getListofPlayLists)
        : Container(
            color: globalVars.primaryDark,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                createPlaylistsBtn(),
                SizedBox(
                  height: 40.0,
                ),
                Center(
                  child: Container(
                      child: (dataResponse != null &&
                              dataResponse["data"].length != 0)
                          ? Text(
                              "Your Playlists",
                              style: TextStyle(color: Colors.grey),
                            )
                          : null),
                ),
                SizedBox(
                  height: 10.0,
                ),
                playListsView()
              ],
            ),
          );
  }

  Widget playListsView() {
    return Center(
      child: Container(
        child: (_isLoading)
            ? SizedBox(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(globalVars.accentRed),
                ),
              )
            : (dataResponse != null && dataResponse["data"].length != 0)
                ? playListsListView()
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

  Widget playListsListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: dataResponse["data"].length,
      itemBuilder: playListsListViewBody,
    );
  }

  Widget playListsListViewBody(context, index) {
    int noOfSongs = dataResponse["data"][index]["totalSongs"];
    String subTitle = "";
    if (noOfSongs != 0) if (noOfSongs == 1)
      subTitle = noOfSongs.toString() + " song";
    else
      subTitle = noOfSongs.toString() + " songs";
    else
      subTitle = "No Songs in playlist";
    return Container(
      child: ListTile(
        enabled: !_addingSongFlag,
        subtitle: Text(subTitle),
        leading: Icon(
          FontAwesomeIcons.thList,
          color: globalVars.accentWhite,
        ),
        title: Text(
          dataResponse["data"][index]["name"],
          style: TextStyle(color: Colors.white),
        ),
        onTap: () {
          addSongToPlayList(dataResponse["data"][index]["_id"],
              dataResponse["data"][index]["name"], widget.videosResponseItem);
        },
      ),
    );
  }

  Widget createPlaylistsBtn() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: RaisedButton(
          onPressed: () {
            if (!_addingSongFlag) {
              showCreatePlayListBox();
            }
          },
          shape: StadiumBorder(),
          textColor: globalVars.accentRed,
          color: globalVars.accentWhite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.plus,
                size: 20.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "Create Playlist",
                style: TextStyle(fontSize: 20.0),
              )
            ],
          ),
          padding: EdgeInsets.all(20.0),
        ));
  }
}
