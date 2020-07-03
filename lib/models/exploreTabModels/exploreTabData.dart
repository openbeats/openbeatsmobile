import 'package:obsmobile/imports.dart';

class ExploreTabData extends ChangeNotifier {
  // holds the recentlyPlayed loading flag
  bool _recentlyPlayedLoadingFlag = true;

  // getter and setter for _recentlyPlayedLoadingFlag
  bool getRecentlyPlayedLoading() => _recentlyPlayedLoadingFlag;
  void setRecentlyPlayedLoading(bool value) {
    _recentlyPlayedLoadingFlag = value;
  }
}
