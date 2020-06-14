import '../../imports.dart';

// navigate to searchNowView
void navigateToSearchNowView(BuildContext context) async {
  // navigating to searchNowView.dart and waiting for search query
  var selectedSearchString =
      await Navigator.of(context).pushNamed('/searchNow');
  // checking if the user has returned something
  if (selectedSearchString != null &&
      selectedSearchString.toString().length > 0) {
    // adding the query to the search results history
    addToSearchHistorySharedPrefs(context, selectedSearchString);
    // calling function to get videos for query
    getVideosForQuery(context, selectedSearchString);
  }
}
