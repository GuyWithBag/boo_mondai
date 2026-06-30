import 'package:boo_mondai/lib.barrel.dart'
    show StudyDeckSearchFilter, StudyDeckEntry, SearchResults;
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

final class StudyDeckSearchResults
    implements SearchResults<StudyDeckEntry, StudyDeckSearchFilter> {
  const StudyDeckSearchResults();

  @override
  List<StudyDeckEntry> resolve({
    required Iterable<StudyDeckEntry> items,
    required StudyDeckSearchFilter filter,
  }) {
    final normalizedFreeText = filter.freeText.trim();

    if (normalizedFreeText.isEmpty) {
      return items.toList();
    }

    return extractAllSorted<StudyDeckEntry>(
      query: normalizedFreeText,
      choices: items.toList(),
      cutoff: filter.fuzzyCutoff,
      getter: _searchText,
    ).map((result) => result.choice).toList();
  }

  String _searchText(StudyDeckEntry entry) {
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
