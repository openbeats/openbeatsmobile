import '../../../imports.dart';

// show update dialog
void showUpdateDialog(Map<String, dynamic> response, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor: Provider.of<ApplicationTheme>(context, listen: false)
              .getBottomAppBarColor(),
          title: (response == null)
              ? Text("You have the latest version")
              : Text("Update Available!"),
          content: (response == null)
              ? Text("We are working hard to bring more features to you ")
              : RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "What's New:\n",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      WidgetSpan(
                        child: SizedBox(
                          height: 6.0,
                        ),
                      ),
                      TextSpan(
                        text: "\n⦿ " + response["changeLog"].join("\n⦿ "),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
          actions: (response != null)
              ? <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    textColor: Colors.grey,
                    child: Text("Later"),
                  ),
                  FlatButton(
                    onPressed: () {
                      initiateAppUpdate(response["accessLink"], response["newVersionCode"]);
                      showToast("Initiated App Update",
                          position: ToastPosition.bottom,);
                      Navigator.of(context).pop();
                    },
                    textColor: Colors.green,
                    child: Text("Update"),
                  ),
                ]
              : [
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    textColor: Colors.green,
                    child: Text("Close"),
                  ),
                ],
        );
      });
}
