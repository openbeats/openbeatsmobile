import 'package:obsmobile/imports.dart';
import 'package:obsmobile/models/homePageModels/bottomNavBarDest.dart';

// holds the bottomNavBarItem for the homePage
BottomNavigationBarItem bottomNavBarItem(Destination destination) {
  return BottomNavigationBarItem(
    icon: Icon(destination.icon),
    title: Text(destination.title),
    backgroundColor: destination.color
  );
}
