import 'package:boo_mondai/features/search/search_text_parser.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckListingSearchSortField,
        SearchDirectiveProperty,
        SearchFilter,
        SearchSortDirection;

class DeckListingSearchFilter implements SearchFilter {
  const DeckListingSearchFilter({
    required this.freeText,
    required this.deckIds,
    required this.sortField,
    required this.sortDirection,
    required this.fuzzyCutoff,
  });

  @override
  final String freeText;
  final Set<String> deckIds;
  final DeckListingSearchSortField sortField;
  final SearchSortDirection sortDirection;
  @override
  final int fuzzyCutoff;

  static DeckListingSearchFilter parse(
    String input, {
    DeckListingSearchSortField defaultSortField =
        DeckListingSearchSortField.updatedAt,
    SearchSortDirection defaultSortDirection = SearchSortDirection.descending,
    int defaultFuzzyCutoff = 60,
  }) {
    final freeTextParts = <String>[];
    final deckIds = <String>{};
    var sortField = defaultSortField;
    var sortDirection = defaultSortDirection;
    var fuzzyCutoff = defaultFuzzyCutoff;

    for (final token in SearchTextParser.tokenize(input)) {
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

    return DeckListingSearchFilter(
      freeText: freeTextParts.join(' ').trim(),
      deckIds: deckIds,
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
      'sort:${_formatSortField(sortField)}',
      'direction:${_formatDirection(sortDirection)}',
      'fuzzy:$fuzzyCutoff',
    ].where((part) => part.trim().isNotEmpty).join(' ').trim();
  }

  static DeckListingSearchSortField? _parseField(String value) {
    return switch (value.toLowerCase()) {
      'created' ||
      'createdat' ||
      'created_at' => DeckListingSearchSortField.createdAt,
      'updated' ||
      'updatedat' ||
      'updated_at' ||
      'latest' ||
      'newest' => DeckListingSearchSortField.updatedAt,
      'downloads' || 'downloaded' => DeckListingSearchSortField.downloads,
      'favorites' ||
      'favourites' ||
      'saved' => DeckListingSearchSortField.favorites,
      'upvotes' || 'votes' || 'rating' => DeckListingSearchSortField.upvotes,
      'comments' => DeckListingSearchSortField.comments,
      'reviews' => DeckListingSearchSortField.reviews,
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

  static String _formatSortField(DeckListingSearchSortField field) {
    return switch (field) {
      DeckListingSearchSortField.createdAt => 'created',
      DeckListingSearchSortField.updatedAt => 'updated',
      DeckListingSearchSortField.downloads => 'downloads',
      DeckListingSearchSortField.favorites => 'favorites',
      DeckListingSearchSortField.upvotes => 'upvotes',
      DeckListingSearchSortField.comments => 'comments',
      DeckListingSearchSortField.reviews => 'reviews',
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
