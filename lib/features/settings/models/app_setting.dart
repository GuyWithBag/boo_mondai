/// Typed key for a single user preference stored in [UserSettings.preferences].
///
/// All keys use `/` as a namespace separator for grep-friendliness.
/// Add new settings here as a single line — no model changes required.
class AppSetting<T> {
  const AppSetting._(this.key, this.defaultValue);

  /// Namespaced storage key, e.g. `'review/reminders_enabled'`.
  final String key;

  /// Value used when the key is absent from [UserSettings.preferences].
  final T defaultValue;

  // ---------------------------------------------------------------------------
  // Review reminders
  // ---------------------------------------------------------------------------

  static const reviewRemindersEnabled = AppSetting<bool>._(
    'review/reminders_enabled',
    false,
  );
  static const reviewReminderHour = AppSetting<int>._(
    'review/reminder_hour',
    9,
  );
  static const reviewReminderMinute = AppSetting<int>._(
    'review/reminder_minute',
    0,
  );

  // ---------------------------------------------------------------------------
  // Streak reminders
  // ---------------------------------------------------------------------------

  static const streakRemindersEnabled = AppSetting<bool>._(
    'streak/reminders_enabled',
    false,
  );
  static const streakReminderHour = AppSetting<int>._(
    'streak/reminder_hour',
    20,
  );
  static const streakReminderMinute = AppSetting<int>._(
    'streak/reminder_minute',
    0,
  );

  // ---------------------------------------------------------------------------
  // Theme — stored as primitives; read by UserSettingsThemeBridge
  // ---------------------------------------------------------------------------

  /// One of `'system'`, `'light'`, `'dark'`.
  static const themeMode = AppSetting<String>._('theme/mode', 'system');
  static const lightThemePresetId = AppSetting<String>._(
    'theme/light_preset_id',
    'boomondai',
  );
  static const darkThemePresetId = AppSetting<String>._(
    'theme/dark_preset_id',
    'boomondai',
  );

  /// Serialised [ThemeOverride] as `Map<String, dynamic>?`. Null = no override.
  static const themeOverride = AppSetting<Map<String, dynamic>?>._(
    'theme/override',
    null,
  );

  /// Serialised list of [CustomThemePreset] maps.
  static const customThemePresets = AppSetting<List<Map<String, dynamic>>>._(
    'theme/custom_presets',
    [],
  );
}
