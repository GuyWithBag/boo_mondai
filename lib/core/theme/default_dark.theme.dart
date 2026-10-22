import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, DefaultDarkTokens, buildAppThemeData;
import 'package:flutter/material.dart' show Brightness;
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariant, ThemeVariantBrightness;

AppTokens get defaultDark => const DefaultDarkTokens();

ThemeVariant<AppTokens> createBooMondaiDark() {
  final tokens = defaultDark;

  return ThemeVariant<AppTokens>(
    themePresetId: 'boomondai',
    brightness: ThemeVariantBrightness.dark,
    themeData: buildAppThemeData(tokens, Brightness.dark),
    tokens: tokens,
  );
}

ThemeVariant<AppTokens> get booMondaiDark => createBooMondaiDark();
