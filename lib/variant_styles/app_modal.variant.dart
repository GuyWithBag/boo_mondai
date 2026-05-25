import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    SurfaceStylePart.padding(EdgeInsets.all(tokens.spacePanelPadding.r)),
    SurfaceStylePart.decoration({
      DecorationPart.color(tokens.backgroundSurface),
      DecorationPart.borderRadius(BorderRadius.circular(tokens.radius3xl.r)),
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
  },
  defaultVariants: const [AppModalTone.surface],
  variants: {
    AppModalTone.primary: (tokens) => {
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
    },
    AppModalTone.surface: (tokens) => {
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
    },
    AppModalTone.success: (tokens) => {
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
    },
    AppModalTone.error: (tokens) => {
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
    },
    AppModalTone.streak: (tokens) => {
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
    },
    AppModalTone.dashed: (tokens) => {
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
    },

    AppModalTone.again: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingAgainBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingAgainBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
    },
    AppModalTone.hard: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingHardBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingHardBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
    },
    AppModalTone.good: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingGoodBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingGoodBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
    },
    AppModalTone.easy: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingEasyBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingEasyBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
    },
  },
);
