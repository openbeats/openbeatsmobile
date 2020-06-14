import './imports.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // getting the toast theme data
    Map<String, dynamic> _toastThemedata = ThemeComponents().toastThemeData;
    return OKToast(
      backgroundColor: _toastThemedata["backgroundColor"],
      duration: _toastThemedata["duration"],
      textPadding: _toastThemedata["textPadding"],
      position: _toastThemedata["position"],
      dismissOtherOnShow: _toastThemedata["dismissOtherOnShow"],
      child: MaterialApp(
        title: "OpenBeats",
        theme: ThemeComponents().themeData,
        home: AudioServiceWidget(
          child: HomePage(),
        ),
      ),
    );
  }
}
