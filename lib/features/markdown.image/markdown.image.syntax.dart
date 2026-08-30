import 'package:markdown/markdown.dart' as md;

class MarkdownImageSyntax extends md.InlineSyntax {
  MarkdownImageSyntax()
    : super(
        r'!\[([^\]\r\n]*)\]\(\s*([^\s)\r\n]+)(?:\s+"([^"\r\n]*)")?\s*\)\{([^}\r\n]+)\}',
        startCharacter: _exclamationMark,
      );

  static const _exclamationMark = 33;
  static const tag = 'configurable-img';

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final alt = match.group(1) ?? '';
    final source = match.group(2) ?? '';
    final title = match.group(3);
    final options = match.group(4) ?? '';
    final element = md.Element.empty(tag)
      ..attributes['alt'] = alt
      ..attributes['src'] = source
      ..attributes['options'] = options;
    if (title != null) {
      element.attributes['title'] = title;
    }

    parser.addNode(element);
    return true;
  }
}
