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
import 'package:markdown/markdown.dart' as md;
import 'package:theme_variants/theme_variants.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownTextBody extends StatelessWidget {
  const MarkdownTextBody({
    super.key,
    required this.resolvedTextStyle,
    required this.data,
    required this.selectable,
    required this.defaultAlignment,
    this.fitContent = false,
    this.contentScale = 1,
    this.resolveAttachmentUrl,
    this.imageConstraints,
    this.audioConstraints,
  });

  final TextStyle resolvedTextStyle;
  final String data;
  final bool selectable;
  final WrapAlignment defaultAlignment;
  final bool fitContent;
  final double contentScale;
  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;
  final BoxConstraints? imageConstraints;
  final BoxConstraints? audioConstraints;

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

    final body = MarkdownBody(
      data: data,
      selectable: selectable,
      fitContent: fitContent,
      extensionSet: md.ExtensionSet.gitHubFlavored,
      softLineBreak: true,
      blockSyntaxes: [MarkdownAlignedTextSyntax()],
      inlineSyntaxes: [MarkdownImageSyntax()],
      builders: {
        MarkdownImageSyntax.tag: MarkdownImageElementBuilder(
          resolveAttachmentUrl: resolveAttachmentUrl,
          imageConstraints: imageConstraints,
          contentScale: contentScale,
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
            imageConstraints: imageConstraints,
            audioConstraints: audioConstraints,
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
        imageConstraints: imageConstraints,
        audioConstraints: audioConstraints,
      ),
      styleSheet: styleSheet,
    );

    if (fitContent) return body;

    return SizedBox(width: double.infinity, child: body);
  }
}
