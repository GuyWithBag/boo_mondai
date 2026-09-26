// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/review_dashboard_controller.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckReviewStats,
        DeckRatingStats,
        LocalDB,
        StudyDeckEntry,
        DueFilterThreshold,
        FsrsService;
import 'package:signals/signals_flutter.dart';

class ViewStudyDecksController {
  final deckEntries = signal<List<StudyDeckEntry>>(const []);
  final dueFilter = signal(DueFilterThreshold.lookAheadOneDay);
  final cachedHistoricalStats = signal<Map<String, DeckRatingStats>?>(null);
  final isLoading = signal(false);
  final error = signal<Exception?>(null);

  late final deckStats = computed(
    () => deckEntries.value.map((entry) => entry.stats).toList(growable: false),
  );
  late final totalDue = computed(
    () => deckEntries.value.fold(0, (sum, deck) => sum + deck.totalDue),
  );

  void setDueFilter(DueFilterThreshold value) {
    if (dueFilter.value == value) return;
    dueFilter.value = value;
    load(getRatingStats: false);
  }

  Future<void> load({bool getRatingStats = true}) async {
    isLoading.value = true;
    error.value = null;

    try {
      final profileId = LocalDB.currentProfile.getOrCreate().id;
      final allDecks = LocalDB.deck.selectMany();

      if (getRatingStats || cachedHistoricalStats.value == null) {
        cachedHistoricalStats.value = FsrsService.calculateHistoricalStats(
          profileId: profileId,
        );
      }

      final dueMap = FsrsService.calculateDueStats(
        profileId: profileId,
        dueFilter: dueFilter.value,
      );

      final combinedEntries = <StudyDeckEntry>[];

      for (final deck in allDecks) {
        final dueStats = dueMap[deck.id];
        if (dueStats == null || dueStats.totalDue == 0) continue;

        final stats = DeckReviewStats(
          deck: deck,
          due: dueStats,
          historical:
              cachedHistoricalStats.value![deck.id] ?? const DeckRatingStats(),
        );

        combinedEntries.add(StudyDeckEntry(deck: deck, stats: stats));
      }

      combinedEntries.sort((a, b) => b.totalDue.compareTo(a.totalDue));
      deckEntries.value = List.unmodifiable(combinedEntries);
    } on Exception catch (e) {
      error.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    totalDue.dispose();
    deckStats.dispose();
    error.dispose();
    isLoading.dispose();
    cachedHistoricalStats.dispose();
    dueFilter.dispose();
    deckEntries.dispose();
  }
}
