import 'package:flutter/material.dart';

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

class AppTokens {
  const AppTokens();

  String get name => 'BooMondai';
  String get fontFamily => 'Noto Sans';

  Color get colorLayoutShadow => const Color(0x14080808);

  // Primary
  Color get colorPrimary => const Color(0xff6366f1);
  Color get colorPrimaryDim => const Color(0xff3f498a);
  Color get colorPrimaryBright => const Color(0xffc7d2fe);
  Color get colorPrimarySoft => const Color(0xffeef2ff);

  // Streak
  Color get colorStreak => const Color(0xfff97316);
  Color get colorStreakDim => const Color(0xffc2410c);

  // Background
  Color get colorScaffoldBackground => const Color(0xffF0F3F5);
  Color get colorSurfaceBackground => const Color(0xffffffff);

  // Border
  Color get colorBorderNeutralSubtle => const Color(0xffe5e7eb);

  // Action
  Color get colorActionSuccess => const Color(0xff22c55e);
  Color get colorActionSuccessBackground => const Color(0xfff0fdf4);
  Color get colorActionSuccessBorder => const Color(0xffbbf7d0);
  Color get colorActionError => const Color(0xffef4444);
  Color get colorActionErrorBackground => const Color(0xfffef2f2);
  Color get colorActionErrorBorder => const Color(0xfffecaca);

  // Text
  Color get colorTextBaseline => const Color(0xff111827);
  Color get colorTextMuted => const Color(0xff9ca3af);

  // Neutral
  Color get colorMuted => const Color(0xfff3f4f6);

  // Rating
  Color get colorRatingAgainBackground => const Color(0xfffef2f2);
  Color get colorRatingAgainText => const Color(0xfff44336);
  Color get colorRatingAgainBorder => const Color(0xfffecaca);
  Color get colorRatingAgainHoverBackground => const Color(0xfffee2e2);
  Color get colorRatingHardBackground => const Color(0xfffff7ed);
  Color get colorRatingHardText => const Color(0xffff9800);
  Color get colorRatingHardBorder => const Color(0xfffed7aa);
  Color get colorRatingHardHoverBackground => const Color(0xffffedd5);
  Color get colorRatingGoodBackground => const Color(0xfff0fdf4);
  Color get colorRatingGoodText => const Color(0xff4caf50);
  Color get colorRatingGoodBorder => const Color(0xffbbf7d0);
  Color get colorRatingGoodHoverBackground => const Color(0xffdcfce7);
  Color get colorRatingEasyBackground => const Color(0xffeff6ff);
  Color get colorRatingEasyText => const Color(0xff2196f3);
  Color get colorRatingEasyBorder => const Color(0xffbfdbfe);
  Color get colorRatingEasyHoverBackground => const Color(0xffdbeafe);

  // Utility
  Color get colorTransparent => Colors.transparent;
  Color get colorTextOnBrand => Colors.white;

  // Auth providers
  Color get colorGoogle => const Color(0xFFFFFFFF);
  Color get colorGoogleDim => const Color(0xFFDADADA);
  Color get colorTextOnGoogle => const Color(0xFF1F1F1F);
  Color get colorMono => const Color(0xFF000000);
  Color get colorMonoDim => const Color(0xFF3A3A3A);
  Color get colorTextOnMono => const Color(0xFFFFFFFF);

  // Button padding
  double get buttonPaddingHorizontalSm => 8;
  double get buttonPaddingVerticalSm => 12;
  double get buttonPaddingHorizontalMd => 24;
  double get buttonPaddingVerticalMd => 16;
  double get buttonPaddingHorizontalLg => 32;
  double get buttonPaddingVerticalLg => 18;
  double get buttonPaddingHorizontalIconWithLabel => 4;
  double get buttonPaddingVerticalIconWithLabel => 6;
  double get buttonPaddingHorizontalExtendedFab => 24;
  double get buttonPaddingVerticalExtendedFab => 0;

  double get buttonIconSmallTactileShadowOffset => 5;
  double get buttonTactileShadowOffset => 8;
  double get buttonShadowOffset => 8;
  double get modalShadowOffset => 10;

  FontWeight get fontWeightTextBody => FontWeight.w600;
  FontWeight get fontWeightTextStrong => FontWeight.w800;
  FontWeight get fontWeightTextHeavy => FontWeight.w900;

  double get lineHeightTextBody => 1.45;
  double get lineHeightTextTitle => 1.1;
  double get lineHeightTextDisplay => 1.05;
  double get lineHeightFieldDisplay => 1.15;
  double get lineHeightButton => 1.1;
  double get letterSpacingTextEyebrow => 2;

  double get borderWidthDefault => 2;

  double get spaceScaffoldPadding => 20;
  double get spaceScaffoldPaddingXsm => 2;
  double get spaceScaffoldPaddingMobileY => 28;

  double get spaceLayoutPaddingLg => 20;
  double get spaceLayoutPadding => 15;
  double get spaceLayoutPaddingSm => 10;
  double get spaceLayoutGapLg => 24;
  double get spaceLayoutGapMd => 18;
  double get spaceLayoutGapSm => 8;
  double get spaceLayoutGapXsm => 4;
  double get spaceScaffoldMaxWidth => 800;

  double get radiusSurfaceLg => 60;
  double get radiusSurface => 40;
  double get radiusSurfaceSm => 26;
  double get radiusSurfaceXsm => 16;
  double get radiusSurfaceXxsm => 8;

  double get radiusButton => 16;
  double get radiusButtonIcon => 16;
  double get radiusButtonIconSm => 12;

  double get textSizeHeaderLarge => 36;
  double get textSizeHeader => 24;
  double get textSizeHeader2 => 30;
  double get textSizeBody => 20;
  double get textSizeBodyLarge => 30;
  double get textSizeLabelLarge => 16;
  double get textSizeLabel => 14;
  double get textSizeLabelSmall => 10;

  double get sizeIconSm => 18;
  double get sizeIcon => 24;
  double get sizeIconLg => 30;
  double get sizeModalIcon => 50;

  double get sizeButtonIcon => 48;
  double get sizeButtonIconSm => 38;
  // final double bottomNavBarPreferredHeight = 90;
  // final double appBarPreferredHeight = 90;
  // final double preferredHeightDefault = 82;
  // final double unfocusButtonHeight = 48;

  double get studyCardAspectRatio => 5 / 7;
  double get studyCardWidth => 300;
  double get studyCardRadius => 16;
  double get studyCardTextSizeFront => 68;
  double get studyCardTextSizeBack => 42;
  double get studyCardTextSizeBackContent => 34;

  double get deckListingFeaturedImagesAspectRatio => 83 / 65;
}
