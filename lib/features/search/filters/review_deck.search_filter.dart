import 'package:boo_mondai/features/search/search_text_parser.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        DueFilterThreshold,
        SearchDirectiveProperty,
        SearchFilter,
        SearchFilterDirective;

abstract final class ReviewDeckSearchFilterDirective {
  static const due = SearchFilterDirective(
    name: 'due',
    aliases: ['threshold', 'filter', 'mode'],
    order: 0,
  );
  static const fuzzy = SearchFilterDirective(
    name: 'fuzzy',
    aliases: ['cutoff'],
    order: 1,
  );
}

class ReviewDeckSearchFilter implements SearchFilter {
  const ReviewDeckSearchFilter({
    required this.freeText,
    required this.dueFilter,
    required this.fuzzyCutoff,
  });

  @override
  final String freeText;
  final DueFilterThreshold dueFilter;
  @override
  final int fuzzyCutoff;

  static ReviewDeckSearchFilter parse(
    String input, {
    DueFilterThreshold defaultDueFilter = DueFilterThreshold.lookAheadOneDay,
    int defaultFuzzyCutoff = 60,
  }) {
    final freeTextParts = <String>[];
    var dueFilter = defaultDueFilter;
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

      if (ReviewDeckSearchFilterDirective.due.matches(key)) {
        dueFilter = _parseDueFilter(value) ?? dueFilter;
      } else if (ReviewDeckSearchFilterDirective.fuzzy.matches(key)) {
        fuzzyCutoff = int.tryParse(value) ?? fuzzyCutoff;
      } else {
        freeTextParts.add(token);
      }
    }

    return ReviewDeckSearchFilter(
      freeText: freeTextParts.join(' ').trim(),
      dueFilter: dueFilter,
      fuzzyCutoff: fuzzyCutoff.clamp(0, 100).toInt(),
    );
  }

  @override
  String toSearchText() {
    return [
      freeText,
      'due:${_formatDueFilter(dueFilter)}',
      'fuzzy:$fuzzyCutoff',
    ].where((part) => part.trim().isNotEmpty).join(' ').trim();
  }

  static DueFilterThreshold? _parseDueFilter(String value) {
    switch (value.toLowerCase()) {
      case 'exact':
      case 'exactandoverdue':
      case 'due':
      case 'now':
        return DueFilterThreshold.exactAndOverdue;
      case '1h':
      case '1hour':
      case 'hour':
      case 'onehour':
      case 'lookaheadonehour':
        return DueFilterThreshold.lookAheadOneHour;
      case '1d':
      case '1day':
      case 'day':
      case 'oneday':
      case 'lookaheadoneday':
        return DueFilterThreshold.lookAheadOneDay;
      case 'cram':
      case 'all':
      case 'studyall':
      case 'studyallcards':
      case 'cramall':
        return DueFilterThreshold.cramAll;
      default:
        return null;
    }
  }

  static String _formatDueFilter(DueFilterThreshold value) {
    return switch (value) {
      DueFilterThreshold.exactAndOverdue => 'exact',
      DueFilterThreshold.lookAheadOneHour => '1h',
      DueFilterThreshold.lookAheadOneDay => '1d',
      DueFilterThreshold.cramAll => 'cram',
    };
  }
}
