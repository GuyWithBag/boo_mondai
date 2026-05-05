// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/streak_controller.dart
// PURPOSE: UI state for user's daily FSRS review streak
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';

class StreakController extends ChangeNotifier {
  Streak? _streak;
  bool _isLoading = false;
  String? _error;

  Streak? get streak => _streak;
  int get currentStreak => _streak?.currentStreak ?? 0;
  int get longestStreak => _streak?.longestStreak ?? 0;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStreak(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _streak = await Services.streak.fetchStreak(userId);
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recordActivity(String userId) async {
    try {
      _streak = await Services.streak.recordAndSync(userId);
      notifyListeners();
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
