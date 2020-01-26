import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openbeatsmobile/pages/AddSongsToPlaylistPage.dart';

import '../globalFun.dart' as globalFun;
import '../globalVars.dart' as globalVars;
import '../globalWids.dart' as globalWids;

// holds the appBar for the homePage
Widget appBarW(context, navigateToSearchPage,
    GlobalKey<ScaffoldState> _homePageScaffoldKey) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Image.asset(
      "assets/images/logo/logotext.png",
      height: 40.0,
    ),
    leading: IconButton(
      icon: Icon(FontAwesomeIcons.alignLeft),
      iconSize: 22.0,
      onPressed: () {
        _homePageScaffoldKey.currentState.openDrawer();
      },
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(
          FontAwesomeIcons.search,
          size: 22.0,
        ),
        onPressed: () {
          navigateToSearchPage();
        },
        color: globalVars.primaryLight,
      ),
    ],
  );
}

Widget homePageView() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[hiText(), welcomeText()],
  );
}

Widget hiText() {
  return Text("Hi!", style: TextStyle(fontSize: 70.0, color: Colors.grey));
}

Widget welcomeText() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15.0),
    child: Text(
      "Try searching for any \nsong, podcast or audiobook you like",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey, fontSize: 20.0),
    ),
  );
}

// widget to hold each container of video results
Widget vidResultContainerW(
    context, videosResponseItem, index, getMp3URL, settingModalBottomSheet) {
  return InkWell(
      onTap: () async {
        if (AudioService.playbackState != null &&
            AudioService.currentMediaItem != null &&
            AudioService.currentMediaItem.artUri ==
                videosResponseItem["thumbnail"] &&
            (AudioService.playbackState.basicState ==
                    BasicPlaybackState.playing ||
                AudioService.playbackState.basicState ==
                    BasicPlaybackState.buffering ||
                AudioService.playbackState.basicState ==
                    BasicPlaybackState.paused)) {
          settingModalBottomSheet(context);
        } else {
          await getMp3URL(videosResponseItem["videoId"], index);
        }
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        icon: Icon(
          Icons.more_vert,
          size: 30.0,
        ),
        onSelected: (choice) {
          if (globalVars.loginInfo["loginStatus"] == true) {
            if (choice == "addToPlayList") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddSongsToPlaylistPage(videosResponseItem),
                  ));
            }
          } else {
            globalFun.showToastMessage(
                "Please login to use feature", Colors.black, Colors.white);
            Navigator.pushNamed(context, '/authPage');
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: "download",
                  child: ListTile(
                    title: Text("Download"),
                    leading: Icon(Icons.file_download),
                  )),
              PopupMenuItem(
                  value: "addToPlayList",
                  child: ListTile(
                    title: Text("Add to Playlist"),
                    leading: Icon(Icons.playlist_add),
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

// holds the buffering indicator
Widget bufferingIndicator() {
  return SizedBox(
    height: 20.0,
    child: Container(
      child: (AudioService.playbackState != null)
          ? (AudioService.playbackState.basicState ==
                  BasicPlaybackState.buffering)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                      width: 10.0,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(globalVars.accentRed),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "Buffering...",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                )
              : null
          : null,
    ),
  );
}

// button to hold the stopButton
Widget bNavStopBtn(context, state) {
  return Container(
      child: (state != null)
          ? IconButton(
              onPressed: () {
                AudioService.stop();
                Navigator.pop(context);
              },
              icon: Icon(FontAwesomeIcons.stop),
            )
          : null);
}

