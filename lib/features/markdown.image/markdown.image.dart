import 'package:boo_mondai/lib.barrel.dart'
    show ImageHelper, MarkdownImageOptions, AppTokens, MarkdownHelper;
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:theme_variants/theme_variants.dart';

// It is kept separate from MarkdownImageElementBuilder because it needs to support regular flutter_markdown_plus image and the configurable image
class MarkdownImage extends StatelessWidget {
  const MarkdownImage({
    super.key,
    required this.uri,
    this.title,
    this.alt,
    this.options,
  });

  final Uri uri;
  final String? title;
  final String? alt;
  final String? options;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final image = ImageHelper.getImageProviderFromSource(
      MarkdownHelper.resolveAttachmentUrl(uri),
    );
    if (image == null) return const SizedBox.shrink();

    // ToDo: Needs rewrite. This basically takes the config from the text and translates it into image config.
    final imageOptions = MarkdownImageOptions.parse(title, rawOptions: options);
    final child = ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radiusSurfaceXsm),
      child: Image(
        image: image,
        width: imageOptions.pixelWidth,
        height: imageOptions.pixelHeight,
        fit: imageOptions.fit,
        semanticLabel: alt,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );

    return Align(
      alignment: imageOptions.alignment,
      child: FractionallySizedBox(
        widthFactor: imageOptions.widthFactor,
        heightFactor: imageOptions.heightFactor,
        child: child,
      ),
    );
  }
}

class MarkdownImageElementBuilder extends MarkdownElementBuilder {
  @override
  Widget visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final uri = Uri.tryParse(element.attributes['src'] ?? '');
    if (uri == null) return const SizedBox.shrink();

    return MarkdownImage(
      uri: uri,
      title: element.attributes['title'],
      alt: element.attributes['alt'],
      options: element.attributes['options'],
    );
  }
}
