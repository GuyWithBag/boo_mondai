import 'package:boo_mondai/lib.barrel.dart'
    show
        Cube,
        PhysicalCardController,
        AppTokens,
        ScaleHelper,
        surfaceStyle,
        SurfaceShape,
        usePhysicalCardController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariantsContext, Surface, SurfaceStyle;

class PhysicalCard extends HookWidget {
  const PhysicalCard({
    super.key,
    this.controller,
    required this.front,
    this.back,
    this.tapToFlip = false,
    this.onTap,
    this.animateChanges = true,
    this.frontVariants = const [],
    this.backVariants = const [],
  });

  final PhysicalCardController? controller;
  final Widget front;
  final Widget? back;
  final List<Object> frontVariants;
  final List<Object> backVariants;
  final bool tapToFlip;
  final VoidCallback? onTap;
  final bool animateChanges;

  @override
  Widget build(BuildContext context) {
    final effectiveController =
        controller ?? usePhysicalCardController(context);
    useListenable(controller);
    final tokens = context.themeTokens<AppTokens>();
    final radius = ScaleHelper.getScaledRadiusFromBase(
      radius: tokens.studyCardRadius,
      current: effectiveController.width,
      base: tokens.studyCardWidth,
    );
    final resolvedFrontStyle = surfaceStyle.resolve(tokens, frontVariants);
    final resolvedBackStyle = surfaceStyle.resolve(tokens, backVariants);
    final scaledFrontStyle = resolvedFrontStyle.copyWith(
      decoration: resolvedFrontStyle.decoration.copyWith(
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
    );
    final scaledBackStyle = resolvedFrontStyle.copyWith(
      decoration: resolvedBackStyle.decoration.copyWith(
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
    );

    final cube = Cube(
      controller: effectiveController.controller,
      front: Surface(style: scaledFrontStyle, child: front),
      back: Surface(style: scaledBackStyle, child: back),
      depth: effectiveController.depth,
    );

    if (!tapToFlip && onTap == null) {
      return cube;
    }

    return GestureDetector(
      onTap: () {
        onTap?.call();
        if (tapToFlip) {
          effectiveController.flip();
        }
      },
      child: cube,
    );
  }
}
