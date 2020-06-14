import 'package:openbeatsmobile/imports.dart';

void main() {
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<HomePageModel>(
        create: (_) => HomePageModel(),
      ),
      ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
      ),
      ChangeNotifierProvider<SearchPageProvider>(
        create: (_) => SearchPageProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // printing debug message
    DebugFunctions().printMessage("=======MyAPP BUILD=======");
    // getting the toast theme data
    Map<String, dynamic> _toastThemedata = ThemeComponents().getToastTheme();
    return OKToast(
      backgroundColor: _toastThemedata["backgroundColor"],
      duration: _toastThemedata["duration"],
      textPadding: _toastThemedata["textPadding"],
      position: _toastThemedata["position"],
      dismissOtherOnShow: _toastThemedata["dismissOtherOnShow"],
      child: MaterialApp(
        title: "OpenBeats",
        theme: ThemeComponents().getAppTheme(),
        home: AudioServiceWidget(
          child: HomePage(),
        ),
      ),
    );
  }
}
