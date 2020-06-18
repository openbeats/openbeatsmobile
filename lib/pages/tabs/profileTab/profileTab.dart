import 'package:obsmobile/imports.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _profileTabBody(),
    );
  }

  // holds the body of profileTab
  Widget _profileTabBody() {
    return Container(
      child: Center(
        child: Text("Profile Tab"),
      ),
    );
  }
}
