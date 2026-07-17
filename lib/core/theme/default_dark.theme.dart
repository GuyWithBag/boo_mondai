import 'package:boo_mondai/lib.barrel.dart' show AppTokens, buildAppThemeData;
import 'package:flutter/material.dart' show Color, Brightness, Colors;
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariant, ThemeVariantBrightness;

final AppTokens defaultDark = AppTokens(
  name: 'BooMondai Dark',
  colorLayoutShadow: Color(0x36000000),
  colorPrimary: Color(0xff6366f1),
  colorPrimaryDim: Color(0xff3f498a),
  colorPrimaryBright: Color(0xff3730a3),
  colorPrimarySoft: Color(0xff312e81),
  colorStreak: Color(0xfffb923c),
  colorStreakDim: Color(0xffea580c),
  colorScaffoldBackground: Color(0xff0b1020),
  colorSurfaceBackground: Color(0xff111827),
  colorBorderNeutralSubtle: Color(0xff374151),
  colorActionSuccess: Color(0xff4ade80),
  colorActionSuccessBackground: Color(0xff052e16),
  colorActionSuccessBorder: Color(0xff14532d),
  colorActionError: Color(0xfff87171),
  colorActionErrorBackground: Color(0xff450a0a),
  colorActionErrorBorder: Color(0xff7f1d1d),
  colorTextBaseline: Color(0xfff3f4f6),
  colorTextMuted: Color(0xff9ca3af),
  colorMuted: Color(0xff1f2937),
  colorRatingAgainBackground: Color(0xff450a0a),
  colorRatingAgainText: Color(0xffff8a80),
  colorRatingAgainBorder: Color(0xff7f1d1d),
  colorRatingAgainHoverBackground: Color(0xff5f1414),
  colorRatingHardBackground: Color(0xff431407),
  colorRatingHardText: Color(0xffffb74d),
  colorRatingHardBorder: Color(0xff7c2d12),
  colorRatingHardHoverBackground: Color(0xff5a1d0a),
  colorRatingGoodBackground: Color(0xff052e16),
  colorRatingGoodText: Color(0xff81c784),
  colorRatingGoodBorder: Color(0xff14532d),
  colorRatingGoodHoverBackground: Color(0xff0b3d1f),
  colorRatingEasyBackground: Color(0xff082f49),
  colorRatingEasyText: Color(0xff64b5f6),
  colorRatingEasyBorder: Color(0xff075985),
  colorRatingEasyHoverBackground: Color(0xff0c4a6e),

  colorGoogle: Color(0xFF131314),
  colorGoogleDim: Color(0xFF3A3A3A),
  colorTextOnGoogle: Color(0xFFE3E3E3),
  colorMono: Color(0xFFFFFFFF),
  colorMonoDim: Color(0xFFDADADA),
  colorTextOnMono: Color(0xFF000000),
);

final booMondaiDark = ThemeVariant<AppTokens>(
  themePresetId: 'boomondai',
  brightness: ThemeVariantBrightness.dark,
  themeData: buildAppThemeData(defaultDark, Brightness.dark),
  tokens: defaultDark,
);
