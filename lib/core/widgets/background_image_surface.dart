import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, SurfaceShape, surfaceStyle, SurfaceBorder;
import 'package:flutter/material.dart'
    show
        Alignment,
        AlignmentGeometry,
        BoxFit,
        AssetImage,
        BuildContext,
        Center,
        Clip,
        EdgeInsets,
        Icon,
        IconData,
        IconTheme,
        Icons,
        Image,
        ImageProvider,
        NetworkImage,
        Padding,
        Positioned,
        Stack,
        StackFit,
        StatelessWidget,
        Widget;
import 'package:theme_variants/theme_variants.dart';

ImageProvider? backgroundImageProviderFromSource(String? source) {
  final value = source?.trim();
  if (value == null || value.isEmpty) return null;

  final uri = Uri.tryParse(value);
  if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
    return NetworkImage(value);
  }

  return AssetImage(value);
}

class BackgroundImageSurface extends StatelessWidget {
  const BackgroundImageSurface({
    super.key,
    this.image,
    this.child,
    this.style,
    this.fit = BoxFit.cover,
    this.imageAlignment = Alignment.center,
    this.clipBehavior = Clip.antiAlias,
    this.missingImageIcon = Icons.image_not_supported_outlined,
    this.missingImageIconSize = 40,
  });

  final ImageProvider? image;
  final Widget? child;
  final SurfaceStyle? style;
  final BoxFit fit;
  final AlignmentGeometry imageAlignment;
  final Clip clipBehavior;
  final IconData missingImageIcon;
  final double missingImageIconSize;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final resolvedStyle =
        style ??
        surfaceStyle.resolve(tokens, const [
          SurfaceShape.sharp,
          SurfaceBorder.none,
        ]);
    final childPadding = resolvedStyle.padding ?? EdgeInsets.zero;
    final finalStyle = resolvedStyle.copyWith(
      padding: EdgeInsets.zero,
      clipBehavior: resolvedStyle.clipBehavior ?? clipBehavior,
    );

    return Surface(
      style: finalStyle,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (image case final image?)
            Positioned.fill(
              child: Image(image: image, fit: fit, alignment: imageAlignment),
            )
          else
            Center(
              child: IconTheme(
                data: finalStyle.iconTheme,
                child: Icon(missingImageIcon, size: missingImageIconSize),
              ),
            ),
          if (child != null)
            Positioned.fill(
              child: Padding(padding: childPadding, child: child),
            ),
        ],
      ),
    );
  }
}
