// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/streak_controller.dart
// PURPOSE: UI state for user's daily FSRS review streak
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';

class StreakController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  Streak? get streak => LocalDB.streak.retrieve();
  bool get isLoading => _isLoading;
  String? get error => _error;

  // void fetchStreak(String userId) {
  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {} on AppException catch (e) {
  //     _error = e.message;
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> recordActivity(DateTime activityDate) async {
    try {
      await LocalDB.streak.recordActivity(activityDate);
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
