import 'package:obsmobile/imports.dart';

class PlaylistViewData extends ChangeNotifier {
  // holds the loading flag
  bool _isLoading = true;
  // holds the list of songs for the current playlist
  List<dynamic> _currPlaylistSongs;

  // getter and setter for _isLoading
  bool getIsLoading() => _isLoading;
  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // getter and setter for _currPlaylistSongs
  List<dynamic> getCurrPlaylistSongs() => _currPlaylistSongs;
  void setCurrPlaylistSongs(List<dynamic> value) {
    _currPlaylistSongs = value;
    notifyListeners();
  }
}
