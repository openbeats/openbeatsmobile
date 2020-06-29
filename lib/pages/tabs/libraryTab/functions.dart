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
