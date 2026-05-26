import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:theme_variants/theme_variants.dart';

enum MetaLabelTone { muted, primary, brand }

final metaLabelStyle = VariantStyle.contentParts<AppTokens>(
  base: (tokens) => {
    ContentStylePart.text({
      TextStylePart.color(tokens.textMuted),
      TextStylePart.fontSize(tokens.textSizeLabelSmall.sp),
      TextStylePart.fontWeight(tokens.fontWeightTextStrong),
      (style) => style.copyWith(letterSpacing: tokens.letterSpacingTextEyebrow),
    }),
    ContentStylePart.icon({
      IconThemePart.color(tokens.textMuted),
      IconThemePart.size(tokens.sizeIconMd.sp),
    }),
  },
  defaultVariants: const [MetaLabelTone.muted],
  variants: {
    MetaLabelTone.muted: (tokens) => {
      ContentStylePart.text({TextStylePart.color(tokens.textMuted)}),
      ContentStylePart.icon({IconThemePart.color(tokens.textMuted)}),
    },
    MetaLabelTone.primary: (tokens) => {
      ContentStylePart.text({TextStylePart.color(tokens.textPrimary)}),
      ContentStylePart.icon({IconThemePart.color(tokens.textPrimary)}),
    },
    MetaLabelTone.brand: (tokens) => {
      ContentStylePart.text({TextStylePart.color(tokens.primary)}),
      ContentStylePart.icon({IconThemePart.color(tokens.primary)}),
    },
  },
);
