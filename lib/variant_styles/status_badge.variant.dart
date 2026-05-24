import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum StatusBadgeTone { brand, neutral, success, error }

final statusBadgeStyle = VariantStyle.chipParts<AppTokens>(
  base: (tokens) => {
    ChipPart.padding(EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h)),
    ChipPart.shape(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.r)),
    ),
    ChipPart.side(
      BorderSide(color: tokens.primaryBright, width: tokens.borderWidthDefault),
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
  defaultVariants: const [StatusBadgeTone.brand],
  variants: {
    StatusBadgeTone.brand: (tokens) => {
      ChipPart.backgroundColor(tokens.primarySoft),
      ChipPart.side(
        BorderSide(
          color: tokens.primaryBright,
          width: tokens.borderWidthDefault,
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
    StatusBadgeTone.neutral: (tokens) => {
      ChipPart.backgroundColor(tokens.softGray),
      ChipPart.side(
        BorderSide(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault,
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
    StatusBadgeTone.success: (tokens) => {
      ChipPart.backgroundColor(tokens.actionSuccess.withValues(alpha: 0.12)),
      ChipPart.side(
        BorderSide(
          color: tokens.actionSuccess,
          width: tokens.borderWidthDefault,
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
    StatusBadgeTone.error: (tokens) => {
      ChipPart.backgroundColor(tokens.actionError.withValues(alpha: 0.12)),
      ChipPart.side(
        BorderSide(color: tokens.actionError, width: tokens.borderWidthDefault),
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
