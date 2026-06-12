import 'package:boo_mondai/features/search/search_text_parser.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckSearchSortField,
        SearchDirectiveProperty,
        SearchFilter,
        SearchSortDirection;

class DeckSearchFilter implements SearchFilter {
  const DeckSearchFilter({
    required this.freeText,
    required this.tagIds,
    required this.tagNames,
    required this.sortField,
    required this.sortDirection,
    required this.fuzzyCutoff,
  });

  @override
  final String freeText;
  final Set<String> tagIds;
  final Set<String> tagNames;
  final DeckSearchSortField sortField;
  final SearchSortDirection sortDirection;
  @override
  final int fuzzyCutoff;

  static DeckSearchFilter parse(
    String input, {
    DeckSearchSortField defaultSortField = DeckSearchSortField.updatedAt,
    SearchSortDirection defaultSortDirection = SearchSortDirection.descending,
    int defaultFuzzyCutoff = 60,
  }) {
    final freeTextParts = <String>[];
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
        case 'tag':
        case 'tags':
          tagNames.addAll(SearchTextParser.splitValues(value));
        case 'tagid':
          tagIds.addAll(SearchTextParser.splitValues(value));
        case 'sort':
          final sort = _parseSort(value);
          if (sort == null) {
            freeTextParts.add(token);
          } else {
            sortField = sort.$1;
            sortDirection = sort.$2;
          }
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

    return DeckSearchFilter(
      freeText: freeTextParts.join(' ').trim(),
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
      ...tagNames.map((tagName) => 'tag:${_formatValue(tagName)}'),
      ...tagIds.map((tagId) => 'tag_id:${_formatValue(tagId)}'),
      'sort:${_formatSortField(sortField)}',
      'direction:${_formatDirection(sortDirection)}',
      'fuzzy:$fuzzyCutoff',
    ].where((part) => part.trim().isNotEmpty).join(' ').trim();
  }

  static (DeckSearchSortField, SearchSortDirection)? _parseSort(String value) {
    return switch (value.toLowerCase()) {
      'latest' || 'newest' || 'recent' || 'updated' => (
        DeckSearchSortField.updatedAt,
        SearchSortDirection.descending,
      ),
      'oldest' => (
        DeckSearchSortField.updatedAt,
        SearchSortDirection.ascending,
      ),
      'az' ||
      'a-z' ||
      'letters' ||
      'title' ||
      'name' => (DeckSearchSortField.letters, SearchSortDirection.ascending),
      'za' ||
      'z-a' => (DeckSearchSortField.letters, SearchSortDirection.descending),
      'created' ||
      'date' => (DeckSearchSortField.createdAt, SearchSortDirection.descending),
      _ => null,
    };
  }

  static DeckSearchSortField? _parseField(String value) {
    return switch (value.toLowerCase()) {
      'letters' || 'title' || 'name' || 'az' => DeckSearchSortField.letters,
      'created' ||
      'createdat' ||
      'created_at' ||
      'date' => DeckSearchSortField.createdAt,
      'updated' || 'updatedat' || 'updated_at' => DeckSearchSortField.updatedAt,
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

  static String _formatSortField(DeckSearchSortField field) {
    return switch (field) {
      DeckSearchSortField.letters => 'letters',
      DeckSearchSortField.createdAt => 'created',
      DeckSearchSortField.updatedAt => 'updated',
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
