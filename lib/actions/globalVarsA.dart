import 'package:shared_preferences/shared_preferences.dart';

import '../globalVars.dart' as globalVars;

// to modify the loginInfo global variable
void modifyLoginInfo(loginParameters, shouldUpdateSharedPreferences) async {
  if (loginParameters["loginStatus"] == true) {
    globalVars.loginInfo["loginStatus"] = true;
    globalVars.loginInfo["userEmail"] = loginParameters["userEmail"];
    globalVars.loginInfo["userName"] = loginParameters["userName"];
    globalVars.loginInfo["userId"] = loginParameters["userId"];
    globalVars.loginInfo["userAvatar"] = loginParameters["userAvatar"];
    globalVars.loginInfo["userToken"] = loginParameters["userToken"];
    if (shouldUpdateSharedPreferences) {
      // creating sharedPreferences instance to set media values
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("loginStatus", true);
      prefs.setString("userEmail", loginParameters["userEmail"]);
      prefs.setString("userName", loginParameters["userName"]);
      prefs.setString("userId", loginParameters["userId"]);
      prefs.setString("userAvatar", loginParameters["userAvatar"]);
      prefs.setString("userToken", loginParameters["userToken"]);
    }
  } else if (loginParameters["loginStatus"] == false) {
    // holds the login information of the user
    Map<String, dynamic> loginInfo = {
      "loginStatus": false,
      "userEmail": "example@examplemail.com",
      "userName": "user_name",
      "userId": "user_id",
      "userAvatar":"user_avatar",
      "userToken":"user_token"
    };
    globalVars.loginInfo = loginInfo;
    if(shouldUpdateSharedPreferences){
      // creating sharedPreferences instance to set media values
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("loginStatus", false);
      prefs.remove("userEmail");
      prefs.remove("userName");
      prefs.remove("userId");
      prefs.remove("userAvatar");
      prefs.remove("userToken");
    }
  }
}
