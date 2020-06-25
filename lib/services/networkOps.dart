import 'package:obsmobile/imports.dart';

// used to handle the exceptions raised by the network request methods
void _handleExceptionsRaised(
    String exception, BuildContext context, bool showToastMessage) {
  // holds the string to show the user
  String _userMessage;
  // constructing the right error message
  if (exception == "SocketException")
    _userMessage =
        "Unable to connect to the internet. Please check network connectivity";
  else if (exception == "TimeoutException")
    _userMessage = "Server took too long to respond. Please try again.";
  else if (exception == "BadRequestException")
    _userMessage =
        "Application sending incorrect data. Please contact developer.";
  else if (exception == "UnauthorizedException")
    _userMessage =
        "Unable to access forbidden data. Please try signing in again.";
  else
    _userMessage = "An unknown network error occurred. Please try again.";

  // checking if toast should be shown instead of snackbar
  if (showToastMessage) {
    showToast(_userMessage);
  } else {
    // constructing snackbar to show error message
    SnackBar _errorSnackBar = SnackBar(
      content: Text(
        _userMessage,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 10),
      action: SnackBarAction(
          label: "Close",
          textColor: Colors.white,
          onPressed: () {
            homePageScaffoldKey.currentState.hideCurrentSnackBar();
          }),
    );

    // checking if snackbar should be shown
    if (getCurrSnackBarErrorMsg() == null &&
        getCurrSnackBarErrorMsg() != exception) {
      // setting the current exception in global store
      setCurrSnackBarErrorMsg(exception);
      // hiding any present snackbars
      homePageScaffoldKey.currentState.removeCurrentSnackBar();
      // showing snackbar
      homePageScaffoldKey.currentState
          .showSnackBar(_errorSnackBar)
          .closed
          .then((value) => setCurrSnackBarErrorMsg(null));
    }
  }
}

// used to classify the responses recieved for a network request
dynamic _returnResponse(Response response, BuildContext context) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      return {"status": true, "data": responseJson};
    case 400:
      _handleExceptionsRaised("BadRequestException", context, false);
      return {"status": false, "error": "BadRequestException"};
    case 401:
    case 403:
      _handleExceptionsRaised("UnauthorizedException", context, false);
      return {"status": false, "error": "UnauthorizedException"};
    case 500:
    default:
      _handleExceptionsRaised("UnknownException", context, false);
      return {
        "status": false,
      };
  }
}

// get search suggestions for SearchNowPage
void getSearchSuggestion(BuildContext context) async {
  try {
    // getting the current search string
    String query = Provider.of<SearchTabModel>(context, listen: false)
        .getCurrentSearchString();
    // checking if the search results have got any value
    for (int i = 0; i < 5; i++) {
      // sending http request
      var response = await get(getApiEndpoint() + "/suggester?k=" + query);
      var responseClassified = _returnResponse(response, context);
      if (responseClassified["status"] == true &&
          responseClassified["data"]["data"].length != 0) {
        // updating the seacch suggestions list
        Provider.of<SearchTabModel>(context, listen: false)
            .updateSearchSuggestions(responseClassified["data"]["data"]);
        break;
      }
    }
  } on SocketException {
    // no internet connection
    _handleExceptionsRaised("SocketException", context, false);
  } on TimeoutException {
    // timeout exception
    _handleExceptionsRaised("TimeoutException", context, false);
  }
}

// get ytcat search results
Future<void> getYTCatSearchResults(BuildContext context, String query) async {
  try {
    // checking if the search results have got any value
    for (int i = 0; i < 5; i++) {
      // sending http request
      var response = await get(getApiEndpoint() + "/ytcat?q=" + query);
      var responseClassified = _returnResponse(response, context);
      if (responseClassified["status"] == true &&
          responseClassified["data"]["data"].length != 0) {
        // updating the seacch suggestions list
        Provider.of<SearchTabModel>(context, listen: false)
            .updateSearchResults(responseClassified["data"]["data"]);
        break;
      }
    }
  } on SocketException {
    // no internet connection
    _handleExceptionsRaised("SocketException", context, false);
  } on TimeoutException {
    // timeout exception
    _handleExceptionsRaised("TimeoutException", context, false);
  }
}

// used to get the streamingUrl
Future<String> getStreamingUrl(mediaParameters) async {
  try {
    // checking if the search results have got any value
    for (int i = 0; i < 5; i++) {
      // sending http request
      var response =
          await get(getApiEndpoint() + "/opencc/" + mediaParameters["videoId"]);
      var responseClassified = _returnResponse(response, null);
      if (responseClassified["status"] == true &&
          responseClassified["data"]["link"].length != 0 &&
          responseClassified["data"]["link"] != null) {
        // returning the streaming url
        return responseClassified["data"]["link"];
      }
    }
    return null;
  } on SocketException {
    // no internet connection
    _handleExceptionsRaised("SocketException", null, true);
    return null;
  } on TimeoutException {
    // timeout exception
    _handleExceptionsRaised("TimeoutException", null, true);
    return null;
  }
}

// used to check if high resolution thumbnail is available for the song
Future<String> checkHighResThumbnailAvailability(String videoId) async {
  // constructing image urls
  String _highResURL =
      "https://img.youtube.com/vi/" + videoId + "/maxresdefault.jpg";
  String _lowResURL =
      "https://img.youtube.com/vi/" + videoId + "/mqdefault.jpg";
  try {
    // sending http request
    var response = await head(_highResURL);
    // checking if image exists
    if (response.statusCode == 200)
      return _highResURL;
    else
      return _lowResURL;
  } on SocketException {
    // no internet connection
    _handleExceptionsRaised("SocketException", null, true);
    return _lowResURL;
  } on TimeoutException {
    // timeout exception
    _handleExceptionsRaised("TimeoutException", null, true);
    return _lowResURL;
  }
}

// login authentication handler
Future<dynamic> loginAuthticationHandler(
    Map<String, String> _userData, BuildContext context) async {
  try {
    // sending http request
    var response = await post(getApiEndpoint() + "/auth/login",
        body: {"email": _userData["email"], "password": _userData["password"]});
    var responseClassified = _returnResponse(response, context);
    if (responseClassified["status"] == true) {
      return responseClassified["data"];
    }
  } on SocketException {
    // no internet connection
    _handleExceptionsRaised("SocketException", null, true);
  } on TimeoutException {
    // timeout exception
    _handleExceptionsRaised("TimeoutException", null, true);
  }
}
