// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/review_dashboard_controller.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

import 'package:boo_mondai/services/services.barrel.dart';

class ViewReviewsController extends Controller {
  List<DeckReviewStats> _deckStats = [];
  DueFilterThreshold _dueFilter = DueFilterThreshold.lookAheadOneDay;

  // Cache historical stats so we don't recalculate them on filter change
  Map<String, DeckHistoricalStats>? _cachedHistoricalStats;

  List<DeckReviewStats> get deckStats => _deckStats;
  DueFilterThreshold get dueFilter => _dueFilter;

  int get totalDue => _deckStats.fold(0, (sum, deck) => sum + deck.totalDue);

  void setDueFilter(DueFilterThreshold filter) {
    if (_dueFilter != filter) {
      _dueFilter = filter;
      // We pass "false" so we don't recalculate historical stats
      _loadData(fetchHistorical: false);
    }
  }

  Future<void> load() async {
    // Initial load fetches everything
    await _loadData(fetchHistorical: true);
  }

  Future<void> _loadData({required bool fetchHistorical}) async {
    setLoading(true);
    setError(null);
    notifyListeners();

    try {
      final userId = LocalDB.profile.getOrCreate().id;
      final allDecks = LocalDB.deck.selectMany();
      final deckMap = {for (final d in allDecks) d.id: d};

      // 1. Fetch Historical (Only if requested or not cached)
      if (fetchHistorical || _cachedHistoricalStats == null) {
        _cachedHistoricalStats = Services.fsrs.calculateHistoricalStats(
          userId: userId,
        );
      }

      // 2. Fetch Due (Always calculated based on filter)
      final dueMap = Services.fsrs.calculateDueStats(
        userId: userId,
        dueFilter: _dueFilter,
      );

      // 3. Merge them together for the UI
      final combinedStats = <DeckReviewStats>[];

      for (final deckId in dueMap.keys) {
        final deck = deckMap[deckId];
        final dueStats = dueMap[deckId]!;

        // If a deck has 0 due cards, we skip it entirely for the dashboard
        if (dueStats.totalDue == 0) continue;

        combinedStats.add(
          DeckReviewStats(
            deckId: deckId,
            deckTitle: deck?.title ?? 'Unknown Deck',
            due: dueStats,
            historical:
                _cachedHistoricalStats![deckId] ?? const DeckHistoricalStats(),
          ),
        );
      }

      // Sort by most due cards first
      combinedStats.sort((a, b) => b.totalDue.compareTo(a.totalDue));
      _deckStats = combinedStats;
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }
}
