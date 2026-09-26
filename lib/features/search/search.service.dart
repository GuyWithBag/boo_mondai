import 'package:boo_mondai/features/search/models/search.token_shape.dart';
import 'package:boo_mondai/features/search/models/search_tokens.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

typedef SearchTextLabel<TObject> = String Function(TObject item);
typedef SearchItemFilter<TObject> =
    bool Function(TObject item, SearchTokens tokens);
typedef SearchSorter<TObject> =
    List<TObject> Function(List<TObject> items, SearchTokens tokens);

abstract final class SearchService {
  static List<TObject> resolve<TObject>({
    required String input,
    required Iterable<TObject> items,
    required List<SearchTokenShape> tokenShapes,
    required SearchTextLabel<TObject> searchTextLabel,
    SearchItemFilter<TObject>? itemFilter,
    SearchSorter<TObject>? sorter,
    int defaultFuzzyCutoff = 60,
  }) {
    final tokens = SearchTokens(input: input, tokenShapes: tokenShapes);
    final filteredItems = itemFilter == null
        ? items.toList()
        : items.where((item) => itemFilter(item, tokens)).toList();
    final freeText = tokens.freeText.trim();
    final fuzzyCutoff = _fuzzyCutoff(
      tokens,
      tokenShapes,
      defaultFuzzyCutoff: defaultFuzzyCutoff,
    );

    final results = freeText.isEmpty
        ? filteredItems
        : extractAllSorted<TObject>(
            query: freeText,
            choices: filteredItems,
            cutoff: fuzzyCutoff,
            getter: searchTextLabel,
          ).map((result) => result.choice).toList();

    return sorter?.call(results, tokens) ?? results;
  }

  static int _fuzzyCutoff(
    SearchTokens tokens,
    List<SearchTokenShape> tokenShapes, {
    required int defaultFuzzyCutoff,
  }) {
    for (final shape in tokenShapes) {
      if (shape.name != 'fuzzy') continue;

      return (int.tryParse(tokens.getLast(shape) ?? '') ?? defaultFuzzyCutoff)
          .clamp(0, 100)
          .toInt();
    }

    return defaultFuzzyCutoff.clamp(0, 100).toInt();
  }
}
