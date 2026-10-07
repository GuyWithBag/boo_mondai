import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownAlignmentHelper,
        MarkdownHelper,
        MarkdownAlignedTextSyntax,
        MarkdownImageSyntax,
        MarkdownAttachmentUrlResolver,
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
    this.resolveAttachmentUrl,
  });

  final TextStyle resolvedTextStyle;
  final String data;
  final bool selectable;
  final WrapAlignment defaultAlignment;
  final double contentScale;
  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    final styleSheet = MarkdownAlignmentHelper.copyStyleSheetWithAlignment(
      MarkdownHelper.getMarkdownStyleSheet(tokens, resolvedTextStyle),
      defaultAlignment,
    );

    Future<Uri?> resolveExternalUri(String? href) async {
      final value = href?.trim() ?? '';
      if (value.isEmpty) return null;

      final uri = Uri.tryParse(value);
      if (uri == null) return null;
      final resolved = await resolveAttachmentUrl?.call(uri);
      if (resolved != null) return Uri.tryParse(resolved);

      if (uri.hasScheme) return uri;

      return Uri.tryParse('https://$value');
    }

    Future<void> launchLink(String? href) async {
      final uri = await resolveExternalUri(href);
      if (uri == null) return;
      await launchUrl(uri, mode: LaunchMode.externalApplication);
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
          MarkdownImageSyntax.tag: MarkdownImageElementBuilder(
            resolveAttachmentUrl: resolveAttachmentUrl,
          ),
          MarkdownAlignedTextSyntax.tag: MarkdownAlignedText(
            selectable: selectable,
            onTapLink: onTapLink,
            imageBuilder: (uri, title, alt) => MarkdownMedia(
              uri: uri,
              title: title,
              alt: alt,
              resolveAttachmentUrl: resolveAttachmentUrl,
              contentScale: contentScale,
            ),
            styleSheet: styleSheet,
          ),
        },

        onTapLink: onTapLink,
        imageBuilder: (uri, title, alt) => MarkdownMedia(
          uri: uri,
          title: title,
          alt: alt,
          resolveAttachmentUrl: resolveAttachmentUrl,
          contentScale: contentScale,
        ),
        styleSheet: styleSheet,
      ),
    );
  }
}
