import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import '../globalVars.dart' as globalVars;
import '../widgets/queuePageW.dart' as queuePageW;

class QueuePage extends StatefulWidget {
  @override
  _QueuePageState createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
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
      // storing the exsisting on
      MediaItem oldOne = queueList[oldIndex];
      queueList.insert(newIndex, queueList[oldIndex]);
      queueList.removeAt(oldIndex+1);
    });
    Map<String, int> parameters = {
      "oldIndex":oldIndex,
      "newIndex":newIndex
    };
     AudioService.customAction("updateQueueOrder", parameters);
  }

  // deletes the item from queue
  void deleteItemFromQueue(int index) {
    setState(() {
      queueList.removeAt(index);
      Map<String, int> parameters = {"index": index};
      AudioService.customAction("removeItemFromQueue", parameters);
    });
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
      child: (AudioService.queue != null && AudioService.playbackState != null)
          ? StreamBuilder(
              stream: AudioService.queueStream,
              builder: (context, snapshot) {
                queueList = snapshot.data;
                return StreamBuilder(
                    stream: AudioService.playbackStateStream,
                    builder: (context, snapshot) {
                      PlaybackState state = snapshot.data;
                      return (queueList != null)
                          ? ReorderableListView(
                              children: List.generate(queueList.length,
                                  (index) => queueListTile(index, state)),
                              onReorder: updateQueue)
                          : Container(width: 0.0, height: 0.0);
                    });
              })
          : queuePageW.noSongsInQueue(),
    );
  }

  Widget queueListTile(int index, state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      key: ValueKey("value$index"),
      child: queuePageW.queueListTile(
          context, queueList, index, deleteItemFromQueue),
    );
  }
}
