import 'package:obsmobile/imports.dart';

// used to navigate to the SearchNowPage and handle the data passed back
void navigateToSearchNowPage(BuildContext context) async{
  // pushing to page and waiting for returned data
  String query = await Navigator.pushNamed(context, "/searchNowPage");
  // checking if valid query has been returned
  if(query!=null && query.length > 0){
    
  }
}