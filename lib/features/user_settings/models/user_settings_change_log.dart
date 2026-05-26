/// Change categories emitted by user settings import/update operations.
enum UserSettingsChangeType { created, updated, skipped }

/// One user settings change entry for UI summaries and telemetry.
class UserSettingsChangeLog {
  /// Creates a user settings change log row.
  const UserSettingsChangeLog({
    required this.type,
    required this.entityType,
    required this.entityId,
    required this.message,
  });

  /// High-level result category.
  final UserSettingsChangeType type;

  /// Domain entity type, such as `user_settings` or `custom_theme_preset`.
  final String entityType;

  /// Identifier of the changed entity.
  final String entityId;

  /// Human-readable description of the applied change.
  final String message;
}

/// Export scope options for user settings payloads.
class UserSettingsExportOptions {
  /// Creates export options controlling payload sections.
  const UserSettingsExportOptions({
    this.includeSelections = true,
    this.includeThemeMode = true,
    this.includeOverrides = true,
    this.includeCustomPresets = true,
  });

  /// Include selected light/dark preset ids.
  final bool includeSelections;

  /// Include selected theme mode.
  final bool includeThemeMode;

  /// Include user override payload.
  final bool includeOverrides;

  /// Include custom preset list.
  final bool includeCustomPresets;
}

/// Import policy for decoded or raw JSON settings payloads.
enum UserSettingsImportMode { replaceCurrent, mergeCurrent }

/// Generic operation result with value and per-operation logs/failures.
class UserSettingsOperationResult<T> {
  /// Creates an operation result.
  const UserSettingsOperationResult({
    required this.value,
    this.changeLogs = const [],
    this.failures = const [],
  });

  /// Returned value.
  final T value;

  /// Human-readable change logs.
  final List<UserSettingsChangeLog> changeLogs;

  /// Non-fatal failures encountered while applying the operation.
  final List<String> failures;
}
