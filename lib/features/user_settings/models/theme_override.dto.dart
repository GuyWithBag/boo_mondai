import 'package:dart_mappable/dart_mappable.dart';

part 'theme_override.dto.mapper.dart';

/// User-selected theme overrides layered on top of a preset theme.
@MappableClass()
class ThemeOverride with ThemeOverrideMappable {
  /// Creates a theme override payload.
  const ThemeOverride({
    this.primaryColorValue,
    this.fontFamily,
    this.radiusScale,
    this.spacingScale,
    this.textScale,
    this.highContrast,
    this.reducedMotion,
    this.extraTokens = const {},
  });

  /// Optional ARGB color value overriding `tokens.primary`.
  final int? primaryColorValue;

  /// Optional font family override.
  final String? fontFamily;

  /// Optional multiplier for radius-related tokens.
  final double? radiusScale;

  /// Optional multiplier for spacing-related tokens.
  final double? spacingScale;

  /// Optional multiplier for text-size related tokens.
  final double? textScale;

  /// Optional high-contrast preference.
  final bool? highContrast;

  /// Optional reduced-motion preference.
  final bool? reducedMotion;

  /// Forward-compatible token values unknown to the current app version.
  final Map<String, dynamic> extraTokens;
}
