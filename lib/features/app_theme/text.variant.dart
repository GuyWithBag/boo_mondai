import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:theme_variants/theme_variants.dart';

enum TextSize {
  header,
  labelLarge,
  label,
  labelSmall,
  bodyLarge,
  cardFront,
  cardBackFront,
  cardBackContent,
}

enum TextWeight { body, strong, heavy }

enum TextTone { primary, secondary, muted, brand }

final appTextStyle = VariantStyle.textParts<AppTokens>(
  base: (tokens) => {
    TextStylePart.color(tokens.textPrimary),
    TextStylePart.fontWeight(tokens.fontWeightTextBody),
  },
  defaultVariants: const [
    TextSize.labelSmall,
    TextWeight.body,
    TextTone.secondary,
  ],
  variants: {
    TextSize.header: (tokens) => {
      TextStylePart.fontSize(tokens.textSizeHeader.sp),
      TextStylePart.height(tokens.lineHeightTextDisplay),
    },
    TextSize.labelLarge: (tokens) => {
      TextStylePart.fontSize(tokens.textSizeLabelLarge.sp),
      TextStylePart.height(tokens.lineHeightTextTitle),
    },
    TextSize.label: (tokens) => {
      TextStylePart.fontSize(tokens.textSizeLabel.sp),
      TextStylePart.height(tokens.lineHeightTextBody),
    },
    TextSize.labelSmall: (tokens) => {
      TextStylePart.fontSize(tokens.textSizeLabelSmall.sp),
      (style) => style.copyWith(letterSpacing: tokens.letterSpacingTextEyebrow),
    },
    TextSize.bodyLarge: (tokens) => {
      TextStylePart.fontSize(tokens.textSizeBodyLarge.sp),
      TextStylePart.height(tokens.lineHeightFieldDisplay),
    },
    TextSize.cardFront: (tokens) => {
      TextStylePart.fontSize(tokens.textSizeCardFront.sp),
      TextStylePart.height(tokens.lineHeightTextDisplay),
    },
    TextSize.cardBackFront: (tokens) => {
      TextStylePart.fontSize(tokens.textSizeCardBackFront.sp),
      TextStylePart.height(tokens.lineHeightTextTitle),
    },
    TextSize.cardBackContent: (tokens) => {
      TextStylePart.fontSize(tokens.textSizeCardBackContent.sp),
      TextStylePart.height(tokens.lineHeightFieldDisplay),
    },
    TextWeight.body: (tokens) => {
      TextStylePart.fontWeight(tokens.fontWeightTextBody),
    },
    TextWeight.strong: (tokens) => {
      TextStylePart.fontWeight(tokens.fontWeightTextStrong),
    },
    TextWeight.heavy: (tokens) => {
      TextStylePart.fontWeight(tokens.fontWeightTextHeavy),
    },
    TextTone.primary: (tokens) => {TextStylePart.color(tokens.textPrimary)},
    TextTone.secondary: (tokens) => {TextStylePart.color(tokens.textSecondary)},
    TextTone.muted: (tokens) => {TextStylePart.color(tokens.textMuted)},
    TextTone.brand: (tokens) => {TextStylePart.color(tokens.primary)},
  },
);
