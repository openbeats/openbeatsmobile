import 'package:openbeatsmobile/imports.dart';

// gets list of videos for query
void getVideosForQuery(BuildContext context, String query) async {
  // holds the iteration count for the ytcat retrying logic
  int _iterationCount = 0;
  // sanitizing query to prevent rogue characters
  query = query.replaceAll(new RegExp(r'[^\w\s]+'), '');
  // constructing url to send request to to get list of videos
  String url = AppComponents().apiHostAddress + "/ytcat?q=" + query + " audio";
  try {
    while (_iterationCount < 5) {
      // sending http get request
      var response = await get(url);
      // decoding to json
      var responseJSON = jsonDecode(response.body);
      // checking if proper response is received
      if (responseJSON["status"] == true && responseJSON["data"].length != 0) {
        // response as list to iterate over
        Provider.of<SearchPageProvider>(context)
            .setVideoResponseList(responseJSON["data"] as List);

        // removing loading animation from screen
        Provider.of<SearchPageProvider>(context).setSearchResultLoading(false);

        // breaking the loop
        break;
      } else {
        // incrementing iteration count
        _iterationCount += 1;
      }
    }

    // removing loading animation from screen
    Provider.of<SearchPageProvider>(context).setSearchResultLoading(false);
  } catch (e) {
    // removing loading animation from screen
    Provider.of<SearchPageProvider>(context).setSearchResultLoading(false);
  }
}