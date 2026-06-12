import 'package:boo_mondai/features/search/search_text_parser.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show SearchDirectiveProperty, SearchFilter;

class StudyCardSearchFilter implements SearchFilter {
  const StudyCardSearchFilter({
    required this.freeText,
    required this.deckIds,
    required this.templateIds,
    required this.tagIds,
    required this.tagNames,
    this.isReversed,
    required this.fuzzyCutoff,
  });

  @override
  final String freeText;
  final Set<String> deckIds;
  final Set<String> templateIds;
  final Set<String> tagIds;
  final Set<String> tagNames;
  final bool? isReversed;
  @override
  final int fuzzyCutoff;

  static StudyCardSearchFilter parse(
    String input, {
    int defaultFuzzyCutoff = 60,
  }) {
    final freeTextParts = <String>[];
    final deckIds = <String>{};
    final templateIds = <String>{};
    final tagIds = <String>{};
    final tagNames = <String>{};
    bool? isReversed;
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
        case 'reversed':
        case 'reverse':
        case 'isreversed':
          isReversed = _parseBool(value) ?? isReversed;
        case 'cutoff':
        case 'fuzzy':
          fuzzyCutoff = int.tryParse(value) ?? fuzzyCutoff;
        default:
          freeTextParts.add(token);
      }
    }

    return StudyCardSearchFilter(
      freeText: freeTextParts.join(' ').trim(),
      deckIds: deckIds,
      templateIds: templateIds,
      tagIds: tagIds,
      tagNames: tagNames,
      isReversed: isReversed,
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
      if (isReversed != null) 'reversed:$isReversed',
      'fuzzy:$fuzzyCutoff',
    ].where((part) => part.trim().isNotEmpty).join(' ').trim();
  }

  static bool? _parseBool(String value) {
    return switch (value.toLowerCase()) {
      'true' || 'yes' || 'y' || '1' || 'reversed' => true,
      'false' || 'no' || 'n' || '0' || 'normal' => false,
      _ => null,
    };
  }

  static String _formatValue(String value) {
    final trimmed = value.trim();
    if (trimmed.contains(RegExp(r'[\s,]'))) return '"$trimmed"';
    return trimmed;
  }
}
