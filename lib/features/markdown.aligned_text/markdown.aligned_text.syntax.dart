import 'package:markdown/markdown.dart' as md;

class MarkdownAlignedTextSyntax extends md.BlockSyntax {
  static final _pattern = RegExp(r'^\](<|=|>)\s*(.+)$');
  static final tag = 'aligned-line';

  @override
  RegExp get pattern => _pattern;

  @override
  md.Node parse(md.BlockParser parser) {
    final match = _pattern.firstMatch(parser.current.content)!;
    parser.advance();

    return md.Element.empty(tag)
      ..attributes['align'] = match.group(1)!
      ..attributes['content'] = match.group(2)!;
  }
}
