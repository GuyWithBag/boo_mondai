import 'package:boo_mondai/features/search/models/search.token_shape.dart';
import 'package:boo_mondai/features/search/search_text.parser.dart';

// Turns input into tokens using token shapes
final class SearchTokens {
  SearchTokens({required String input, required this.tokenShapes}) {
    final parsedValues = <String, List<String>>{};
    final parsedFreeText = <String>[];

    for (final token in SearchTextParser.tokenize(input)) {
      final separatorIndex = token.indexOf(':');
      if (separatorIndex <= 0) {
        parsedFreeText.add(token);
        continue;
      }

      final key = token.substring(0, separatorIndex);
      final value = SearchTextParser.cleanValue(
        token.substring(separatorIndex + 1),
      );
      final shape = getShapeOf(key);

      if (shape == null || value.isEmpty) {
        parsedFreeText.add(token);
        continue;
      }

      parsedValues
          .putIfAbsent(shape.name, () => [])
          .addAll(SearchTextParser.splitValues(value));
    }

    values = {
      for (final entry in parsedValues.entries)
        entry.key: List.unmodifiable(entry.value),
    };
    freeText = parsedFreeText.join(' ').trim();
  }

  final List<SearchTokenShape> tokenShapes;

  late final Map<String, List<String>> values;
  late final String freeText;

  SearchTokenShape? getShapeOf(String key) {
    for (final shape in tokenShapes) {
      if (shape.matches(key)) return shape;
    }
    return null;
  }

  List<String> getAll(SearchTokenShape shape) {
    return values[shape.name] ?? const [];
  }

  String? getLast(SearchTokenShape shape) {
    final values = getAll(shape);
    if (values.isEmpty) return null;
    return values.last;
  }

  bool contains(SearchTokenShape shape) {
    return getAll(shape).isNotEmpty;
  }

  @override
  String toString() {
    final parts = <String>[
      if (freeText.isNotEmpty) freeText,
      for (final shape in tokenShapes)
        for (final value in getAll(shape)) '${shape.name}:${value.trim()}',
    ];

    return parts.join(' ').trim();
  }
}
