import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum SurfaceTone { surface, muted, dark, primaryOutline, header }

enum SurfaceShape { rounded, cardShape, sharp }

enum SurfacePadding { normal, text, none }

final surfaceStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.padding(EdgeInsets.all(tokens.spacePanelPadding.r)),
    SurfaceStylePart.decoration({
      DecorationPart.color(tokens.backgroundSurface),
      DecorationPart.borderRadius(
        BorderRadius.circular(tokens.radiusContainerLarge.r),
      ),
      DecorationPart.border(
        Border.all(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      DecorationPart.boxShadow([
        BoxShadow(
          color: tokens.borderNeutralSubtle.withValues(alpha: 0.55),
          offset: Offset(0, 4.h),
          blurRadius: 12.r,
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
          BorderRadiusGeometry.circular(tokens.radius2xl.r),
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
        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      ),
    },
    SurfaceTone.surface: (_) => const {},
    SurfaceTone.primaryOutline: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.backgroundSurface),
        DecorationPart.border(
          Border.all(color: tokens.primary, width: tokens.borderWidthDefault.w),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.primary.withValues(alpha: 0.16),
            offset: Offset(0, 8.h),
            blurRadius: 30.r,
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
              width: tokens.borderWidthDefault.w,
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
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
    },
    SurfaceTone.dark: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.primaryDim),
        DecorationPart.radius(tokens.radiusContainerLarge.r),
        DecorationPart.border(
          Border.all(
            color: tokens.primaryDim,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.primaryDim.withValues(alpha: 0.35),
            offset: Offset(0, 8.h),
            blurRadius: 20.r,
          ),
        ]),
      }),
    },
  },
);
