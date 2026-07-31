abstract class StringHelper {
  static String? toTrimmedOrNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static String toCamelCase(String text) {
    final words = _caseWords(text);
    if (words.isEmpty) return text;
    return [
      words.first,
      for (final word in words.skip(1)) _capitalize(word),
    ].join();
  }

  static String toPascalCase(String text) {
    final words = _caseWords(text);
    if (words.isEmpty) return text;
    return words.map(_capitalize).join();
  }

  static String toSnakeCase(String text) {
    final words = _caseWords(text);
    if (words.isEmpty) return text;
    return words.join('_');
  }

  static String toKebabCase(String text) {
    final words = _caseWords(text);
    if (words.isEmpty) return text;
    return words.join('-');
  }

  static String toTitleCase(String text) {
    final words = _caseWords(text);
    if (words.isEmpty) return text;
    return words.map(_capitalize).join(' ');
  }

  static String toTrimmedOrFallback(String? value, String fallback) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return fallback;

    return trimmed;
  }

  static List<String> toTrimmedCommaSeparatedValues(String value) {
    return value
        .split(',')
        .map((entry) => entry.trim())
        .where((entry) => entry.isNotEmpty)
        .toList();
  }

  static List<String> _caseWords(String text) {
    final separated = text
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (match) => '${match[1]} ${match[2]}',
        )
        .replaceAllMapped(
          RegExp(r'([A-Z]+)([A-Z][a-z])'),
          (match) => '${match[1]} ${match[2]}',
        )
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), ' ');

    return separated
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word.toLowerCase())
        .toList();
  }

  static String _capitalize(String word) {
    if (word.isEmpty) return word;
    return '${word[0].toUpperCase()}${word.substring(1)}';
  }
}
