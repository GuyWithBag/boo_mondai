// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/streak_repository.dart
// PURPOSE: Hive CRUD for Streak — single record per user with activity tracking
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';

class StreakLocalDB extends HiveSingleDataLocalDB<Streak> {
  @override
  String get boxName => 'streaks';

  @override
  String getId(Streak item) => item.profileId;

  // This is not used.
  @override
  Streak createValue() => Streak(
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
    id: uuid.v7(),
    profileId: LocalDB.profile.getOrCreate().id,
    currentStreak: 0,
    longestStreak: 0,
    lastActivityDate: null,
  );

  @override
  Streak? retrieve() {
    final streak = super.retrieve();
    if (streak == null) return null;

    final effectiveCurrentStreak = StreakHelper.effectiveCurrentStreak(
      currentStreak: streak.currentStreak,
      lastActivityDate: streak.lastActivityDate,
      now: DateTime.now(),
    );

    if (effectiveCurrentStreak == streak.currentStreak) {
      return streak;
    }

    return streak.copyWith(currentStreak: effectiveCurrentStreak);
  }

  /// Records an activity for [userId] on [activityDate] and returns the
  /// updated [Streak]. Handles first-time, same-day, consecutive, and
  /// broken-streak cases.
  Future<Streak> recordActivity(DateTime activityDate) => guard(() async {
    final existing = retrieve();

    if (existing == null) {
      final created = Streak(
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        id: uuid.v7(),
        profileId: LocalDB.profile.getOrCreate().id,
        currentStreak: 1,
        longestStreak: 1,
        lastActivityDate: activityDate,
      );
      await upsert(created);
      return created;
    }

    if (existing.lastActivityDate != null &&
        DateHelper.isSameLocalDate(existing.lastActivityDate!, activityDate)) {
      return existing;
    }

    final int newCurrent;
    if (existing.lastActivityDate == null) {
      newCurrent = 1;
    } else {
      newCurrent =
          DateHelper.daysBetweenLocalDates(
                existing.lastActivityDate!,
                activityDate,
              ) ==
              1
          ? existing.currentStreak + 1
          : 1;
    }

    final newLongest = newCurrent > existing.longestStreak
        ? newCurrent
        : existing.longestStreak;

    final updated = existing.copyWith(
      updatedAt: DateTime.now(),
      currentStreak: newCurrent,
      longestStreak: newLongest,
      lastActivityDate: activityDate,
    );
    await upsert(updated);
    return updated;
  }, action: 'recordActivity');
}
