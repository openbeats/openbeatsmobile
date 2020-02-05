import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import '../globalVars.dart' as globalVars;
import '../widgets/queuePageW.dart' as queuePageW;
import '../globalFun.dart' as globalFun;

class QueuePage extends StatefulWidget {
  @override
  QueueListPageState createState() => QueueListPageState();
}

class QueueListPageState extends State<QueuePage> {
  bool _isLoading = true;
  List<MediaItem> queueList = [];

  // gets the list of songs in queue
  void getListOfSongs() {
    if (AudioService.queue != null) {
      setState(() {
        queueList = AudioService.queue;
      });
    }
  }

  // updates the queue list according to user arrangement
  void updateQueue(int oldIndex, int newIndex) {
    setState(() {
      // checks if the rearrangement is upqueue or downqueue
      if (newIndex < oldIndex) {
        queueList.insert(newIndex, queueList[oldIndex]);
        queueList.removeAt(oldIndex + 1);
      } else if (newIndex > oldIndex) {
        queueList.insert(newIndex, queueList[oldIndex]);
        queueList.removeAt(oldIndex);
      }
    });
    Map<String, dynamic> parameters = {
      "oldIndex": oldIndex,
      "newIndex": newIndex,
      "currentArtURI": AudioService.currentMediaItem.artUri
    };
    AudioService.customAction("updateQueueOrder", parameters);
  }

  // deletes the item from queue
  void deleteItemFromQueue(int index) {
    if (queueList[index].artUri != AudioService.currentMediaItem.artUri) {
      setState(() {
        queueList.removeAt(index);
        Map<String, dynamic> parameters = {
          "index": index,
          "currentArtURI": AudioService.currentMediaItem.artUri
        };
        AudioService.customAction("removeItemFromQueue", parameters);
      });
    } else {
      globalFun.showToastMessage(
          "Current playing media cannot be deleted from queue",
          Colors.orange,
          Colors.white);
    }
  }

  // connects to the audio service
  void connect() async {
    await AudioService.connect();
  }

  // disconnects from the audio service
  void disconnect() {
    AudioService.disconnect();
  }

  @override
  void initState() {
    super.initState();
    // connecting to audio service
    connect();
    // getting list of songs in queue
    getListOfSongs();
    // getting the list of songs in queue
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: queuePageW.appBarW(),
      backgroundColor: globalVars.primaryDark,
      body: queuePageBody(),
    ));
  }

  Widget queuePageBody() {
    return Container(
        child: StreamBuilder(
            stream: AudioService.queueStream,
            builder: (context, snapshot) {
              queueList = snapshot.data;
              return StreamBuilder(
                  stream: AudioService.playbackStateStream,
                  builder: (context, snapshot) {
                    PlaybackState state = snapshot.data;
                    return (queueList != null && state != null && state.basicState != null && state.basicState != BasicPlaybackState.none)
                        ? ReorderableListView(
                            header: Text(
                              "Press and hold song to change queue order",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14.0),
                            ),
                            children: List.generate(queueList.length,
                                (index) => queueListTile(index, state)),
                            onReorder: updateQueue)
                        : queuePageW.noSongsInQueue();
                  });
            }));
  }

  Widget queueListTile(int index, state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      key: ValueKey("value$index"),
      child: queuePageW.queueListTile(
          context, queueList, index, deleteItemFromQueue, state),
    );
  }
}
