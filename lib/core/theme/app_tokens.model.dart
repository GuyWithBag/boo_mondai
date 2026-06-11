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
spacePanelGapLg
surfaceShadowOffset
radiusSurface
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
radiusSurfaceSm
radiusSurface

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

@MappableClass()
class AppTokens with AppTokensMappable {
  const AppTokens({
    required this.name,
    required this.fontFamily,
    required this.primary,
    required this.primaryDim,
    required this.primaryBright,
    required this.streak,
    required this.streakDim,
    required this.backgroundPage,
    required this.backgroundSurface,
    required this.borderNeutralSubtle,
    required this.actionSuccess,
    required this.actionSuccessBackground,
    required this.actionSuccessBorder,
    required this.actionError,
    required this.actionErrorBackground,
    required this.actionErrorBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.softGray,
    required this.primarySoft,
    required this.greenSoft,
    required this.ratingAgainBackground,
    required this.ratingAgainText,
    required this.ratingAgainBorder,
    required this.ratingAgainHoverBackground,
    required this.ratingHardBackground,
    required this.ratingHardText,
    required this.ratingHardBorder,
    required this.ratingHardHoverBackground,
    required this.ratingGoodBackground,
    required this.ratingGoodText,
    required this.ratingGoodBorder,
    required this.ratingGoodHoverBackground,
    required this.ratingEasyBackground,
    required this.ratingEasyText,
    required this.ratingEasyBorder,
    required this.ratingEasyHoverBackground,
    required this.colorTransparent,
    required this.colorTextOnBrand,
    required this.surfaceShadowOffset,
    required this.modalShadowOffset,
    required this.fontWeightTextBody,
    required this.fontWeightTextStrong,
    required this.fontWeightTextHeavy,
    required this.lineHeightTextBody,
    required this.lineHeightTextTitle,
    required this.lineHeightTextDisplay,
    required this.lineHeightFieldDisplay,
    required this.lineHeightTactile,
    required this.letterSpacingTextEyebrow,
    required this.radiusSurface,
    required this.radiusSurfaceSm,
    required this.borderWidthDefault,
    required this.spacePanelPadding,
    required this.spacePanelPaddingSm,
    required this.spacePanelGapLg,
    required this.spacePanelGapMd,
    required this.spacePanelGapSm,
    required this.textSizeHeader,
    required this.textSizeLabelLarge,
    required this.textSizeLabel,
    required this.textSizeLabelSmall,
    required this.textSizeBodyLarge,
    required this.textSizeCardFront,
    required this.textSizeCardBackFront,
    required this.textSizeCardBackContent,
    required this.sizeIconMd,
    required this.sizeIconLg,
    required this.cardAspectRatio,
    required this.widthCard,
    required this.radiusCard,
    required this.radiusSurfaceLg,
  });

  final String name;
  final String fontFamily;
  final Color primary;
  final Color primaryDim;
  final Color primaryBright;
  final Color streak;
  final Color streakDim;
  final Color backgroundPage;
  final Color backgroundSurface;
  final Color borderNeutralSubtle;
  final Color actionSuccess;
  final Color actionSuccessBackground;
  final Color actionSuccessBorder;
  final Color actionError;
  final Color actionErrorBackground;
  final Color actionErrorBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color softGray;
  final Color primarySoft;
  final Color greenSoft;
  final Color ratingAgainBackground;
  final Color ratingAgainText;
  final Color ratingAgainBorder;
  final Color ratingAgainHoverBackground;
  final Color ratingHardBackground;
  final Color ratingHardText;
  final Color ratingHardBorder;
  final Color ratingHardHoverBackground;
  final Color ratingGoodBackground;
  final Color ratingGoodText;
  final Color ratingGoodBorder;
  final Color ratingGoodHoverBackground;
  final Color ratingEasyBackground;
  final Color ratingEasyText;
  final Color ratingEasyBorder;
  final Color ratingEasyHoverBackground;
  final Color colorTransparent;
  final Color colorTextOnBrand;
  final double surfaceShadowOffset;
  final double modalShadowOffset;
  final FontWeight fontWeightTextBody;
  final FontWeight fontWeightTextStrong;
  final FontWeight fontWeightTextHeavy;
  final double lineHeightTextBody;
  final double lineHeightTextTitle;
  final double lineHeightTextDisplay;
  final double lineHeightFieldDisplay;
  final double lineHeightTactile;
  final double letterSpacingTextEyebrow;
  final double radiusSurfaceLg;
  final double radiusSurface;
  final double radiusSurfaceSm;
  final double borderWidthDefault;
  final double spacePanelPadding;
  final double spacePanelPaddingSm;
  final double spacePanelGapLg;
  final double spacePanelGapMd;
  final double spacePanelGapSm;
  final double textSizeHeader;
  final double textSizeLabelLarge;
  final double textSizeLabel;
  final double textSizeLabelSmall;
  final double textSizeBodyLarge;
  final double textSizeCardFront;
  final double textSizeCardBackFront;
  final double textSizeCardBackContent;
  final double sizeIconMd;
  final double sizeIconLg;
  final double cardAspectRatio;
  final double widthCard;
  final double radiusCard;
}
