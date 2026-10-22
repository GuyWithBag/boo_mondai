abstract final class MarkdownFormatHelper {
  static String toBold(String text) {
    return '**$text**';
  }

  static String toItalic(String text) {
    return '_${text}_';
  }

  static String toStrikethrough(String text) {
    return '~~$text~~';
  }

  static String toInlineCode(String text) {
    return '`$text`';
  }

  static String toCodeBlock(String text) {
    return '```\n$text\n```';
  }

  static String toHeading(String text, int level) {
    final normalizedLevel = level.clamp(1, 6);
    return '${'#' * normalizedLevel} $text';
  }

  static String toBlockQuote(String text) {
    return '> $text';
  }

  static String toUnorderedListItem(String text) {
    return '- $text';
  }

  static String toOrderedListItem(String text, int number) {
    return '$number. $text';
  }

  static String toTaskListItem(String text) {
    return '- [ ] $text';
  }

  static String toLink(String text) {
    return '[$text](https://)';
  }

  static String toImage(String text) {
    return '![$text](https://)';
  }

  static String toHorizontalRule() {
    return '\n---\n';
  }

  static String toTable() {
    return '| Header | Header |\n'
        '| --- | --- |\n'
        '| Cell | Cell |';
  }
}
