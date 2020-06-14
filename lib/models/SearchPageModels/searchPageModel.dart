import 'package:openbeatsmobile/imports.dart';

class SearchPageProvider extends ChangeNotifier {
  // flag used to indicate that the search results are loading
  bool _searchResultLoading = false;
  // holds the videos received for query
  List _videosResponseList = new List();

  // used to get the searchResultLoading value
  bool getSearchResultLoading() => _searchResultLoading;
  // used to set the searchResultLoading value
  void setSearchResultLoading(bool value) {
    _searchResultLoading = value;
    notifyListeners();
  }

  // used to get the videoResponseList
  List getVideoResponseList() => _videosResponseList;
  // used to set the videoResponseList
  void setVideoResponseList(List value) {
    _videosResponseList = value;
    notifyListeners();
  }
}
