import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum SegmentControlOptionState { idle, selected, disabled }

final segmentControlOptionStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.padding(
      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
    ),
    SurfaceStylePart.decoration({
      DecorationPart.color(tokens.colorTransparent),
      DecorationPart.borderRadius(
        BorderRadius.circular(tokens.radiusSurfaceSm.r),
      ),
      DecorationPart.border(
        Border.all(
          color: tokens.colorTransparent,
          width: tokens.borderWidthDefault.w,
        ),
      ),
    }),
    SurfaceStylePart.text({
      TextStylePart.color(tokens.colorTextSecondary),
      TextStylePart.fontSize(tokens.textSizeLabel.sp),
      TextStylePart.fontWeight(tokens.fontWeightTextStrong),
    }),
  },
  defaultVariants: const [SegmentControlOptionState.idle],
  variants: {
    SegmentControlOptionState.idle: (_) => const {},
    SegmentControlOptionState.selected: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorSurfaceBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorBorderNeutralSubtle,
            width: tokens.borderWidthDefault.w,
          ),
        ),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextBaseline)}),
    },
    SegmentControlOptionState.disabled: (tokens) => {
      SurfaceStylePart.opacity(0.5),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextMuted)}),
    },
  },
);
