import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, DefaultLightTokens, buildAppThemeData;
import 'package:flutter/material.dart' show Brightness;
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariant, ThemeVariantBrightness;

AppTokens get defaultLight => const DefaultLightTokens();

ThemeVariant<AppTokens> createBooMondaiLight() {
  final tokens = defaultLight;

  return ThemeVariant<AppTokens>(
    themePresetId: 'boomondai',
    brightness: ThemeVariantBrightness.light,
    themeData: buildAppThemeData(tokens, Brightness.light),
    tokens: tokens,
  );
}

ThemeVariant<AppTokens> get booMondaiLight => createBooMondaiLight();
