import 'package:boo_mondai/features/streak/streak.helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StreakHelper.calculateFromActivityDates', () {
    test('returns zero when there are no activity dates', () {
      final result = StreakHelper.calculateFromActivityDates(
        activityDates: const [],
        now: DateTime(2026, 7, 1, 12),
      );

      expect(result.currentStreak, 0);
      expect(result.longestStreak, 0);
      expect(result.lastActivityDate, isNull);
    });

    test('counts multiple logs on the same day once', () {
      final result = StreakHelper.calculateFromActivityDates(
        activityDates: [DateTime(2026, 7, 1, 9), DateTime(2026, 7, 1, 18)],
        now: DateTime(2026, 7, 1, 20),
      );

      expect(result.currentStreak, 1);
      expect(result.longestStreak, 1);
      expect(result.lastActivityDate, DateTime(2026, 7, 1));
    });

    test('counts consecutive local activity days', () {
      final result = StreakHelper.calculateFromActivityDates(
        activityDates: [
          DateTime(2026, 6, 29, 23),
          DateTime(2026, 6, 30, 8),
          DateTime(2026, 7, 1, 10),
        ],
        now: DateTime(2026, 7, 1, 22),
      );

      expect(result.currentStreak, 3);
      expect(result.longestStreak, 3);
      expect(result.lastActivityDate, DateTime(2026, 7, 1));
    });

    test('keeps yesterday streak alive until today is missed', () {
      final result = StreakHelper.calculateFromActivityDates(
        activityDates: [DateTime(2026, 6, 29, 9), DateTime(2026, 6, 30, 9)],
        now: DateTime(2026, 7, 1, 8),
      );

      expect(result.currentStreak, 2);
      expect(result.longestStreak, 2);
      expect(result.lastActivityDate, DateTime(2026, 6, 30));
    });

    test('resets current streak after missing a full day', () {
      final result = StreakHelper.calculateFromActivityDates(
        activityDates: [DateTime(2026, 6, 28, 9), DateTime(2026, 6, 29, 9)],
        now: DateTime(2026, 7, 1, 8),
      );

      expect(result.currentStreak, 0);
      expect(result.longestStreak, 2);
      expect(result.lastActivityDate, DateTime(2026, 6, 29));
    });
  });
}
