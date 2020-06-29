import 'package:obsmobile/imports.dart';

class PlaylistViewData extends ChangeNotifier {
  // holds the loading flag
  bool _isLoading = true;

  // getter and setter for _isLoading
  bool getIsLoading() => _isLoading;
  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
