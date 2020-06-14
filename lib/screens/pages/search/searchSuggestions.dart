import '../../../imports.dart';

class SearchSuggestions extends StatefulWidget {
  @override
  _SearchSuggestionsState createState() => _SearchSuggestionsState();
}

class _SearchSuggestionsState extends State<SearchSuggestions> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchSuggestionsProvider(),
      child: Scaffold(
        key: Provider.of<ScaffoldKeys>(context)
            .getScaffoldKey("searchSuggestionsPage"),
        appBar: AppBar(),
      ),
    );
  }
}
