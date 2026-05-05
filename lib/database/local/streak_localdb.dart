// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/streak_repository.dart
// PURPOSE: Hive CRUD for Streak — single record per user with activity tracking
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart';

class StreakLocalDB extends HiveLocalDB<Streak> {
  @override
  String get boxName => 'streak_box';

  @override
  String getId(Streak item) => item.userId;

  Streak? getByUserId(String userId) => box.get(userId);

  /// Records an activity for [userId] on [activityDate] and returns the
  /// updated [Streak]. Handles first-time, same-day, consecutive, and
  /// broken-streak cases.
  Future<Streak> recordActivity(String userId, DateTime activityDate) async {
    final existing = getByUserId(userId);

    if (existing == null) {
      final created = Streak(
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        id: UuidService.uuid.v4(),
        userId: userId,
        currentStreak: 1,
        longestStreak: 1,
        lastActivityDate: activityDate,
      );
      await put(created);
      return created;
    }

    // Already counted today — no-op
    if (existing.lastActivityDate != null &&
        DateUtils.isSameDay(existing.lastActivityDate, activityDate)) {
      return existing;
    }

    final int newCurrent;
    if (existing.lastActivityDate == null) {
      newCurrent = 1;
    } else {
      final lastDay = DateTime(
        existing.lastActivityDate!.year,
        existing.lastActivityDate!.month,
        existing.lastActivityDate!.day,
      );
      final today = DateTime(
        activityDate.year,
        activityDate.month,
        activityDate.day,
      );
      newCurrent = today.difference(lastDay).inDays == 1
          ? existing.currentStreak + 1
          : 1;
    }

    final newLongest = newCurrent > existing.longestStreak
        ? newCurrent
        : existing.longestStreak;

    final updated = existing.copyWith(
      currentStreak: newCurrent,
      longestStreak: newLongest,
      lastActivityDate: activityDate,
    );
    await put(updated);
    return updated;
  }
}
