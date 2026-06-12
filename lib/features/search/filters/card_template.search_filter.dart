import 'package:boo_mondai/features/search/search_text_parser.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplateSearchSortField,
        SearchDirectiveProperty,
        SearchFilter,
        SearchSortDirection;

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

      switch (key) {
        case 'deck':
        case 'deckid':
          deckIds.addAll(SearchTextParser.splitValues(value));
        case 'template':
        case 'templateid':
          templateIds.addAll(SearchTextParser.splitValues(value));
        case 'tag':
        case 'tags':
          tagNames.addAll(SearchTextParser.splitValues(value));
        case 'tagid':
          tagIds.addAll(SearchTextParser.splitValues(value));
        case 'sort':
        case 'field':
        case 'sortby':
          sortField = _parseField(value) ?? sortField;
        case 'order':
        case 'dir':
        case 'direction':
          sortDirection = _parseDirection(value) ?? sortDirection;
        case 'cutoff':
        case 'fuzzy':
          fuzzyCutoff = int.tryParse(value) ?? fuzzyCutoff;
        default:
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
    return [
      freeText,
      ...deckIds.map((deckId) => 'deck:${_formatValue(deckId)}'),
      ...templateIds.map(
        (templateId) => 'template:${_formatValue(templateId)}',
      ),
      ...tagNames.map((tagName) => 'tag:${_formatValue(tagName)}'),
      ...tagIds.map((tagId) => 'tag_id:${_formatValue(tagId)}'),
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
}
