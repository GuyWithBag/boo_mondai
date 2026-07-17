import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:theme_variants/theme_variants.dart';

enum SnackbarColor {
  primary,
  surface,
  success,
  error,
  streak,
  muted,
  again,
  hard,
  good,
  easy,
}

enum SnackbarVariant { elevated, flat, dashed }

Set<StylePart<SurfaceStyle>> _snackbarPalette({
  required Color background,
  required Color border,
  required Color shadow,
  required Color foreground,
}) {
  return {
    SurfaceStylePart.decoration({
      DecorationPart.color(background),
      DecorationPart.borderParts({BorderPart.color(border)}),
      DecorationPart.boxShadowParts({BoxShadowPart.color(shadow)}),
    }),
    SurfaceStylePart.content({
      ContentStylePart.text({TextStylePart.color(foreground)}),
      ContentStylePart.icon({IconThemePart.color(foreground)}),
    }),
  };
}

final snackbarStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.padding(
      EdgeInsets.symmetric(
        horizontal: tokens.spaceLayoutGapMd.w,
        vertical: tokens.spaceLayoutGapSm.h,
      ),
    ),
    SurfaceStylePart.decoration({
      DecorationPart.borderRadius(
        BorderRadius.circular(tokens.radiusSurfaceXsm.r),
      ),
      DecorationPart.borderParts({
        BorderPart.width(tokens.borderWidthDefault.w),
        BorderPart.style(BorderStyle.solid),
      }),
    }),
    SurfaceStylePart.content({
      ContentStylePart.text({
        TextStylePart.fontSize(tokens.textSizeLabel.sp),
        TextStylePart.fontWeight(tokens.fontWeightTextStrong),
        TextStylePart.height(tokens.lineHeightTextBody),
      }),
      ContentStylePart.icon({IconThemePart.size(tokens.sizeIconSm.sp)}),
    }),
  },
  defaultVariants: const [SnackbarColor.surface, SnackbarVariant.elevated],
  variants: {
    SnackbarColor.primary: (tokens) => _snackbarPalette(
      background: tokens.colorPrimary,
      border: tokens.colorPrimary,
      shadow: tokens.colorPrimaryDim.withValues(alpha: 0.45),
      foreground: tokens.colorTextOnBrand,
    ),
    SnackbarColor.surface: (tokens) => _snackbarPalette(
      background: tokens.colorSurfaceBackground,
      border: tokens.colorBorderNeutralSubtle,
      shadow: tokens.colorBorderNeutralSubtle,
      foreground: tokens.colorTextBaseline,
    ),
    SnackbarColor.success: (tokens) => _snackbarPalette(
      background: tokens.colorActionSuccessBackground,
      border: tokens.colorActionSuccessBorder,
      shadow: tokens.colorActionSuccessBorder,
      foreground: tokens.colorActionSuccess,
    ),
    SnackbarColor.error: (tokens) => _snackbarPalette(
      background: tokens.colorActionErrorBackground,
      border: tokens.colorActionErrorBorder,
      shadow: tokens.colorActionErrorBorder,
      foreground: tokens.colorActionError,
    ),
    SnackbarColor.streak: (tokens) => _snackbarPalette(
      background: tokens.colorStreak,
      border: tokens.colorStreak,
      shadow: tokens.colorStreakDim.withValues(alpha: 0.45),
      foreground: tokens.colorTextOnBrand,
    ),
    SnackbarColor.muted: (tokens) => _snackbarPalette(
      background: tokens.colorMuted,
      border: tokens.colorBorderNeutralSubtle,
      shadow: tokens.colorTransparent,
      foreground: tokens.colorTextMuted,
    ),
    SnackbarColor.again: (tokens) => _snackbarPalette(
      background: tokens.colorRatingAgainBackground,
      border: tokens.colorRatingAgainBorder,
      shadow: tokens.colorRatingAgainBorder,
      foreground: tokens.colorRatingAgainText,
    ),
    SnackbarColor.hard: (tokens) => _snackbarPalette(
      background: tokens.colorRatingHardBackground,
      border: tokens.colorRatingHardBorder,
      shadow: tokens.colorRatingHardBorder,
      foreground: tokens.colorRatingHardText,
    ),
    SnackbarColor.good: (tokens) => _snackbarPalette(
      background: tokens.colorRatingGoodBackground,
      border: tokens.colorRatingGoodBorder,
      shadow: tokens.colorRatingGoodBorder,
      foreground: tokens.colorRatingGoodText,
    ),
    SnackbarColor.easy: (tokens) => _snackbarPalette(
      background: tokens.colorRatingEasyBackground,
      border: tokens.colorRatingEasyBorder,
      shadow: tokens.colorRatingEasyBorder,
      foreground: tokens.colorRatingEasyText,
    ),

    SnackbarVariant.elevated: (tokens) => {
      SurfaceStylePart.transform(
        Matrix4.translationValues(0, -tokens.modalShadowOffset.h, 0),
      ),
      SurfaceStylePart.decoration({
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset(0, tokens.modalShadowOffset.h)),
          BoxShadowPart.blurRadius(0),
        }),
      }),
    },
    SnackbarVariant.flat: (_) => {
      SurfaceStylePart.transform(Matrix4.translationValues(0, 0, 0)),
      SurfaceStylePart.decoration({
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset.zero),
          BoxShadowPart.blurRadius(0),
        }),
      }),
    },
    SnackbarVariant.dashed: (tokens) => {
      SurfaceStylePart.transform(Matrix4.translationValues(0, 0, 0)),
      SurfaceStylePart.decoration({DecorationPart.boxShadow(const [])}),
    },
  },
);
