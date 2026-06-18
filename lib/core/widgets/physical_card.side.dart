import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ScaleHelper, surfaceStyle, SurfaceShape;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class PhysicalCardSide extends StatelessWidget {
  const PhysicalCardSide({
    super.key,
    required this.child,
    this.maxWidth,
    this.surfaceStyleVariants = const [],
  });

  final Widget child;
  final List<Object> surfaceStyleVariants;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final effectiveMaxWidth = maxWidth ?? tokens.studyCardWidth;
    final radius = ScaleHelper.radius(
      radius: tokens.studyCardRadius,
      current: effectiveMaxWidth,
      base: tokens.studyCardWidth,
    );
    final resolvedStyle = surfaceStyle.resolve(tokens, [
      ...surfaceStyleVariants,
      SurfaceShape.cardShape,
    ]);
    final style = resolvedStyle.copyWith(
      decoration: resolvedStyle.decoration.copyWith(
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
      child: Surface(style: style, child: child),
    );
  }
}
