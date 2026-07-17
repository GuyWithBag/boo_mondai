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

enum SurfaceShape {
  rounded,
  roundedSm,
  roundedXsm,
  cardShape,
  sharp,
  topRounded,
  circle,
}

enum SurfaceBorderColor { inherit, selected }

enum SurfacePadding {
  baseline,
  text,
  none,
  sm,
  scaffold,
  scaffoldButBottom,
  large,
}

enum SurfaceBorder { baseline, sidebar, none, top, bottom }

enum SurfaceShadow { baseline, none, tactile }

Set<StylePart<SurfaceStyle>> _surfacePalette({
  Color? background,
  Color? border,
  Color? shadow,
  Color? foreground,
}) {
  return {
    if (background != null || border != null || shadow != null)
      SurfaceStylePart.decoration({
        if (background != null) DecorationPart.color(background),
        if (border != null)
          DecorationPart.borderParts({BorderPart.color(border)}),
        if (shadow != null)
          DecorationPart.boxShadowParts({BoxShadowPart.color(shadow)}),
      }),
    if (foreground != null) ...[
      SurfaceStylePart.text({TextStylePart.color(foreground)}),
      SurfaceStylePart.icon({IconThemePart.color(foreground)}),
    ],
  };
}

final surfaceStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextBaseline)}),
  },
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
          BorderPart.style(BorderStyle.solid),
        }),
      }),
    },
    SurfaceBorder.sidebar: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderParts({
          BorderPart.width(0),
          BorderPart.right({
            BorderSidePart.width(tokens.borderWidthDefault.w),
            BorderSidePart.style(BorderStyle.solid),
          }),
        }),
      }),
    },
    SurfaceBorder.none: (_) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderParts({
          BorderPart.width(0),
          BorderPart.style(BorderStyle.none),
        }),
      }),
    },
    SurfaceBorder.top: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderParts({
          BorderPart.width(0),
          BorderPart.top({
            BorderSidePart.width(tokens.borderWidthDefault.w),
            BorderSidePart.style(BorderStyle.solid),
          }),
        }),
      }),
    },
    SurfaceBorder.bottom: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderParts({
          BorderPart.width(0),
          BorderPart.bottom({
            BorderSidePart.width(tokens.borderWidthDefault.w),
            BorderSidePart.style(BorderStyle.solid),
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
    SurfaceShape.roundedXsm: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderRadius(
          BorderRadius.circular(tokens.radiusSurfaceXsm.r),
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
    SurfaceShape.circle: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.borderRadius(BorderRadiusGeometry.circular(999)),
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
    SurfacePadding.large: (tokens) => {
      SurfaceStylePart.padding(EdgeInsets.all(tokens.spaceLayoutPaddingLg)),
    },
    SurfacePadding.baseline: (tokens) => {
      SurfaceStylePart.padding(EdgeInsets.all(tokens.spaceLayoutPadding)),
    },
    SurfacePadding.sm: (tokens) => {
      SurfaceStylePart.padding(EdgeInsets.all(tokens.spaceLayoutPaddingSm)),
    },
    SurfacePadding.scaffold: (tokens) => {
      SurfaceStylePart.padding(EdgeInsets.all(tokens.spaceScaffoldPadding)),
    },
    SurfacePadding.scaffoldButBottom: (tokens) => {
      SurfaceStylePart.padding(
        EdgeInsets.only(
          left: tokens.spaceScaffoldPadding,
          right: tokens.spaceScaffoldPadding,
          top: tokens.spaceScaffoldPadding,
        ),
      ),
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
    },
    SurfaceColor.baseline: (tokens) => _surfacePalette(
      background: tokens.colorSurfaceBackground,
      border: tokens.colorBorderNeutralSubtle,
      shadow: tokens.colorLayoutShadow,
      foreground: tokens.colorTextBaseline,
    ),
    SurfaceBorderColor.inherit: (_) => const <StylePart<SurfaceStyle>>{},
    SurfaceBorderColor.selected: (tokens) =>
        _surfacePalette(border: tokens.colorPrimary),
    SurfaceColor.primarySoft: (tokens) => {
      ..._surfacePalette(
        background: tokens.colorPrimarySoft,
        border: tokens.colorPrimaryBright,
        shadow: tokens.colorPrimaryBright,
        foreground: tokens.colorTextBaseline,
      ),
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
      }),
    },
    SurfaceColor.invisible: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorTransparent),
        DecorationPart.borderParts({BorderPart.color(tokens.colorTransparent)}),
        DecorationPart.borderParts({BorderPart.width(0)}),
        DecorationPart.boxShadowParts({
          BoxShadowPart.color(tokens.colorTransparent),
        }),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTransparent)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTransparent)}),
    },
  },
);
