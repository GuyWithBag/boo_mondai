import 'setting.dart';
import 'setting.path.dart';

/// Typed application-side definitions and defaults for all settings.
class SettingsRegistry {
  SettingsRegistry(this.settingsByPath);

  static final instance = SettingsRegistry(settings);

  static final settings = <SettingPath, Setting<dynamic>>{
    SettingPath.reviewRemindersEnabled: Setting<bool>(
      defaultValue: false,
      description: 'Daily reminder to review your due cards.',
    ),
    SettingPath.reviewReminderHour: Setting<int>(
      defaultValue: 9,
      description: 'When to send the daily review reminder.',
    ),
    SettingPath.reviewReminderMinute: Setting<int>(defaultValue: 0),
    SettingPath.streakRemindersEnabled: Setting<bool>(
      defaultValue: false,
      description: 'Evening nudge to keep your streak alive.',
    ),
    SettingPath.streakReminderHour: Setting<int>(
      defaultValue: 20,
      description: 'When to send the streak reminder.',
    ),
    SettingPath.streakReminderMinute: Setting<int>(defaultValue: 0),
    SettingPath.themeMode: Setting<String>(
      defaultValue: 'system',
      description: 'Use the system theme, light theme, or dark theme.',
    ),
    SettingPath.lightThemePresetId: Setting<String>(defaultValue: 'boomondai'),
    SettingPath.darkThemePresetId: Setting<String>(defaultValue: 'boomondai'),
    SettingPath.themeOverride: Setting<Map<String, dynamic>?>(
      defaultValue: null,
    ),
    SettingPath.customThemePresets: Setting<List<Map<String, dynamic>>>(
      defaultValue: [],
    ),
    SettingPath.syncDeletionRetentionDays: Setting<int>(defaultValue: 90),
    SettingPath.syncActiveClientWindowDays: Setting<int>(defaultValue: 90),
    SettingPath.studySessionCardStageUseCardAsContainer: Setting<bool>(
      defaultValue: true,
      description: 'Display study cards inside the physical card container.',
    ),
    SettingPath.uiSoundsEnabled: Setting<bool>(
      defaultValue: true,
      description: 'Play interaction sounds across the app.',
    ),
    SettingPath.buttonDownSoundEnabled: Setting<bool>(
      defaultValue: true,
      description: 'Play the sound when a button is pressed down.',
    ),
    SettingPath.buttonUpSoundEnabled: Setting<bool>(
      defaultValue: true,
      description: 'Play the sound when a button press is released.',
    ),
    SettingPath.studySessionSoundsEnabled: Setting<bool>(
      defaultValue: true,
      description: 'Play sounds during study and drill sessions.',
    ),
    SettingPath.disableOnlineFeatures: Setting<bool>(
      defaultValue: true,
      description: 'Disable features like deck listing, sync.',
    ),
  };

  final Map<SettingPath, Setting<dynamic>> settingsByPath;

  Setting<T> get<T>(SettingPath path) => settingsByPath[path]! as Setting<T>;

  SettingPath pathFor(Setting<dynamic> setting) => settingsByPath.entries
      .firstWhere((entry) => identical(entry.value, setting))
      .key;

  Map<String, dynamic> exportValues(Map<SettingPath, dynamic> values) => {
    for (final entry in values.entries) entry.key.value: entry.value,
  };

  Map<SettingPath, dynamic> importValues(Map<String, dynamic> values) => {
    for (final entry in settingsByPath.entries)
      entry.key: values.containsKey(entry.key.value)
          ? values[entry.key.value]
          : entry.value.defaultValue,
  };
}
