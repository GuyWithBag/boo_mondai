import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:theme_variants/theme_variants.dart';

enum TactileSize { sm, md, lg, icon }

enum TactileState { idle, hovered, selected, disabled, pressed }

enum TactileDepth { flat, elevated }

enum TactileTone {
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

final tactileButtonStyle = VariantStyle.surfaceParts<AppTokens>(
  base: (tokens) => {
    SurfaceStylePart.decoration({
      DecorationPart.color(tokens.backgroundSurface),
      DecorationPart.borderRadius(BorderRadius.circular(tokens.radius2xl)),
      DecorationPart.border(
        Border.all(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault,
        ),
      ),
      DecorationPart.boxShadow([
        BoxShadow(
          color: tokens.borderNeutralSubtle,
          offset: Offset(0, tokens.shadowSecondaryOffset),
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
      IconThemePart.size(tokens.sizeIconMd),
    }),
  },
  defaultVariants: const [
    TactileTone.ghost,
    TactileSize.md,
    TactileState.idle,
    TactileDepth.elevated,
  ],
  variants: {
    TactileTone.filled: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.primary),
        DecorationPart.border(
          Border.all(color: tokens.primary, width: tokens.borderWidthDefault),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.primaryDim,
            offset: Offset(0, tokens.shadowPrimaryLgOffset),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
    },
    TactileTone.ghost: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.backgroundSurface),
        DecorationPart.border(
          Border.all(
            color: tokens.borderNeutralSubtle,
            width: tokens.borderWidthDefault,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.borderNeutralSubtle,
            offset: Offset(0, tokens.shadowSecondaryOffset),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.textPrimary)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.textPrimary)}),
    },
    TactileTone.success: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.actionSuccess.withValues(alpha: 0.12)),
        DecorationPart.border(
          Border.all(
            color: tokens.actionSuccess,
            width: tokens.borderWidthDefault,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.actionSuccess.withValues(alpha: 0.32),
            offset: Offset(0, tokens.shadowFeedbackOffset),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.actionSuccess)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.actionSuccess)}),
    },
    TactileTone.error: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.actionError.withValues(alpha: 0.12)),
        DecorationPart.border(
          Border.all(
            color: tokens.actionError,
            width: tokens.borderWidthDefault,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.actionError.withValues(alpha: 0.32),
            offset: Offset(0, tokens.shadowFeedbackOffset),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.actionError)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.actionError)}),
    },
    TactileTone.streak: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.streak),
        DecorationPart.border(
          Border.all(color: tokens.streak, width: tokens.borderWidthDefault),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.streakDim,
            offset: Offset(0, tokens.shadowStreakOffset),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.colorTextOnBrand)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.colorTextOnBrand)}),
    },
    TactileTone.dashed: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.softGray),
        DecorationPart.border(
          Border.all(
            color: tokens.colorTransparent,
            width: tokens.borderWidthDefault,
          ),
        ),
        DecorationPart.boxShadow(const []),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.textMuted)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.textMuted)}),
    },
    TactileTone.text: (tokens) => {
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
    TactileTone.again: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingAgainBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingAgainBorder,
            width: tokens.borderWidthDefault,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.ratingAgainBorder,
            offset: Offset(0, tokens.shadowFeedbackOffset),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.ratingAgainText)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.ratingAgainText)}),
    },
    TactileTone.hard: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingHardBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingHardBorder,
            width: tokens.borderWidthDefault,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.ratingHardBorder,
            offset: Offset(0, tokens.shadowFeedbackOffset),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.ratingHardText)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.ratingHardText)}),
    },
    TactileTone.good: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingGoodBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingGoodBorder,
            width: tokens.borderWidthDefault,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.ratingGoodBorder,
            offset: Offset(0, tokens.shadowFeedbackOffset),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.ratingGoodText)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.ratingGoodText)}),
    },
    TactileTone.easy: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.ratingEasyBackground),
        DecorationPart.border(
          Border.all(
            color: tokens.ratingEasyBorder,
            width: tokens.borderWidthDefault,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.ratingEasyBorder,
            offset: Offset(0, tokens.shadowFeedbackOffset),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.ratingEasyText)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.ratingEasyText)}),
    },
    TactileSize.sm: (tokens) => {
      SurfaceStylePart.text({TextStylePart.fontSize(tokens.textSizeLabel)}),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconMd)}),
    },
    TactileSize.md: (tokens) => {
      SurfaceStylePart.text({TextStylePart.fontSize(tokens.textSizeLabel)}),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconMd)}),
    },
    TactileSize.lg: (tokens) => {
      SurfaceStylePart.text({TextStylePart.fontSize(tokens.textSizeLabel)}),
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconLg)}),
    },
    TactileSize.icon: (tokens) => {
      SurfaceStylePart.icon({IconThemePart.size(tokens.sizeIconLg)}),
      SurfaceStylePart.height(48),
      SurfaceStylePart.width(48),
    },
    TactileState.idle: (_) => const <StylePart<SurfaceStyle>>{},
    TactileState.hovered: (_) => const <StylePart<SurfaceStyle>>{},
    TactileState.pressed: (_) => {
      SurfaceStylePart.decoration({DecorationPart.boxShadow(const [])}),
    },
    TactileState.selected: (tokens) => {
      SurfaceStylePart.decoration({
        DecorationPart.color(tokens.primarySoft),
        DecorationPart.border(
          Border.all(
            color: tokens.primaryBright,
            width: tokens.borderWidthDefault,
          ),
        ),
        DecorationPart.boxShadow([
          BoxShadow(
            color: tokens.primaryBright,
            offset: Offset(0, tokens.shadowGhostOffset),
          ),
        ]),
      }),
      SurfaceStylePart.text({TextStylePart.color(tokens.primary)}),
      SurfaceStylePart.icon({IconThemePart.color(tokens.primary)}),
    },
    TactileState.disabled: (_) => {
      SurfaceStylePart.decoration({DecorationPart.boxShadow(const [])}),
    },
    TactileDepth.elevated: (_) => const <StylePart<SurfaceStyle>>{},
    TactileDepth.flat: (_) => {
      SurfaceStylePart.decoration({DecorationPart.boxShadow(const [])}),
    },
  },
  compoundVariants: [
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {TactileTone.dashed, TactileState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({DecorationPart.color(tokens.primarySoft)}),
        SurfaceStylePart.text({TextStylePart.color(tokens.primary)}),
        SurfaceStylePart.icon({IconThemePart.color(tokens.primary)}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {TactileTone.ghost, TactileState.selected},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.primarySoft),
          DecorationPart.border(
            Border.all(
              color: tokens.primaryBright,
              width: tokens.borderWidthDefault,
            ),
          ),
          DecorationPart.boxShadow([
            BoxShadow(
              color: tokens.primaryBright,
              offset: Offset(0, tokens.shadowGhostOffset),
            ),
          ]),
        }),
        SurfaceStylePart.text({TextStylePart.color(tokens.primary)}),
        SurfaceStylePart.icon({IconThemePart.color(tokens.primary)}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {TactileTone.again, TactileState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.ratingAgainHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {TactileTone.hard, TactileState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.ratingHardHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {TactileTone.good, TactileState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.ratingGoodHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {TactileTone.easy, TactileState.hovered},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.ratingEasyHoverBackground),
        }),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {TactileDepth.flat, TactileState.disabled, TactileTone.ghost},
      build: (_) => {SurfaceStylePart.opacity(0.5)},
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {TactileTone.success, TactileState.disabled},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.actionSuccess.withValues(alpha: 0.08)),
          DecorationPart.border(
            Border.all(
              color: tokens.actionSuccess,
              width: tokens.borderWidthDefault,
            ),
          ),
          DecorationPart.boxShadow([
            BoxShadow(
              color: tokens.actionSuccess.withValues(alpha: 0.32),
              offset: Offset(0, tokens.shadowFeedbackOffset),
            ),
          ]),
        }),
        SurfaceStylePart.text({TextStylePart.color(tokens.actionSuccess)}),
        SurfaceStylePart.icon({IconThemePart.color(tokens.actionSuccess)}),
      },
    ),
    CompoundVariantParts<AppTokens, SurfaceStyle>(
      when: const {TactileTone.error, TactileState.disabled},
      build: (tokens) => {
        SurfaceStylePart.decoration({
          DecorationPart.color(tokens.actionError.withValues(alpha: 0.08)),
          DecorationPart.border(
            Border.all(
              color: tokens.actionError.withValues(alpha: 0.35),
              width: tokens.borderWidthDefault,
            ),
          ),
          DecorationPart.boxShadow(const []),
        }),
        SurfaceStylePart.text({
          TextStylePart.color(tokens.actionError.withValues(alpha: 0.7)),
        }),
        SurfaceStylePart.icon({
          IconThemePart.color(tokens.actionError.withValues(alpha: 0.7)),
        }),
      },
    ),
  ],
);

// final tactileButtonDecoration = _TactileButtonDecorationStyle();
// final tactileButtonText = _TactileButtonTextStyle();

// class _TactileButtonDecorationStyle {
//   BoxDecoration resolve(
//     AppTokens tokens, [
//     Iterable<Object> variants = const [],
//   ]) {
//     return tactileButtonStyle.resolve(tokens, variants).decoration;
//   }
// }

// class _TactileButtonTextStyle {
//   TextStyle resolve(AppTokens tokens, [Iterable<Object> variants = const []]) {
//     return tactileButtonStyle.resolve(tokens, variants).textStyle;
//   }
// }
