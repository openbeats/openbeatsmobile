import '../imports.dart';

// holds the base url for the update server
String _baseUpdateURL = "https://obsmobileupdateserver.herokuapp.com";

bool _compareVersions(var rVersion, Map<String, int> pVersion) {
  if (rVersion["vCode1"] > pVersion["vCode1"])
    return true;
  else if (rVersion["vCode2"] > pVersion["vCode2"])
    return true;
  else if (rVersion["vCode3"] > pVersion["vCode3"])
    return true;
  else if (rVersion["buildNumber"] > pVersion["buildNumber"])
    return true;
  else
    return false;
}

checkForUpdate() async {
  try {
    // getting update version
    var response =
        await get(_baseUpdateURL + "/obsmobileserver/getlatestVersion");
    var jsonResponse = json.decode(response.body);

    // getting present version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // splitting version code into list
    List<String> versionCodeList = packageInfo.version.split(".");
    Map<String, int> presentVersion = {
      "vCode1": int.parse(versionCodeList[0]),
      "vCode2": int.parse(versionCodeList[1]),
      "vCode3": int.parse(versionCodeList[2]),
      "buildNumber": int.parse(packageInfo.buildNumber)
    };

    // comparing the present versions
    bool shouldUpdate =
        _compareVersions(jsonResponse["data"]["versionCode"], presentVersion);
    print(jsonResponse["data"]["changeLog"]);
    return (shouldUpdate)
        ? {
            "changeLog": jsonResponse["data"]["changeLog"],
            "accessLink": jsonResponse["data"]["accessLink"]
          }
        : null;
  } catch (error) {
    print("Error in checkForUpdate: " + error.toString());
    return null;
  }
}
