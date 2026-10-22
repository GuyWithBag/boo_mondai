import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:theme_variants/theme_variants.dart';

enum NotificationBubbleColor { primary, surface, success, error, streak, muted }

enum NotificationBubbleVariant { elevated, flat }

Set<StylePart<SurfaceStyle>> notificationBubblePalette({
  required Color background,
  required Color border,
  required Color shadow,
  required Color foreground,
}) {
  return {
    SurfaceStylePart.decoration({
      DecorationPart.color(background),
      DecorationPart.borderParts({BorderPart.color(border)}),
      DecorationPart.boxShadowParts({BoxShadowPart.color(shadow)}),
    }),
    SurfaceStylePart.content({
      ContentStylePart.text({TextStylePart.color(foreground)}),
      ContentStylePart.icon({IconThemePart.color(foreground)}),
    }),
  };
}

final notificationBubbleStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.padding(
      EdgeInsets.symmetric(
        horizontal: tokens.spaceLayoutGapMd.w,
        vertical: tokens.spaceLayoutGapSm.h,
      ),
    ),
    SurfaceStylePart.decoration({
      DecorationPart.borderRadius(
        BorderRadius.circular(tokens.radiusSurfaceXsm.r),
      ),
      DecorationPart.borderParts({
        BorderPart.width(tokens.borderWidthDefault.w),
        BorderPart.style(BorderStyle.solid),
      }),
    }),
    SurfaceStylePart.content({
      ContentStylePart.text({
        TextStylePart.fontSize(tokens.textSizeLabel.sp),
        TextStylePart.fontWeight(tokens.fontWeightTextStrong),
        TextStylePart.height(tokens.lineHeightTextBody),
      }),
      ContentStylePart.icon({IconThemePart.size(tokens.sizeIconSm.sp)}),
    }),
  },
  defaultVariants: const [
    NotificationBubbleColor.surface,
    NotificationBubbleVariant.elevated,
  ],
  variants: {
    NotificationBubbleColor.primary: (tokens) => notificationBubblePalette(
      background: tokens.colorPrimary,
      border: tokens.colorPrimary,
      shadow: tokens.colorPrimaryDim.withValues(alpha: 0.45),
      foreground: tokens.colorTextOnBrand,
    ),
    NotificationBubbleColor.surface: (tokens) => notificationBubblePalette(
      background: tokens.colorSurfaceBackground,
      border: tokens.colorBorderNeutralSubtle,
      shadow: tokens.colorBorderNeutralSubtle,
      foreground: tokens.colorTextBaseline,
    ),
    NotificationBubbleColor.success: (tokens) => notificationBubblePalette(
      background: tokens.colorActionSuccessBackground,
      border: tokens.colorActionSuccessBorder,
      shadow: tokens.colorActionSuccessBorder,
      foreground: tokens.colorActionSuccess,
    ),
    NotificationBubbleColor.error: (tokens) => notificationBubblePalette(
      background: tokens.colorActionErrorBackground,
      border: tokens.colorActionErrorBorder,
      shadow: tokens.colorActionErrorBorder,
      foreground: tokens.colorActionError,
    ),
    NotificationBubbleColor.streak: (tokens) => notificationBubblePalette(
      background: tokens.colorStreak,
      border: tokens.colorStreak,
      shadow: tokens.colorStreakDim.withValues(alpha: 0.45),
      foreground: tokens.colorTextOnBrand,
    ),
    NotificationBubbleColor.muted: (tokens) => notificationBubblePalette(
      background: tokens.colorMuted,
      border: tokens.colorBorderNeutralSubtle,
      shadow: tokens.colorTransparent,
      foreground: tokens.colorTextMuted,
    ),
    NotificationBubbleVariant.elevated: (tokens) => {
      SurfaceStylePart.transform(
        Matrix4.translationValues(0, -tokens.modalShadowOffset.h, 0),
      ),
      SurfaceStylePart.decoration({
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset(0, tokens.modalShadowOffset.h)),
          BoxShadowPart.blurRadius(0),
        }),
      }),
    },
    NotificationBubbleVariant.flat: (_) => {
      SurfaceStylePart.transform(Matrix4.translationValues(0, 0, 0)),
      SurfaceStylePart.decoration({
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset.zero),
          BoxShadowPart.blurRadius(0),
        }),
      }),
    },
  },
);
