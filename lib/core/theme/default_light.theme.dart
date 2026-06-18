import 'package:boo_mondai/lib.barrel.dart' show AppTokens, buildAppThemeData;
import 'package:flutter/material.dart' show Color, Brightness;
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariant, ThemeVariantBrightness;

final AppTokens defaultLight = AppTokens(
  name: 'BooMondai Light',
  colorPrimary: Color(0xff6366f1),
  colorPrimaryDim: Color(0xff3f498a),
  colorPrimaryBright: Color(0xffc7d2fe),
  colorPrimarySoft: Color(0xffeef2ff),
  colorStreak: Color(0xfff97316),
  colorStreakDim: Color(0xffc2410c),
  colorScaffoldBackground: Color(0xffF0F3F5),
  colorSurfaceBackground: Color(0xffffffff),
  colorBorderNeutralSubtle: Color(0xffe5e7eb),
  colorActionSuccess: Color(0xff22c55e),
  colorActionSuccessBackground: Color(0xfff0fdf4),
  colorActionSuccessBorder: Color(0xffbbf7d0),
  colorActionError: Color(0xffef4444),
  colorActionErrorBackground: Color(0xfffef2f2),
  colorActionErrorBorder: Color(0xfffecaca),
  colorTextBaseline: Color(0xff111827),
  colorTextMuted: Color(0xff9ca3af),
  colorMuted: Color(0xfff3f4f6),
  colorRatingAgainBackground: Color(0xfffef2f2),
  colorRatingAgainText: Color(0xfff44336),
  colorRatingAgainBorder: Color(0xfffecaca),
  colorRatingAgainHoverBackground: Color(0xfffee2e2),
  colorRatingHardBackground: Color(0xfffff7ed),
  colorRatingHardText: Color(0xffff9800),
  colorRatingHardBorder: Color(0xfffed7aa),
  colorRatingHardHoverBackground: Color(0xffffedd5),
  colorRatingGoodBackground: Color(0xfff0fdf4),
  colorRatingGoodText: Color(0xff4caf50),
  colorRatingGoodBorder: Color(0xffbbf7d0),
  colorRatingGoodHoverBackground: Color(0xffdcfce7),
  colorRatingEasyBackground: Color(0xffeff6ff),
  colorRatingEasyText: Color(0xff2196f3),
  colorRatingEasyBorder: Color(0xffbfdbfe),
  colorRatingEasyHoverBackground: Color(0xffdbeafe),

  colorGoogle: Color(0xFFFFFFFF),
  colorGoogleDim: Color(0xFFDADADA),
  colorTextOnGoogle: Color(0xFF1F1F1F),
  colorMono: Color(0xFF000000),
  colorMonoDim: Color(0xFF3A3A3A),
  colorTextOnMono: Color(0xFFFFFFFF),
);

final booMondaiLight = ThemeVariant<AppTokens>(
  themePresetId: 'boomondai',
  brightness: ThemeVariantBrightness.light,
  themeData: buildAppThemeData(defaultLight, Brightness.light),
  tokens: defaultLight,
);
