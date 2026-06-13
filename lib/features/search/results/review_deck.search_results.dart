import 'package:boo_mondai/features/search/filters/review_deck.search_filter.dart';
import 'package:boo_mondai/features/search/results/search_results.dart';
import 'package:boo_mondai/features/view_reviews/models/review_deck_entry.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

final class ReviewDeckSearchResults
    implements SearchResults<ReviewDeckEntry, ReviewDeckSearchFilter> {
  const ReviewDeckSearchResults();

  @override
  List<ReviewDeckEntry> resolve({
    required Iterable<ReviewDeckEntry> items,
    required ReviewDeckSearchFilter filter,
  }) {
    final normalizedFreeText = filter.freeText.trim();

    if (normalizedFreeText.isEmpty) {
      return items.toList();
    }

    return extractAllSorted<ReviewDeckEntry>(
      query: normalizedFreeText,
      choices: items.toList(),
      cutoff: filter.fuzzyCutoff,
      getter: _searchText,
    ).map((result) => result.choice).toList();
  }

  String _searchText(ReviewDeckEntry entry) {
    final historical = entry.stats.historical;
    final due = entry.stats.due;
    return [
      entry.deck.title,
      entry.stats.deckId,
      entry.stats.deckTitle,
      entry.totalDue.toString(),
      due.dueNew.toString(),
      due.dueLearning.toString(),
      due.dueReview.toString(),
      historical.again.toString(),
      historical.hard.toString(),
      historical.good.toString(),
      historical.easy.toString(),
    ].join(' ');
  }
}
