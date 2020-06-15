import 'package:openbeatsmobile/imports.dart';

// template for bottomNavBar destinations
class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final Color color;
}

// holds all the destinations for bottomNabBar
List<Destination> allDestinations = <Destination>[
  Destination('Explore', Icons.explore,
      ThemeComponents().getAppTheme().bottomAppBarColor),
  Destination('Search', Icons.search,
      ThemeComponents().getAppTheme().bottomAppBarColor),
  Destination('Library', Icons.library_music,
      ThemeComponents().getAppTheme().bottomAppBarColor),
  Destination('Profile', Icons.person,
      ThemeComponents().getAppTheme().bottomAppBarColor)
];
