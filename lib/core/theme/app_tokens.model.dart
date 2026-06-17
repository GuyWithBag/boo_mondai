import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'app_tokens.model.mapper.dart';

/*
Token naming guide

Use names that describe purpose, not just value.

Good:
textSizeLabelSmall = 10
textSizeLabel = 14
textSizeLabelLarge = 16
textSizeHeader = 24
textSizeBodyLarge = 30

Avoid:
textSize10
fontSmall
bigText

Prefer this order:
category + property + role + scale

Examples:
textSizeLabelSmall
textSizeBodyLarge
fontWeightTextStrong
lineHeightTextBody
spaceLayoutGapLg
buttonShadowOffset
radiusSurface
borderWidthDefault

Color tokens should describe use, prefixed with 'color'.

Good:
colorPageBackground
colorSurfaceBackground
colorTextBaseline
colorTextSecondary
colorTextMuted
colorBorderNeutralSubtle
colorActionSuccess
colorActionError

Avoid:
gray100
blue500
green
red

Use scale words only when the token is part of a real scale.

Good:
spaceLayoutGapSm
spaceLayoutGapMd
spaceLayoutGapLg
sizeIconMd
sizeIconLg
radiusSurfaceSm
radiusSurface

Avoid adding scale names if there is only one value:
spaceLayoutGapDefault
iconSizeDefault

Component-specific values should stay with the component first.
Promote them into AppTokens when several components reuse the same idea,
or when they need to be configurable for custom themes.

Good global token:
borderWidthDefault

Component-scoped:
studyCardWidth
studyCardAspectRatio
*/

@MappableClass()
class AppTokens with AppTokensMappable {
  const AppTokens({
    required this.name,
    required this.fontFamily,
    required this.colorPrimary,
    required this.colorPrimaryDim,
    required this.colorPrimaryBright,
    required this.colorPrimarySoft,
    required this.colorStreak,
    required this.colorStreakDim,
    required this.colorPageBackground,
    required this.colorSurfaceBackground,
    required this.colorBorderNeutralSubtle,
    required this.colorActionSuccess,
    required this.colorActionSuccessBackground,
    required this.colorActionSuccessBorder,
    required this.colorActionError,
    required this.colorActionErrorBackground,
    required this.colorActionErrorBorder,
    required this.colorTextBaseline,
    required this.colorTextSecondary,
    required this.colorTextMuted,
    required this.colorMuted,
    required this.colorRatingAgainBackground,
    required this.colorRatingAgainText,
    required this.colorRatingAgainBorder,
    required this.colorRatingAgainHoverBackground,
    required this.colorRatingHardBackground,
    required this.colorRatingHardText,
    required this.colorRatingHardBorder,
    required this.colorRatingHardHoverBackground,
    required this.colorRatingGoodBackground,
    required this.colorRatingGoodText,
    required this.colorRatingGoodBorder,
    required this.colorRatingGoodHoverBackground,
    required this.colorRatingEasyBackground,
    required this.colorRatingEasyText,
    required this.colorRatingEasyBorder,
    required this.colorRatingEasyHoverBackground,
    required this.colorTransparent,
    required this.colorTextOnBrand,
    required this.colorGoogle,
    required this.colorGoogleDim,
    required this.colorTextOnGoogle,
    required this.colorMono,
    required this.colorMonoDim,
    required this.colorTextOnMono,
    required this.buttonShadowOffset,
    required this.modalShadowOffset,
    required this.fontWeightTextBody,
    required this.fontWeightTextStrong,
    required this.fontWeightTextHeavy,
    required this.lineHeightTextBody,
    required this.lineHeightTextTitle,
    required this.lineHeightTextDisplay,
    required this.lineHeightFieldDisplay,
    required this.lineHeightButton,
    required this.letterSpacingTextEyebrow,
    required this.radiusSurfaceLg,
    required this.radiusSurface,
    required this.radiusSurfaceSm,
    required this.borderWidthDefault,
    required this.spaceScaffoldPadding,
    required this.spaceLayoutPadding,
    required this.spaceLayoutGapLg,
    required this.spaceLayoutGapMd,
    required this.spaceLayoutGapSm,
    required this.spaceScaffoldMaxWidth,
    required this.textSizeHeader,
    required this.textSizeLabelLarge,
    required this.textSizeLabel,
    required this.textSizeLabelSmall,
    required this.textSizeBodyLarge,
    required this.sizeIconMd,
    required this.sizeIconLg,
    required this.studyCardWidth,
    required this.studyCardAspectRatio,
    required this.studyCardRadius,
    required this.studyCardTextSizeFront,
    required this.studyCardTextSizeBack,
    required this.studyCardTextSizeBackContent,
    required this.textSizeHeaderLarge,
  });

  final String name;
  final String fontFamily;

  // Primary
  final Color colorPrimary;
  final Color colorPrimaryDim;
  final Color colorPrimaryBright;
  final Color colorPrimarySoft;

  // Streak
  final Color colorStreak;
  final Color colorStreakDim;

  // Background
  final Color colorPageBackground;
  final Color colorSurfaceBackground;

  // Border
  final Color colorBorderNeutralSubtle;

  // Action
  final Color colorActionSuccess;
  final Color colorActionSuccessBackground;
  final Color colorActionSuccessBorder;
  final Color colorActionError;
  final Color colorActionErrorBackground;
  final Color colorActionErrorBorder;

  // Text
  final Color colorTextBaseline;
  final Color colorTextSecondary;
  final Color colorTextMuted;

  // Neutral
  final Color colorMuted;

  // Rating
  final Color colorRatingAgainBackground;
  final Color colorRatingAgainText;
  final Color colorRatingAgainBorder;
  final Color colorRatingAgainHoverBackground;
  final Color colorRatingHardBackground;
  final Color colorRatingHardText;
  final Color colorRatingHardBorder;
  final Color colorRatingHardHoverBackground;
  final Color colorRatingGoodBackground;
  final Color colorRatingGoodText;
  final Color colorRatingGoodBorder;
  final Color colorRatingGoodHoverBackground;
  final Color colorRatingEasyBackground;
  final Color colorRatingEasyText;
  final Color colorRatingEasyBorder;
  final Color colorRatingEasyHoverBackground;

  // Utility
  final Color colorTransparent;
  final Color colorTextOnBrand;

  // Auth providers
  final Color colorGoogle;
  final Color colorGoogleDim;
  final Color colorTextOnGoogle;
  final Color colorMono;
  final Color colorMonoDim;
  final Color colorTextOnMono;

  // Shadow
  final double buttonShadowOffset;
  final double modalShadowOffset;

  // Font weight
  final FontWeight fontWeightTextBody;
  final FontWeight fontWeightTextStrong;
  final FontWeight fontWeightTextHeavy;

  // Line height
  final double lineHeightTextBody;
  final double lineHeightTextTitle;
  final double lineHeightTextDisplay;
  final double lineHeightFieldDisplay;
  final double lineHeightButton;

  // Letter spacing
  final double letterSpacingTextEyebrow;

  // Radius
  final double radiusSurfaceLg;
  final double radiusSurface;
  final double radiusSurfaceSm;

  // Border
  final double borderWidthDefault;

  // Spacing
  final double spaceScaffoldPadding;
  final double spaceLayoutPadding;
  final double spaceLayoutGapLg;
  final double spaceLayoutGapMd;
  final double spaceLayoutGapSm;
  final double spaceScaffoldMaxWidth;

  // Text size
  final double textSizeHeaderLarge;
  final double textSizeHeader;
  final double textSizeLabelLarge;
  final double textSizeLabel;
  final double textSizeLabelSmall;
  final double textSizeBodyLarge;

  // Icon size
  final double sizeIconMd;
  final double sizeIconLg;

  // Study card
  final double studyCardWidth;
  final double studyCardAspectRatio;
  final double studyCardRadius;
  final double studyCardTextSizeFront;
  final double studyCardTextSizeBack;
  final double studyCardTextSizeBackContent;
}
