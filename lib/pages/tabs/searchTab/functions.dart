import 'package:obsmobile/imports.dart';

// used to navigate to the SearchNowPage and handle the data passed back
Future<void> navigateToSearchNowPage(BuildContext context) async {
  // pushing to page and waiting for returned data
  var query = await Navigator.pushNamed(context, "/searchNowPage");
  // checking if valid query has been returned
  if (query != null && query.toString().length > 0) {
    // sanitizing query to prevent rogue characters
    query = query.toString().replaceAll(new RegExp(r'[^\w\s]+'), '');
    // setting loading flag
    Provider.of<SearchTabModel>(context, listen: false).setLoadingFlag(true);
    // updating the currentSearch string
    Provider.of<SearchTabModel>(context, listen: false)
        .setCurrentSearchString(query);
    // getting current search history
    List<String> _searchHistory =
        Provider.of<SearchTabModel>(context, listen: false).getSearchHistory();
    // checking if the query exists in search history
    if (_searchHistory.contains(query)) {
      // deleting the duplicate
      _searchHistory.remove(query);
      _searchHistory.insert(0, query);
    } else
      _searchHistory.insert(0, query);

    // updating providers
    Provider.of<SearchTabModel>(context, listen: false)
        .updateSearchHistory(_searchHistory);
    // updating shared preferences
    updateSearchHistorySharedPrefs(_searchHistory);

    // getting the audio search results for this query
    await getYTCatSearchResults(context, query);

    // reset loading flag
    Provider.of<SearchTabModel>(context, listen: false).setLoadingFlag(false);
  }
}

// used to start single song playback
void startSingleSongPlayback(SearchTabModel data, int index) {
  // getting the songObject details to send to AudioService
  Map _songObj = data.getSearchResults()[index];

  // constructing the mediaParameters object
  Map<String, dynamic> mediaParameters = {
    "title": _songObj["title"],
    "thumbnail": _songObj["thumbnail"],
    "duration": _songObj["duration"],
    "durationInMilliSeconds":
        reformatTimeStampToMilliSeconds(_songObj["duration"]),
    "videoId": _songObj["videoId"],
    "channelName": _songObj["channelName"],
    "views": reformatViewstoHumanReadable(_songObj["views"]),
  };
  AudioServiceOps().startSingleSongPlayback(mediaParameters);
}
