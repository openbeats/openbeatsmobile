import 'package:obsmobile/imports.dart';

class SearchTabModel extends ChangeNotifier {
  // holds the current searched string
  String _currentSearchString;

  // used to get the current search string
  String getCurrentSearchString() => _currentSearchString;
  // used to update the current search string
  void setCurrentSearchString(String value) {
    _currentSearchString = value;
    notifyListeners();
  }
}
