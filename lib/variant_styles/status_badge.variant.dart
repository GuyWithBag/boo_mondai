import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:theme_variants/theme_variants.dart';

enum StatusBadgeTone { brand, neutral, success, error }

final statusBadgeStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.padding(
      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    ),
    SurfaceStylePart.decoration({
      DecorationPart.borderRadius(BorderRadius.circular(7.r)),
      DecorationPart.border(
        Border.all(
          color: tokens.primaryBright,
          width: tokens.borderWidthDefault,
        ),
      ),
      DecorationPart.color(tokens.primarySoft),
    }),
    SurfaceStylePart.text({
      TextStylePart.color(tokens.primary),
      TextStylePart.fontSize(tokens.textSizeLabelSmall.sp),
      TextStylePart.fontWeight(tokens.fontWeightTextHeavy),
      (style) => style.copyWith(letterSpacing: tokens.letterSpacingTextEyebrow),
    }),
  },
  defaultVariants: const [StatusBadgeTone.brand],
  variants: {
    StatusBadgeTone.brand: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.primarySoft),
        DecorationPart.border(
          Border.all(
            color: tokens.primaryBright,
            width: tokens.borderWidthDefault,
          ),
        ),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.primary)}),
    },
    StatusBadgeTone.neutral: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.softGray),
        DecorationPart.border(
          Border.all(
            color: tokens.borderNeutralSubtle,
            width: tokens.borderWidthDefault,
          ),
        ),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.textSecondary)}),
    },
    StatusBadgeTone.success: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.actionSuccess.withValues(alpha: 0.12)),
        DecorationPart.border(
          Border.all(
            color: tokens.actionSuccess,
            width: tokens.borderWidthDefault,
          ),
        ),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.actionSuccess)}),
    },
    StatusBadgeTone.error: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.actionError.withValues(alpha: 0.12)),
        DecorationPart.border(
          Border.all(
            color: tokens.actionError,
            width: tokens.borderWidthDefault,
          ),
        ),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.actionError)}),
    },
  },
);
