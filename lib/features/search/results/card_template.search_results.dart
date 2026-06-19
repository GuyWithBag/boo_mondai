import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardTemplateSearchFilter,
        SearchResults,
        CardTemplateSearchSortField,
        SearchSortDirection;
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

final class CardTemplateSearchResults
    implements SearchResults<CardTemplate, CardTemplateSearchFilter> {
  const CardTemplateSearchResults();

  @override
  List<CardTemplate> resolve({
    required Iterable<CardTemplate> items,
    required CardTemplateSearchFilter filter,
  }) {
    final selectedTagNames = filter.tagNames
        .map((tagName) => tagName.trim().toLowerCase())
        .where((tagName) => tagName.isNotEmpty)
        .toSet();
    final normalizedFreeText = filter.freeText.trim();

    var filtered = items.where((template) {
      if (filter.deckIds.isNotEmpty &&
          !filter.deckIds.contains(template.deckId)) {
        return false;
      }

      if (filter.templateIds.isNotEmpty &&
          !filter.templateIds.contains(template.id)) {
        return false;
      }

      if (filter.tagIds.isNotEmpty &&
          !filter.tagIds.every(
            (tagId) => template.tags.any((tag) => tag.id == tagId),
          )) {
        return false;
      }

      if (selectedTagNames.isNotEmpty &&
          !selectedTagNames.every(
            (tagName) =>
                template.tags.any((tag) => tag.name.toLowerCase() == tagName),
          )) {
        return false;
      }

      return true;
    }).toList();

    if (normalizedFreeText.isNotEmpty) {
      filtered = extractAllSorted<CardTemplate>(
        query: normalizedFreeText,
        choices: filtered,
        cutoff: filter.fuzzyCutoff,
        getter: _cardTemplateSearchText,
      ).map((result) => result.choice).toList();
    }

    return sortCardTemplates(
      filtered,
      field: filter.sortField,
      direction: filter.sortDirection,
    );
  }

  List<CardTemplate> sortCardTemplates(
    Iterable<CardTemplate> templates, {
    CardTemplateSearchSortField field = CardTemplateSearchSortField.sortOrder,
    SearchSortDirection direction = SearchSortDirection.ascending,
  }) {
    final sorted = templates.toList();
    sorted.sort((a, b) {
      final comparison = switch (field) {
        CardTemplateSearchSortField.sortOrder => a.sortOrder.compareTo(
          b.sortOrder,
        ),
        CardTemplateSearchSortField.createdAt => a.createdAt.compareTo(
          b.createdAt,
        ),
        CardTemplateSearchSortField.updatedAt => a.updatedAt.compareTo(
          b.updatedAt,
        ),
      };

      return direction == SearchSortDirection.ascending
          ? comparison
          : -comparison;
    });
    return sorted;
  }

  String _cardTemplateSearchText(CardTemplate template) {
    final tagNames = template.tags.map((tag) => tag.name).join(' ');
    return [
      template.id,
      template.deckId,
      template.sourceTemplateId,
      tagNames,
    ].whereType<String>().join(' ');
  }
}
