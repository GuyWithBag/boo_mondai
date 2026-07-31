import 'package:boo_mondai/lib.barrel.dart' show AppTokens, booMondaiPreset;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

final appThemeRegistry = ThemeVariantRegistry<AppTokens>(
  presets: [booMondaiPreset],
);

ThemeVariantsController<AppTokens> createAppThemeController() {
  return ThemeVariantsController<AppTokens>(
    registry: appThemeRegistry,
    lightThemeId: 'boomondai',
    darkThemeId: 'boomondai',
    themeMode: ThemeMode.dark,
  );
}
