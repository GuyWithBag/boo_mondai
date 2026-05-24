import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum SurfaceTone { surface, muted, dark, primaryOutline, header }

enum SurfaceShape { rounded, cardShape, sharp }

enum SurfacePadding { normal, text, none }

final surfaceStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.padding(EdgeInsets.all(tokens.spacePanelPadding)),
    SurfaceStylePart.decoration({
      DecorationPart.color(tokens.backgroundSurface),
      DecorationPart.borderRadius(
        BorderRadius.circular(tokens.radiusContainerLarge),
      ),
      DecorationPart.border(
        Border.all(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault,
        ),
      ),
      DecorationPart.boxShadow([
        BoxShadow(
          color: tokens.borderNeutralSubtle.withValues(alpha: 0.55),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ]),
    }),
  },
  defaultVariants: const [SurfaceTone.surface],
  variants: {
    SurfaceShape.rounded: (_) => const {},
    SurfaceShape.cardShape: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderRadius(
          BorderRadiusGeometry.circular(tokens.radius2xl),
        ),
      }),
    },
    SurfaceShape.sharp: (_) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderRadius(BorderRadius.zero),
      }),
    },
    SurfacePadding.normal: (_) => const {},
    SurfacePadding.none: (_) => {SurfaceStylePart.padding(EdgeInsets.all(0))},
    SurfacePadding.text: (_) => {
      SurfaceStylePart.padding(
        EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
      ),
    },
    SurfaceTone.surface: (_) => const {},
    SurfaceTone.primaryOutline: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.backgroundSurface),
        DecorationPart.border(
          Border.all(color: tokens.primary, width: tokens.borderWidthDefault),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.primary.withValues(alpha: 0.16),
            offset: const Offset(0, 8),
            blurRadius: 30,
          ),
        ]),
      }),
    },
    SurfaceTone.header: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.softGray),
        DecorationPart.border(
          // Border.all(
          //   color: tokens.borderNeutralSubtle,
          //   width: tokens.borderWidthDefault,
          // ),
          BoxBorder.fromLTRB(
            bottom: BorderSide(
              color: tokens.borderNeutralSubtle,
              width: tokens.borderWidthDefault,
            ),
          ),
        ),
        DecorationPart.boxShadow([BoxShadow(color: tokens.colorTransparent)]),
      }),
    },
    SurfaceTone.muted: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.softGray),
        DecorationPart.border(
          Border.all(
            color: tokens.borderNeutralSubtle,
            width: tokens.borderWidthDefault,
          ),
        ),
      }),
    },
    SurfaceTone.dark: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.primaryDim),
        DecorationPart.radius(tokens.radiusContainerLarge),
        DecorationPart.border(
          Border.all(
            color: tokens.primaryDim,
            width: tokens.borderWidthDefault,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.primaryDim.withValues(alpha: 0.35),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ]),
      }),
    },
  },
);
