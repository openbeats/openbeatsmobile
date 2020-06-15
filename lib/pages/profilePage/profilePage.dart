import 'package:openbeatsmobile/imports.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _profilePageAppBar(),
    );
  }

  Widget _profilePageAppBar() {
    return AppBar(
      title: Text(
        "Profile",
      ),
    );
  }
}
