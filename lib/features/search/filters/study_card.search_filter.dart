import 'package:boo_mondai/features/search/search_text_parser.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show SearchDirectiveProperty, SearchFilter;
import 'package:boo_mondai/features/search/filters/search_filter_directive.dart';

abstract final class StudyCardSearchFilterDirective {
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
  static const reversed = SearchFilterDirective(
    name: 'reversed',
    aliases: ['reverse', 'isreversed'],
    order: 4,
  );
  static const fuzzy = SearchFilterDirective(
    name: 'fuzzy',
    aliases: ['cutoff'],
    order: 5,
  );
}

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

      if (_isViewCardsDataModeDirective(key)) {
        continue;
      }

      if (StudyCardSearchFilterDirective.deck.matches(key)) {
        deckIds.addAll(SearchTextParser.splitValues(value));
      } else if (StudyCardSearchFilterDirective.template.matches(key)) {
        templateIds.addAll(SearchTextParser.splitValues(value));
      } else if (StudyCardSearchFilterDirective.tag.matches(key)) {
        tagNames.addAll(SearchTextParser.splitValues(value));
      } else if (StudyCardSearchFilterDirective.tagId.matches(key)) {
        tagIds.addAll(SearchTextParser.splitValues(value));
      } else if (StudyCardSearchFilterDirective.reversed.matches(key)) {
        isReversed = _parseBool(value) ?? isReversed;
      } else if (StudyCardSearchFilterDirective.fuzzy.matches(key)) {
        fuzzyCutoff = int.tryParse(value) ?? fuzzyCutoff;
      } else {
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

  static bool _isViewCardsDataModeDirective(String key) {
    return key == 'studycards' || key == 'study_cards' || key == 'cards';
  }
}
