import 'package:openbeatsmobile/imports.dart';

// template for bottomNavBar destinations
class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

// holds all the destinations for bottomNabBar
const List<Destination> allDestinations = <Destination>[
  Destination('Explore', Icons.explore, Colors.lightGreen),
  Destination('Search', Icons.search, Colors.cyan),
  Destination('Library', Icons.library_music, Colors.orange),
  Destination('Profile', Icons.person, Colors.blue)
];