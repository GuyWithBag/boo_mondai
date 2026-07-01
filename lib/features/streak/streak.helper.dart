import 'package:boo_mondai/core/helpers/date.helper.dart';

class StreakCalculation {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;

  const StreakCalculation({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActivityDate,
  });
}

abstract final class StreakHelper {
  static int effectiveCurrentStreak({
    required int currentStreak,
    required DateTime? lastActivityDate,
    required DateTime now,
  }) {
    if (lastActivityDate == null) return 0;

    final daysSinceLastActivity = DateHelper.daysBetweenLocalDates(
      lastActivityDate,
      now,
    );

    return daysSinceLastActivity <= 1 ? currentStreak : 0;
  }

  static StreakCalculation calculateFromActivityDates({
    required Iterable<DateTime> activityDates,
    required DateTime now,
  }) {
    final activityDays = activityDates.map(DateHelper.localDateOnly).toSet()
      ..removeWhere((date) => date.isAfter(DateHelper.localDateOnly(now)));

    final sortedDays = activityDays.toList()..sort();

    if (sortedDays.isEmpty) {
      return const StreakCalculation(
        currentStreak: 0,
        longestStreak: 0,
        lastActivityDate: null,
      );
    }

    var longestStreak = 1;
    var currentRun = 1;
    final lastActivityDate = sortedDays.last;

    for (var i = 1; i < sortedDays.length; i++) {
      final previous = sortedDays[i - 1];
      final current = sortedDays[i];
      final daysBetween = DateHelper.daysBetweenLocalDates(previous, current);

      currentRun = daysBetween == 1 ? currentRun + 1 : 1;

      if (currentRun > longestStreak) {
        longestStreak = currentRun;
      }
    }

    final currentStreak = effectiveCurrentStreak(
      currentStreak: currentRun,
      lastActivityDate: lastActivityDate,
      now: now,
    );

    return StreakCalculation(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastActivityDate: lastActivityDate,
    );
  }
}
