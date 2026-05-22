import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import 'app_tokens.dart';

ThemeData _themeData(AppTokens tokens, Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: tokens.primary,
    brightness: brightness,
    primary: tokens.primary,
    surface: tokens.backgroundSurface,
    error: tokens.actionError,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: tokens.backgroundPage,
    fontFamily: tokens.fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: tokens.backgroundSurface,
      foregroundColor: tokens.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 88,
      titleSpacing: 0,
      shape: Border(
        bottom: BorderSide(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault,
        ),
      ),
    ),
    textTheme: TextTheme(),
    dividerTheme: DividerThemeData(
      color: tokens.borderNeutralSubtle,
      thickness: tokens.borderWidthDefault,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: tokens.primary.withValues(alpha: 0.22),
      cursorColor: tokens.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: TextStyle(
        color: tokens.textMuted.withValues(alpha: 0.65),
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

final booMondaiLight = ThemeVariant<AppTokens>(
  themePresetId: 'boomondai',
  brightness: ThemeVariantBrightness.light,
  themeData: _themeData(defaultLight, Brightness.light),
  tokens: defaultLight,
);

final booMondaiDark = ThemeVariant<AppTokens>(
  themePresetId: 'boomondai',
  brightness: ThemeVariantBrightness.dark,
  themeData: _themeData(defaultDark, Brightness.dark),
  tokens: defaultDark,
);

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
    themeMode: ThemeMode.system,
  );
}
