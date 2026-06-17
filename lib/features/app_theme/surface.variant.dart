import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum SurfaceTone { none, streak, primarySoft }

enum SurfaceColor { baseline, muted, dark, header }

enum SurfaceShape { rounded, roundedSm, cardShape, sharp, topRounded }

enum SurfacePadding { normal, text, none }

enum SurfaceBorder { normal, sidebar, none, top, bottom, primary, ghost }

enum SurfaceShadow { normal, none, tactile }

final surfaceStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {},
  defaultVariants: const [
    SurfaceColor.baseline,
    SurfaceBorder.normal,
    SurfacePadding.normal,
    SurfaceShape.rounded,
  ],
  variants: {
    SurfaceShadow.tactile: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorBorderNeutralSubtle,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
    },
    SurfaceShadow.normal: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorBorderNeutralSubtle.withValues(alpha: 0.55),
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
            color: tokens.colorBorderNeutralSubtle,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
    },
    SurfaceBorder.primary: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.border(
          Border.all(
            color: tokens.colorPrimary,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
    },
    SurfaceBorder.ghost: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.border(
          Border.all(
            color: tokens.colorBorderNeutralSubtle,
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
              color: tokens.colorBorderNeutralSubtle,
              width: tokens.borderWidthDefault.w,
            ),
          ),
        ),
      }),
    },
    SurfaceBorder.none: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.border(Border.fromBorderSide(BorderSide.none)),
      }),
    },
    SurfaceBorder.top: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.border(
          BorderDirectional(
            top: BorderSide(
              color: tokens.colorBorderNeutralSubtle,
              width: tokens.borderWidthDefault.w,
            ),
          ),
        ),
      }),
    },
    SurfaceBorder.bottom: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.border(
          BoxBorder.fromLTRB(
            bottom: BorderSide(
              color: tokens.colorBorderNeutralSubtle,
              width: tokens.borderWidthDefault.w,
            ),
          ),
        ),
      }),
    },
    SurfaceShape.rounded: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderRadius(
          BorderRadius.circular(tokens.radiusSurface.r),
        ),
      }),
    },
    SurfaceShape.roundedSm: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderRadius(
          BorderRadius.circular(tokens.radiusSurfaceSm.r),
        ),
      }),
    },
    SurfaceShape.cardShape: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderRadius(
          BorderRadiusGeometry.circular(tokens.studyCardRadius.r),
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
    SurfacePadding.normal: (tokens) => {
      SurfaceStylePart.padding(EdgeInsets.all(tokens.spaceLayoutPadding)),
    },
    SurfacePadding.none: (_) => {SurfaceStylePart.padding(EdgeInsets.all(0))},
    SurfacePadding.text: (_) => {
      SurfaceStylePart.padding(
        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      ),
    },
    SurfaceTone.streak: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorStreak),
        DecorationPart.border(
          Border.all(
            color: tokens.colorStreakDim,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorStreakDim,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
    },
    SurfaceColor.baseline: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorSurfaceBackground),
      }),
    },
    SurfaceTone.primarySoft: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorPrimarySoft),
        DecorationPart.border(
          Border.all(
            color: tokens.colorPrimaryBright,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorPrimaryBright,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorPrimary)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorPrimary)}),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
    },
    SurfaceColor.header: (tokens) => {
      SurfaceStylePart.decoration({DecorationPart.color(tokens.colorMuted)}),
    },
    SurfaceColor.muted: (tokens) => {
      SurfaceStylePart.decoration({DecorationPart.color(tokens.colorMuted)}),
    },
    SurfaceColor.dark: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorPrimaryDim),
        DecorationPart.radius(tokens.radiusSurface.r),
        DecorationPart.border(
          Border.all(
            color: tokens.colorPrimaryDim,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorPrimaryDim.withValues(alpha: 0.35),
            offset: Offset(0, 8.h),
            blurRadius: 20.r,
          ),
        ]),
      }),
    },
  },
);
