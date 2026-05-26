import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum SectionEyebrowTone { muted, primary, brand }

final sectionEyebrowStyle = VariantStyle.textParts<AppTokens>(
  base: (tokens) => {
    TextStylePart.color(tokens.textMuted),
    TextStylePart.fontSize(tokens.textSizeLabelSmall.sp),
    TextStylePart.fontWeight(tokens.fontWeightTextHeavy),
    (style) => style.copyWith(letterSpacing: tokens.letterSpacingTextEyebrow),
  },
  defaultVariants: const [SectionEyebrowTone.muted],
  variants: {
    SectionEyebrowTone.muted: (tokens) => {
      TextStylePart.color(tokens.textMuted),
    },
    SectionEyebrowTone.primary: (tokens) => {
      TextStylePart.color(tokens.textPrimary),
    },
    SectionEyebrowTone.brand: (tokens) => {TextStylePart.color(tokens.primary)},
  },
);
