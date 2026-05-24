import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

abstract final class ViewDecksService {
  static List<Deck> filterDecksFromText({
    required Iterable<Deck> decks,
    required String input,
    BrowseSortField defaultSortField = BrowseSortField.updatedAt,
    BrowseSortDirection defaultSortDirection = BrowseSortDirection.descending,
    int defaultFuzzyCutoff = 60,
  }) {
    final filter = ViewDecksTextFilter.parse(
      input,
      defaultSortField: defaultSortField,
      defaultSortDirection: defaultSortDirection,
      defaultFuzzyCutoff: defaultFuzzyCutoff,
    );

    return filterDecks(
      decks: decks,
      query: filter.query,
      tagIds: filter.tagIds,
      tagNames: filter.tagNames,
      sortField: filter.sortField,
      sortDirection: filter.sortDirection,
      fuzzyCutoff: filter.fuzzyCutoff,
    );
  }

  static List<Deck> filterDecks({
    required Iterable<Deck> decks,
    String query = '',
    String? tagId,
    Iterable<String> tagIds = const [],
    Iterable<String> tagNames = const [],
    BrowseSortField sortField = BrowseSortField.updatedAt,
    BrowseSortDirection sortDirection = BrowseSortDirection.descending,
    int fuzzyCutoff = 60,
  }) {
    final selectedTagIds = {?tagId, ...tagIds};
    final selectedTagNames = tagNames
        .map((tagName) => tagName.trim().toLowerCase())
        .where((tagName) => tagName.isNotEmpty)
        .toSet();
    final normalizedQuery = query.trim();

    var filtered = decks.where((deck) {
      if (selectedTagIds.isNotEmpty &&
          !selectedTagIds.every((tagId) => _hasTagId(deck, tagId))) {
        return false;
      }

      if (selectedTagNames.isNotEmpty &&
          !selectedTagNames.every((tagName) => _hasTagName(deck, tagName))) {
        return false;
      }

      return true;
    }).toList();

    if (normalizedQuery.isNotEmpty) {
      filtered = extractAllSorted<Deck>(
        query: normalizedQuery,
        choices: filtered,
        cutoff: fuzzyCutoff,
        getter: _deckSearchText,
      ).map((result) => result.choice).toList();
    }

    return sortDecks(filtered, field: sortField, direction: sortDirection);
  }

  static List<Deck> sortDecks(
    Iterable<Deck> decks, {
    BrowseSortField field = BrowseSortField.updatedAt,
    BrowseSortDirection direction = BrowseSortDirection.descending,
  }) {
    final sorted = decks.toList();
    sorted.sort((a, b) {
      final comparison = switch (field) {
        BrowseSortField.letters => a.title.toLowerCase().compareTo(
          b.title.toLowerCase(),
        ),
        BrowseSortField.createdAt => a.createdAt.compareTo(b.createdAt),
        BrowseSortField.updatedAt => a.updatedAt.compareTo(b.updatedAt),
      };

      return direction == BrowseSortDirection.ascending
          ? comparison
          : -comparison;
    });

    return sorted;
  }

  static List<Tag> availableTags(Iterable<Deck> decks) {
    final tagMap = <String, Tag>{};

    for (final deck in decks) {
      for (final tag in deck.tags) {
        tagMap[tag.id] = tag;
      }
    }

    return tagMap.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  static String _deckSearchText(Deck deck) {
    final tagNames = deck.tags.map((tag) => tag.name).join(' ');
    return [
      deck.title,
      deck.shortDescription,
      deck.longDescription,
      tagNames,
    ].join(' ');
  }

  static bool _hasTagId(Deck deck, String tagId) {
    return deck.tags.any((tag) => tag.id == tagId);
  }

  static bool _hasTagName(Deck deck, String tagName) {
    return deck.tags.any((tag) => tag.name.toLowerCase() == tagName);
  }
}

class ViewDecksTextFilter {
  const ViewDecksTextFilter({
    required this.query,
    required this.tagIds,
    required this.tagNames,
    required this.sortField,
    required this.sortDirection,
    required this.fuzzyCutoff,
  });

  final String query;
  final Set<String> tagIds;
  final Set<String> tagNames;
  final BrowseSortField sortField;
  final BrowseSortDirection sortDirection;
  final int fuzzyCutoff;

  static ViewDecksTextFilter parse(
    String input, {
    BrowseSortField defaultSortField = BrowseSortField.updatedAt,
    BrowseSortDirection defaultSortDirection = BrowseSortDirection.descending,
    int defaultFuzzyCutoff = 60,
  }) {
    final queryParts = <String>[];
    final tagIds = <String>{};
    final tagNames = <String>{};
    var sortField = defaultSortField;
    var sortDirection = defaultSortDirection;
    var fuzzyCutoff = defaultFuzzyCutoff;

    for (final token in _tokenize(input)) {
      if (token.startsWith('#') && token.length > 1) {
        tagNames.add(_cleanValue(token.substring(1)));
        continue;
      }

      final separatorIndex = token.indexOf(':');
      if (separatorIndex <= 0) {
        queryParts.add(token);
        continue;
      }

      final key = token.substring(0, separatorIndex).toLowerCase();
      final value = _cleanValue(token.substring(separatorIndex + 1));

      if (value.isEmpty) continue;

      switch (key) {
        case 'tag':
        case 'tags':
          tagNames.addAll(_splitValues(value));
        case 'tagid':
        case 'tag-id':
        case 'tag_id':
          tagIds.addAll(_splitValues(value));
        case 'sort':
          final sort = _parseSort(value);
          if (sort == null) {
            queryParts.add(token);
          } else {
            sortField = sort.$1;
            sortDirection = sort.$2;
          }
        case 'field':
        case 'sortby':
        case 'sort-by':
        case 'sort_by':
          sortField = _parseField(value) ?? sortField;
        case 'order':
        case 'dir':
        case 'direction':
          sortDirection = _parseDirection(value) ?? sortDirection;
        case 'cutoff':
        case 'fuzzy':
          fuzzyCutoff = int.tryParse(value) ?? fuzzyCutoff;
        default:
          queryParts.add(token);
      }
    }

    return ViewDecksTextFilter(
      query: queryParts.join(' ').trim(),
      tagIds: tagIds,
      tagNames: tagNames,
      sortField: sortField,
      sortDirection: sortDirection,
      fuzzyCutoff: fuzzyCutoff.clamp(0, 100).toInt(),
    );
  }

  static List<String> _tokenize(String input) {
    final tokens = <String>[];
    final buffer = StringBuffer();
    String? quote;

    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      final isQuote = char == '"' || char == "'";

      if (isQuote) {
        if (quote == null) {
          quote = char;
        } else if (quote == char) {
          quote = null;
        }

        buffer.write(char);
        continue;
      }

      if (quote == null && char.trim().isEmpty) {
        final token = _cleanValue(buffer.toString());
        if (token.isNotEmpty) tokens.add(token);
        buffer.clear();
        continue;
      }

      buffer.write(char);
    }

    final token = _cleanValue(buffer.toString());
    if (token.isNotEmpty) tokens.add(token);

    return tokens;
  }

  static String _cleanValue(String value) {
    final trimmed = value.trim();
    if (trimmed.length < 2) return trimmed;

    final startsAndEndsWithDoubleQuote =
        trimmed.startsWith('"') && trimmed.endsWith('"');
    final startsAndEndsWithSingleQuote =
        trimmed.startsWith("'") && trimmed.endsWith("'");

    if (startsAndEndsWithDoubleQuote || startsAndEndsWithSingleQuote) {
      return trimmed.substring(1, trimmed.length - 1).trim();
    }

    return trimmed;
  }

  static Set<String> _splitValues(String value) {
    return value
        .split(',')
        .map(_cleanValue)
        .where((part) => part.isNotEmpty)
        .toSet();
  }

  static (BrowseSortField, BrowseSortDirection)? _parseSort(String value) {
    return switch (value.toLowerCase()) {
      'latest' ||
      'newest' ||
      'recent' ||
      'updated' => (BrowseSortField.updatedAt, BrowseSortDirection.descending),
      'oldest' => (BrowseSortField.updatedAt, BrowseSortDirection.ascending),
      'az' ||
      'a-z' ||
      'letters' ||
      'title' ||
      'name' => (BrowseSortField.letters, BrowseSortDirection.ascending),
      'za' ||
      'z-a' => (BrowseSortField.letters, BrowseSortDirection.descending),
      'created' ||
      'date' => (BrowseSortField.createdAt, BrowseSortDirection.descending),
      _ => null,
    };
  }

  static BrowseSortField? _parseField(String value) {
    return switch (value.toLowerCase()) {
      'letters' || 'title' || 'name' || 'az' => BrowseSortField.letters,
      'created' ||
      'createdat' ||
      'created_at' ||
      'date' => BrowseSortField.createdAt,
      'updated' || 'updatedat' || 'updated_at' => BrowseSortField.updatedAt,
      _ => null,
    };
  }

  static BrowseSortDirection? _parseDirection(String value) {
    return switch (value.toLowerCase()) {
      'asc' || 'ascending' || 'oldest' => BrowseSortDirection.ascending,
      'desc' ||
      'descending' ||
      'latest' ||
      'newest' => BrowseSortDirection.descending,
      _ => null,
    };
  }
}
