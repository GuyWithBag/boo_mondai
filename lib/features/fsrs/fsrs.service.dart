// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/fsrs_service.dart
// PURPOSE: Wraps the fsrs dart package for spaced repetition scheduling
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        FsrsCard,
        FsrsReviewLog,
        DueFilterThreshold,
        DeckDueStats,
        DeckHistoricalStats,
        LocalDB,
        DueFilterExtension;
import 'package:fsrs/fsrs.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

class FsrsService {
  final Scheduler scheduler = Scheduler();

  // Reviews card and puts it in the Repository
  Future<void> enrollCard({
    required FsrsCard card,
    required Rating rating,
    DateTime? reviewDateTime, // ── NEW PARAMETER ──
  }) async {
    // ── FSRS STRICT REQUIREMENT: MUST BE UTC ──
    final utcReviewTime = reviewDateTime?.toUtc();

    final res = scheduler.reviewCard(
      card.state.copyWith(),
      rating,
      reviewDateTime: utcReviewTime, // ── PASS TO SCHEDULER ──
    );

    final newCard = card.copyWith(state: res.card);
    final newLog = FsrsReviewLog.create(log: res.reviewLog, cardId: newCard.id);

    await LocalDB.fsrsCard.upsert(newCard);
    await LocalDB.reviewLog.upsert(newLog);
  }

  // ── Due Stats (Calculated dynamically based on time/filter) ──
  Map<String, DeckDueStats> calculateDueStats({
    required String userId,
    required DueFilterThreshold dueFilter,
  }) {
    final now = DateTime.now();
    final allFsrsCards = LocalDB.fsrsCard.getByUserId(userId);
    final allReviewCards = LocalDB.reviewCard.selectMany();
    final rcToDeck = {for (final rc in allReviewCards) rc.id: rc.deckId};

    // We only need logs to determine if a card is "New" or "Learning"
    final studiedCardIds = LocalDB.reviewLog
        .selectMany()
        .map((l) => l.fsrsCardId)
        .toSet();

    final dueNewMap = <String, int>{};
    final dueLearnMap = <String, int>{};
    final dueReviewMap = <String, int>{};

    for (final fsrsCard in allFsrsCards) {
      final deckId = rcToDeck[fsrsCard.reviewCardId];
      if (deckId == null) continue;

      // Let your filter decide, regardless of whether it's Learning or Review!
      if (dueFilter.isCardDue(fsrsCard.state.due, now)) {
        final state = fsrsCard.state.state;

        if (!studiedCardIds.contains(fsrsCard.id)) {
          dueNewMap[deckId] = (dueNewMap[deckId] ?? 0) + 1;
        } else if (state == fsrs.State.learning ||
            state == fsrs.State.relearning) {
          dueLearnMap[deckId] = (dueLearnMap[deckId] ?? 0) + 1;
        } else {
          dueReviewMap[deckId] = (dueReviewMap[deckId] ?? 0) + 1;
        }
      }
    }

    // Convert map of counters into a map of DeckDueStats
    final activeDeckIds = {
      ...dueNewMap.keys,
      ...dueLearnMap.keys,
      ...dueReviewMap.keys,
    };
    return {
      for (final id in activeDeckIds)
        id: DeckDueStats(
          dueNew: dueNewMap[id] ?? 0,
          dueLearning: dueLearnMap[id] ?? 0,
          dueReview: dueReviewMap[id] ?? 0,
        ),
    };
  }

  // ── Historical Stats (Calculated once, independent of time) ──
  Map<String, DeckHistoricalStats> calculateHistoricalStats({
    required String userId,
  }) {
    final allLogs = LocalDB.reviewLog.selectMany();
    // In a real app, you'd want to query logs by userId, but relying on the card relation works for now
    final allReviewCards = LocalDB.reviewCard.selectMany();
    final rcToDeck = {for (final rc in allReviewCards) rc.id: rc.deckId};

    final againMap = <String, int>{};
    final hardMap = <String, int>{};
    final goodMap = <String, int>{};
    final easyMap = <String, int>{};

    for (final log in allLogs) {
      final fsrsCard = LocalDB.fsrsCard.selectByPk({'id': log.fsrsCardId});
      if (fsrsCard == null) continue;

      final deckId = rcToDeck[fsrsCard.reviewCardId];
      if (deckId == null) continue;

      switch (log.rating) {
        case fsrs.Rating.again:
          againMap[deckId] = (againMap[deckId] ?? 0) + 1;
          break;
        case fsrs.Rating.hard:
          hardMap[deckId] = (hardMap[deckId] ?? 0) + 1;
          break;
        case fsrs.Rating.good:
          goodMap[deckId] = (goodMap[deckId] ?? 0) + 1;
          break;
        case fsrs.Rating.easy:
          easyMap[deckId] = (easyMap[deckId] ?? 0) + 1;
          break;
      }
    }

    final activeDeckIds = {
      ...againMap.keys,
      ...hardMap.keys,
      ...goodMap.keys,
      ...easyMap.keys,
    };
    return {
      for (final id in activeDeckIds)
        id: DeckHistoricalStats(
          again: againMap[id] ?? 0,
          hard: hardMap[id] ?? 0,
          good: goodMap[id] ?? 0,
          easy: easyMap[id] ?? 0,
        ),
    };
  }
}
