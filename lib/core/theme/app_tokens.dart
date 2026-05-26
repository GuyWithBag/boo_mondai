import 'package:boo_mondai/lib.barrel.dart'
    show
        fontWeightTextHeavy,
        lineHeightTextBody,
        fontFamily,
        radiusContainerLarge,
        radius2xl,
        radius3xl,
        surfaceShadowOffset,
        modalShadowOffset,
        borderWidthDefault,
        spacePanelPadding,
        spacePanelGapSm,
        spacePanelGapLg,
        spacePanelGapMd,
        textSizeHeader,
        textSizeLabelLarge,
        textSizeLabel,
        textSizeLabelSmall,
        textSizeBodyLarge,
        textSizeCardFront,
        textSizeCardBackFront,
        textSizeCardBackContent,
        fontWeightTextBody,
        fontWeightTextStrong,
        lineHeightTextTitle,
        lineHeightTextDisplay,
        lineHeightFieldDisplay,
        lineHeightTactile,
        letterSpacingTextEyebrow,
        sizeIconMd,
        sizeIconLg,
        colorTransparent,
        colorTextOnBrand,
        cardAspectRatio;
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
spacePanelGapLg
surfaceShadowOffset
radiusContainerLarge
borderWidthDefault

Color tokens should describe use.

Good:
backgroundPage
backgroundSurface
textPrimary
textSecondary
textMuted
borderNeutralSubtle
actionSuccess
actionError

Avoid:
gray100
blue500
green
red

Use scale words only when the token is part of a real scale.

Good:
spacePanelGapSm
spacePanelGapMd
spacePanelGapLg
sizeIconMd
sizeIconLg
radius2xl
radius3xl

Avoid adding scale names if there is only one value:
spacePanelGapDefault
iconSizeDefault

Component-specific values should stay with the component first.
Promote them into AppTokens only when several components reuse the same idea.

Good global token:
borderWidthDefault

Better kept local until reused:
matchingTypeInputBorderWidth
tactileButtonPressedYOffset
*/

typedef AppTokens = ({
  String name,
  String fontFamily,
  Color primary,
  Color primaryDim,
  Color primaryBright,
  Color streak,
  Color streakDim,
  Color backgroundPage,
  Color backgroundSurface,
  Color borderNeutralSubtle,
  Color actionSuccess,
  Color actionSuccessBackground,
  Color actionSuccessBorder,
  Color actionError,
  Color actionErrorBackground,
  Color actionErrorBorder,
  Color textPrimary,
  Color textSecondary,
  Color textMuted,
  Color softGray,
  Color primarySoft,
  Color greenSoft,
  Color ratingAgainBackground,
  Color ratingAgainText,
  Color ratingAgainBorder,
  Color ratingAgainHoverBackground,
  Color ratingHardBackground,
  Color ratingHardText,
  Color ratingHardBorder,
  Color ratingHardHoverBackground,
  Color ratingGoodBackground,
  Color ratingGoodText,
  Color ratingGoodBorder,
  Color ratingGoodHoverBackground,
  Color ratingEasyBackground,
  Color ratingEasyText,
  Color ratingEasyBorder,
  Color ratingEasyHoverBackground,
  Color colorTransparent,
  Color colorTextOnBrand,

  double surfaceShadowOffset,
  double modalShadowOffset,

  FontWeight fontWeightTextBody,
  FontWeight fontWeightTextStrong,
  FontWeight fontWeightTextHeavy,

  double lineHeightTextBody,
  double lineHeightTextTitle,
  double lineHeightTextDisplay,
  double lineHeightFieldDisplay,
  double lineHeightTactile,
  double letterSpacingTextEyebrow,

  double radiusContainerLarge,
  double radius2xl,
  double radius3xl,

  double borderWidthDefault,
  double spacePanelPadding,
  double spacePanelPaddingSm,
  double spacePanelGapLg,
  double spacePanelGapMd,
  double spacePanelGapSm,

  double textSizeHeader,
  double textSizeLabelLarge,
  double textSizeLabel,
  double textSizeLabelSmall,
  double textSizeBodyLarge,
  double textSizeCardFront,
  double textSizeCardBackFront,
  double textSizeCardBackContent,
  double sizeIconMd,
  double sizeIconLg,
  double cardAspectRatio,
});

final AppTokens defaultLight = (
  name: 'BooMondai Light',
  fontFamily: fontFamily,
  primary: Color(0xff6366f1),
  primaryDim: Color(0xff3f498a),
  primaryBright: Color(0xffc7d2fe),
  primarySoft: Color(0xffeef2ff),
  streak: Color(0xfff97316),
  streakDim: Color(0xffc2410c),
  backgroundPage: Color(0xfff8f9fa),
  backgroundSurface: Color(0xffffffff),
  borderNeutralSubtle: Color(0xffe5e7eb),
  actionSuccess: Color(0xff22c55e),
  actionSuccessBackground: Color(0xfff0fdf4),
  actionSuccessBorder: Color(0xffbbf7d0),
  actionError: Color(0xffef4444),
  actionErrorBackground: Color(0xfffef2f2),
  actionErrorBorder: Color(0xfffecaca),
  textPrimary: Color(0xff111827),
  textSecondary: Color(0xff6b7280),
  textMuted: Color(0xff9ca3af),
  softGray: Color(0xfff3f4f6),
  greenSoft: Color(0xfff0fdf4),
  ratingAgainBackground: Color(0xfffef2f2),
  ratingAgainText: Color(0xfff44336),
  ratingAgainBorder: Color(0xfffecaca),
  ratingAgainHoverBackground: Color(0xfffee2e2),
  ratingHardBackground: Color(0xfffff7ed),
  ratingHardText: Color(0xffff9800),
  ratingHardBorder: Color(0xfffed7aa),
  ratingHardHoverBackground: Color(0xffffedd5),
  ratingGoodBackground: Color(0xfff0fdf4),
  ratingGoodText: Color(0xff4caf50),
  ratingGoodBorder: Color(0xffbbf7d0),
  ratingGoodHoverBackground: Color(0xffdcfce7),
  ratingEasyBackground: Color(0xffeff6ff),
  ratingEasyText: Color(0xff2196f3),
  ratingEasyBorder: Color(0xffbfdbfe),
  ratingEasyHoverBackground: Color(0xffdbeafe),
  radiusContainerLarge: radiusContainerLarge,
  radius2xl: radius2xl,
  radius3xl: radius3xl,
  surfaceShadowOffset: surfaceShadowOffset,
  modalShadowOffset: modalShadowOffset,
  borderWidthDefault: borderWidthDefault,
  spacePanelPadding: spacePanelPadding,
  spacePanelPaddingSm: spacePanelGapSm,
  spacePanelGapLg: spacePanelGapLg,
  spacePanelGapMd: spacePanelGapMd,
  spacePanelGapSm: spacePanelGapSm,
  textSizeHeader: textSizeHeader,
  textSizeLabelLarge: textSizeLabelLarge,
  textSizeLabel: textSizeLabel,
  textSizeLabelSmall: textSizeLabelSmall,
  textSizeBodyLarge: textSizeBodyLarge,
  textSizeCardFront: textSizeCardFront,
  textSizeCardBackFront: textSizeCardBackFront,
  textSizeCardBackContent: textSizeCardBackContent,
  fontWeightTextBody: fontWeightTextBody,
  fontWeightTextStrong: fontWeightTextStrong,
  fontWeightTextHeavy: fontWeightTextHeavy,
  lineHeightTextBody: lineHeightTextBody,
  lineHeightTextTitle: lineHeightTextTitle,
  lineHeightTextDisplay: lineHeightTextDisplay,
  lineHeightFieldDisplay: lineHeightFieldDisplay,
  lineHeightTactile: lineHeightTactile,
  letterSpacingTextEyebrow: letterSpacingTextEyebrow,
  sizeIconMd: sizeIconMd,
  sizeIconLg: sizeIconLg,
  colorTransparent: colorTransparent,
  colorTextOnBrand: colorTextOnBrand,
  cardAspectRatio: cardAspectRatio,
);

final AppTokens defaultDark = (
  name: 'BooMondai Dark',
  fontFamily: fontFamily,
  primary: Color(0xff6366f1),
  primaryDim: Color(0xff3f498a),
  primaryBright: Color(0xff3730a3),
  primarySoft: Color(0xff312e81),
  streak: Color(0xfffb923c),
  streakDim: Color(0xffea580c),
  backgroundPage: Color(0xff0b1020),
  backgroundSurface: Color(0xff111827),
  borderNeutralSubtle: Color(0xff374151),
  actionSuccess: Color(0xff4ade80),
  actionSuccessBackground: Color(0xff052e16),
  actionSuccessBorder: Color(0xff14532d),
  actionError: Color(0xfff87171),
  actionErrorBackground: Color(0xff450a0a),
  actionErrorBorder: Color(0xff7f1d1d),
  textPrimary: Color(0xfff3f4f6),
  textSecondary: Color(0xffd1d5db),
  textMuted: Color(0xff9ca3af),
  softGray: Color(0xff1f2937),
  greenSoft: Color(0xff052e16),
  ratingAgainBackground: Color(0xff450a0a),
  ratingAgainText: Color(0xffff8a80),
  ratingAgainBorder: Color(0xff7f1d1d),
  ratingAgainHoverBackground: Color(0xff5f1414),
  ratingHardBackground: Color(0xff431407),
  ratingHardText: Color(0xffffb74d),
  ratingHardBorder: Color(0xff7c2d12),
  ratingHardHoverBackground: Color(0xff5a1d0a),
  ratingGoodBackground: Color(0xff052e16),
  ratingGoodText: Color(0xff81c784),
  ratingGoodBorder: Color(0xff14532d),
  ratingGoodHoverBackground: Color(0xff0b3d1f),
  ratingEasyBackground: Color(0xff082f49),
  ratingEasyText: Color(0xff64b5f6),
  ratingEasyBorder: Color(0xff075985),
  ratingEasyHoverBackground: Color(0xff0c4a6e),
  radiusContainerLarge: radiusContainerLarge,
  radius2xl: radius2xl,
  radius3xl: radius3xl,
  surfaceShadowOffset: surfaceShadowOffset,
  modalShadowOffset: modalShadowOffset,
  borderWidthDefault: borderWidthDefault,
  spacePanelPadding: spacePanelPadding,
  spacePanelPaddingSm: spacePanelGapSm,
  spacePanelGapLg: spacePanelGapLg,
  spacePanelGapMd: spacePanelGapMd,
  spacePanelGapSm: spacePanelGapSm,
  textSizeHeader: textSizeHeader,
  textSizeLabelLarge: textSizeLabelLarge,
  textSizeLabel: textSizeLabel,
  textSizeLabelSmall: textSizeLabelSmall,
  textSizeBodyLarge: textSizeBodyLarge,
  textSizeCardFront: textSizeCardFront,
  textSizeCardBackFront: textSizeCardBackFront,
  textSizeCardBackContent: textSizeCardBackContent,
  fontWeightTextBody: fontWeightTextBody,
  fontWeightTextStrong: fontWeightTextStrong,
  fontWeightTextHeavy: fontWeightTextHeavy,
  lineHeightTextBody: lineHeightTextBody,
  lineHeightTextTitle: lineHeightTextTitle,
  lineHeightTextDisplay: lineHeightTextDisplay,
  lineHeightFieldDisplay: lineHeightFieldDisplay,
  lineHeightTactile: lineHeightTactile,
  letterSpacingTextEyebrow: letterSpacingTextEyebrow,
  sizeIconMd: sizeIconMd,
  sizeIconLg: sizeIconLg,
  colorTransparent: colorTransparent,
  colorTextOnBrand: colorTextOnBrand,
  cardAspectRatio: cardAspectRatio,
);
