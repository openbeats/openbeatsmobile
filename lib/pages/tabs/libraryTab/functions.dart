import 'package:obsmobile/imports.dart';

// used to navigate to playlistView page
void navigateToPlaylistView(BuildContext context,
    Map<String, String> playlistData, bool _isCollection) {
  // setting loading indicator
  Provider.of<PlaylistViewData>(context, listen: false).setIsLoading(true);
  // navigate to the playlist view page
  Navigator.of(context).pushNamed('/playlistView', arguments: {
    "isCollection": _isCollection,
    "arguments": playlistData,
  });
}

// used to start playlist playback
void initiatePlaylistPlayback(BuildContext context) {
  // holds the playlist songs in structure
  List<Map<String, dynamic>> _playlistParameters =
      new List<Map<String, dynamic>>();
  // getting the list of songs from model
  List<dynamic> _playlistSongs =
      Provider.of<PlaylistViewData>(context, listen: false)
          .getCurrPlaylistSongs();

  // looping through each song in the playlist
  for (int i = 0; i < _playlistSongs.length; i++) {
    _playlistParameters.add({
      "title": _playlistSongs[i]["title"],
      "thumbnail": _playlistSongs[i]["thumbnail"],
      "duration": _playlistSongs[i]["duration"],
      "durationInMilliSeconds":
          reformatTimeStampToMilliSeconds(_playlistSongs[i]["duration"]),
      "videoId": _playlistSongs[i]["videoId"],
      "channelName": _playlistSongs[i]["channelName"],
      "views": reformatViewstoHumanReadable(_playlistSongs[i]["views"]),
    });
  }
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String prettyprint = encoder.convert(_playlistParameters);
  debugPrint(prettyprint);
  // print(_playlistParameters);
}
