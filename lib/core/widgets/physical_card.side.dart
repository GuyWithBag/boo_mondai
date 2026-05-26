import 'package:boo_mondai/lib.barrel.dart'
    show SurfaceTone, AppTokens, surfaceStyle, SurfaceShape, SurfacePadding;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class PhysicalCardSide extends StatelessWidget {
  const PhysicalCardSide({
    super.key,
    required this.child,
    this.tone = SurfaceTone.surface,
    this.maxWidth = 480,
  });

  final Widget child;
  final SurfaceTone tone;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Surface(
        style: surfaceStyle.resolve(tokens, [
          tone,
          SurfaceShape.cardShape,
          SurfacePadding.none,
        ]),
        child: child,
      ),
    );
  }
}
