import 'package:boo_mondai/core/widgets/markdown_alignment.helper.dart';
import 'package:boo_mondai/core/widgets/markdown_attachment_url_resolver.dart';
import 'package:boo_mondai/core/widgets/markdown_body.builder.dart';
import 'package:boo_mondai/core/widgets/markdown_link.builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

class AlignedLineMarkdownBuilder extends MarkdownElementBuilder {
  AlignedLineMarkdownBuilder({
    required this.selectable,
    required this.onTapLink,
    required this.resolveAttachmentUrl,
    required this.imageBuilder,
    required this.styleSheet,
  });

  final bool selectable;
  final MarkdownTapLinkCallback onTapLink;
  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;
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
        data: rewriteMarkdownImageAttributeSyntax(
          element.attributes['content'] ?? '',
        ),
        selectable: selectable,
        fitContent: false,
        onTapLink: onTapLink,
        builders: {'a': MarkdownLinkBuilder(onTapLink: onTapLink)},
        imageBuilder: imageBuilder,
        styleSheet: MarkdownAlignmentHelper.alignStyleSheet(
          styleSheet,
          element.attributes['align'],
        ),
      ),
    );
  }
}
