import 'package:boo_mondai/features/search/search_text_parser.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplateSearchSortField,
        SearchDirectiveProperty,
        SearchFilter,
        SearchSortDirection,
        SearchFilterDirective;

abstract final class CardTemplateSearchFilterDirective {
  static const deck = SearchFilterDirective(
    name: 'deck',
    aliases: ['deckid'],
    order: 0,
  );
  static const template = SearchFilterDirective(
    name: 'template',
    aliases: ['templateid'],
    order: 1,
  );
  static const tag = SearchFilterDirective(
    name: 'tag',
    aliases: ['tags'],
    order: 2,
  );
  static const tagId = SearchFilterDirective(
    name: 'tag_id',
    aliases: ['tagid'],
    order: 3,
  );
  static const sort = SearchFilterDirective(
    name: 'sort',
    aliases: ['field', 'sortby'],
    order: 4,
  );
  static const direction = SearchFilterDirective(
    name: 'direction',
    aliases: ['order', 'dir'],
    order: 5,
  );
  static const fuzzy = SearchFilterDirective(
    name: 'fuzzy',
    aliases: ['cutoff'],
    order: 6,
  );
}

class CardTemplateSearchFilter implements SearchFilter {
  const CardTemplateSearchFilter({
    required this.freeText,
    required this.deckIds,
    required this.templateIds,
    required this.tagIds,
    required this.tagNames,
    required this.sortField,
    required this.sortDirection,
    required this.fuzzyCutoff,
  });

  @override
  final String freeText;
  final Set<String> deckIds;
  final Set<String> templateIds;
  final Set<String> tagIds;
  final Set<String> tagNames;
  final CardTemplateSearchSortField sortField;
  final SearchSortDirection sortDirection;
  @override
  final int fuzzyCutoff;

  static CardTemplateSearchFilter parse(
    String input, {
    CardTemplateSearchSortField defaultSortField =
        CardTemplateSearchSortField.sortOrder,
    SearchSortDirection defaultSortDirection = SearchSortDirection.ascending,
    int defaultFuzzyCutoff = 60,
  }) {
    final freeTextParts = <String>[];
    final deckIds = <String>{};
    final templateIds = <String>{};
    final tagIds = <String>{};
    final tagNames = <String>{};
    var sortField = defaultSortField;
    var sortDirection = defaultSortDirection;
    var fuzzyCutoff = defaultFuzzyCutoff;

    for (final token in SearchTextParser.tokenize(input)) {
      if (token.startsWith('#') && token.length > 1) {
        tagNames.add(SearchTextParser.cleanValue(token.substring(1)));
        continue;
      }

      final separatorIndex = token.indexOf(':');
      if (separatorIndex <= 0) {
        freeTextParts.add(token);
        continue;
      }

      final key = SearchDirectiveProperty.normalize(
        token.substring(0, separatorIndex),
      );
      final value = SearchTextParser.cleanValue(
        token.substring(separatorIndex + 1),
      );

      if (value.isEmpty) continue;

      if (_isViewCardsDataModeDirective(key)) {
        continue;
      }

      if (CardTemplateSearchFilterDirective.deck.matches(key)) {
        deckIds.addAll(SearchTextParser.splitValues(value));
      } else if (CardTemplateSearchFilterDirective.template.matches(key)) {
        templateIds.addAll(SearchTextParser.splitValues(value));
      } else if (CardTemplateSearchFilterDirective.tag.matches(key)) {
        tagNames.addAll(SearchTextParser.splitValues(value));
      } else if (CardTemplateSearchFilterDirective.tagId.matches(key)) {
        tagIds.addAll(SearchTextParser.splitValues(value));
      } else if (CardTemplateSearchFilterDirective.sort.matches(key)) {
        sortField = _parseField(value) ?? sortField;
      } else if (CardTemplateSearchFilterDirective.direction.matches(key)) {
        sortDirection = _parseDirection(value) ?? sortDirection;
      } else if (CardTemplateSearchFilterDirective.fuzzy.matches(key)) {
        fuzzyCutoff = int.tryParse(value) ?? fuzzyCutoff;
      } else {
        freeTextParts.add(token);
      }
    }

    return CardTemplateSearchFilter(
      freeText: freeTextParts.join(' ').trim(),
      deckIds: deckIds,
      templateIds: templateIds,
      tagIds: tagIds,
      tagNames: tagNames,
      sortField: sortField,
      sortDirection: sortDirection,
      fuzzyCutoff: fuzzyCutoff.clamp(0, 100).toInt(),
    );
  }

  @override
  String toSearchText() {
    final sortedDeckIds = deckIds.toList()..sort();
    final sortedTemplateIds = templateIds.toList()..sort();
    final sortedTagNames = tagNames.toList()..sort();
    final sortedTagIds = tagIds.toList()..sort();

    return [
      freeText,
      ...sortedDeckIds.map((deckId) => 'deck:${_formatValue(deckId)}'),
      ...sortedTemplateIds.map(
        (templateId) => 'template:${_formatValue(templateId)}',
      ),
      ...sortedTagNames.map((tagName) => 'tag:${_formatValue(tagName)}'),
      ...sortedTagIds.map((tagId) => 'tag_id:${_formatValue(tagId)}'),
      'sort:${_formatSortField(sortField)}',
      'direction:${_formatDirection(sortDirection)}',
      'fuzzy:$fuzzyCutoff',
    ].where((part) => part.trim().isNotEmpty).join(' ').trim();
  }

  static CardTemplateSearchSortField? _parseField(String value) {
    return switch (value.toLowerCase()) {
      'sort' ||
      'order' ||
      'sortorder' ||
      'sort_order' => CardTemplateSearchSortField.sortOrder,
      'created' ||
      'createdat' ||
      'created_at' => CardTemplateSearchSortField.createdAt,
      'updated' ||
      'updatedat' ||
      'updated_at' => CardTemplateSearchSortField.updatedAt,
      _ => null,
    };
  }

  static SearchSortDirection? _parseDirection(String value) {
    return switch (value.toLowerCase()) {
      'asc' || 'ascending' || 'oldest' => SearchSortDirection.ascending,
      'desc' ||
      'descending' ||
      'latest' ||
      'newest' => SearchSortDirection.descending,
      _ => null,
    };
  }

  static String _formatSortField(CardTemplateSearchSortField field) {
    return switch (field) {
      CardTemplateSearchSortField.sortOrder => 'sort_order',
      CardTemplateSearchSortField.createdAt => 'created',
      CardTemplateSearchSortField.updatedAt => 'updated',
    };
  }

  static String _formatDirection(SearchSortDirection direction) {
    return switch (direction) {
      SearchSortDirection.ascending => 'ascending',
      SearchSortDirection.descending => 'descending',
    };
  }

  static String _formatValue(String value) {
    final trimmed = value.trim();
    if (trimmed.contains(RegExp(r'[\s,]'))) return '"$trimmed"';
    return trimmed;
  }

  static bool _isViewCardsDataModeDirective(String key) {
    return key == 'studycards' || key == 'study_cards' || key == 'cards';
  }
}
