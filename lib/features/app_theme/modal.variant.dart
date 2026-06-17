import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:theme_variants/theme_variants.dart';

enum AppModalTone {
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

final appModalStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.padding(EdgeInsets.all(tokens.spaceLayoutPadding.r)),
    SurfaceStylePart.decoration({
      DecorationPart.color(tokens.colorSurfaceBackground),
      DecorationPart.borderRadius(
        BorderRadius.circular(tokens.radiusSurface.r),
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
  },
  defaultVariants: const [AppModalTone.surface],
  variants: {
    AppModalTone.primary: (tokens) => {
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
    },
    AppModalTone.surface: (tokens) => {
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
    },
    AppModalTone.success: (tokens) => {
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
    },
    AppModalTone.error: (tokens) => {
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
    },
    AppModalTone.streak: (tokens) => {
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
    },
    AppModalTone.dashed: (tokens) => {
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
    },

    AppModalTone.again: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorRatingAgainBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorRatingAgainBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
    },
    AppModalTone.hard: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorRatingHardBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorRatingHardBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
    },
    AppModalTone.good: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorRatingGoodBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorRatingGoodBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
    },
    AppModalTone.easy: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorRatingEasyBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorRatingEasyBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
    },
  },
);
