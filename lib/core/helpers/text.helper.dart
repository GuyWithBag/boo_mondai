import 'package:flutter/material.dart';

abstract final class TextHelper {
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
}
