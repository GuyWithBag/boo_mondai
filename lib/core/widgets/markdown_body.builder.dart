import 'package:boo_mondai/core/widgets/aligned_line_markdown.builder.dart';
import 'package:boo_mondai/core/widgets/aligned_line_markdown.syntax.dart';
import 'package:boo_mondai/core/widgets/markdown_alignment.helper.dart';
import 'package:boo_mondai/core/widgets/markdown_attachment_url_resolver.dart';
import 'package:boo_mondai/core/widgets/markdown_link.builder.dart';
import 'package:boo_mondai/core/widgets/markdown_media.builder.dart';
import 'package:boo_mondai/lib.barrel.dart' show AppTokens, MarkdownHelper;
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildMarkdownBody({
  required AppTokens tokens,
  required TextStyle resolvedTextStyle,
  required String data,
  required bool selectable,
  required WrapAlignment defaultAlignment,
  required MarkdownTapLinkCallback onTapLink,
  required MarkdownAttachmentUrlResolver? resolveAttachmentUrl,
  double contentScale = 1,
}) {
  final styleSheet = MarkdownAlignmentHelper.copyStyleSheetWithAlignment(
    MarkdownHelper.getMarkdownStyleSheet(tokens, resolvedTextStyle),
    defaultAlignment,
  );
  final imageBuilder = MarkdownMediaBuilder.build(
    tokens,
    resolveAttachmentUrl,
    contentScale,
  );

  return Align(
    alignment: MarkdownAlignmentHelper.alignmentForWrapAlignment(
      defaultAlignment,
    ),
    child: MarkdownBody(
      data: rewriteMarkdownImageAttributeSyntax(data),
      selectable: selectable,
      fitContent: false,
      blockSyntaxes: [AlignedLineMarkdownSyntax()],
      builders: {
        'a': MarkdownLinkBuilder(onTapLink: onTapLink),
        alignedLineMarkdownTag: AlignedLineMarkdownBuilder(
          selectable: selectable,
          onTapLink: onTapLink,
          resolveAttachmentUrl: resolveAttachmentUrl,
          imageBuilder: imageBuilder,
          styleSheet: styleSheet,
        ),
      },
      onTapLink: onTapLink,
      imageBuilder: imageBuilder,
      styleSheet: styleSheet,
    ),
  );
}

MarkdownTapLinkCallback buildMarkdownLaunchLink(
  MarkdownAttachmentUrlResolver? resolveAttachmentUrl,
) {
  return (String text, String? href, String title) async {
    if (href == null) return;
    final uri = Uri.tryParse(href);
    if (uri == null) return;

    final resolvedHref = MarkdownMediaBuilder.resolveAttachmentHref(
      uri,
      resolveAttachmentUrl,
    );
    if (resolvedHref == null) return;

    await _launchLink(resolvedHref);
  };
}

String rewriteMarkdownImageAttributeSyntax(String data) {
  return data.replaceAllMapped(
    RegExp(r'!\[([^\]\r\n]*)\]\(([^)\r\n]+)\)\{([^}\r\n]+)\}'),
    (match) {
      final alt = match.group(1) ?? '';
      final source = match.group(2) ?? '';
      final params = match.group(3) ?? '';
      final escapedParams = params
          .replaceAll(r'\', r'\\')
          .replaceAll('"', r'\"');
      return '![$alt]($source "__bm_image_options:$escapedParams")';
    },
  );
}

Future<void> _launchLink(String href) async {
  final uri = Uri.tryParse(href);
  if (uri == null) return;
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
