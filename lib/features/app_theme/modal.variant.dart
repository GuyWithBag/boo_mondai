import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:theme_variants/theme_variants.dart';

enum ModalTone {
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

final modalStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextBaseline)}),
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
  defaultVariants: const [ModalTone.surface],
  variants: {
    ModalTone.primary: (tokens) => {
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
    ModalTone.surface: (tokens) => {
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
    ModalTone.success: (tokens) => {
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
    ModalTone.error: (tokens) => {
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
    ModalTone.streak: (tokens) => {
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
    ModalTone.dashed: (tokens) => {
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

    ModalTone.again: (tokens) => {
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
    ModalTone.hard: (tokens) => {
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
    ModalTone.good: (tokens) => {
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
    ModalTone.easy: (tokens) => {
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
