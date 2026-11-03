import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, SettingPath, appThemeRegistry, SettingsStore;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ThemeController {
  ThemeController() {
    final mode = switch (_settings.get<String>(SettingPath.themeBrightness)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    instance = ThemeVariantsController<AppTokens>(
      registry: appThemeRegistry,
      lightThemeId: _settings.get<String>(SettingPath.lightThemePresetId),
      darkThemeId: _settings.get<String>(SettingPath.darkThemePresetId),
      themeMode: mode,
    );
  }

  static final _settings = SettingsStore.instance;

  static late final ThemeVariantsController instance;

  static Brightness get brightness =>
      switch (_settings.get<String>(SettingPath.themeBrightness)) {
        'light' => Brightness.light,
        'dark' => Brightness.dark,
        _ => Brightness.light,
      };

  static AppTokens get tokens => instance
      .getCurrentTheme(_settings.get(SettingPath.themeBrightness))
      .tokens;
}
