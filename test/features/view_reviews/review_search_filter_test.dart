import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/review.study_session/models/deck_review_stats.dart'
    show DeckDueStats, DeckHistoricalStats, DeckReviewStats;
import 'package:boo_mondai/features/search/filters/review_deck.search_filter.dart';
import 'package:boo_mondai/features/search/results/review_deck.search_results.dart';
import 'package:boo_mondai/features/study_session/models/due_filter_threshold.dart';
import 'package:boo_mondai/features/view_reviews/models/review_deck_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses review filter directives', () {
    final filter = ReviewDeckSearchFilter.parse('japanese due:1h fuzzy:42');

    expect(filter.freeText, 'japanese');
    expect(filter.dueFilter, DueFilterThreshold.lookAheadOneHour);
    expect(filter.fuzzyCutoff, 42);
    expect(filter.toSearchText(), 'japanese due:1h fuzzy:42');
  });

  test('filters review entries by free text', () {
    final entries = [
      ReviewDeckEntry(
        deck: Deck.createNow(
          userId: 'user-1',
          title: 'Japanese Basics',
          isPublished: false,
        ),
        stats: const DeckReviewStats(
          deckId: 'deck-1',
          deckTitle: 'Japanese Basics',
          due: DeckDueStats(dueNew: 2, dueReview: 3),
          historical: DeckHistoricalStats(again: 1, hard: 2, good: 3, easy: 4),
        ),
      ),
      ReviewDeckEntry(
        deck: Deck.createNow(
          userId: 'user-1',
          title: 'French Basics',
          isPublished: false,
        ),
        stats: const DeckReviewStats(
          deckId: 'deck-2',
          deckTitle: 'French Basics',
          due: DeckDueStats(dueNew: 1, dueReview: 1),
          historical: DeckHistoricalStats(),
        ),
      ),
    ];

    final results = const ReviewDeckSearchResults().resolve(
      items: entries,
      filter: ReviewDeckSearchFilter.parse('japanese'),
    );

    expect(results, hasLength(1));
    expect(results.single.deck.title, 'Japanese Basics');
  });
}
