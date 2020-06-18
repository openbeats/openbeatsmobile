import 'package:obsmobile/imports.dart';

// holds the title for the suggestions and searchHistory list titles
Widget suggestionsTitleW(bool showHistory) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 5.0),
    child: Text(
      (showHistory) ? "Search History" : "Suggestions",
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// holds the search suggestions listview
Widget searchSuggestionsListBuilder(
    BuildContext context, int index, bool showHistory) {
  // getting the search suggestion title
  String _searchSuggestionTitle = (showHistory)
      ? Provider.of<SearchTabModel>(context).getSearchHistory()[index]
      : Provider.of<SearchTabModel>(context, listen: false)
          .getSearchSuggestions()[index][0];
  return ListTile(
    leading: Icon(Icons.search),
    title: Text(_searchSuggestionTitle),
    onTap: () {
      Navigator.pop(context, _searchSuggestionTitle);
    },
  );
}

// holds the searchHomeView search instruction widgets
Widget searchInstructionW(BuildContext context) {
  return ListView(
    physics: BouncingScrollPhysics(),
    children: <Widget>[
      searchInstructionFlareActor(context),
      SizedBox(
        height: 10.0,
      ),
      searchInstructionText(context),
    ],
  );
}

// holds the searchHomeView search instruction FlareActor
Widget searchInstructionFlareActor(BuildContext context) {
  return Container(
    margin: (MediaQuery.of(context).orientation == Orientation.portrait)
        ? EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.11)
        : null,
    height: MediaQuery.of(context).size.height * 0.4,
    child: FlareActor(
      "assets/flareAssets/searchforsong.flr",
      animation: "Searching",
    ),
  );
}

// holds the searchHomeView search instruction text
Widget searchInstructionText(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    child: (MediaQuery.of(context).orientation == Orientation.portrait)
        ? RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.grey, fontSize: 25.0),
              children: [
                TextSpan(
                  text: "Click on ",
                ),
                WidgetSpan(
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 30.0,
                  ),
                ),
                TextSpan(text: " to search\nfor your favorite songs")
              ],
            ),
          )
        : null,
  );
}

