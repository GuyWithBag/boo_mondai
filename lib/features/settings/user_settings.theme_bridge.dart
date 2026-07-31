import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        buildAppThemeData,
        SettingsController,
        CustomThemePreset,
        ThemeOverride,
        SettingsService,
        CustomThemePresetMapper,
        ThemeOverrideMapper,
        appThemeRegistry,
        AppTokensMapper;
import 'package:flutter/material.dart' show Brightness, ThemeMode, Color;
import 'package:theme_variants/theme_variants.dart';

/// Builds a [ThemeVariantsController] from live [SettingsController] state.
///
/// Pass the controller directly rather than a snapshot of [UserSettings] so
/// that [app.dart] can key [useMemoized] on the controller itself and get a
/// reactive rebuild whenever any setting changes.
class UserSettingsThemeBridge {
  const UserSettingsThemeBridge._();

  /// Creates a [ThemeVariantsController] driven by [settingsCtrl].
  static ThemeVariantsController<AppTokens> createController(
    SettingsController settingsCtrl,
  ) {
    final settings = settingsCtrl.settings;

    // Decode custom presets from stored maps.
    final rawPresets = settings.get(SettingsService.customThemePresets);
    final customPresets = rawPresets
        .map((raw) => CustomThemePresetMapper.fromMap(raw))
        .toList(growable: false);

    // Decode optional theme override.
    final rawOverride = settings.get(SettingsService.themeOverride);
    final themeOverride = rawOverride != null
        ? ThemeOverrideMapper.fromMap(rawOverride)
        : null;

    final registry = _buildRegistry(customPresets);

    return ThemeVariantsController<AppTokens>(
      registry: registry,
      lightThemeId: _resolvedPresetId(
        registry: registry,
        requestedId: settings.get(SettingsService.lightThemePresetId),
      ),
      darkThemeId: _resolvedPresetId(
        registry: registry,
        requestedId: settings.get(SettingsService.darkThemePresetId),
      ),
      themeMode: _themeMode(settings.get(SettingsService.themeMode)),
      transform: (theme) => _applyOverride(theme, themeOverride),
    );
  }

  // ---------------------------------------------------------------------------
  // Registry
  // ---------------------------------------------------------------------------

  static ThemeVariantRegistry<AppTokens> _buildRegistry(
    List<CustomThemePreset> customPresets,
  ) {
    final presets = [...appThemeRegistry.presets.values];
    for (final preset in customPresets) {
      final lightTokens = AppTokensMapper.fromMap(preset.lightTokens);
      final darkTokens = AppTokensMapper.fromMap(preset.darkTokens);
      presets.add(
        LightDarkThemePreset<AppTokens>(
          id: preset.id,
          name: preset.name,
          light: ThemeVariant<AppTokens>(
            themePresetId: preset.id,
            brightness: ThemeVariantBrightness.light,
            themeData: buildAppThemeData(lightTokens, Brightness.light),
            tokens: lightTokens,
          ),
          dark: ThemeVariant<AppTokens>(
            themePresetId: preset.id,
            brightness: ThemeVariantBrightness.dark,
            themeData: buildAppThemeData(darkTokens, Brightness.dark),
            tokens: darkTokens,
          ),
        ),
      );
    }
    return ThemeVariantRegistry<AppTokens>(presets: presets);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static String _resolvedPresetId({
    required ThemeVariantRegistry<AppTokens> registry,
    required String requestedId,
  }) => registry.presets.containsKey(requestedId) ? requestedId : 'boomondai';

  static ThemeMode _themeMode(String stored) => switch (stored) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  static ThemeVariant<AppTokens> _applyOverride(
    ThemeVariant<AppTokens> theme,
    ThemeOverride? override,
  ) {
    if (override == null) return theme;
    if (override.extraTokens.isNotEmpty) {
      throw ArgumentError(
        'Unsupported extraTokens in strict mode: '
        '${override.extraTokens.keys.join(', ')}',
      );
    }

    final radiusScale = _validScale(override.radiusScale, 'radiusScale');
    final spacingScale = _validScale(override.spacingScale, 'spacingScale');
    final textScale = _validScale(override.textScale, 'textScale');
    final hasPrimary = override.primaryColorValue != null;
    final hasFont = _trimOrNull(override.fontFamily) != null;
    final hasScales =
        radiusScale != null || spacingScale != null || textScale != null;

    if (!hasPrimary && !hasFont && !hasScales) return theme;

    final t = theme.tokens;
    final nextTokens = t.copyWith(
      colorPrimary: hasPrimary ? Color(override.primaryColorValue!) : null,
      //   fontFamily: hasFont ? override.fontFamily!.trim() : null,
      //   radiusSurface: radiusScale == null ? null : t.radiusSurface * radiusScale,
      //   radiusSurfaceXsm: radiusScale == null
      //       ? null
      //       : t.radiusSurfaceXsm * radiusScale,
      //   spaceScaffoldPadding: spacingScale == null
      //       ? null
      //       : t.spaceScaffoldPadding * spacingScale,
      //   spaceLayoutPadding: spacingScale == null
      //       ? null
      //       : t.spaceLayoutPadding * spacingScale,
      //   spaceLayoutGapLg: spacingScale == null
      //       ? null
      //       : t.spaceLayoutGapLg * spacingScale,
      //   spaceLayoutGapMd: spacingScale == null
      //       ? null
      //       : t.spaceLayoutGapMd * spacingScale,
      //   spaceLayoutGapSm: spacingScale == null
      //       ? null
      //       : t.spaceLayoutGapSm * spacingScale,
      //   textSizeHeader: textScale == null ? null : t.textSizeHeader * textScale,
      //   textSizeLabelLarge: textScale == null
      //       ? null
      //       : t.textSizeLabelLarge * textScale,
      //   textSizeLabel: textScale == null ? null : t.textSizeLabel * textScale,
      //   textSizeLabelSmall: textScale == null
      //       ? null
      //       : t.textSizeLabelSmall * textScale,
      //   textSizeBodyLarge: textScale == null
      //       ? null
      //       : t.textSizeBodyLarge * textScale,
      //   studyCardTextSizeFront: textScale == null
      //       ? null
      //       : t.studyCardTextSizeFront * textScale,
      //   studyCardTextSizeBack: textScale == null
      //       ? null
      //       : t.studyCardTextSizeBack * textScale,
      //   studyCardTextSizeBackContent: textScale == null
      //       ? null
      //       : t.studyCardTextSizeBackContent * textScale,
    );

    final brightness = switch (theme.brightness) {
      ThemeVariantBrightness.single => theme.themeData.brightness,
      ThemeVariantBrightness.light => Brightness.light,
      ThemeVariantBrightness.dark => Brightness.dark,
    };

    return ThemeVariant<AppTokens>(
      themePresetId: theme.themePresetId,
      brightness: theme.brightness,
      themeData: buildAppThemeData(nextTokens, brightness),
      tokens: nextTokens,
    );
  }

  static double? _validScale(double? value, String fieldName) {
    if (value == null) return null;
    if (value <= 0) {
      throw ArgumentError.value(value, fieldName, 'must be greater than zero');
    }
    return value;
  }

  static String? _trimOrNull(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
