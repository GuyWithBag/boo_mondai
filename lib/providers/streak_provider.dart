// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/streak_provider.dart
// PURPOSE: Tracks and updates user's daily FSRS review streak
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

import 'package:boo_mondai/services/app_exception.dart';
import 'package:boo_mondai/services/services.dart';

/// Manages streak state. Activity = completing at least one FSRS review per day.
///
/// Call [fetchStreak] on app start / home page mount.
/// Call [recordActivity] after every review session completes.
class StreakProvider extends ChangeNotifier {
  Streak? _streak;
  bool _isLoading = false;
  String? _error;

  Streak? get streak => _streak;
  int get currentStreak => _streak?.currentStreak ?? 0;
  int get longestStreak => _streak?.longestStreak ?? 0;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Loads streak — Hive first (fast), then syncs from Supabase.
  Future<void> fetchStreak(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _streak = LocalDB.streak.getByUserId(userId);
      if (_streak != null) notifyListeners();

      final data = await Services.streakSync.fetchStreak(userId);
      if (data != null) {
        _streak = StreakMapper.fromMap(data);
        await LocalDB.streak.put(_streak!);
      }
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Records today as an active day and syncs to Supabase in the background.
  Future<void> recordActivity(String userId) async {
    try {
      final updated = await LocalDB.streak.recordActivity(
        userId,
        DateTime.now(),
      );
      _streak = updated;
      notifyListeners();

      // Keys must match snake_case DB column names (Supabase ignores camelCase).
      await Services.streakSync.upsertStreak({
        'id': updated.id,
        'user_id': updated.userId,
        'current_streak': updated.currentStreak,
        'longest_streak': updated.longestStreak,
        if (updated.lastActivityDate != null)
          'last_activity_date': updated.lastActivityDate!.toIso8601String(),
      });
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
