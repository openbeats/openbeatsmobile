import 'package:obsmobile/imports.dart';

// holds the title for the suggestions and searchHistory list titles
Widget suggestionsTitleW(bool showHistory) {
  return Container(
    margin: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 5.0),
    child: Text(
      (showHistory) ? "Search History" : "Suggestions",
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// holds the search suggestions listview
Widget searchSuggestionsListBuilder(BuildContext context, int index) {
  // getting the search suggestion title
  String _searchSuggestionTitle =
      Provider.of<SearchTabModel>(context, listen: false)
          .getSearchSuggestions()[index][0];
  return ListTile(
    leading: Icon(Icons.search),
    title: Text(_searchSuggestionTitle),
    onTap: () {
      Navigator.pop(context, _searchSuggestionTitle);
    },
  );
}
