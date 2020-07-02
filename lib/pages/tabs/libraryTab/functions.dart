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
void initiatePlaylistPlayback(BuildContext context, int index) {
  // holds the playlist songs in structure
  List<Map<String, dynamic>> _playlistParameters =
      new List<Map<String, dynamic>>();
  // getting the list of songs from model
  List<dynamic> _playlistSongs =
      Provider.of<PlaylistViewData>(context, listen: false)
          .getCurrPlaylistSongs();

  // looping through each song in the playlist
  for (int i = 0; i < _playlistSongs.length; i++) {
    _playlistParameters.add(_playlistSongs[index]);

    // incrementing the current index of song in playlist list
    index += 1;

    // reiterating if it croses the end of list
    if (index == _playlistSongs.length) index = 0;
  }
  AudioServiceOps().startPlaylistPlayback({
    "token": Provider.of<UserModel>(context, listen: false)
        .getUserDetails()["token"],
    "_songObj": _playlistParameters
  });
}
