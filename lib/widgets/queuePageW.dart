import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import '../globalVars.dart' as globalVars;

Widget appBarW() {
  return AppBar(
    title: Text("Playing Queue"),
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    elevation: 0,
  );
}

Widget nowPlayingAnimation(bool isPlaying) {
  return FlareActor(
    'assets/flareAssets/analysis_new.flr',
    animation: (isPlaying)
        ? 'ana'
            'lysis'
        : null,
    fit: BoxFit.scaleDown,
  );
}

Widget thumbNailView(artUri) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(globalVars.borderRadius),
    child: CachedNetworkImage(
      imageUrl: artUri,
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

Widget noSongsInQueue() {
  return Center(
    child: Text(
      "No songs in queue",
      style: TextStyle(color: Colors.grey, fontSize: 30.0),
    ),
  );
}

Widget queueListTile(context, queueList, index, deleteItemFromQueue, state) {
  return ListTile(
    leading: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.width * 0.15,
        decoration: BoxDecoration(boxShadow: [
          new BoxShadow(
            color: Colors.black,
            blurRadius: 2.0,
            offset: new Offset(1.0, 1.0),
          ),
        ], borderRadius: BorderRadius.circular(globalVars.borderRadius)),
        child: (AudioService.currentMediaItem != null &&
                AudioService.currentMediaItem.artUri == queueList[index].artUri)
            ? (state.basicState == BasicPlaybackState.playing)
                ? nowPlayingAnimation(true)
                : nowPlayingAnimation(false)
            : thumbNailView(queueList[index].artUri)),
    trailing: IconButton(
      icon: Icon(Icons.remove_circle),
      onPressed: () {
        deleteItemFromQueue(index);
      },
    ),
    title: Text(queueList[index].title),
  );
}
