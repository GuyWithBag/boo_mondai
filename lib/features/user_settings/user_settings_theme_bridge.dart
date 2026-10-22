// import 'package:boo_mondai/lib.barrel.dart'
//     show
//         AppTokens,
//         AppTokensMapper,
//         CustomThemePreset,
//         ThemeOverride,
//         UserSettings,
//         appThemeRegistry,
//         buildAppThemeData;
// import 'package:flutter/material.dart' show Brightness, Color;
// import 'package:theme_variants/theme_variants.dart';

// /// Builds runtime theme registry and controller from persisted user settings.
// class UserSettingsThemeBridge {
//   const UserSettingsThemeBridge._();

//   /// Creates a theme controller from [settings], including custom presets.
//   static ThemeVariantsController<AppTokens> createController(
//     UserSettings settings,
//   ) {
//     final registry = _buildRegistry(settings.customThemePresets);
//     return ThemeVariantsController<AppTokens>(
//       registry: registry,
//       lightThemeId: _selectedThemeOrFallback(
//         registry: registry,
//         requestedId: settings.lightThemePresetId,
//       ),
//       darkThemeId: _selectedThemeOrFallback(
//         registry: registry,
//         requestedId: settings.darkThemePresetId,
//       ),
//       themeMode: settings.themeMode,
//       transform: (theme) => _applyOverrides(theme, settings.themeOverride),
//     );
//   }

//   static ThemeVariantRegistry<AppTokens> _buildRegistry(
//     List<CustomThemePreset> customPresets,
//   ) {
//     final presets = [...appThemeRegistry.presets.values];
//     for (final preset in customPresets) {
//       final lightTokens = _strictTokensFromMap(preset.lightTokens);
//       final darkTokens = _strictTokensFromMap(preset.darkTokens);
//       presets.add(
//         LightDarkThemePreset<AppTokens>(
//           id: preset.id,
//           name: preset.name,
//           light: ThemeVariant<AppTokens>(
//             themePresetId: preset.id,
//             brightness: ThemeVariantBrightness.light,
//             themeData: buildAppThemeData(lightTokens, Brightness.light),
//             tokens: lightTokens,
//           ),
//           dark: ThemeVariant<AppTokens>(
//             themePresetId: preset.id,
//             brightness: ThemeVariantBrightness.dark,
//             themeData: buildAppThemeData(darkTokens, Brightness.dark),
//             tokens: darkTokens,
//           ),
//         ),
//       );
//     }
//     return ThemeVariantRegistry<AppTokens>(presets: presets);
//   }

//   static String _selectedThemeOrFallback({
//     required ThemeVariantRegistry<AppTokens> registry,
//     required String requestedId,
//   }) {
//     final exists = registry.presets.containsKey(requestedId);
//     return exists ? requestedId : 'boomondai';
//   }

//   static ThemeVariant<AppTokens> _applyOverrides(
//     ThemeVariant<AppTokens> theme,
//     ThemeOverride? override,
//   ) {
//     if (override == null) return theme;
//     if (override.extraTokens.isNotEmpty) {
//       throw ArgumentError(
//         'Unsupported extraTokens in strict mode: '
//         '${override.extraTokens.keys.join(', ')}',
//       );
//     }

//     final radiusScale = _strictScale(override.radiusScale, 'radiusScale');
//     final spacingScale = _strictScale(override.spacingScale, 'spacingScale');
//     final textScale = _strictScale(override.textScale, 'textScale');
//     final hasPrimary = override.primaryColorValue != null;
//     final hasFont = _trimOrNull(override.fontFamily) != null;
//     final hasScales =
//         radiusScale != null || spacingScale != null || textScale != null;

//     if (!hasPrimary && !hasFont && !hasScales) return theme;

//     final nextTokens = theme.tokens.copyWith(
//       primary: hasPrimary ? Color(override.primaryColorValue!) : null,
//       fontFamily: hasFont ? override.fontFamily!.trim() : null,
//       radiusSurface: radiusScale == null
//           ? null
//           : theme.tokens.radiusSurface * radiusScale,
//       radiusSurfaceXsm: radiusScale == null
//           ? null
//           : theme.tokens.radiusSurfaceXsm * radiusScale,
//       spacePanelPadding: spacingScale == null
//           ? null
//           : theme.tokens.spaceLayoutPadding * spacingScale,
//       spacePanelPaddingSm: spacingScale == null
//           ? null
//           : theme.tokens.spaceLayoutPadding * spacingScale,
//       spaceLayoutGapLg: spacingScale == null
//           ? null
//           : theme.tokens.spaceLayoutGapLg * spacingScale,
//       spaceLayoutGapMd: spacingScale == null
//           ? null
//           : theme.tokens.spaceLayoutGapMd * spacingScale,
//       spaceLayoutGapSm: spacingScale == null
//           ? null
//           : theme.tokens.spaceLayoutGapSm * spacingScale,
//       textSizeHeader: textScale == null
//           ? null
//           : theme.tokens.textSizeHeader * textScale,
//       textSizeLabelLarge: textScale == null
//           ? null
//           : theme.tokens.textSizeLabelLarge * textScale,
//       textSizeLabel: textScale == null
//           ? null
//           : theme.tokens.textSizeLabel * textScale,
//       textSizeLabelSmall: textScale == null
//           ? null
//           : theme.tokens.textSizeLabelSmall * textScale,
//       textSizeBodyLarge: textScale == null
//           ? null
//           : theme.tokens.textSizeBodyLarge * textScale,
//       textSizeCardFront: textScale == null
//           ? null
//           : theme.tokens.studyCardTextSizeFront * textScale,
//       textSizeCardBackFront: textScale == null
//           ? null
//           : theme.tokens.studyCardTextSizeBack * textScale,
//       studyCardTextSizeBackContent: textScale == null
//           ? null
//           : theme.tokens.studyCardTextSizeBackContent * textScale,
//     );

//     final brightness = switch (theme.brightness) {
//       ThemeVariantBrightness.single => theme.themeData.brightness,
//       ThemeVariantBrightness.light => Brightness.light,
//       ThemeVariantBrightness.dark => Brightness.dark,
//     };

//     return ThemeVariant<AppTokens>(
//       themePresetId: theme.themePresetId,
//       brightness: theme.brightness,
//       themeData: buildAppThemeData(nextTokens, brightness),
//       tokens: nextTokens,
//     );
//   }

//   static AppTokens _strictTokensFromMap(Map<String, dynamic> raw) {
//     return AppTokensMapper.fromMap(raw);
//   }

//   static double? _strictScale(double? value, String fieldName) {
//     if (value == null) return null;
//     if (value <= 0) {
//       throw ArgumentError.value(value, fieldName, 'must be greater than zero');
//     }
//     return value;
//   }

//   static String? _trimOrNull(String? value) {
//     if (value == null) return null;
//     final trimmed = value.trim();
//     return trimmed.isEmpty ? null : trimmed;
//   }
// }
