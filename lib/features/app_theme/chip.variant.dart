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
        color: tokens.colorBorderNeutralSubtle,
        width: tokens.borderWidthDefault.w,
      ),
    ),
    ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorTextBaseline)),
    ChipPart.elevation(0),
    ChipPart.showCheckmark(false),
  },
  defaultVariants: const [ChipTone.ghost],
  variants: {
    ChipTone.filled: (tokens) => {
      ChipPart.iconTheme(IconThemeData(color: tokens.colorPrimary)),
      ChipPart.selectedColor(tokens.colorPrimarySoft),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.colorPrimary),
      ),
      ChipPart.backgroundColor(tokens.colorPrimarySoft),
      ChipPart.side(
        BorderSide(
          color: tokens.colorPrimaryBright,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorPrimary)),
    },
    ChipTone.ghost: (tokens) => {
      ChipPart.selectedColor(tokens.colorSurfaceBackground),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.colorTextBaseline),
      ),
      ChipPart.backgroundColor(tokens.colorSurfaceBackground),
      ChipPart.side(
        BorderSide(
          color: tokens.colorBorderNeutralSubtle,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorTextBaseline)),
    },
    ChipTone.success: (tokens) => {
      ChipPart.selectedColor(tokens.colorActionSuccess.withValues(alpha: 0.12)),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.colorActionSuccess),
      ),
      ChipPart.backgroundColor(
        tokens.colorActionSuccess.withValues(alpha: 0.12),
      ),
      ChipPart.side(
        BorderSide(
          color: tokens.colorActionSuccess,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorActionSuccess)),
    },
    ChipTone.error: (tokens) => {
      ChipPart.selectedColor(tokens.colorActionError.withValues(alpha: 0.12)),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.colorActionError),
      ),
      ChipPart.backgroundColor(tokens.colorActionError.withValues(alpha: 0.12)),
      ChipPart.side(
        BorderSide(
          color: tokens.colorActionError,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorActionError)),
    },
    ChipTone.streak: (tokens) => {
      ChipPart.selectedColor(tokens.colorStreak),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.colorTextOnBrand),
      ),
      ChipPart.backgroundColor(tokens.colorStreak),
      ChipPart.side(
        BorderSide(
          color: tokens.colorStreak,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorTextOnBrand)),
    },
    ChipTone.dashed: (tokens) => {
      ChipPart.selectedColor(tokens.colorMuted),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.colorTextMuted),
      ),
      ChipPart.backgroundColor(tokens.colorMuted),
      ChipPart.side(
        BorderSide(
          color: tokens.colorTransparent,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorTextMuted)),
    },
    ChipTone.text: (tokens) => {
      ChipPart.selectedColor(tokens.colorTransparent),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.colorTextMuted),
      ),
      ChipPart.backgroundColor(tokens.colorTransparent),
      ChipPart.side(BorderSide(color: tokens.colorTransparent, width: 0)),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorTextMuted)),
    },
    ChipTone.again: (tokens) => {
      ChipPart.selectedColor(tokens.colorRatingAgainBackground),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.colorRatingAgainText),
      ),
      ChipPart.backgroundColor(tokens.colorRatingAgainBackground),
      ChipPart.side(
        BorderSide(
          color: tokens.colorRatingAgainBorder,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorRatingAgainText)),
    },
    ChipTone.hard: (tokens) => {
      ChipPart.iconTheme(IconThemeData(color: tokens.colorRatingHardText)),
      ChipPart.selectedColor(tokens.colorRatingHardBackground),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.colorRatingHardText),
      ),
      ChipPart.backgroundColor(tokens.colorRatingHardBackground),
      ChipPart.side(
        BorderSide(
          color: tokens.colorRatingHardBorder,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorRatingHardText)),
    },
    ChipTone.good: (tokens) => {
      ChipPart.selectedColor(tokens.colorRatingGoodBackground),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.colorRatingGoodText),
      ),
      ChipPart.backgroundColor(tokens.colorRatingGoodBackground),
      ChipPart.side(
        BorderSide(
          color: tokens.colorRatingGoodBorder,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorRatingGoodText)),
    },
    ChipTone.easy: (tokens) => {
      ChipPart.selectedColor(tokens.colorRatingEasyBackground),
      ChipPart.secondaryLabelStyle(
        _chipLabelStyle(tokens, tokens.colorRatingEasyText),
      ),
      ChipPart.backgroundColor(tokens.colorRatingEasyBackground),
      ChipPart.side(
        BorderSide(
          color: tokens.colorRatingEasyBorder,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      ChipPart.labelStyle(_chipLabelStyle(tokens, tokens.colorRatingEasyText)),
    },
  },
);
