import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;
import '../globalWids.dart' as globalWids;

// holds the appBar for the plaistPage
Widget appBarW(context, GlobalKey<ScaffoldState> _playlistsPageScaffoldKey,
    String playlistName) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Text(playlistName),
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

// widget to hold each container of video results
Widget vidResultContainerW(
    context, videosResponseItem, index, startPlaylistFromMusic) {
  return InkWell(
      onTap: () async {
        startPlaylistFromMusic(index);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            vidResultThumbnail(context, videosResponseItem["thumbnail"]),
            SizedBox(
              width: 15.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  vidResultVidDetails(context, videosResponseItem["title"],
                      videosResponseItem["duration"]),
                  vidResultExtraOptions(context, videosResponseItem)
                ],
              ),
            ),
          ],
        ),
      ));
}

// holds the thumbnail of results list
Widget vidResultThumbnail(context, thumbnail) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.width * 0.15,
      decoration: BoxDecoration(boxShadow: [
        new BoxShadow(
          color: Colors.black,
          blurRadius: 2.0,
          offset: new Offset(1.0, 1.0),
        ),
      ], borderRadius: BorderRadius.circular(5.0)),
      child: StreamBuilder(
          stream: AudioService.playbackStateStream,
          builder: (context, snapshot) {
            PlaybackState state = snapshot.data;
            return ((state != null) &&
                    AudioService.currentMediaItem != null &&
                    AudioService.currentMediaItem.artUri == thumbnail &&
                    (state.basicState == BasicPlaybackState.connecting ||
                        state.basicState == BasicPlaybackState.playing ||
                        state.basicState == BasicPlaybackState.buffering ||
                        state.basicState == BasicPlaybackState.paused))
                ? (state.basicState == BasicPlaybackState.buffering ||
                        state.basicState == BasicPlaybackState.connecting)
                    ? globalWids.nowPlayingLoadingAnimation()
                    : (state.basicState == BasicPlaybackState.paused)
                        ? globalWids.nowPlayingFlutterActor(true)
                        : globalWids.nowPlayingFlutterActor(false)
                : globalWids.showActualThumbnail(thumbnail);
          }));
}
// holds the video details of video list
Widget vidResultVidDetails(context, title, duration) {
  return Column(
    children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width * 0.60,
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 16.0),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      Text(
        duration,
        style: TextStyle(color: Colors.grey, fontSize: 12.0),
      )
    ],
    crossAxisAlignment: CrossAxisAlignment.start,
  );
}

// holds the extra options of video result list
Widget vidResultExtraOptions(context, videosResponseItem) {
  return Container(
    alignment: Alignment.centerRight,
    width: MediaQuery.of(context).size.width * 0.1,
    child: PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 30.0,
        icon: Icon(
          Icons.more_vert,
          size: 30.0,
        ),
        onSelected: (choice) {
          if (globalVars.loginInfo["loginStatus"] == true) {
            if (choice == "addToPlayList") {}
          } else {
            globalFun.showToastMessage(
                "Please login to use feature", Colors.black, Colors.white);
            Navigator.pushNamed(context, '/authPage');
          }
        },
        itemBuilder: (context) => [
            PopupMenuItem(
                  value: "delete",
                  child: ListTile(
                    title: Text("Delete"),
                    leading: Icon(Icons.delete),
                  )),
              PopupMenuItem(
                  value: "favorite",
                  child: ListTile(
                    title: Text("Favorite"),
                    leading: Icon(Icons.favorite_border),
                  ))
            ]),
  );
}
