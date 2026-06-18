import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum SurfaceColor {
  baseline,
  muted,
  dark,
  header,
  streak,
  primarySoft,
  invisible,
}

enum SurfaceShape { rounded, roundedSm, cardShape, sharp, topRounded }

enum SurfacePadding { baseline, text, none }

enum SurfaceBorder { baseline, sidebar, none, top, bottom }

enum SurfaceShadow { baseline, none, tactile }

Set<StylePart<SurfaceStyle>> _surfacePalette({
  required Color background,
  required Color border,
  required Color shadow,
  Color? foreground,
}) {
  return {
    SurfaceStylePart.decoration({
      DecorationPart.color(background),
      DecorationPart.borderParts({BorderPart.color(border)}),
      DecorationPart.boxShadowParts({BoxShadowPart.color(shadow)}),
    }),
    if (foreground != null) ...[
      SurfaceStylePart.text({TextStylePart.color(foreground)}),
      SurfaceStylePart.icon({IconThemePart.color(foreground)}),
    ],
  };
}

final surfaceStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (_) => {},
  defaultVariants: const [
    SurfaceColor.baseline,
    SurfaceBorder.baseline,
    SurfacePadding.baseline,
    SurfaceShape.rounded,
    SurfaceShadow.baseline,
  ],
  variants: {
    SurfaceShadow.tactile: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset(0, tokens.buttonShadowOffset.h)),
          BoxShadowPart.blurRadius(0),
        }),
      }),
    },
    SurfaceShadow.baseline: (_) => {
      SurfaceStylePart.decoration({
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset(0, 4.h)),
          BoxShadowPart.blurRadius(12),
        }),
      }),
    },
    SurfaceShadow.none: (_) => {
      SurfaceStylePart.decoration({
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset.zero),
          BoxShadowPart.blurRadius(0),
        }),
      }),
    },
    SurfaceBorder.baseline: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderParts({
          BorderPart.width(tokens.borderWidthDefault.w),
        }),
      }),
    },
    SurfaceBorder.sidebar: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderParts({
          BorderPart.width(0),
          BorderPart.right({BorderSidePart.width(tokens.borderWidthDefault.w)}),
        }),
      }),
    },
    SurfaceBorder.none: (_) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderParts({BorderPart.width(0)}),
      }),
    },
    SurfaceBorder.top: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderParts({
          BorderPart.width(0),
          BorderPart.top({BorderSidePart.width(tokens.borderWidthDefault.w)}),
        }),
      }),
    },
    SurfaceBorder.bottom: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderParts({
          BorderPart.width(0),
          BorderPart.bottom({
            BorderSidePart.width(tokens.borderWidthDefault.w),
          }),
        }),
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
    SurfacePadding.baseline: (tokens) => {
      SurfaceStylePart.padding(EdgeInsets.all(tokens.spaceLayoutPadding)),
    },
    SurfacePadding.none: (_) => {SurfaceStylePart.padding(EdgeInsets.all(0))},
    SurfacePadding.text: (_) => {
      SurfaceStylePart.padding(
        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      ),
    },
    SurfaceColor.streak: (tokens) => {
      ..._surfacePalette(
        background: tokens.colorStreak,
        border: tokens.colorStreakDim,
        shadow: tokens.colorStreakDim,
        foreground: tokens.colorTextOnBrand,
      ),
      SurfaceStylePart.decoration({
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset(0, tokens.buttonShadowOffset.h)),
          BoxShadowPart.blurRadius(0),
        }),
      }),
    },
    SurfaceColor.baseline: (tokens) => _surfacePalette(
      background: tokens.colorSurfaceBackground,
      border: tokens.colorBorderNeutralSubtle,
      shadow: tokens.colorBorderNeutralSubtle.withValues(alpha: 0.30),
      foreground: tokens.colorTextBaseline,
    ),
    SurfaceColor.primarySoft: (tokens) => {
      ..._surfacePalette(
        background: tokens.colorPrimarySoft,
        border: tokens.colorPrimaryBright,
        shadow: tokens.colorPrimaryBright,
        foreground: tokens.colorTextBaseline,
      ),
      SurfaceStylePart.decoration({
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset(0, tokens.buttonShadowOffset.h)),
          BoxShadowPart.blurRadius(0),
        }),
      }),
    },
    SurfaceColor.header: (tokens) => _surfacePalette(
      background: tokens.colorMuted,
      border: tokens.colorBorderNeutralSubtle,
      shadow: tokens.colorBorderNeutralSubtle.withValues(alpha: 0.30),
      foreground: tokens.colorTextBaseline,
    ),
    SurfaceColor.muted: (tokens) => _surfacePalette(
      background: tokens.colorMuted,
      border: tokens.colorBorderNeutralSubtle,
      shadow: tokens.colorBorderNeutralSubtle.withValues(alpha: 0.30),
      foreground: tokens.colorTextBaseline,
    ),
    SurfaceColor.dark: (tokens) => {
      ..._surfacePalette(
        background: tokens.colorPrimaryDim,
        border: tokens.colorPrimaryDim,
        shadow: tokens.colorPrimaryDim.withValues(alpha: 0.35),
      ),
      SurfaceStylePart.decoration({
        DecorationPart.radius(tokens.radiusSurface.r),
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset(0, 8.h)),
          BoxShadowPart.blurRadius(20.r),
        }),
      }),
    },
    SurfaceColor.invisible: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorTransparent),
        DecorationPart.borderParts({BorderPart.color(tokens.colorTransparent)}),
        DecorationPart.boxShadowParts({
          BoxShadowPart.color(tokens.colorTransparent),
        }),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTransparent)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTransparent)}),
    },
  },
);
