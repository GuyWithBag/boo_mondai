import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:theme_variants/theme_variants.dart';

enum SegmentControlOptionState { idle, selected, disabled }

final segmentControlOptionStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.padding(
      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
    ),
    SurfaceStylePart.decoration({
      DecorationPart.color(tokens.colorTransparent),
      DecorationPart.borderRadius(BorderRadius.circular(tokens.radius2xl.r)),
      DecorationPart.border(
        Border.all(
          color: tokens.colorTransparent,
          width: tokens.borderWidthDefault.w,
        ),
      ),
    }),
    SurfaceStylePart.text({
      TextStylePart.color(tokens.textSecondary),
      TextStylePart.fontSize(tokens.textSizeLabel.sp),
      TextStylePart.fontWeight(tokens.fontWeightTextStrong),
    }),
  },
  defaultVariants: const [SegmentControlOptionState.idle],
  variants: {
    SegmentControlOptionState.idle: (_) => const {},
    SegmentControlOptionState.selected: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.backgroundSurface),
        DecorationPart.border(
          Border.all(
            color: tokens.borderNeutralSubtle,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.textPrimary)}),
    },
    SegmentControlOptionState.disabled: (tokens) => {
      SurfaceStylePart.opacity(0.5),
      SurfaceStylePart.text({TextStylePart.color(tokens.textMuted)}),
    },
  },
);
