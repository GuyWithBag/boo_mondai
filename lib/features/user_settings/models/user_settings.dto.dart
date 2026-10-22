// import 'package:boo_mondai/lib.barrel.dart' show MutableEntity;
// import 'package:dart_mappable/dart_mappable.dart';
// import 'package:flutter/material.dart' show ThemeMode;

// import 'custom_theme_preset.dto.dart';
// import 'theme_override.dto.dart';

// part 'user_settings.dto.mapper.dart';

// /// One latest-state settings document for a profile/user.
// @MappableClass()
// class UserSettings extends MutableEntity with UserSettingsMappable {
//   /// Creates a persisted user settings row.
//   const UserSettings({
//     required super.id,
//     required this.profileId,
//     required this.themeModeName,
//     required this.lightThemePresetId,
//     required this.darkThemePresetId,
//     this.themeOverride,
//     this.customThemePresets = const [],
//     required super.createdAt,
//     required super.updatedAt,
//   });

//   /// Owning profile/user id.
//   final String profileId;

//   /// Stored `ThemeMode` name (`system`, `light`, `dark`).
//   final String themeModeName;

//   /// Selected preset id for light mode.
//   final String lightThemePresetId;

//   /// Selected preset id for dark mode.
//   final String darkThemePresetId;

//   /// Optional override values layered over selected preset tokens.
//   final ThemeOverride? themeOverride;

//   /// Selectable custom presets imported or authored by the user.
//   final List<CustomThemePreset> customThemePresets;

//   /// Decodes `themeModeName` into Flutter `ThemeMode`.
//   ThemeMode get themeMode {
//     return switch (themeModeName) {
//       'light' => ThemeMode.light,
//       'dark' => ThemeMode.dark,
//       _ => ThemeMode.system,
//     };
//   }
// }
