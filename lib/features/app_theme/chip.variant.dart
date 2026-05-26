import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum ChipTone {
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
}

TextStyle _chipLabelStyle(AppTokens tokens, Color color) {
  return TextStyle(
    color: color,
    fontSize: tokens.textSizeLabelSmall.sp,
    fontWeight: tokens.fontWeightTextHeavy,
    letterSpacing: tokens.letterSpacingTextEyebrow,
  );
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
        width: tokens.borderWidthDefault.w,
      ),
    ),
    ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.textPrimary)),
    ChipPart.elevation(0),
    ChipPart.showCheckmark(false),
  },
  defaultVariants: const [ChipTone.ghost],
  variants: {
    ChipTone.filled: (tokens) => {
      ChipPart.selectedColor(tokens.primarySoft),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.colorTextOnBrand),
      ),
      ChipPart.backgroundColor(tokens.primarySoft),
      ChipPart.side(
        BorderSide(
          color: tokens.primaryBright,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorTextOnBrand)),
    },
    ChipTone.ghost: (tokens) => {
      ChipPart.selectedColor(tokens.backgroundSurface),
      ChipPart.secondaryLabelStyle(_chipLabelStyle(tokens, tokens.textPrimary)),
      ChipPart.backgroundColor(tokens.backgroundSurface),
      ChipPart.side(
        BorderSide(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.textPrimary)),
    },
    ChipTone.success: (tokens) => {
      ChipPart.selectedColor(tokens.actionSuccess.withValues(alpha: 0.12)),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.actionSuccess),
      ),
      ChipPart.backgroundColor(tokens.actionSuccess.withValues(alpha: 0.12)),
      ChipPart.side(
        BorderSide(
          color: tokens.actionSuccess,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.actionSuccess)),
    },
    ChipTone.error: (tokens) => {
      ChipPart.selectedColor(tokens.actionError.withValues(alpha: 0.12)),
      ChipPart.secondaryLabelStyle(_chipLabelStyle(tokens, tokens.actionError)),
      ChipPart.backgroundColor(tokens.actionError.withValues(alpha: 0.12)),
      ChipPart.side(
        BorderSide(
          color: tokens.actionError,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.actionError)),
    },
    ChipTone.streak: (tokens) => {
      ChipPart.selectedColor(tokens.streak),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.colorTextOnBrand),
      ),
      ChipPart.backgroundColor(tokens.streak),
      ChipPart.side(
        BorderSide(color: tokens.streak, width: tokens.borderWidthDefault.w),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorTextOnBrand)),
    },
    ChipTone.dashed: (tokens) => {
      ChipPart.selectedColor(tokens.softGray),
      ChipPart.secondaryLabelStyle(_chipLabelStyle(tokens, tokens.textMuted)),
      ChipPart.backgroundColor(tokens.softGray),
      ChipPart.side(
        BorderSide(
          color: tokens.colorTransparent,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.textMuted)),
    },
    ChipTone.text: (tokens) => {
      ChipPart.selectedColor(tokens.colorTransparent),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.textSecondary),
      ),
      ChipPart.backgroundColor(tokens.colorTransparent),
      ChipPart.side(BorderSide(color: tokens.colorTransparent, width: 0)),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.textSecondary)),
    },
    ChipTone.again: (tokens) => {
      ChipPart.selectedColor(tokens.ratingAgainBackground),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.ratingAgainText),
      ),
      ChipPart.backgroundColor(tokens.ratingAgainBackground),
      ChipPart.side(
        BorderSide(
          color: tokens.ratingAgainBorder,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.ratingAgainText)),
    },
    ChipTone.hard: (tokens) => {
      ChipPart.selectedColor(tokens.ratingHardBackground),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.ratingHardText),
      ),
      ChipPart.backgroundColor(tokens.ratingHardBackground),
      ChipPart.side(
        BorderSide(
          color: tokens.ratingHardBorder,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.ratingHardText)),
    },
    ChipTone.good: (tokens) => {
      ChipPart.selectedColor(tokens.ratingGoodBackground),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.ratingGoodText),
      ),
      ChipPart.backgroundColor(tokens.ratingGoodBackground),
      ChipPart.side(
        BorderSide(
          color: tokens.ratingGoodBorder,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.ratingGoodText)),
    },
    ChipTone.easy: (tokens) => {
      ChipPart.selectedColor(tokens.ratingEasyBackground),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.ratingEasyText),
      ),
      ChipPart.backgroundColor(tokens.ratingEasyBackground),
      ChipPart.side(
        BorderSide(
          color: tokens.ratingEasyBorder,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.ratingEasyText)),
    },
  },
);
