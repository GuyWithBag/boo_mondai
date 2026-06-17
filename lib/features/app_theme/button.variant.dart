import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum ButtonSize { sm, md, lg, icon, smallIcon, iconWithLabel, fab, extendedFab }

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
  smallIcon,
  again,
  hard,
  good,
  easy,
  mechanicalFilled,
  mechanicalGhost,
  google,
  mono,
}

final buttonStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.decoration({
      DecorationPart.borderRadius(
        BorderRadius.circular(tokens.radiusSurfaceSm.r),
      ),
    }),
    SurfaceStylePart.text({
      TextStylePart.fontWeight(tokens.fontWeightTextStrong),
      TextStylePart.height(tokens.lineHeightButton),
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
        DecorationPart.color(tokens.colorPrimary),
        DecorationPart.border(
          Border.all(
            color: tokens.colorPrimary,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorPrimaryDim,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
    },
    ButtonTone.ghost: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorSurfaceBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorBorderNeutralSubtle,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorBorderNeutralSubtle,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextBaseline)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextBaseline)}),
    },
    ButtonTone.success: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorActionSuccessBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorActionSuccessBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorActionSuccessBorder,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorActionSuccess)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorActionSuccess)}),
    },
    ButtonTone.error: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorActionErrorBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorActionErrorBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorActionErrorBorder,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorActionError)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorActionError)}),
    },
    ButtonTone.streak: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorStreak),
        DecorationPart.border(
          Border.all(
            color: tokens.colorStreak,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorStreakDim,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
    },
    ButtonTone.dashed: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorMuted),
        DecorationPart.border(
          Border.all(
            color: tokens.colorTransparent,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow(const []),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextMuted)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextMuted)}),
    },
    ButtonTone.google: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorGoogle),
        DecorationPart.border(
          Border.all(
            color: tokens.colorGoogleDim,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorGoogleDim,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
    },
    ButtonTone.mono: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorMono),
        DecorationPart.border(
          Border.all(
            color: tokens.colorMonoDim,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorMonoDim,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnMono)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnMono)}),
    },
    ButtonTone.textGhostSelect: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorTransparent),
        DecorationPart.border(
          Border.all(color: tokens.colorTransparent, width: 0),
        ),
        DecorationPart.boxShadow(const []),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextSecondary)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextSecondary)}),
    },
    ButtonTone.text: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorTransparent),
        DecorationPart.border(
          Border.all(color: tokens.colorTransparent, width: 0),
        ),
        DecorationPart.boxShadow(const []),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextSecondary)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextSecondary)}),
    },
    ButtonTone.again: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorRatingAgainBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorRatingAgainBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorRatingAgainBorder,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorRatingAgainText)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorRatingAgainText)}),
    },
    ButtonTone.hard: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorRatingHardBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorRatingHardBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorRatingHardBorder,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorRatingHardText)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorRatingHardText)}),
    },
    ButtonTone.good: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorRatingGoodBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorRatingGoodBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorRatingGoodBorder,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorRatingGoodText)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorRatingGoodText)}),
    },
    ButtonTone.easy: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorRatingEasyBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorRatingEasyBorder,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorRatingEasyBorder,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorRatingEasyText)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorRatingEasyText)}),
    },
    ButtonTone.mechanicalFilled: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorPrimary),
        DecorationPart.border(
          Border.all(
            color: tokens.colorPrimaryDim,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(color: tokens.colorPrimaryDim, offset: Offset(0, 8.h)),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
    },
    ButtonTone.mechanicalGhost: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorSurfaceBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.colorTextMuted.withValues(alpha: 0.45),
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorTextMuted.withValues(alpha: 0.45),
            offset: Offset(0, 8.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextBaseline)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextSecondary)}),
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
    ButtonSize.smallIcon: (tokens) => {
      SurfaceStylePart.padding(EdgeInsets.zero),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconMd.sp)}),
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
      SurfaceStylePart.transform(Matrix4.translationValues(0, 4.h, 0)),
    },
    ButtonState.selected: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.colorPrimarySoft),
        DecorationPart.border(
          Border.all(
            color: tokens.colorPrimaryBright,
            width: tokens.borderWidthDefault.w,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.colorPrimaryBright,
            offset: Offset(0, tokens.buttonShadowOffset.h),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorPrimary)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorPrimary)}),
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
          DecorationPart.color(tokens.colorPrimarySoft),
          DecorationPart.border(
            Border.all(
              color: tokens.colorPrimaryBright,
              width: tokens.borderWidthDefault.w,
            ),
          ),
          DecorationPart.boxShadow([
            BoxShadow(
              color: tokens.colorPrimaryBright,
              offset: Offset(0, tokens.buttonShadowOffset.h),
            ),
          ]),
        }),
        SurfaceStylePart.text({TextStylePart.color(tokens.colorPrimary)}),
        SurfaceStylePart.icon({IconThemePart.color(tokens.colorPrimary)}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.mechanicalFilled, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.colorPrimary.withValues(alpha: 0.88)),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.mechanicalGhost, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({DecorationPart.color(tokens.colorMuted)}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonDepth.mechanical, ButtonState.pressed},
      build: (_) => {
        SurfaceStylePart.decoration({DecorationPart.boxShadow(const [])}),
        SurfaceStylePart.transform(Matrix4.translationValues(0, 8.h, 0)),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonDepth.flat, ButtonState.pressed},
      build: (_) => {
        SurfaceStylePart.decoration({DecorationPart.boxShadow(const [])}),
        SurfaceStylePart.transform(Matrix4.translationValues(0, 0, 0)),
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
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.colorPrimarySoft),
        }),
        SurfaceStylePart.text({TextStylePart.color(tokens.colorPrimary)}),
        SurfaceStylePart.icon({IconThemePart.color(tokens.colorPrimary)}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.ghost, ButtonState.selected},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.colorPrimarySoft),
          DecorationPart.border(
            Border.all(
              color: tokens.colorPrimaryBright,
              width: tokens.borderWidthDefault.w,
            ),
          ),
          DecorationPart.boxShadow([
            BoxShadow(
              color: tokens.colorPrimaryBright,
              offset: Offset(0, tokens.buttonShadowOffset.h),
            ),
          ]),
        }),
        SurfaceStylePart.text({TextStylePart.color(tokens.colorPrimary)}),
        SurfaceStylePart.icon({IconThemePart.color(tokens.colorPrimary)}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.again, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.colorRatingAgainHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.hard, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.colorRatingHardHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.good, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.colorRatingGoodHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.easy, ButtonState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.colorRatingEasyHoverBackground),
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
          DecorationPart.color(tokens.colorActionSuccessBackground),
          DecorationPart.border(
            Border.all(
              color: tokens.colorActionSuccessBorder,
              width: tokens.borderWidthDefault.w,
            ),
          ),
          DecorationPart.boxShadow([
            BoxShadow(
              color: tokens.colorActionSuccessBorder,
              offset: Offset(0, tokens.buttonShadowOffset.h),
            ),
          ]),
        }),
        SurfaceStylePart.text({TextStylePart.color(tokens.colorActionSuccess)}),
        SurfaceStylePart.icon({IconThemePart.color(tokens.colorActionSuccess)}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {ButtonTone.error, ButtonState.disabled},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.colorActionErrorBackground),
          DecorationPart.border(
            Border.all(
              color: tokens.colorActionErrorBorder,
              width: tokens.borderWidthDefault.w,
            ),
          ),
          DecorationPart.boxShadow(const []),
        }),
        SurfaceStylePart.text({TextStylePart.color(tokens.colorActionError)}),
        SurfaceStylePart.icon({IconThemePart.color(tokens.colorActionError)}),
      },
    ),
  ],
);

final mechanicalFabIconBadgeStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.decoration({
      DecorationPart.color(tokens.colorMuted),
      DecorationPart.borderRadius(BorderRadius.circular(12.r)),
      DecorationPart.border(
        Border.all(
          color: tokens.colorBorderNeutralSubtle,
          width: tokens.borderWidthDefault.w / 2,
        ),
      ),
      DecorationPart.boxShadow(const []),
    }),
    SurfaceStylePart.icon({
      IconThemePart.color(tokens.colorTextSecondary),
      IconThemePart.size(tokens.sizeIconMd.sp),
    }),
    SurfaceStylePart.height(32.h),
    SurfaceStylePart.width(32.w),
    SurfaceStylePart.padding(EdgeInsets.zero),
  },
);
