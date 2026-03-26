// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/streak_provider.dart
// PURPOSE: Tracks and updates user's daily FSRS review streak
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:boo_mondai/models/streak.dart';
import 'package:boo_mondai/services/supabase_service.dart';
import 'package:boo_mondai/services/hive_service.dart';
import 'package:boo_mondai/services/app_exception.dart';

/// Manages streak state. Activity = completing at least one FSRS review per day.
class StreakProvider extends ChangeNotifier {
  final SupabaseService _supabaseService;
  final HiveService _hiveService;
  static const _uuid = Uuid();

  StreakProvider({
    required SupabaseService supabaseService,
    required HiveService hiveService,
  })  : _supabaseService = supabaseService,
        _hiveService = hiveService;

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
      // Fast local read first
      _streak = _hiveService.getStreak(userId);
      notifyListeners();

      // Then sync from remote
      final data = await _supabaseService.fetchStreak(userId);
      if (data != null) {
        _streak = Streak.fromJson(data);
        await _hiveService.saveStreak(_streak!);
      }
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recordActivity(String userId) async {
    _error = null;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (_streak == null) {
      _streak = Streak(
        id: _uuid.v4(),
        userId: userId,
        currentStreak: 1,
        longestStreak: 1,
        lastActivityDate: todayDate,
      );
    } else {
      final last = _streak!.lastActivityDate;
      if (last != null) {
        final lastDate = DateTime(last.year, last.month, last.day);
        final diff = todayDate.difference(lastDate).inDays;

        if (diff == 0) {
          return; // Already recorded today
        } else if (diff == 1) {
          // Consecutive day
          final newCurrent = _streak!.currentStreak + 1;
          _streak = _streak!.copyWith(
            currentStreak: newCurrent,
            longestStreak:
                newCurrent > _streak!.longestStreak ? newCurrent : null,
            lastActivityDate: todayDate,
          );
        } else {
          // Gap — reset
          _streak = _streak!.copyWith(
            currentStreak: 1,
            lastActivityDate: todayDate,
          );
        }
      } else {
        _streak = _streak!.copyWith(
          currentStreak: 1,
          longestStreak: _streak!.longestStreak < 1 ? 1 : null,
          lastActivityDate: todayDate,
        );
      }
    }

    await _hiveService.saveStreak(_streak!);
    notifyListeners();

    try {
      await _supabaseService.upsertStreak(_streak!.toJson());
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }
}
