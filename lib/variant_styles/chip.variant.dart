import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum AppChipTone {
  filled,
  ghost,
  success,
  error,
  streak,
  dashed,
  text,
  again,
  hard,
  good,
  easy,
  mechanicalFilled,
  mechanicalGhost,
}

final appChipStyle = VariantStyle.chipParts<AppTokens>(
  base: (tokens) => {
    ChipPart.padding(EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h)),
    ChipPart.shape(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.r)),
    ),
    ChipPart.side(
      BorderSide(
        color: tokens.borderNeutralSubtle,
        width: tokens.borderWidthDefault,
      ),
    ),
    ChipPart.backgroundColor(tokens.backgroundSurface),
    ChipPart.labelStyle(
      TextStyle(
        color: tokens.textPrimary,
        fontSize: tokens.textSizeLabelSmall.sp,
        fontWeight: tokens.fontWeightTextHeavy,
        letterSpacing: tokens.letterSpacingTextEyebrow,
      ),
    ),
    ChipPart.elevation(0),
  },
  defaultVariants: const [AppChipTone.ghost],
  variants: {
    AppChipTone.filled: (tokens) => {
      ChipPart.backgroundColor(tokens.primary),
      ChipPart.side(
        BorderSide(color: tokens.primary, width: tokens.borderWidthDefault),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.colorTextOnBrand,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    AppChipTone.ghost: (tokens) => {
      ChipPart.backgroundColor(tokens.backgroundSurface),
      ChipPart.side(
        BorderSide(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.textPrimary,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    AppChipTone.success: (tokens) => {
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
    AppChipTone.error: (tokens) => {
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
    AppChipTone.streak: (tokens) => {
      ChipPart.backgroundColor(tokens.streak),
      ChipPart.side(
        BorderSide(color: tokens.streak, width: tokens.borderWidthDefault),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.colorTextOnBrand,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    AppChipTone.dashed: (tokens) => {
      ChipPart.backgroundColor(tokens.softGray),
      ChipPart.side(
        BorderSide(
          color: tokens.colorTransparent,
          width: tokens.borderWidthDefault,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.textMuted,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    AppChipTone.text: (tokens) => {
      ChipPart.backgroundColor(tokens.colorTransparent),
      ChipPart.side(BorderSide(color: tokens.colorTransparent, width: 0)),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.textSecondary,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    AppChipTone.again: (tokens) => {
      ChipPart.backgroundColor(tokens.ratingAgainBackground),
      ChipPart.side(
        BorderSide(
          color: tokens.ratingAgainBorder,
          width: tokens.borderWidthDefault,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.ratingAgainText,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    AppChipTone.hard: (tokens) => {
      ChipPart.backgroundColor(tokens.ratingHardBackground),
      ChipPart.side(
        BorderSide(
          color: tokens.ratingHardBorder,
          width: tokens.borderWidthDefault,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.ratingHardText,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    AppChipTone.good: (tokens) => {
      ChipPart.backgroundColor(tokens.ratingGoodBackground),
      ChipPart.side(
        BorderSide(
          color: tokens.ratingGoodBorder,
          width: tokens.borderWidthDefault,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.ratingGoodText,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    AppChipTone.easy: (tokens) => {
      ChipPart.backgroundColor(tokens.ratingEasyBackground),
      ChipPart.side(
        BorderSide(
          color: tokens.ratingEasyBorder,
          width: tokens.borderWidthDefault,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.ratingEasyText,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    AppChipTone.mechanicalFilled: (tokens) => {
      ChipPart.backgroundColor(tokens.primary),
      ChipPart.side(
        BorderSide(color: tokens.primaryDim, width: tokens.borderWidthDefault),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.colorTextOnBrand,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
    AppChipTone.mechanicalGhost: (tokens) => {
      ChipPart.backgroundColor(tokens.backgroundSurface),
      ChipPart.side(
        BorderSide(
          color: tokens.textMuted.withValues(alpha: 0.45),
          width: tokens.borderWidthDefault,
        ),
      ),
      ChipPart.labelStyle(
        TextStyle(
          color: tokens.textPrimary,
          fontSize: tokens.textSizeLabelSmall.sp,
          fontWeight: tokens.fontWeightTextHeavy,
          letterSpacing: tokens.letterSpacingTextEyebrow,
        ),
      ),
    },
  },
);
