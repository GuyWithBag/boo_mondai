import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownAlignmentHelper,
        MarkdownHelper,
        MarkdownAlignedTextSyntax,
        MarkdownImageSyntax,
        AppTokens,
        MarkdownAlignedText,
        MarkdownImageElementBuilder,
        MarkdownMedia;
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:theme_variants/theme_variants.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownTextBody extends StatelessWidget {
  const MarkdownTextBody({
    super.key,
    required this.resolvedTextStyle,
    required this.data,
    required this.selectable,
    required this.defaultAlignment,
    this.contentScale = 1,
  });

  final TextStyle resolvedTextStyle;
  final String data;
  final bool selectable;
  final WrapAlignment defaultAlignment;
  final double contentScale;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    final styleSheet = MarkdownAlignmentHelper.copyStyleSheetWithAlignment(
      MarkdownHelper.getMarkdownStyleSheet(tokens, resolvedTextStyle),
      defaultAlignment,
    );

    Future<void> launchLink(String? href) async {
      final uri = Uri.tryParse(href ?? '');
      if (uri == null) return;
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }

    void onTapLink(String text, String? href, String title) {
      launchLink(href);
    }

    return Align(
      alignment: MarkdownAlignmentHelper.alignmentForWrapAlignment(
        defaultAlignment,
      ),
      child: MarkdownBody(
        data: data,
        selectable: selectable,
        fitContent: false,
        blockSyntaxes: [MarkdownAlignedTextSyntax()],
        inlineSyntaxes: [MarkdownImageSyntax()],
        builders: {
          MarkdownImageSyntax.tag: MarkdownImageElementBuilder(),
          MarkdownAlignedTextSyntax.tag: MarkdownAlignedText(
            selectable: selectable,
            onTapLink: onTapLink,
            imageBuilder: (uri, title, alt) =>
                MarkdownMedia(uri: uri, title: title, alt: alt),
            styleSheet: styleSheet,
          ),
        },

        onTapLink: onTapLink,
        imageBuilder: (uri, title, alt) =>
            MarkdownMedia(uri: uri, title: title, alt: alt),
        styleSheet: styleSheet,
      ),
    );
  }
}
