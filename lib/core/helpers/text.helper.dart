import 'package:flutter/material.dart';

abstract final class TextHelper {
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

  static MainAxisAlignment getMainAxisAlignmentForTextAlign(
    TextAlign? textAlign,
  ) {
    if (textAlign == null) return MainAxisAlignment.start;
    return switch (textAlign) {
      TextAlign.center => MainAxisAlignment.center,
      TextAlign.left || TextAlign.start => MainAxisAlignment.start,
      TextAlign.right || TextAlign.end => MainAxisAlignment.end,
      TextAlign.justify => MainAxisAlignment.spaceBetween,
    };
  }

  static String getTrimmedTextOrFallback(String? value, String fallback) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return fallback;

    return trimmed;
  }

  static String? getTrimmedTextOrNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;

    return trimmed;
  }

  static List<String> getTrimmedCommaSeparatedValues(String value) {
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
