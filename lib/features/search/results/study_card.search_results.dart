import 'package:boo_mondai/lib.barrel.dart'
    show SearchResults, StudyCard, StudyCardSearchFilter;
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

final class StudyCardSearchResults
    implements SearchResults<StudyCard, StudyCardSearchFilter> {
  const StudyCardSearchResults();

  @override
  List<StudyCard> resolve({
    required Iterable<StudyCard> items,
    required StudyCardSearchFilter filter,
  }) {
    final selectedTagNames = filter.tagNames
        .map((tagName) => tagName.trim().toLowerCase())
        .where((tagName) => tagName.isNotEmpty)
        .toSet();
    final normalizedFreeText = filter.freeText.trim();

    var filtered = items.where((card) {
      if (filter.deckIds.isNotEmpty && !filter.deckIds.contains(card.deckId)) {
        return false;
      }

      if (filter.templateIds.isNotEmpty &&
          !filter.templateIds.contains(card.templateId)) {
        return false;
      }

      if (filter.isReversed != null && card.isReversed != filter.isReversed) {
        return false;
      }

      if (filter.tagIds.isNotEmpty &&
          !filter.tagIds.every(
            (tagId) => card.personalTags.any((tag) => tag.id == tagId),
          )) {
        return false;
      }

      if (selectedTagNames.isNotEmpty &&
          !selectedTagNames.every(
            (tagName) => card.personalTags.any(
              (tag) => tag.name.toLowerCase() == tagName,
            ),
          )) {
        return false;
      }

      return true;
    }).toList();

    if (normalizedFreeText.isNotEmpty) {
      filtered = extractAllSorted<StudyCard>(
        query: normalizedFreeText,
        choices: filtered,
        cutoff: filter.fuzzyCutoff,
        getter: _studyCardSearchText,
      ).map((result) => result.choice).toList();
    }

    return filtered;
  }

  String _studyCardSearchText(StudyCard card) {
    final tagNames = card.personalTags.map((tag) => tag.name).join(' ');
    return [
      card.id,
      card.deckId,
      card.templateId,
      card.deck?.title,
      card.template?.id,
      tagNames,
    ].whereType<String>().join(' ');
  }
}
