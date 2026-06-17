// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/review_dashboard_controller.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        Deck,
        DeckReviewStats,
        DeckHistoricalStats,
        LocalDB,
        Services;
import 'package:boo_mondai/features/decks/models/visibility_state.dto.dart';
import 'package:boo_mondai/features/search/filters/review_deck.search_filter.dart';
import 'package:boo_mondai/features/search/filters/review_deck.search_filter_codec.dart';
import 'package:boo_mondai/features/search/results/review_deck.search_results.dart';
import 'package:boo_mondai/features/study_session/models/due_filter_threshold.dart';
import 'package:boo_mondai/features/view_reviews/models/review_deck_entry.dart';

class ViewReviewsController extends Controller {
  static const reviewSearchFilterCodec = ReviewDeckSearchFilterCodec();
  static const reviewSearchResults = ReviewDeckSearchResults();

  List<ReviewDeckEntry> _deckEntries = [];
  ReviewDeckSearchFilter _reviewFilter = const ReviewDeckSearchFilter(
    freeText: '',
    dueFilter: DueFilterThreshold.lookAheadOneDay,
    fuzzyCutoff: 60,
  );

  // Cache historical stats so we don't recalculate them on filter change
  Map<String, DeckHistoricalStats>? _cachedHistoricalStats;

  List<ReviewDeckEntry> get deckEntries => List.unmodifiable(_deckEntries);
  List<DeckReviewStats> get deckStats =>
      _deckEntries.map((entry) => entry.stats).toList(growable: false);
  ReviewDeckSearchFilter get reviewFilter => _reviewFilter;
  DueFilterThreshold get dueFilter => _reviewFilter.dueFilter;

  int get totalDue => _deckEntries.fold(0, (sum, deck) => sum + deck.totalDue);

  void setReviewFilter(ReviewDeckSearchFilter filter) {
    if (_reviewFilter.freeText == filter.freeText &&
        _reviewFilter.dueFilter == filter.dueFilter &&
        _reviewFilter.fuzzyCutoff == filter.fuzzyCutoff) {
      return;
    }

    final dueFilterChanged = _reviewFilter.dueFilter != filter.dueFilter;
    _reviewFilter = filter;

    if (!dueFilterChanged) return;

    _loadData(fetchHistorical: false);
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
        dueFilter: _reviewFilter.dueFilter,
      );

      // 3. Merge them together for the UI
      final combinedEntries = <ReviewDeckEntry>[];

      for (final deckId in dueMap.keys) {
        final deck = deckMap[deckId];
        final dueStats = dueMap[deckId]!;

        // If a deck has 0 due cards, we skip it entirely for the dashboard
        if (dueStats.totalDue == 0) continue;

        final stats = DeckReviewStats(
          deckId: deckId,
          deckTitle: deck?.title ?? 'Unknown Deck',
          due: dueStats,
          historical:
              _cachedHistoricalStats![deckId] ?? const DeckHistoricalStats(),
        );

        combinedEntries.add(
          ReviewDeckEntry(
            deck:
                deck ??
                Deck(
                  id: deckId,
                  userId: userId,
                  title: stats.deckTitle,
                  visibilityState: VisibilityState.private,
                  isPublished: false,
                  cardCount: 0,
                  createdAt: DateTime.fromMillisecondsSinceEpoch(0),
                  updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
                ),
            stats: stats,
          ),
        );
      }

      // Sort by most due cards first
      combinedEntries.sort((a, b) => b.totalDue.compareTo(a.totalDue));
      _deckEntries = combinedEntries;
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }
}
