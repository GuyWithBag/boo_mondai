import 'package:boo_mondai/lib.barrel.dart'
    show
        SurfaceTone,
        AppTokens,
        surfaceStyle,
        SurfaceShape,
        SurfacePadding,
        widthCard;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class PhysicalCardSide extends StatelessWidget {
  const PhysicalCardSide({
    super.key,
    required this.child,
    this.tone = SurfaceTone.surface,
    this.maxWidth = widthCard,
  });

  final Widget child;
  final SurfaceTone tone;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final radius = tokens.radiusCard * (maxWidth / tokens.widthCard);
    final resolvedStyle = surfaceStyle.resolve(tokens, [
      tone,
      SurfaceShape.cardShape,
      SurfacePadding.none,
    ]);
    final style = resolvedStyle.copyWith(
      decoration: resolvedStyle.decoration.copyWith(
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Surface(style: style, child: child),
    );
  }
}
