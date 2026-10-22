import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, SettingPath, SettingsStore, appThemeRegistry;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

/// Creates the theme controller from the current settings store values.
abstract final class UserSettingsThemeBridge {
  static ThemeVariantsController<AppTokens> createController(
    SettingsStore store,
  ) {
    final mode = switch (store.get<String>(SettingPath.themeMode)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    return ThemeVariantsController<AppTokens>(
      registry: appThemeRegistry,
      lightThemeId: store.get<String>(SettingPath.lightThemePresetId),
      darkThemeId: store.get<String>(SettingPath.darkThemePresetId),
      themeMode: mode,
    );
  }
}
