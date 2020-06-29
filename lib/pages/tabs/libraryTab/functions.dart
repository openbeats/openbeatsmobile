import 'package:obsmobile/imports.dart';

// used to navigate to playlistView page
void navigateToPlaylistView(
    BuildContext context, Map<String, String> playlistData) {
  // navigate to the playlist view page
  Navigator.of(context).pushNamed('/playlistView', arguments: playlistData);
}
