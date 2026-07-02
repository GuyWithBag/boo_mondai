import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:theme_variants/theme_variants.dart';

enum SnackbarTone {
  primary,
  surface,
  success,
  error,
  streak,
  dashed,
  again,
  hard,
  good,
  easy,
}

final appSnackbarStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.padding(
      EdgeInsets.symmetric(
        horizontal: tokens.spaceLayoutGapMd.w,
        vertical: tokens.spaceLayoutGapSm.h,
      ),
    ),
    SurfaceStylePart.decoration({
      DecorationPart.color(tokens.colorSurfaceBackground),
      DecorationPart.borderRadius(
        BorderRadius.circular(tokens.radiusSurfaceXsm.r),
      ),
      DecorationPart.border(
        Border.all(
          color: tokens.colorBorderNeutralSubtle,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      DecorationPart.boxShadow([
        BoxShadow(
          color: tokens.colorBorderNeutralSubtle.withValues(alpha: 0.55),
          offset: Offset(0, tokens.modalShadowOffset.h),
        ),
      ]),
    }),
    SurfaceStylePart.content({
      ContentStylePart.text({
        TextStylePart.color(tokens.colorTextBaseline),
        TextStylePart.fontSize(tokens.textSizeLabel.sp),
        TextStylePart.fontWeight(tokens.fontWeightTextStrong),
        TextStylePart.height(tokens.lineHeightTextBody),
      }),
      ContentStylePart.icon({
        IconThemePart.color(tokens.colorTextBaseline),
        IconThemePart.size(tokens.sizeIconSm.sp),
      }),
    }),
  },
  defaultVariants: const [SnackbarTone.surface],
  variants: {
    SnackbarTone.primary: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorPrimary),
        DecorationPart.border(
          Border.all(
            color: tokens.colorPrimary,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorPrimaryDim.withValues(alpha: 0.45),
            offset: Offset(0, tokens.modalShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
        ContentStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
      }),
    },
    SnackbarTone.surface: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorSurfaceBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorBorderNeutralSubtle,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorBorderNeutralSubtle,
            offset: Offset(0, tokens.modalShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.colorTextBaseline)}),
        ContentStylePart.icon({IconThemePart.color(tokens.colorTextBaseline)}),
      }),
    },
    SnackbarTone.success: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorActionSuccessBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorActionSuccessBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorActionSuccessBorder,
            offset: Offset(0, tokens.modalShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.colorActionSuccess)}),
        ContentStylePart.icon({IconThemePart.color(tokens.colorActionSuccess)}),
      }),
    },
    SnackbarTone.error: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorActionErrorBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorActionErrorBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorActionErrorBorder,
            offset: Offset(0, tokens.modalShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.colorActionError)}),
        ContentStylePart.icon({IconThemePart.color(tokens.colorActionError)}),
      }),
    },
    SnackbarTone.streak: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorStreak),
        DecorationPart.border(
          Border.all(
            color: tokens.colorStreak,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorStreakDim.withValues(alpha: 0.45),
            offset: Offset(0, tokens.modalShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
        ContentStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
      }),
    },
    SnackbarTone.dashed: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorMuted),
        DecorationPart.border(
          Border.all(
            color: tokens.colorBorderNeutralSubtle,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow(const []),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.colorTextMuted)}),
        ContentStylePart.icon({IconThemePart.color(tokens.colorTextMuted)}),
      }),
    },
    SnackbarTone.again: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorRatingAgainBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorRatingAgainBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({
          TextStylePart.color(tokens.colorRatingAgainText),
        }),
        ContentStylePart.icon({
          IconThemePart.color(tokens.colorRatingAgainText),
        }),
      }),
    },
    SnackbarTone.hard: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorRatingHardBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorRatingHardBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({
          TextStylePart.color(tokens.colorRatingHardText),
        }),
        ContentStylePart.icon({
          IconThemePart.color(tokens.colorRatingHardText),
        }),
      }),
    },
    SnackbarTone.good: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorRatingGoodBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorRatingGoodBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({
          TextStylePart.color(tokens.colorRatingGoodText),
        }),
        ContentStylePart.icon({
          IconThemePart.color(tokens.colorRatingGoodText),
        }),
      }),
    },
    SnackbarTone.easy: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorRatingEasyBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorRatingEasyBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({
          TextStylePart.color(tokens.colorRatingEasyText),
        }),
        ContentStylePart.icon({
          IconThemePart.color(tokens.colorRatingEasyText),
        }),
      }),
    },
  },
);
