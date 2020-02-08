void addSongsToList(parameters, getMp3URL) {
  List<dynamic> songsList = parameters;
  for (int i = 0; i < songsList.length; i++) {
    if (i == 0)
      getMp3URL(songsList[i], true);
    else
      getMp3URL(songsList[i], false);
  }
}

