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
colorScaffoldBackground
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
sizeIconSm
sizeIcon
radiusSurfaceXsm
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
    required this.colorPrimary,
    required this.colorPrimaryDim,
    required this.colorPrimaryBright,
    required this.colorPrimarySoft,
    required this.colorStreak,
    required this.colorStreakDim,
    required this.colorScaffoldBackground,
    required this.colorSurfaceBackground,
    required this.colorBorderNeutralSubtle,
    required this.colorActionSuccess,
    required this.colorActionSuccessBackground,
    required this.colorActionSuccessBorder,
    required this.colorActionError,
    required this.colorActionErrorBackground,
    required this.colorActionErrorBorder,
    required this.colorTextBaseline,
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
    required this.colorGoogle,
    required this.colorGoogleDim,
    required this.colorTextOnGoogle,
    required this.colorMono,
    required this.colorMonoDim,
    required this.colorTextOnMono,
  });

  final String name;
  final String fontFamily = 'Noto Sans';

  // Primary
  final Color colorPrimary;
  final Color colorPrimaryDim;
  final Color colorPrimaryBright;
  final Color colorPrimarySoft;

  // Streak
  final Color colorStreak;
  final Color colorStreakDim;

  // Background
  final Color colorScaffoldBackground;
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
  final Color colorTransparent = Colors.transparent;
  final Color colorTextOnBrand = Colors.white;

  // Auth providers
  final Color colorGoogle;
  final Color colorGoogleDim;
  final Color colorTextOnGoogle;
  final Color colorMono;
  final Color colorMonoDim;
  final Color colorTextOnMono;

  // Button padding
  final double buttonPaddingHorizontalSm = 8;
  final double buttonPaddingVerticalSm = 12;
  final double buttonPaddingHorizontalMd = 24;
  final double buttonPaddingVerticalMd = 16;
  final double buttonPaddingHorizontalLg = 32;
  final double buttonPaddingVerticalLg = 18;
  final double buttonPaddingHorizontalIconWithLabel = 4;
  final double buttonPaddingVerticalIconWithLabel = 6;
  final double buttonPaddingHorizontalExtendedFab = 24;
  final double buttonPaddingVerticalExtendedFab = 0;

  final double buttonShadowOffset = 8;
  final double modalShadowOffset = 10;

  final FontWeight fontWeightTextBody = FontWeight.w600;
  final FontWeight fontWeightTextStrong = FontWeight.w800;
  final FontWeight fontWeightTextHeavy = FontWeight.w900;

  final double lineHeightTextBody = 1.45;
  final double lineHeightTextTitle = 1.1;
  final double lineHeightTextDisplay = 1.05;
  final double lineHeightFieldDisplay = 1.15;
  final double lineHeightButton = 1.1;
  final double letterSpacingTextEyebrow = 1.8;

  final double borderWidthDefault = 2;

  final double spaceScaffoldPadding = 20;
  final double spaceScaffoldPaddingXsm = 2;
  final double spaceScaffoldPaddingMobileY = 28;

  final double spaceLayoutPaddingLg = 20;
  final double spaceLayoutPadding = 15;
  final double spaceLayoutPaddingSm = 10;
  final double spaceLayoutGapLg = 24;
  final double spaceLayoutGapMd = 18;
  final double spaceLayoutGapSm = 8;
  final double spaceLayoutGapXsm = 4;
  final double spaceScaffoldMaxWidth = 800;

  final double radiusSurfaceLg = 60;
  final double radiusSurface = 40;
  final double radiusSurfaceSm = 26;
  final double radiusSurfaceXsm = 16;

  final double textSizeHeaderLarge = 36;
  final double textSizeHeader = 24;
  final double textSizeHeader2 = 30;
  final double textSizeBody = 20;
  final double textSizeBodyLarge = 30;
  final double textSizeLabelLarge = 16;
  final double textSizeLabel = 14;
  final double textSizeLabelSmall = 10;

  final double sizeIconSm = 18;
  final double sizeIcon = 24;
  final double sizeIconLg = 30;

  final double studyCardAspectRatio = 5 / 7;
  final double studyCardWidth = 300;
  final double studyCardRadius = 16;
  final double studyCardTextSizeFront = 68;
  final double studyCardTextSizeBack = 42;
  final double studyCardTextSizeBackContent = 34;

  final double deckListingFeaturedImagesAspectRatio = 83 / 65;
}
