import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

class MarkdownLinkBuilder extends MarkdownElementBuilder {
  MarkdownLinkBuilder({required this.onTapLink});

  final MarkdownTapLinkCallback onTapLink;

  @override
  Widget visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final href = element.attributes['href'];
    final title = element.attributes['title'] ?? '';
    final label = element.textContent.trim().isEmpty
        ? href ?? ''
        : element.textContent.trim();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTapLink(label, href, title),
      child: Text(label, style: preferredStyle ?? parentStyle),
    );
  }
}
