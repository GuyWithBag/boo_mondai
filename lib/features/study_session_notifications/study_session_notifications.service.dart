import 'package:boo_mondai/lib.barrel.dart'
    show
        FsrsCard,
        ImmediateSchedule,
        LocalDB,
        NotificationIds,
        Notifications,
        NotificationsService,
        SettingPath,
        SettingsStore;

abstract final class StudySessionNotificationsService {
  static const scheduleWindow = Duration(days: 7);

  static Future<void> rescheduleAfterSession({
    required String profileId,
    required String? deckId,
  }) async {
    if (deckId == null) return;
    if (!SettingsStore.instance.get<bool>(
      SettingPath.studyDeckNotificationsEnabled,
    )) {
      await cancelDeckSchedule(deckId: deckId);
      return;
    }

    await rescheduleDeck(profileId: profileId, deckId: deckId);
  }

  static Future<void> rescheduleDeck({
    required String profileId,
    required String deckId,
  }) async {
    await cancelDeckSchedule(deckId: deckId);

    final deck = LocalDB.deck.selectByPk({'id': deckId});
    if (deck == null) return;

    final deckStudyCardIds = LocalDB.studyCard
        .getByDeckId(deckId)
        .map((card) => card.id)
        .toSet();
    if (deckStudyCardIds.isEmpty) return;

    final fsrsCards = LocalDB.fsrsCard
        .selectManyByProfileIdAndStudyCardIds(
          profileId: profileId,
          studyCardIds: deckStudyCardIds,
        )
        .where((card) => deckStudyCardIds.contains(card.studyCardId))
        .toList();
    if (fsrsCards.isEmpty) return;

    final now = DateTime.now();
    final today = _localDay(now);
    final windowEnd = today.add(scheduleWindow);
    final groups = _groupFsrsDueTimesByDay(
      fsrsCards,
      deckStudyCardIds,
      windowEnd,
    );

    for (final entry in groups.entries) {
      final day = entry.key;
      final dueTimes = entry.value..sort();
      if (dueTimes.isEmpty) continue;

      final nextDue = dueTimes.first;
      final id = NotificationIds.studyDeckReview(deckId: deckId, day: day);
      final body = _bodyForDay(
        count: dueTimes.length,
        day: day,
        today: today,
        nextDue: nextDue,
        now: now,
      );

      await NotificationsService.show(
        Notifications.studyDeckReview(
          id: id,
          deckTitle: deck.title,
          body: body,
        ),
        day == today
            ? const ImmediateSchedule.now()
            : ImmediateSchedule.at(nextDue),
      );
    }
  }

  static Future<void> cancelDeckSchedule({required String deckId}) async {
    final today = _localDay(DateTime.now());
    for (var offset = 0; offset <= scheduleWindow.inDays; offset++) {
      final day = today.add(Duration(days: offset));
      await NotificationsService.cancel(
        NotificationIds.studyDeckReview(deckId: deckId, day: day),
      );
    }
  }

  static Map<DateTime, List<DateTime>> _groupFsrsDueTimesByDay(
    List<FsrsCard> fsrsCards,
    Set<String> deckStudyCardIds,
    DateTime windowEnd,
  ) {
    final groups = <DateTime, List<DateTime>>{};

    for (final fsrsCard in fsrsCards) {
      if (!deckStudyCardIds.contains(fsrsCard.studyCardId)) continue;

      final due = fsrsCard.state.due.toLocal();
      final day = _localDay(due);
      if (day.isAfter(windowEnd)) continue;

      groups.putIfAbsent(day, () => []).add(due);
    }

    return groups;
  }

  static String _bodyForDay({
    required int count,
    required DateTime day,
    required DateTime today,
    required DateTime nextDue,
    required DateTime now,
  }) {
    final cardLabel = count == 1 ? 'card' : 'cards';

    if (day != today) {
      return '$count $cardLabel will be ready to review.';
    }

    if (!nextDue.isAfter(now)) {
      return '$count $cardLabel ready to review.';
    }

    return '$count $cardLabel today. Your next card is in ${_relativeMinutes(nextDue.difference(now))}.';
  }

  static String _relativeMinutes(Duration duration) {
    final minutes = duration.inMinutes <= 0 ? 1 : duration.inMinutes;
    if (minutes < 60) {
      return minutes == 1 ? '1 minute' : '$minutes minutes';
    }

    final hours = duration.inHours;
    final remainingMinutes = duration.inMinutes.remainder(60);
    final hourLabel = hours == 1 ? '1 hour' : '$hours hours';
    if (remainingMinutes == 0) return hourLabel;

    final minuteLabel = remainingMinutes == 1
        ? '1 minute'
        : '$remainingMinutes minutes';
    return '$hourLabel $minuteLabel';
  }

  static DateTime _localDay(DateTime value) {
    final local = value.toLocal();
    return DateTime(local.year, local.month, local.day);
  }
}
