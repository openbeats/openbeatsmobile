import 'package:obsmobile/imports.dart';

// used to navigate to the SearchNowPage and handle the data passed back
Future<void> navigateToSearchNowPage(BuildContext context) async {
  // pushing to page and waiting for returned data
  var query = await Navigator.pushNamed(context, "/searchNowPage");
  // checking if valid query has been returned
  if (query != null && query.toString().length > 0) {
    // setting loading flag
    Provider.of<SearchTabModel>(context, listen: false).setLoadingFlag(true);

    print(query.toString() + " Recieved");
    // getting current search history
    List<String> _searchHistory =
        Provider.of<SearchTabModel>(context, listen: false).getSearchHistory();
    // adding current query to search history
    _searchHistory.add(query);
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
