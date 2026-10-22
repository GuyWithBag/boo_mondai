import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum HeaderBadgeTone { brand, neutral, success, error }

final headerBadgeStyle = VariantStyle.chipParts<AppTokens>(
  base: (tokens) => {
    ChipPart.padding(EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h)),
    ChipPart.shape(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.r)),
    ),
    ChipPart.side(
      BorderSide(
        color: tokens.colorPrimaryBright,
        width: tokens.borderWidthDefault.w,
      ),
    ),
    ChipPart.backgroundColor(tokens.colorPrimarySoft),
    ChipPart.labelStyle(
      TextStyle(
        color: tokens.colorPrimary,
        fontSize: tokens.textSizeLabelSmall.sp,
        fontWeight: tokens.fontWeightTextHeavy,
        letterSpacing: tokens.letterSpacingTextEyebrow,
      ),
    ),
    ChipPart.elevation(0),
  },
  defaultVariants: const [HeaderBadgeTone.brand],
  variants: {
    HeaderBadgeTone.brand: (tokens) => {
      ChipPart.backgroundColor(tokens.colorPrimarySoft),
      ChipPart.side(
        BorderSide(
          color: tokens.colorPrimaryBright,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.colorPrimary,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    HeaderBadgeTone.neutral: (tokens) => {
      ChipPart.backgroundColor(tokens.colorMuted),
      ChipPart.side(
        BorderSide(
          color: tokens.colorBorderNeutralSubtle,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.colorTextMuted,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    HeaderBadgeTone.success: (tokens) => {
      ChipPart.backgroundColor(
        tokens.colorActionSuccess.withValues(alpha: 0.12),
      ),
      ChipPart.side(
        BorderSide(
          color: tokens.colorActionSuccess,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.colorActionSuccess,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    HeaderBadgeTone.error: (tokens) => {
      ChipPart.backgroundColor(tokens.colorActionError.withValues(alpha: 0.12)),
      ChipPart.side(
        BorderSide(
          color: tokens.colorActionError,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.colorActionError,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
  },
);
