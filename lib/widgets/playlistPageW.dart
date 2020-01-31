import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;
import '../globalWids.dart' as globalWids;

// holds the appBar for the plaistPage
Widget appBarW(context, GlobalKey<ScaffoldState> _playlistsPageScaffoldKey,
    String playlistName, String playlistThumbnail) {
  return SliverAppBar(
    expandedHeight: 200.0,
    floating: true,
    backgroundColor: globalVars.primaryDark,
    pinned: true,
    elevation: 0,
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: true,
      title: Text(playlistName),
      background: Opacity(
        opacity: 0.5,
        child: CachedNetworkImage(
          imageUrl: playlistThumbnail,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: globalVars.primaryDark,
            child: Center(
              child: Text("Loading Thumbnail..."),
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
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

Widget fabView(settingModalBottomSheet, scaffoldKey) {
  return StreamBuilder(
      stream: AudioService.playbackStateStream,
      builder: (context, snapshot) {
        PlaybackState state = snapshot.data;
        if (state != null && state.basicState == BasicPlaybackState.error) {
          // stopping audio playback if an error has been detected
          AudioService.stop();
        }

        return (state != null &&
                (state.basicState == BasicPlaybackState.connecting ||
                    state.basicState == BasicPlaybackState.playing ||
                    state.basicState == BasicPlaybackState.buffering ||
                    state.basicState == BasicPlaybackState.skippingToNext ||
                    state.basicState == BasicPlaybackState.skippingToPrevious ||
                    state.basicState == BasicPlaybackState.paused))
            ? (state.basicState == BasicPlaybackState.buffering ||
                    state.basicState == BasicPlaybackState.connecting ||
                    state.basicState == BasicPlaybackState.skippingToNext ||
                    state.basicState == BasicPlaybackState.skippingToPrevious)
                ? fabBtnW(
                    settingModalBottomSheet, context, false, false, scaffoldKey)
                : (state.basicState == BasicPlaybackState.paused)
                    ? fabBtnW(settingModalBottomSheet, context, true, true,
                        scaffoldKey)
                    : fabBtnW(settingModalBottomSheet, context, true, false,
                        scaffoldKey)
            : Container();
      });
}

// holds the floating action button
Widget fabBtnW(settingModalBottomSheet, context, bool isPlaying, bool isPaused,
    scaffoldKey) {
  return FloatingActionButton(
    onPressed: () {
      settingModalBottomSheet(context);
    },
    child: (isPlaying)
        ? FlareActor(
            'assets/flareAssets/analysis_new.flr',
            animation: (isPaused)
                ? null
                : 'ana'
                    'lysis'
                    '',
            fit: BoxFit.scaleDown,
          )
        : CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ),
    backgroundColor: Color(0xFFFF5C5C),
    foregroundColor: Colors.white,
  );
}

// holds the no playlists message
Widget noSongsMessage() {
  return Container(
    margin: EdgeInsets.all(20.0),
    child: Center(
        child: Text(
      "Hmm!\nNo songs found...\nWhy not try adding some?",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey, fontSize: 25.0),
    )),
  );
}
