import 'package:boo_mondai/core/helpers/casing_type.dart';

abstract final class CasingHelper {
  static bool matches(String input, String expected, CasingType casingType) {
    final normalizedInput = normalizedWords(input);
    final normalizedExpected = normalizedWords(expected);
    if (normalizedInput.isEmpty || normalizedExpected.isEmpty) return false;
    if (normalizedInput != normalizedExpected) return false;

    return switch (casingType) {
      CasingType.any => true,
      CasingType.exact => input.trim() == expected.trim(),
      CasingType.camel => isCamelCase(input.trim()),
      CasingType.pascal => isPascalCase(input.trim()),
      CasingType.snake => isSnakeCase(input.trim()),
      CasingType.kebab => isKebabCase(input.trim()),
      CasingType.title => isTitleCase(input.trim()),
    };
  }

  static bool isCamelCase(String text) {
    if (text.isEmpty || text.contains(RegExp(r'[\s_-]'))) return false;
    if (!RegExp(r'^[a-z][A-Za-z0-9]*$').hasMatch(text)) return false;
    return text.contains(RegExp(r'[A-Z]')) || normalizedWords(text).length == 1;
  }

  static bool isPascalCase(String text) {
    if (text.isEmpty || text.contains(RegExp(r'[\s_-]'))) return false;
    return RegExp(r'^[A-Z][A-Za-z0-9]*$').hasMatch(text);
  }

  static bool isSnakeCase(String text) {
    if (text.isEmpty) return false;
    return RegExp(r'^[a-z0-9]+(_[a-z0-9]+)*$').hasMatch(text);
  }

  static bool isKebabCase(String text) {
    if (text.isEmpty) return false;
    return RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$').hasMatch(text);
  }

  static bool isTitleCase(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;

    final words = trimmed.split(RegExp(r'\s+'));
    return words.every((word) {
      return RegExp(r'^[A-Z][a-z0-9]*$').hasMatch(word);
    });
  }

  static String normalizedWords(String text) {
    return _caseWords(text).join(' ');
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
}
