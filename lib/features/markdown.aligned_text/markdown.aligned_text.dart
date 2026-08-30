import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownAlignmentHelper,
        MarkdownImageSyntax,
        MarkdownImageElementBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

class MarkdownAlignedText extends MarkdownElementBuilder {
  MarkdownAlignedText({
    required this.selectable,
    required this.onTapLink,
    required this.imageBuilder,
    required this.styleSheet,
  });

  final bool selectable;
  final MarkdownTapLinkCallback onTapLink;
  final MarkdownImageBuilder? imageBuilder;
  final MarkdownStyleSheet styleSheet;

  @override
  bool isBlockElement() => true;

  @override
  Widget visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    return Align(
      alignment: MarkdownAlignmentHelper.alignmentForWrapAlignment(
        MarkdownAlignmentHelper.wrapAlignmentForMarker(
          element.attributes['align'],
        ),
      ),
      child: MarkdownBody(
        data: element.attributes['content'] ?? '',
        selectable: selectable,
        fitContent: false,
        inlineSyntaxes: [MarkdownImageSyntax()],
        onTapLink: onTapLink,
        builders: {MarkdownImageSyntax.tag: MarkdownImageElementBuilder()},
        imageBuilder: imageBuilder,
        styleSheet: MarkdownAlignmentHelper.alignStyleSheet(
          styleSheet,
          element.attributes['align'],
        ),
      ),
    );
  }
}
