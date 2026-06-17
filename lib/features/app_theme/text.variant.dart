import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:theme_variants/theme_variants.dart';

enum TextSize {
  headerLarge,
  header,
  labelLarge,
  label,
  labelSmall,
  bodyLarge,
  cardFront,
  cardBack,
  cardBackContent,
}

enum TextWeight { body, strong, heavy }

enum TextTone { baseline, secondary, muted, brand }

final textStyle = VariantStyle.textParts<AppTokens>(
  base: (tokens) => {
    TextStylePart.color(tokens.colorTextBaseline),
    TextStylePart.fontWeight(tokens.fontWeightTextBody),
  },
  defaultVariants: const [
    TextSize.labelSmall,
    TextWeight.body,
    TextTone.secondary,
  ],
  variants: {
    TextSize.headerLarge: (tokens) => {
      TextStylePart.fontSize(tokens.textSizeHeaderLarge.sp),
      // TextStylePart.height(tokens.lineHeightTextDisplay),
    },
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
      TextStylePart.fontSize(tokens.studyCardTextSizeFront.sp),
      TextStylePart.height(tokens.lineHeightTextDisplay),
    },
    TextSize.cardBack: (tokens) => {
      TextStylePart.fontSize(tokens.studyCardTextSizeBack.sp),
      TextStylePart.height(tokens.lineHeightTextTitle),
    },
    TextSize.cardBackContent: (tokens) => {
      TextStylePart.fontSize(tokens.studyCardTextSizeBackContent.sp),
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
    TextTone.baseline: (tokens) => {
      TextStylePart.color(tokens.colorTextBaseline),
    },
    TextTone.secondary: (tokens) => {
      TextStylePart.color(tokens.colorTextSecondary),
    },
    TextTone.muted: (tokens) => {TextStylePart.color(tokens.colorTextMuted)},
    TextTone.brand: (tokens) => {TextStylePart.color(tokens.colorPrimary)},
  },
);
