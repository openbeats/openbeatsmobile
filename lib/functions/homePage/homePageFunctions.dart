import 'package:openbeatsmobile/imports.dart';

// called when the slideUp Panel slides to hide the bottomNavBar
void manageBottomNavVisibility(
    double slidePosition, AnimationController _hideBottomNavBarAnimController) {
  if (slidePosition > 0.7)
    _hideBottomNavBarAnimController.reverse();
  else if (slidePosition < 0.2) _hideBottomNavBarAnimController.forward();
}