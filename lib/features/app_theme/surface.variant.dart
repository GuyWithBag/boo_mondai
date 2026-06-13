import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum SurfaceTone {
  surface,
  muted,
  dark,
  primarySoft,
  primaryOutline,
  header,
  streak,
}

enum SurfaceShape { rounded, cardShape, sharp, topRounded }

enum SurfacePadding { normal, text, none }

enum SurfaceBorder { normal, sidebar, none, top }

enum SurfaceShadow { normal, none, tactile }

final surfaceStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.padding(EdgeInsets.all(tokens.spacePanelPadding.r)),
    SurfaceStylePart.decoration({
      DecorationPart.color(tokens.backgroundSurface),
      DecorationPart.borderRadius(
        BorderRadius.circular(tokens.radiusSurface.r),
      ),
    }),
  },
  defaultVariants: const [
    SurfaceTone.surface,
    SurfaceBorder.normal,
    SurfacePadding.normal,
    SurfaceShape.rounded,
  ],
  variants: {
    SurfaceShadow.tactile: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.primaryDim,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
    },
    SurfaceShadow.normal: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.borderNeutralSubtle.withValues(alpha: 0.55),
            offset: Offset(0, 4.h),
            blurRadius: 12.r,
          ),
        ]),
      }),
    },
    SurfaceShadow.none: (tokens) => {
      SurfaceStylePart.decoration({DecorationPart.boxShadow([])}),
    },
    SurfaceBorder.normal: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.border(
          Border.all(
            color: tokens.borderNeutralSubtle,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
    },
    SurfaceBorder.sidebar: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.border(
          BorderDirectional(
            end: BorderSide(
              color: tokens.borderNeutralSubtle,
              width: tokens.borderWidthDefault.w,
            ),
          ),
        ),
      }),
    },
    SurfaceBorder.none: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.border(
          Border.all(color: tokens.colorTransparent, width: 0),
        ),
        DecorationPart.boxShadow([BoxShadow(color: tokens.colorTransparent)]),
      }),
    },
    SurfaceBorder.top: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.border(
          BorderDirectional(
            top: BorderSide(
              color: tokens.borderNeutralSubtle,
              width: tokens.borderWidthDefault.w,
            ),
          ),
        ),
      }),
    },
    SurfaceShape.rounded: (_) => const {},
    SurfaceShape.cardShape: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderRadius(
          BorderRadiusGeometry.circular(tokens.radiusCard.r),
        ),
      }),
    },
    SurfaceShape.topRounded: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderRadius(
          BorderRadiusGeometry.vertical(
            top: Radius.circular(tokens.radiusSurfaceLg.r),
          ),
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
    SurfaceTone.streak: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.streak),
        DecorationPart.border(
          Border.all(color: tokens.streak, width: tokens.borderWidthDefault.w),
        ),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
    },
    SurfaceTone.surface: (_) => const {},
    SurfaceTone.primarySoft: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.primarySoft),
        DecorationPart.border(
          Border.all(color: tokens.colorTransparent, width: 0),
        ),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
    },
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
        DecorationPart.radius(tokens.radiusSurface.r),
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
