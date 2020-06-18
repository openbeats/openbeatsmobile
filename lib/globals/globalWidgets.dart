import 'package:obsmobile/imports.dart';

// holds the loading animation for the application
Widget loadingAnimationW() {
  return Container(
    height: 100.0,
    child: FlareActor(
      "assets/flareAssets/loadinganim.flr",
      animation: "loadnew",
    ),
  );
}
