import 'package:boo_mondai/lib.barrel.dart'
    show
        StudyDeckSearchFilter,
        DueFilterThreshold,
        DeckReviewStats,
        StudyDeckSearchResults,
        Deck,
        DeckDueStats,
        DeckHistoricalStats,
        StudyDeckEntry;

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses review filter directives', () {
    final filter = StudyDeckSearchFilter.parse('japanese due:1h fuzzy:42');

    expect(filter.freeText, 'japanese');
    expect(filter.dueFilter, DueFilterThreshold.lookAheadOneHour);
    expect(filter.fuzzyCutoff, 42);
    expect(filter.toSearchText(), 'japanese due:1h fuzzy:42');
  });

  test('filters review entries by free text', () {
    final entries = [
      StudyDeckEntry(
        deck: Deck.createNow(
          profileId: 'user-1',
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
      StudyDeckEntry(
        deck: Deck.createNow(
          profileId: 'user-1',
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

    final results = const StudyDeckSearchResults().resolve(
      items: entries,
      filter: StudyDeckSearchFilter.parse('japanese'),
    );

    expect(results, hasLength(1));
    expect(results.single.deck.title, 'Japanese Basics');
  });
}
