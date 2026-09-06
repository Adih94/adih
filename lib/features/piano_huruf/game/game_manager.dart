import 'package:flutter/foundation.dart';

import '../models/letter_item.dart';

enum PianoGameMode { freePlay, followLetter, listenAndFind, playSong }

/// Small state holder. The prototype starts in free play; the public API is
/// ready for the guided modes without coupling their rules to the UI.
class GameManager extends ChangeNotifier {
  PianoGameMode mode = PianoGameMode.freePlay;
  LetterItem? selectedLetter;
  int stars = 0;

  void press(LetterItem item) {
    selectedLetter = item;
    notifyListeners();
  }

  void setMode(PianoGameMode value) {
    mode = value;
    stars = 0;
    notifyListeners();
  }
}
