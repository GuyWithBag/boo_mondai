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
        color: tokens.primaryBright,
        width: tokens.borderWidthDefault.w,
      ),
    ),
    ChipPart.backgroundColor(tokens.primarySoft),
    ChipPart.labelStyle(
      TextStyle(
        color: tokens.primary,
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
      ChipPart.backgroundColor(tokens.primarySoft),
      ChipPart.side(
        BorderSide(
          color: tokens.primaryBright,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.primary,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    HeaderBadgeTone.neutral: (tokens) => {
      ChipPart.backgroundColor(tokens.softGray),
      ChipPart.side(
        BorderSide(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.textSecondary,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    HeaderBadgeTone.success: (tokens) => {
      ChipPart.backgroundColor(tokens.actionSuccess.withValues(alpha: 0.12)),
      ChipPart.side(
        BorderSide(
          color: tokens.actionSuccess,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.actionSuccess,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    HeaderBadgeTone.error: (tokens) => {
      ChipPart.backgroundColor(tokens.actionError.withValues(alpha: 0.12)),
      ChipPart.side(
        BorderSide(
          color: tokens.actionError,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.actionError,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
  },
);
