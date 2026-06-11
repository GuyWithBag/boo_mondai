import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum ButtonSize { sm, md, lg, icon, iconWithLabel, fab, extendedFab }

enum ButtonState { idle, hovered, selected, disabled, pressed }

enum ButtonDepth { flat, elevated, mechanical }

enum ButtonTone {
  filled,
  ghost,
  success,
  error,
  streak,
  dashed,
  textGhostSelect,
  text,
  again,
  hard,
  good,
  easy,
  mechanicalFilled,
  mechanicalGhost,
}

final buttonStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.decoration({
      DecorationPart.color(tokens.backgroundSurface),
      DecorationPart.borderRadius(
        BorderRadius.circular(tokens.radiusSurfaceSm.r),
      ),
      DecorationPart.border(
        Border.all(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      DecorationPart.boxShadow([
        BoxShadow(
          color: tokens.borderNeutralSubtle,
          offset: Offset(0, tokens.buttonShadowOffset.h),
        ),
      ]),
    }),
    SurfaceStylePart.text({
      TextStylePart.color(tokens.textSecondary),
      TextStylePart.fontSize(tokens.textSizeLabel.sp),
      TextStylePart.fontWeight(tokens.fontWeightTextStrong),
      TextStylePart.height(tokens.lineHeightTactile),
    }),
    SurfaceStylePart.icon({
      IconThemePart.color(tokens.textSecondary),
      IconThemePart.size(tokens.sizeIconMd.sp),
    }),
  },
  defaultVariants: const [
    ButtonTone.ghost,
    ButtonSize.md,
    ButtonState.idle,
    ButtonDepth.elevated,
  ],
  variants: {
    ButtonTone.filled: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.primary),
        DecorationPart.border(
          Border.all(color: tokens.primary, width: tokens.borderWidthDefault.w),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.primaryDim,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
    },
    ButtonTone.ghost: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.backgroundSurface),
        DecorationPart.border(
          Border.all(
            color: tokens.borderNeutralSubtle,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.borderNeutralSubtle,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.textPrimary)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.textPrimary)}),
    },
    ButtonTone.success: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.actionSuccessBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.actionSuccessBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.actionSuccessBorder,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.actionSuccess)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.actionSuccess)}),
    },
    ButtonTone.error: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.actionErrorBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.actionErrorBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.actionErrorBorder,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.actionError)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.actionError)}),
    },
    ButtonTone.streak: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.streak),
        DecorationPart.border(
          Border.all(color: tokens.streak, width: tokens.borderWidthDefault.w),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.streakDim,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
    },
    ButtonTone.dashed: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.softGray),
        DecorationPart.border(
          Border.all(
            color: tokens.colorTransparent,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow(const []),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.textMuted)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.textMuted)}),
    },
    ButtonTone.textGhostSelect: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorTransparent),
        DecorationPart.border(
          Border.all(color: tokens.colorTransparent, width: 0),
        ),
        DecorationPart.boxShadow(const []),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.textSecondary)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.textSecondary)}),
    },
    ButtonTone.text: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorTransparent),
        DecorationPart.border(
          Border.all(color: tokens.colorTransparent, width: 0),
        ),
        DecorationPart.boxShadow(const []),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.textSecondary)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.textSecondary)}),
    },
    ButtonTone.again: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingAgainBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingAgainBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.ratingAgainBorder,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.ratingAgainText)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.ratingAgainText)}),
    },
    ButtonTone.hard: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingHardBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingHardBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.ratingHardBorder,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.ratingHardText)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.ratingHardText)}),
    },
    ButtonTone.good: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingGoodBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingGoodBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.ratingGoodBorder,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.ratingGoodText)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.ratingGoodText)}),
    },
    ButtonTone.easy: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingEasyBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingEasyBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.ratingEasyBorder,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.ratingEasyText)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.ratingEasyText)}),
    },
    ButtonTone.mechanicalFilled: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.primary),
        DecorationPart.border(
          Border.all(
            color: tokens.primaryDim,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(color: tokens.primaryDim, offset: Offset(0, 8.h)),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
    },
    ButtonTone.mechanicalGhost: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.backgroundSurface),
        DecorationPart.border(
          Border.all(
            color: tokens.textMuted.withValues(alpha: 0.45),
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.textMuted.withValues(alpha: 0.45),
            offset: Offset(0, 8.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.textPrimary)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.textSecondary)}),
    },
    ButtonSize.sm: (tokens) => {
      SurfaceStylePart.padding(
        const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      SurfaceStylePart.text({TextStylePart.fontSize(tokens.textSizeLabel.sp)}),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconMd.sp)}),
    },
    ButtonSize.md: (tokens) => {
      SurfaceStylePart.padding(
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      SurfaceStylePart.text({TextStylePart.fontSize(tokens.textSizeLabel.sp)}),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconMd.sp)}),
    },
    ButtonSize.lg: (tokens) => {
      SurfaceStylePart.padding(
        const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      ),
      SurfaceStylePart.text({TextStylePart.fontSize(tokens.textSizeLabel.sp)}),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconLg.sp)}),
    },
    ButtonSize.icon: (tokens) => {
      SurfaceStylePart.padding(EdgeInsets.zero),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconLg.sp)}),
      SurfaceStylePart.text({TextStylePart.fontSize(tokens.textSizeLabel.sp)}),
      SurfaceStylePart.height(48.h),
      SurfaceStylePart.width(48.w),
    },
    ButtonSize.iconWithLabel: (tokens) => {
      SurfaceStylePart.padding(
        const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      ),
      SurfaceStylePart.constraints(const BoxConstraints(minWidth: 48)),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconLg.sp)}),
      SurfaceStylePart.text({
        TextStylePart.fontSize(tokens.textSizeLabelSmall.sp),
      }),
    },
    ButtonSize.fab: (tokens) => {
      SurfaceStylePart.padding(EdgeInsets.zero),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconLg.sp)}),
      SurfaceStylePart.height(64.h),
      SurfaceStylePart.width(64.w),
    },
    ButtonSize.extendedFab: (tokens) => {
      SurfaceStylePart.padding(const EdgeInsets.symmetric(horizontal: 24)),
      SurfaceStylePart.text({
        TextStylePart.fontSize(tokens.textSizeLabel.sp),
        TextStylePart.fontWeight(tokens.fontWeightTextHeavy),
      }),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconMd.sp)}),
      SurfaceStylePart.height(64.h),
    },
    ButtonState.idle: (_) => const <StylePart<SurfaceStyle>>{},
    ButtonState.hovered: (_) => const <StylePart<SurfaceStyle>>{},
    ButtonState.pressed: (_) => {
      SurfaceStylePart.decoration({DecorationPart.boxShadow(const [])}),
    },
    ButtonState.selected: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.primarySoft),
        DecorationPart.border(
          Border.all(
            color: tokens.primaryBright,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.primaryBright,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.primary)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.primary)}),
    },
    ButtonState.disabled: (_) => {
      SurfaceStylePart.decoration({DecorationPart.boxShadow(const [])}),
    },
    ButtonDepth.elevated: (_) => const <StylePart<SurfaceStyle>>{},
    ButtonDepth.flat: (_) => {
      SurfaceStylePart.decoration({DecorationPart.boxShadow(const [])}),
    },
    ButtonDepth.mechanical: (_) => const <StylePart<SurfaceStyle>>{},
  },
  compoundVariants: [
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.textGhostSelect, ButtonState.selected},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.primarySoft),
          DecorationPart.border(
            Border.all(
              color: tokens.primaryBright,
              width: tokens.borderWidthDefault.w,
            ),
          ),
          DecorationPart.boxShadow([
            BoxShadow(
              color: tokens.primaryBright,
              offset: Offset(0, tokens.buttonShadowOffset.h),
            ),
          ]),
        }),
        SurfaceStylePart.text({TextStylePart.color(tokens.primary)}),
        SurfaceStylePart.icon({IconThemePart.color(tokens.primary)}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.mechanicalFilled, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.primary.withValues(alpha: 0.88)),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.mechanicalGhost, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({DecorationPart.color(tokens.softGray)}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonDepth.mechanical, ButtonState.pressed},
      build: (_) => {
        SurfaceStylePart.decoration({DecorationPart.boxShadow(const [])}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonDepth.mechanical, ButtonState.disabled},
      build: (_) => {
        SurfaceStylePart.decoration({DecorationPart.boxShadow(const [])}),
        SurfaceStylePart.opacity(0.5),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.dashed, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({DecorationPart.color(tokens.primarySoft)}),
        SurfaceStylePart.text({TextStylePart.color(tokens.primary)}),
        SurfaceStylePart.icon({IconThemePart.color(tokens.primary)}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.ghost, ButtonState.selected},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.primarySoft),
          DecorationPart.border(
            Border.all(
              color: tokens.primaryBright,
              width: tokens.borderWidthDefault.w,
            ),
          ),
          DecorationPart.boxShadow([
            BoxShadow(
              color: tokens.primaryBright,
              offset: Offset(0, tokens.buttonShadowOffset.h),
            ),
          ]),
        }),
        SurfaceStylePart.text({TextStylePart.color(tokens.primary)}),
        SurfaceStylePart.icon({IconThemePart.color(tokens.primary)}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.again, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.ratingAgainHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.hard, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.ratingHardHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.good, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.ratingGoodHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.easy, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.ratingEasyHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonDepth.flat, ButtonState.disabled, ButtonTone.ghost},
      build: (_) => {SurfaceStylePart.opacity(0.5)},
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.success, ButtonState.disabled},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.actionSuccessBackground),
          DecorationPart.border(
            Border.all(
              color: tokens.actionSuccessBorder,
              width: tokens.borderWidthDefault.w,
            ),
          ),
          DecorationPart.boxShadow([
            BoxShadow(
              color: tokens.actionSuccessBorder,
              offset: Offset(0, tokens.buttonShadowOffset.h),
            ),
          ]),
        }),
        SurfaceStylePart.text({TextStylePart.color(tokens.actionSuccess)}),
        SurfaceStylePart.icon({IconThemePart.color(tokens.actionSuccess)}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.error, ButtonState.disabled},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.actionErrorBackground),
          DecorationPart.border(
            Border.all(
              color: tokens.actionErrorBorder,
              width: tokens.borderWidthDefault.w,
            ),
          ),
          DecorationPart.boxShadow(const []),
        }),
        SurfaceStylePart.text({TextStylePart.color(tokens.actionError)}),
        SurfaceStylePart.icon({IconThemePart.color(tokens.actionError)}),
      },
    ),
  ],
);

final mechanicalFabIconBadgeStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.decoration({
      DecorationPart.color(tokens.softGray),
      DecorationPart.borderRadius(BorderRadius.circular(12.r)),
      DecorationPart.border(
        Border.all(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault.w / 2,
        ),
      ),
      DecorationPart.boxShadow(const []),
    }),
    SurfaceStylePart.icon({
      IconThemePart.color(tokens.textSecondary),
      IconThemePart.size(tokens.sizeIconMd.sp),
    }),
    SurfaceStylePart.height(32.h),
    SurfaceStylePart.width(32.w),
    SurfaceStylePart.padding(EdgeInsets.zero),
  },
);
