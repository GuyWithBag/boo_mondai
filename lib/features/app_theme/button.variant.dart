import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum ButtonSize { sm, md, lg, icon, smallIcon, iconWithLabel, fab, extendedFab }

enum ButtonState { idle, hovered, selected, disabled, pressed }

enum ButtonVariant { flat, elevated, text, dashed }

enum ButtonColor {
  primary,
  baseline,
  success,
  muted,
  error,
  streak,
  google,
  mono,
  again,
  hard,
  good,
  easy,
  dashed,
}

enum ButtonPadding { none, sm, md, lg, iconWithLabel, extendedFab }

Set<StylePart<SurfaceStyle>> _buttonPalette({
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
    SurfaceStylePart.text({TextStylePart.color(foreground)}),
    SurfaceStylePart.icon({IconThemePart.color(foreground)}),
  };
}

final buttonStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.decoration({
      DecorationPart.borderRadius(
        BorderRadius.circular(tokens.radiusSurfaceXsm.r),
      ),
      DecorationPart.borderParts({
        BorderPart.width(tokens.borderWidthDefault.w),
        BorderPart.style(BorderStyle.solid),
      }),
      DecorationPart.boxShadowParts({
        BoxShadowPart.offset(Offset(0, tokens.buttonShadowOffset.h)),
        BoxShadowPart.blurRadius(0),
      }),
    }),
    SurfaceStylePart.text({
      TextStylePart.fontWeight(tokens.fontWeightTextStrong),
      TextStylePart.height(tokens.lineHeightButton),
    }),
  },
  defaultVariants: const [
    ButtonColor.baseline,
    ButtonSize.md,
    ButtonState.idle,
    ButtonVariant.elevated,
    ButtonPadding.md,
  ],
  variants: {
    ButtonColor.primary: (tokens) => _buttonPalette(
      background: tokens.colorPrimary,
      border: tokens.colorPrimary,
      shadow: tokens.colorPrimaryDim,
      foreground: tokens.colorTextOnBrand,
    ),
    ButtonColor.baseline: (tokens) => _buttonPalette(
      background: tokens.colorSurfaceBackground,
      border: tokens.colorBorderNeutralSubtle,
      shadow: tokens.colorBorderNeutralSubtle,
      foreground: tokens.colorTextBaseline,
    ),
    ButtonColor.muted: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorTransparent),
        DecorationPart.borderParts({BorderPart.color(tokens.colorTransparent)}),
        DecorationPart.boxShadowParts({
          BoxShadowPart.color(tokens.colorTransparent),
          BoxShadowPart.offset(Offset.zero),
          BoxShadowPart.blurRadius(0),
        }),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextMuted)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextMuted)}),
    },
    ButtonColor.success: (tokens) => _buttonPalette(
      background: tokens.colorActionSuccessBackground,
      border: tokens.colorActionSuccessBorder,
      shadow: tokens.colorActionSuccessBorder,
      foreground: tokens.colorActionSuccess,
    ),
    ButtonColor.error: (tokens) => _buttonPalette(
      background: tokens.colorActionErrorBackground,
      border: tokens.colorActionErrorBorder,
      shadow: tokens.colorActionErrorBorder,
      foreground: tokens.colorActionError,
    ),
    ButtonColor.streak: (tokens) => _buttonPalette(
      background: tokens.colorStreak,
      border: tokens.colorStreak,
      shadow: tokens.colorStreakDim,
      foreground: tokens.colorTextOnBrand,
    ),
    ButtonColor.google: (tokens) => _buttonPalette(
      background: tokens.colorGoogle,
      border: tokens.colorGoogleDim,
      shadow: tokens.colorGoogleDim,
      foreground: tokens.colorTextOnBrand,
    ),
    ButtonColor.mono: (tokens) => _buttonPalette(
      background: tokens.colorMono,
      border: tokens.colorMonoDim,
      shadow: tokens.colorMonoDim,
      foreground: tokens.colorTextOnMono,
    ),
    ButtonColor.again: (tokens) => _buttonPalette(
      background: tokens.colorRatingAgainBackground,
      border: tokens.colorRatingAgainBorder,
      shadow: tokens.colorRatingAgainBorder,
      foreground: tokens.colorRatingAgainText,
    ),
    ButtonColor.hard: (tokens) => _buttonPalette(
      background: tokens.colorRatingHardBackground,
      border: tokens.colorRatingHardBorder,
      shadow: tokens.colorRatingHardBorder,
      foreground: tokens.colorRatingHardText,
    ),
    ButtonColor.good: (tokens) => _buttonPalette(
      background: tokens.colorRatingGoodBackground,
      border: tokens.colorRatingGoodBorder,
      shadow: tokens.colorRatingGoodBorder,
      foreground: tokens.colorRatingGoodText,
    ),
    ButtonColor.easy: (tokens) => _buttonPalette(
      background: tokens.colorRatingEasyBackground,
      border: tokens.colorRatingEasyBorder,
      shadow: tokens.colorRatingEasyBorder,
      foreground: tokens.colorRatingEasyText,
    ),
    ButtonColor.dashed: (tokens) => _buttonPalette(
      background: tokens.colorMuted,
      border: tokens.colorTransparent,
      shadow: tokens.colorTransparent,
      foreground: tokens.colorTextMuted,
    ),
    ButtonSize.sm: (tokens) => {
      SurfaceStylePart.text({TextStylePart.fontSize(tokens.textSizeLabel.sp)}),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconMd.sp)}),
    },
    ButtonSize.md: (tokens) => {
      SurfaceStylePart.text({TextStylePart.fontSize(tokens.textSizeLabel.sp)}),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconMd.sp)}),
    },
    ButtonSize.lg: (tokens) => {
      SurfaceStylePart.text({TextStylePart.fontSize(tokens.textSizeLabel.sp)}),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconLg.sp)}),
    },
    ButtonSize.icon: (tokens) => {
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconLg.sp)}),
      SurfaceStylePart.text({TextStylePart.fontSize(tokens.textSizeLabel.sp)}),
      SurfaceStylePart.height(48.h),
      SurfaceStylePart.width(48.w),
    },
    ButtonSize.smallIcon: (tokens) => {
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconMd.sp)}),
      SurfaceStylePart.text({TextStylePart.fontSize(tokens.textSizeLabel.sp)}),
      SurfaceStylePart.height(tokens.sizeIconMd.h),
      SurfaceStylePart.width(tokens.sizeIconMd.w),
    },
    ButtonSize.iconWithLabel: (tokens) => {
      SurfaceStylePart.constraints(const BoxConstraints(minWidth: 48)),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconLg.sp)}),
      SurfaceStylePart.text({
        TextStylePart.fontSize(tokens.textSizeLabelSmall.sp),
      }),
    },
    ButtonSize.fab: (tokens) => {
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconLg.sp)}),
      SurfaceStylePart.height(64.h),
      SurfaceStylePart.width(64.w),
    },
    ButtonSize.extendedFab: (tokens) => {
      SurfaceStylePart.text({
        TextStylePart.fontSize(tokens.textSizeLabel.sp),
        TextStylePart.fontWeight(tokens.fontWeightTextHeavy),
      }),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconMd.sp)}),
      SurfaceStylePart.height(64.h),
    },
    ButtonPadding.none: (_) => {SurfaceStylePart.padding(EdgeInsets.zero)},
    ButtonPadding.sm: (tokens) => {
      SurfaceStylePart.padding(
        EdgeInsets.symmetric(
          horizontal: tokens.buttonPaddingHorizontalSm.w,
          vertical: tokens.buttonPaddingVerticalSm.h,
        ),
      ),
    },
    ButtonPadding.md: (tokens) => {
      SurfaceStylePart.padding(
        EdgeInsets.symmetric(
          horizontal: tokens.buttonPaddingHorizontalMd.w,
          vertical: tokens.buttonPaddingVerticalMd.h,
        ),
      ),
    },
    ButtonPadding.lg: (tokens) => {
      SurfaceStylePart.padding(
        EdgeInsets.symmetric(
          horizontal: tokens.buttonPaddingHorizontalLg.w,
          vertical: tokens.buttonPaddingVerticalLg.h,
        ),
      ),
    },
    ButtonPadding.iconWithLabel: (tokens) => {
      SurfaceStylePart.padding(
        EdgeInsets.symmetric(
          horizontal: tokens.buttonPaddingHorizontalIconWithLabel.w,
          vertical: tokens.buttonPaddingVerticalIconWithLabel.h,
        ),
      ),
    },
    ButtonPadding.extendedFab: (tokens) => {
      SurfaceStylePart.padding(
        EdgeInsets.symmetric(
          horizontal: tokens.buttonPaddingHorizontalExtendedFab.w,
          vertical: tokens.buttonPaddingVerticalExtendedFab.h,
        ),
      ),
    },
    ButtonState.idle: (_) => const <StylePart<SurfaceStyle>>{},
    ButtonState.hovered: (_) => const <StylePart<SurfaceStyle>>{},
    ButtonState.pressed: (_) => {
      SurfaceStylePart.decoration({
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset.zero),
          BoxShadowPart.blurRadius(0),
        }),
      }),
      SurfaceStylePart.transform(Matrix4.translationValues(0, 4.h, 0)),
    },
    ButtonState.selected: (tokens) => _buttonPalette(
      background: tokens.colorPrimarySoft,
      border: tokens.colorPrimaryBright,
      shadow: tokens.colorPrimaryBright,
      foreground: tokens.colorPrimary,
    ),
    ButtonState.disabled: (_) => {
      SurfaceStylePart.decoration({
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset.zero),
          BoxShadowPart.blurRadius(0),
        }),
      }),
    },
    ButtonVariant.dashed: (_) => const <StylePart<SurfaceStyle>>{},
    ButtonVariant.elevated: (tokens) => {
      SurfaceStylePart.transform(
        Matrix4.translationValues(0, -tokens.buttonShadowOffset.h, 0),
      ),
    },
    ButtonVariant.flat: (_) => {
      SurfaceStylePart.decoration({
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset.zero),
          BoxShadowPart.blurRadius(0),
        }),
      }),
    },
    ButtonVariant.text: (_) => {
      SurfaceStylePart.decoration({
        DecorationPart.boxShadowParts({
          BoxShadowPart.offset(Offset.zero),
          BoxShadowPart.blurRadius(0),
        }),
        DecorationPart.borderParts({
          BorderPart.width(0),
          BorderPart.style(BorderStyle.none),
        }),
      }),
    },
  },
  compoundVariants: [
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonVariant.text, ButtonState.selected},
      build: (tokens) => _buttonPalette(
        background: tokens.colorPrimarySoft,
        border: tokens.colorPrimaryBright,
        shadow: tokens.colorPrimaryBright,
        foreground: tokens.colorPrimary,
      ),
    ),

    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonVariant.elevated, ButtonState.pressed},
      build: (_) => {
        SurfaceStylePart.transform(Matrix4.translationValues(0, 0, 0)),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonVariant.flat, ButtonState.pressed},
      build: (_) => {
        SurfaceStylePart.decoration({
          DecorationPart.boxShadowParts({
            BoxShadowPart.offset(Offset.zero),
            BoxShadowPart.blurRadius(0),
          }),
        }),
        SurfaceStylePart.transform(Matrix4.translationValues(0, 0, 0)),
      },
    ),

    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonColor.dashed, ButtonState.hovered},
      build: (tokens) => {
        ..._buttonPalette(
          background: tokens.colorPrimarySoft,
          border: tokens.colorPrimary,
          shadow: tokens.colorPrimary,
          foreground: tokens.colorPrimary,
        ),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonColor.baseline, ButtonState.selected},
      build: (tokens) => _buttonPalette(
        background: tokens.colorPrimarySoft,
        border: tokens.colorPrimaryBright,
        shadow: tokens.colorPrimaryBright,
        foreground: tokens.colorPrimary,
      ),
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonColor.again, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.colorRatingAgainHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonColor.hard, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.colorRatingHardHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonColor.good, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.colorRatingGoodHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonColor.easy, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.colorRatingEasyHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {
        ButtonVariant.flat,
        ButtonState.disabled,
        ButtonColor.baseline,
      },
      build: (_) => {SurfaceStylePart.opacity(0.5)},
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonColor.success, ButtonState.disabled},
      build: (tokens) => _buttonPalette(
        background: tokens.colorActionSuccessBackground,
        border: tokens.colorActionSuccessBorder,
        shadow: tokens.colorActionSuccessBorder,
        foreground: tokens.colorActionSuccess,
      ),
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonColor.error, ButtonState.disabled},
      build: (tokens) => {
        ..._buttonPalette(
          background: tokens.colorActionErrorBackground,
          border: tokens.colorActionErrorBorder,
          shadow: tokens.colorActionErrorBorder,
          foreground: tokens.colorActionError,
        ),
        SurfaceStylePart.decoration({
          DecorationPart.boxShadowParts({
            BoxShadowPart.offset(Offset.zero),
            BoxShadowPart.blurRadius(0),
          }),
        }),
      },
    ),
  ],
);
