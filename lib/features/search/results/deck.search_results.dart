import 'package:boo_mondai/lib.barrel.dart'
    show
        SearchResults,
        Deck,
        DeckSearchFilter,
        DeckSearchSortField,
        SearchSortDirection,
        Tag;
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

final class DeckSearchResults implements SearchResults<Deck, DeckSearchFilter> {
  const DeckSearchResults();

  @override
  List<Deck> resolve({
    required Iterable<Deck> items,
    required DeckSearchFilter filter,
  }) {
    final selectedTagNames = filter.tagNames
        .map((tagName) => tagName.trim().toLowerCase())
        .where((tagName) => tagName.isNotEmpty)
        .toSet();
    final normalizedFreeText = filter.freeText.trim();

    var filtered = items.where((deck) {
      if (filter.tagIds.isNotEmpty &&
          !filter.tagIds.every((tagId) => _hasTagId(deck, tagId))) {
        return false;
      }

      if (selectedTagNames.isNotEmpty &&
          !selectedTagNames.every((tagName) => _hasTagName(deck, tagName))) {
        return false;
      }

      return true;
    }).toList();

    if (normalizedFreeText.isNotEmpty) {
      filtered = extractAllSorted<Deck>(
        query: normalizedFreeText,
        choices: filtered,
        cutoff: filter.fuzzyCutoff,
        getter: _deckSearchText,
      ).map((result) => result.choice).toList();
    }

    return sortDecks(
      filtered,
      field: filter.sortField,
      direction: filter.sortDirection,
    );
  }

  List<Deck> resolveText({
    required Iterable<Deck> items,
    required String input,
    DeckSearchSortField defaultSortField = DeckSearchSortField.updatedAt,
    SearchSortDirection defaultSortDirection = SearchSortDirection.descending,
    int defaultFuzzyCutoff = 60,
  }) {
    return resolve(
      items: items,
      filter: DeckSearchFilter.parse(
        input,
        defaultSortField: defaultSortField,
        defaultSortDirection: defaultSortDirection,
        defaultFuzzyCutoff: defaultFuzzyCutoff,
      ),
    );
  }

  List<Deck> sortDecks(
    Iterable<Deck> decks, {
    DeckSearchSortField field = DeckSearchSortField.updatedAt,
    SearchSortDirection direction = SearchSortDirection.descending,
  }) {
    final sorted = decks.toList();
    sorted.sort((a, b) {
      final comparison = switch (field) {
        DeckSearchSortField.letters => a.title.toLowerCase().compareTo(
          b.title.toLowerCase(),
        ),
        DeckSearchSortField.createdAt => a.createdAt.compareTo(b.createdAt),
        DeckSearchSortField.updatedAt => a.updatedAt.compareTo(b.updatedAt),
      };

      return direction == SearchSortDirection.ascending
          ? comparison
          : -comparison;
    });

    return sorted;
  }

  List<Tag> availableTags(Iterable<Deck> decks) {
    final tagMap = <String, Tag>{};

    for (final deck in decks) {
      for (final tag in deck.tags) {
        tagMap[tag.id] = tag;
      }
    }

    return tagMap.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  String _deckSearchText(Deck deck) {
    final tagNames = deck.tags.map((tag) => tag.name).join(' ');
    return [
      deck.title,
      deck.shortDescription,
      deck.longDescription,
      tagNames,
    ].join(' ');
  }

  bool _hasTagId(Deck deck, String tagId) {
    return deck.tags.any((tag) => tag.id == tagId);
  }

  bool _hasTagName(Deck deck, String tagName) {
    return deck.tags.any((tag) => tag.name.toLowerCase() == tagName);
  }
}
