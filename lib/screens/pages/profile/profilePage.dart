import '../../../imports.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // show update dialog
  void showUpdateDialog(Map<String, dynamic> response) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            backgroundColor:
                Provider.of<ApplicationTheme>(context, listen: false)
                    .getBottomAppBarColor(),
            title: (response == null) ? Text("") : Text("Update Available"),
            content: (response == null)
                ? Text("No worries, more features coming soon")
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
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                textColor: Colors.grey,
                child: Text("Later"),
              ),
              FlatButton(
                onPressed: () {},
                textColor: Colors.green,
                child: Text("Update"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          onPressed: () async {
            Map<String, dynamic> _updateCheckResponse = await checkForUpdate();
            showUpdateDialog(_updateCheckResponse);
          },
          child: Text("Update App Now!"),
        ),
      ),
    );
  }
}
