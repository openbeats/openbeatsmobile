import '../imports.dart';

// compare too versions of application to see if an update is necessary
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

// checks for update to app in server
checkForUpdate() async {
  try {
    var jsonResponse = getUpdateFromServer();

    if (jsonResponse["status"] == true) {
      var rVersionCode = jsonResponse["data"]["versionCode"];
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
      // var path = await ExtStorage.getExternalStoragePublicDirectory(
      //     ExtStorage.DIRECTORY_DOWNLOADS);
      // print(path);
      // var file = new File(path +
      //     "/openbeats" +
      //     rVersionCode["vCode1"].toString() +
      //     "." +
      //     rVersionCode["vCode2"].toString() +
      //     "." +
      //     rVersionCode["vCode2"].toString() +
      //     "+" +
      //     rVersionCode["buildNumber"].toString() +
      //     ".apk");
      // print(file.delete());

      // comparing the present versions
      bool shouldUpdate =
          _compareVersions(jsonResponse["data"]["versionCode"], presentVersion);
      return (shouldUpdate)
          ? {
              "changeLog": jsonResponse["data"]["changeLog"],
              "accessLink": jsonResponse["data"]["accessLink"],
              "newVersionCode": rVersionCode["vCode1"].toString() +
                  "." +
                  rVersionCode["vCode2"].toString() +
                  "." +
                  rVersionCode["vCode2"].toString() +
                  "+" +
                  rVersionCode["buildNumber"].toString(),
            }
          : null;
    } else
      return null;
  } catch (error) {
    print("Error in checkForUpdate: " + error.toString());
    return null;
  }
}

// initiates application update process
void initiateAppUpdate(String accessLink, String newVersionCode) async {
  try {
    OtaUpdate()
        .execute(accessLink,
            destinationFilename: 'openbeats' + newVersionCode + '.apk')
        .listen(
      (OtaEvent event) {
        print('EVENT: ${event.status} : ${event.value}');
      },
    ).onDone(() {
      showToast(
        "OpenBeats Update Downloaded",
        position: ToastPosition.bottom,
      );
    });
  } catch (e) {
    print('Failed to make OTA update. Details: $e');
  }
}
