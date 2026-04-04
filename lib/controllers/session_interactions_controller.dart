import 'package:flutter/foundation.dart';

class SessionInteractionsController extends ChangeNotifier {
  String? answer;
  bool _isRevealed = false;

  bool get isRevealed => _isRevealed;

  set isRevealed(bool value) {
    _isRevealed = value;
    notifyListeners();
  }

  bool _canReveal = false;

  bool get canReveal => _canReveal;

  set canReveal(bool value) {
    _canReveal = value;
    notifyListeners();
  }

  void tryAnswer() {
    isRevealed = canReveal;
  }
}
