// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// // PATH: lib/repositories/streak_repository.dart
// // PURPOSE: Hive CRUD for Streak — single-record store that tracks the user's daily activity streak
// // PROVIDERS: none
// // HOOKS: none
// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// import 'package:flutter/material.dart';
// import 'package:hive_ce/hive.dart';
// import 'package:uuid/uuid.dart';
// import '../models/streak.dart';

// class StreakRepository {
//   static const String boxName = 'streak_box';
//   static const String _streakKey = 'streak';
//   static const _uuid = Uuid();

//   Box<Streak> get _box => Hive.box<Streak>(boxName);

//   Streak? get() => _box.get(_streakKey);

//   Future<void> save(Streak streak) => _box.put(_streakKey, streak);

//   Future<void> clear() => _box.clear();

//   Future<Streak> incrementStreak(String userId, DateTime activityDate) async {
//     final existing = get();

//     if (existing == null) {
//       final newStreak = Streak(
//         id: _uuid.v4(),
//         userId: userId,
//         currentStreak: 1,
//         longestStreak: 1,
//         lastActivityDate: activityDate,
//       );
//       await save(newStreak);
//       return newStreak;
//     }

//     // Already counted today — return unchanged
//     if (DateUtils.isSameDay(existing.lastActivityDate, activityDate)) {
//       return existing;
//     }

//     // If no prior activity date, treat as a fresh start
//     if (existing.lastActivityDate == null) {
//       final reset = existing.copyWith(
//         currentStreak: 1,
//         longestStreak: existing.longestStreak < 1 ? 1 : existing.longestStreak,
//         lastActivityDate: activityDate,
//       );
//       await save(reset);
//       return reset;
//     }

//     // Check if lastActivityDate was yesterday (date-only comparison)
//     final lastDate = DateTime(
//       existing.lastActivityDate!.year,
//       existing.lastActivityDate!.month,
//       existing.lastActivityDate!.day,
//     );
//     final currentDate = DateTime(
//       activityDate.year,
//       activityDate.month,
//       activityDate.day,
//     );
//     final differenceInDays = currentDate.difference(lastDate).inDays;

//     final int newCurrentStreak;
//     if (differenceInDays == 1) {
//       // Consecutive day — extend streak
//       newCurrentStreak = existing.currentStreak + 1;
//     } else {
//       // Gap of more than one day — reset streak
//       newCurrentStreak = 1;
//     }

//     final newLongestStreak = newCurrentStreak > existing.longestStreak
//         ? newCurrentStreak
//         : existing.longestStreak;

//     final updated = existing.copyWith(
//       currentStreak: newCurrentStreak,
//       longestStreak: newLongestStreak,
//       lastActivityDate: activityDate,
//     );

//     await save(updated);
//     return updated;
//   }
// }
