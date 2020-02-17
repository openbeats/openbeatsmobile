void addSongsToList(parameters, getMp3URL) {
  List<dynamic> songsList = parameters;
  for (int i = 0; i < songsList.length; i++) {
    if (i == 0)
      getMp3URL(songsList[i], true);
    else
      getMp3URL(songsList[i], false);
  }
}

Future<void> addSongListToQueue(parameters, getMp3URL, List _queue) async{
  List<dynamic> songsList = parameters;
  bool addSong;
  for (int i = 0; i < songsList.length; i++) {
    addSong = true;
    for (int j = 0; j < _queue.length; j++) {
      if (_queue[j].artUri == songsList[i]["thumbnail"]) {
        addSong = false;
        break;
      }
    }
    if (addSong) {
      if (i == 0 && _queue.length == 0)
        getMp3URL(songsList[i], true);
      else
        getMp3URL(songsList[i], false);
    }
  }
}


