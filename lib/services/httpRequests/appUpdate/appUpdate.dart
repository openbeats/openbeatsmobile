import '../../../imports.dart';

getUpdateFromServer() async {
  // holds the base url for the update server
  String _baseUpdateURL = "https://obsmobileupdateserver.herokuapp.com";

  // getting update version
  var response =
      await get(_baseUpdateURL + "/obsmobileserver/getlatestVersion");
  return json.decode(response.body);
}
