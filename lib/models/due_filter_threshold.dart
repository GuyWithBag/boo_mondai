// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/due_filter_threshold.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

enum DueFilterThreshold {
  exactAndOverdue,
  lookAheadOneHour,
  lookAheadOneDay,
  cramAll, // Useful for studying ahead of a test
}

extension DueFilterExtension on DueFilterThreshold {
  /// Returns true if the card's due date falls within the selected threshold
  bool isCardDue(DateTime due, DateTime now) {
    switch (this) {
      case DueFilterThreshold.exactAndOverdue:
        return due.isBefore(now) || due.isAtSameMomentAs(now);

      case DueFilterThreshold.lookAheadOneHour:
        return due.isBefore(now.add(const Duration(hours: 1)));

      case DueFilterThreshold.lookAheadOneDay:
        return due.isBefore(now.add(const Duration(days: 1)));

      case DueFilterThreshold.cramAll:
        return true; // Ignore the due date completely
    }
  }

  /// A user-friendly label for your UI dropdowns/settings
  String get label {
    switch (this) {
      case DueFilterThreshold.exactAndOverdue:
        return 'Exact & Overdue';
      case DueFilterThreshold.lookAheadOneHour:
        return 'Due in < 1 Hour';
      case DueFilterThreshold.lookAheadOneDay:
        return 'Due in < 1 Day';
      case DueFilterThreshold.cramAll:
        return 'Study All Cards';
    }
  }
}
