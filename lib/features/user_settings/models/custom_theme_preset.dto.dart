import 'package:dart_mappable/dart_mappable.dart';

part 'custom_theme_preset.dto.mapper.dart';

/// User-defined or imported custom light/dark theme preset.
@MappableClass()
class CustomThemePreset with CustomThemePresetMappable {
  /// Creates a custom theme preset.
  const CustomThemePreset({
    required this.id,
    required this.name,
    required this.lightTokens,
    required this.darkTokens,
    this.source = 'imported',
    this.schemaVersion = 1,
    this.extraTokens = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  /// Stable preset id used for selection.
  final String id;

  /// Display name for selection lists.
  final String name;

  /// Serializable light token payload.
  final Map<String, dynamic> lightTokens;

  /// Serializable dark token payload.
  final Map<String, dynamic> darkTokens;

  /// Preset origin such as `imported`, `created`, or `synced`.
  final String source;

  /// Version of the token schema used by this payload.
  final int schemaVersion;

  /// Forward-compatible token fields unknown to the current app version.
  final Map<String, dynamic> extraTokens;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Last update timestamp.
  final DateTime updatedAt;
}
