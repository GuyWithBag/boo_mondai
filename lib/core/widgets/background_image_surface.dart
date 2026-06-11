import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, SurfaceShape, surfaceStyle;
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        BoxFit,
        ImageProvider,
        Widget,
        AlignmentGeometry,
        IconData,
        BuildContext,
        Alignment,
        Icons,
        EdgeInsets,
        Clip,
        StackFit,
        Positioned,
        Image,
        Icon,
        Center,
        Padding,
        Stack;
import 'package:theme_variants/theme_variants.dart';

class BackgroundImageSurface extends StatelessWidget {
  const BackgroundImageSurface({
    super.key,
    this.image,
    this.child,
    this.style,
    this.fit = BoxFit.cover,
    this.imageAlignment = Alignment.center,
    this.missingImageIcon = Icons.image_not_supported_outlined,
    this.missingImageIconSize = 40,
  });

  final ImageProvider? image;
  final Widget? child;
  final SurfaceStyle? style;
  final BoxFit fit;
  final AlignmentGeometry imageAlignment;
  final IconData missingImageIcon;
  final double missingImageIconSize;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final resolvedStyle =
        style ?? surfaceStyle.resolve(tokens, const [SurfaceShape.sharp]);
    final childPadding = resolvedStyle.padding ?? EdgeInsets.zero;
    final finalStyle = resolvedStyle.copyWith(
      padding: EdgeInsets.zero,
      clipBehavior: resolvedStyle.clipBehavior ?? Clip.antiAlias,
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
            Center(child: Icon(missingImageIcon, size: missingImageIconSize)),
          if (child != null)
            Positioned.fill(
              child: Padding(padding: childPadding, child: child),
            ),
        ],
      ),
    );
  }
}
