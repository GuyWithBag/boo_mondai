/// Small helpers for parsing search text.
///
/// This parser stays generic so feature-specific filters can decide how to
/// interpret the resulting tokens.
abstract final class SearchTextParser {
  /// Splits a raw search string into tokens.
  ///
  /// Whitespace separates tokens unless the text is wrapped in matching single
  /// or double quotes. Quoted text stays together as one token.
  static List<String> tokenize(String input) {
    final tokens = <String>[];
    final currentToken = StringBuffer();
    String? activeQuote;

    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      final isQuote = char == '"' || char == "'";

      if (isQuote) {
        if (activeQuote == null) {
          activeQuote = char;
        } else if (activeQuote == char) {
          activeQuote = null;
        }

        currentToken.write(char);
        continue;
      }

      if (activeQuote == null && char.trim().isEmpty) {
        final token = cleanValue(currentToken.toString());
        if (token.isNotEmpty) tokens.add(token);
        currentToken.clear();
        continue;
      }

      currentToken.write(char);
    }

    final token = cleanValue(currentToken.toString());
    if (token.isNotEmpty) tokens.add(token);

    return tokens;
  }

  /// Trims surrounding whitespace and removes matching wrapping quotes.
  static String cleanValue(String value) {
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

  /// Splits a comma-separated list into cleaned, non-empty values.
  static Set<String> splitValues(String value) {
    return value
        .split(',')
        .map(cleanValue)
        .where((part) => part.isNotEmpty)
        .toSet();
  }
}
