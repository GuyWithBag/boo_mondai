abstract final class NotificationIds {
  static const int reviewReminder = 1;
  static const int streakReminder = 2;
  static const int downloadComplete = 3;
  static const int syncComplete = 4;
  static const int firstDrillSurvey = 5;

  static const int dynamicIdOffset = 100000;
  static const int dynamicIdRange = 1800000;

  static int studyDeckReview({required String deckId, required DateTime day}) {
    final localDay = DateTime(day.year, day.month, day.day);
    return dynamicIdOffset +
        _stableHash('$deckId:${localDay.toIso8601String()}');
  }

  static int _stableHash(String value) {
    var hash = 0x811c9dc5;
    for (final unit in value.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash % dynamicIdRange;
  }
}
