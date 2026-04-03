// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/review_dashboard_controller.dart
// PURPOSE: Aggregates FSRS cards and logs into deck-by-deck stats
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/deck_review_stats.dart';
import 'package:boo_mondai/repositories/repositories.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

class ReviewDashboardController extends ChangeNotifier {
  bool _isLoading = true;
  String? _error;
  List<DeckReviewStats> _deckStats = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<DeckReviewStats> get deckStats => _deckStats;

  int get totalDue => _deckStats.fold(0, (sum, deck) => sum + deck.totalDue);

  Future<void> loadDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = Services.auth.currentUser!.id;
      final now = DateTime.now();

      // 1. Fetch raw data
      final allFsrsCards = Repositories.fsrsCard.getByUserId(userId);
      final allDecks = Repositories.deck.getAll();
      final allReviewCards = Repositories.reviewCard.getAll();
      final allLogs = Repositories.reviewLog.getAll();

      // 2. Create lookup maps for performance
      final deckMap = {for (final d in allDecks) d.id: d};
      final rcToDeck = {for (final rc in allReviewCards) rc.id: rc.deckId};

      // 3. Temporary accumulators for grouping
      final dueNewMap = <String, int>{};
      final dueLearnMap = <String, int>{};
      final dueReviewMap = <String, int>{};
      final againMap = <String, int>{};
      final hardMap = <String, int>{};
      final goodMap = <String, int>{};
      final easyMap = <String, int>{};

      // ── Determine studied cards to override default FSRS "Learning" state ──
      final studiedCardIds = allLogs.map((log) => log.cardId).toSet();

      // 4. Process Due Cards
      for (final fsrsCard in allFsrsCards) {
        final deckId = rcToDeck[fsrsCard.reviewCardId];
        if (deckId == null) continue;

        // Is it due?
        if (fsrsCard.state.due.isBefore(now) ||
            fsrsCard.state.due.isAtSameMomentAs(now)) {
          final state = fsrsCard.state.state;

          if (!studiedCardIds.contains(fsrsCard.id)) {
            // If there are no logs for this card, it is brand new!
            dueNewMap[deckId] = (dueNewMap[deckId] ?? 0) + 1;
          } else if (state == fsrs.State.learning ||
              state == fsrs.State.relearning) {
            dueLearnMap[deckId] = (dueLearnMap[deckId] ?? 0) + 1;
          } else {
            dueReviewMap[deckId] = (dueReviewMap[deckId] ?? 0) + 1;
          }
        }
      }

      // 5. Process Historical Logs
      for (final log in allLogs) {
        final fsrsCard = Repositories.fsrsCard.getById(log.cardId);
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

      // 6. Assemble the final stats list
      final Set<String> activeDeckIds = {
        ...dueNewMap.keys,
        ...dueLearnMap.keys,
        ...dueReviewMap.keys,
        ...againMap.keys,
        ...hardMap.keys,
        ...goodMap.keys,
        ...easyMap.keys,
      };

      _deckStats = activeDeckIds.map((deckId) {
        final deck = deckMap[deckId];
        return DeckReviewStats(
          deckId: deckId,
          deckTitle: deck?.title ?? 'Unknown Deck',
          dueNew: dueNewMap[deckId] ?? 0,
          dueLearning: dueLearnMap[deckId] ?? 0,
          dueReview: dueReviewMap[deckId] ?? 0,
          historicalAgain: againMap[deckId] ?? 0,
          historicalHard: hardMap[deckId] ?? 0,
          historicalGood: goodMap[deckId] ?? 0,
          historicalEasy: easyMap[deckId] ?? 0,
        );
      }).toList();

      // Sort by most due cards first
      _deckStats.sort((a, b) => b.totalDue.compareTo(a.totalDue));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
