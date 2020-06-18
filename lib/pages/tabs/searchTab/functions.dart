import 'package:obsmobile/imports.dart';

// used to navigate to the SearchNowPage and handle the data passed back
Future<void> navigateToSearchNowPage(BuildContext context) async {
  // pushing to page and waiting for returned data
  var query = await Navigator.pushNamed(context, "/searchNowPage");
  // checking if valid query has been returned
  if (query != null && query.toString().length > 0) {
    print(query);
  }
}
