import 'package:obsmobile/imports.dart';

class LibraryTabData extends ChangeNotifier {
  // holds the users collection data as JSON
  var _userCollections = {};
  // holds the user playlists
  var _userPlaylists = {};
  // holds the loading flag for the library page content
  bool _userCollectionLoading = false;
  bool _userPlaylistLoading = false;

  // getter and setter for user collections
  dynamic getUserCollections() => _userCollections;
  void setUserCollections(var value) {
    _userCollections = value;
    notifyListeners();
  }

  // getter and setter for user playlists
  dynamic getUserPlaylists() => _userPlaylists;
  void setUserPlaylists(var value) {
    _userPlaylists = value;
    notifyListeners();
  }

  // getter and setter for loading indicators
  bool getUserCollectionLoadingFlag() => _userCollectionLoading;
  void setUserCollectionLoadingFlag(bool value) {
    _userCollectionLoading = value;
    notifyListeners();
  }

  bool getUserPlaylistLoadingFlag() => _userPlaylistLoading;
  void setUserPlaylistLoadingFlag(bool value) {
    _userPlaylistLoading = value;
    notifyListeners();
  }
}
