import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum AppSnackbarTone {
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
        horizontal: tokens.spacePanelGapMd.w,
        vertical: tokens.spacePanelGapSm.h,
      ),
    ),
    SurfaceStylePart.decoration({
      DecorationPart.color(tokens.backgroundSurface),
      DecorationPart.borderRadius(BorderRadius.circular(tokens.radius2xl.r)),
      DecorationPart.border(
        Border.all(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      DecorationPart.boxShadow([
        BoxShadow(
          color: tokens.borderNeutralSubtle.withValues(alpha: 0.55),
          offset: Offset(0, tokens.modalShadowOffset.h),
        ),
      ]),
    }),
    SurfaceStylePart.content({
      ContentStylePart.text({
        TextStylePart.color(tokens.textPrimary),
        TextStylePart.fontSize(tokens.textSizeLabel.sp),
        TextStylePart.fontWeight(tokens.fontWeightTextStrong),
        TextStylePart.height(tokens.lineHeightTextBody),
      }),
      ContentStylePart.icon({
        IconThemePart.color(tokens.textPrimary),
        IconThemePart.size(tokens.sizeIconMd.sp),
      }),
    }),
  },
  defaultVariants: const [AppSnackbarTone.surface],
  variants: {
    AppSnackbarTone.primary: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.primary),
        DecorationPart.border(
          Border.all(color: tokens.primary, width: tokens.borderWidthDefault.w),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.primaryDim.withValues(alpha: 0.45),
            offset: Offset(0, tokens.modalShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
        ContentStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
      }),
    },
    AppSnackbarTone.surface: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.backgroundSurface),
        DecorationPart.border(
          Border.all(
            color: tokens.borderNeutralSubtle,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.borderNeutralSubtle,
            offset: Offset(0, tokens.modalShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.textPrimary)}),
        ContentStylePart.icon({IconThemePart.color(tokens.textPrimary)}),
      }),
    },
    AppSnackbarTone.success: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.actionSuccessBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.actionSuccessBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.actionSuccessBorder,
            offset: Offset(0, tokens.modalShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.actionSuccess)}),
        ContentStylePart.icon({IconThemePart.color(tokens.actionSuccess)}),
      }),
    },
    AppSnackbarTone.error: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.actionErrorBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.actionErrorBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.actionErrorBorder,
            offset: Offset(0, tokens.modalShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.actionError)}),
        ContentStylePart.icon({IconThemePart.color(tokens.actionError)}),
      }),
    },
    AppSnackbarTone.streak: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.streak),
        DecorationPart.border(
          Border.all(color: tokens.streak, width: tokens.borderWidthDefault.w),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.streakDim.withValues(alpha: 0.45),
            offset: Offset(0, tokens.modalShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
        ContentStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
      }),
    },
    AppSnackbarTone.dashed: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.softGray),
        DecorationPart.border(
          Border.all(
            color: tokens.borderNeutralSubtle,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow(const []),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.textMuted)}),
        ContentStylePart.icon({IconThemePart.color(tokens.textMuted)}),
      }),
    },
    AppSnackbarTone.again: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingAgainBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingAgainBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.ratingAgainText)}),
        ContentStylePart.icon({IconThemePart.color(tokens.ratingAgainText)}),
      }),
    },
    AppSnackbarTone.hard: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingHardBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingHardBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.ratingHardText)}),
        ContentStylePart.icon({IconThemePart.color(tokens.ratingHardText)}),
      }),
    },
    AppSnackbarTone.good: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingGoodBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingGoodBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.ratingGoodText)}),
        ContentStylePart.icon({IconThemePart.color(tokens.ratingGoodText)}),
      }),
    },
    AppSnackbarTone.easy: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingEasyBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingEasyBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
      SurfaceStylePart.content({
        ContentStylePart.text({TextStylePart.color(tokens.ratingEasyText)}),
        ContentStylePart.icon({IconThemePart.color(tokens.ratingEasyText)}),
      }),
    },
  },
);
