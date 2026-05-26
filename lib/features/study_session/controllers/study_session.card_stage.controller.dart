import 'package:boo_mondai/lib.barrel.dart'
    show StudyRating, StudySessionController;
import 'package:flutter/material.dart';

class StudySessionCardStageController extends ChangeNotifier {
  StudySessionCardStageController({
    required bool canReveal,
    required this.answer,
  }) : _canReveal = canReveal;

  String? answer;

  bool _isRevealed = false;
  bool get isRevealed => _isRevealed;

  StudyRating? _pendingRating;
  StudyRating? get pendingRating => _pendingRating;

  bool _canReveal;
  bool get canReveal => _canReveal;

  void setAnswer(String? value) {
    answer = value;
    notifyListeners();
  }

  void setCanReveal(bool value) {
    if (_canReveal == value) return;
    _canReveal = value;
    notifyListeners();
  }

  void reveal(StudySessionController controller, {StudyRating? pendingRating}) {
    if (!_canReveal || _isRevealed) return;
    _isRevealed = true;
    _pendingRating = pendingRating;
    if (pendingRating == null) {
      controller.calculateNextIntervals();
    }
    notifyListeners();
  }

  void revealWithAnswer(String value) {
    answer = value;
    _canReveal = true;
    _isRevealed = true;
    notifyListeners();
  }
}
