import 'package:obsmobile/imports.dart';
import 'package:obsmobile/pages/homePage/homePage.dart';

void main() => runApp(AudioServiceWidget(
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OpenBeats",
      theme: GlobalThemes().getAppTheme(),
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<SearchTabModel>(
              create: (_) => SearchTabModel()),
          ChangeNotifierProvider<HomePageData>(
            create: (_) => HomePageData(),
          ),
          ChangeNotifierProvider<ProfileTabData>(
            create: (_) => ProfileTabData(),
          ),
          ChangeNotifierProvider<UserModel>(
            create: (_) => UserModel(),
          ),
          ChangeNotifierProvider<LibraryTabData>(
            create: (_) => LibraryTabData(),
          ),
          ChangeNotifierProvider<PlaylistViewData>(
            create: (_) => PlaylistViewData(),
          ),
        ],
        child: HomePage(),
      ),
    );
  }
}
