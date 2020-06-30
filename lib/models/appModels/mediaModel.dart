import 'package:obsmobile/imports.dart';

class MediaModel extends ChangeNotifier {
// holds the repeat status of songs and queue
  bool _repeatSong = false;
  bool _repeatQueue = false;

// getter and setter for _repeatSong
  bool getRepeatSong() => _repeatSong;
  void setRepeatSong(bool value) {
    _repeatSong = value;
    notifyListeners();
  }

// getter and setter for _repeatQueue
  bool getRepeatQueue() => _repeatQueue;
  void setRepeatQueue(bool value) {
    _repeatQueue = value;
    notifyListeners();
  }
}
