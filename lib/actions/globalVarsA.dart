import '../globalVars.dart' as globalVars;

// to modify the loginInfo global variable
void modifyLoginInfo(loginParameters){
  if(loginParameters["loginStatus"] == true){
    globalVars.loginInfo["loginStatus"] = true;
    globalVars.loginInfo["userEmail"] = loginParameters["userEmail"];
    globalVars.loginInfo["userName"] = loginParameters["userName"];
    globalVars.loginInfo["userId"] = loginParameters["userId"];
    globalVars.loginInfo["userToken"] = loginParameters["userToken"];
  } else {
    globalVars.loginInfo["loginStatus"] = false;
  }
}