import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ImageHelper,
        MarkdownAttachmentUrlResolver,
        MarkdownHelper,
        MarkdownImageOptions,
        ScaleHelper;
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

// It is kept separate from MarkdownImageElementBuilder because it needs to support regular flutter_markdown_plus image and the configurable image
class MarkdownImage extends SignalHookWidget {
  const MarkdownImage({
    super.key,
    required this.uri,
    this.title,
    this.alt,
    this.options,
    this.resolveAttachmentUrl,
    this.constraints,
    this.contentScale = 1,
  });

  final Uri uri;
  final String? title;
  final String? alt;
  final String? options;
  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;
  final BoxConstraints? constraints;
  final double contentScale;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final imageSignal = useFutureSignal(() async {
      final imageUrl =
          await resolveAttachmentUrl?.call(uri) ??
          await MarkdownHelper.resolveAttachmentUrl(uri);
      return ImageHelper.getImageProviderFromSource(imageUrl);
    }, keys: [uri, resolveAttachmentUrl]);
    final image = imageSignal.value.map(
      data: (value) => value,
      error: () => null,
      loading: () => null,
    );
    if (image == null) return const SizedBox.shrink();

    // ToDo: Needs rewrite. This basically takes the config from the text and translates it into image config.
    final imageOptions = MarkdownImageOptions.parse(title, rawOptions: options);
    final resolvedConstraints = _scaledConstraints(
      constraints ?? const BoxConstraints.tightFor(width: 250, height: 250),
      contentScale,
    );
    final child = ConstrainedBox(
      constraints: resolvedConstraints,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceXsm),
        child: Image(
          image: image,
          fit: imageOptions.fit,
          semanticLabel: alt,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
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
  MarkdownImageElementBuilder({
    this.resolveAttachmentUrl,
    this.imageConstraints,
    this.contentScale = 1,
  });

  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;
  final BoxConstraints? imageConstraints;
  final double contentScale;

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
      resolveAttachmentUrl: resolveAttachmentUrl,
      constraints: imageConstraints,
      contentScale: contentScale,
    );
  }
}

BoxConstraints _scaledConstraints(BoxConstraints constraints, double scale) {
  double scaleValue(double value) {
    if (value.isInfinite) return value;
    return ScaleHelper.getScaledValue(value, scale);
  }

  return BoxConstraints(
    minWidth: scaleValue(constraints.minWidth),
    maxWidth: scaleValue(constraints.maxWidth),
    minHeight: scaleValue(constraints.minHeight),
    maxHeight: scaleValue(constraints.maxHeight),
  );
}
