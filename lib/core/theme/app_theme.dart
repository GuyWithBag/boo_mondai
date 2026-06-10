import 'package:boo_mondai/lib.barrel.dart'
    show booMondaiLight, booMondaiDark, AppTokens;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

final booMondaiPreset = LightDarkThemePreset<AppTokens>(
  id: 'boomondai',
  name: 'BooMondai',
  light: booMondaiLight,
  dark: booMondaiDark,
);

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
