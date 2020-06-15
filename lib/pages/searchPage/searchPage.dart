import 'package:openbeatsmobile/imports.dart';
import './widgets/searchPageW.dart' as searchPageW;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchPageAppBar(),
      body: _searchPageBody(),
    );
  }

  Widget _searchPageAppBar() {
    // getting the appBar theme
    return AppBar(
      title: Text(
        "Search",
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () => navigateToSearchNowView(context)),
      ],
    );
  }

  // holds the body of the searchPage
  Widget _searchPageBody() {
    // fetching required values
    bool searchResultLoading =
        Provider.of<SearchPageProvider>(context).getSearchResultLoading();
    List videResponseResult =
        Provider.of<SearchPageProvider>(context).getVideoResponseList();
    return Center(
      child: (searchResultLoading)
          ? AppComponents().loadingAnimation()
          : (videResponseResult.length == 0)
              ? searchPageW.askUserToSearchFlareActor()
              : Container(
                  child: null,
                ),
    );
  }
}
