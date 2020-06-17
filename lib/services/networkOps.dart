import 'package:obsmobile/imports.dart';

// get search suggestions for SearchNowPage
void getSearchSuggestion(BuildContext context) async {
  // getting the current search string
  String query = Provider.of<SearchTabModel>(context, listen: false)
      .getCurrentSearchString();
  // sending http request
  var response = await get(getApiEndpoint() + "/suggester?k=" + query);
  var responseJSON = json.decode(response.body);
  // updating the seacch suggestions list
  Provider.of<SearchTabModel>(context, listen: false)
      .updateSearchSuggestions(responseJSON["data"]);
}
