import 'package:audio_service/audio_service.dart';
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

  void getListOfSongs(){
    if(AudioService.queue != null){
      setState(() {
        queueList = AudioService.queue;
        print(queueList);
      });
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
      child: ReorderableListView(children: List.generate(queueList.length, queueListTile), onReorder: null),
    );
  }

  Widget queueListTile(int index){
    return Container(
      child: null,
    );
  }
}
