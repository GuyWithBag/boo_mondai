import 'package:boo_mondai/lib.barrel.dart'
    show Setting, SettingTileEntry, SettingPath;
import 'package:flutter/material.dart';

abstract class SettingsService {
  static const defaultPagePath = 'notifications';

  static final Setting<bool> reviewRemindersEnabled = Setting<bool>(
    'notifications/review.reminders_enabled',
    false,
  );
  static final Setting<int> reviewReminderHour = Setting<int>(
    'notifications/review.reminder_hour',
    9,
  );
  static final Setting<int> reviewReminderMinute = Setting<int>(
    'notifications/review.reminder_minute',
    0,
  );

  static final Setting<bool> streakRemindersEnabled = Setting<bool>(
    'notifications/streak.reminders_enabled',
    false,
  );
  static final Setting<int> streakReminderHour = Setting<int>(
    'notifications/streak.reminder_hour',
    20,
  );
  static final Setting<int> streakReminderMinute = Setting<int>(
    'notifications/streak.reminder_minute',
    0,
  );

  static final Setting<String> themeMode = Setting<String>(
    'appearance/theme.mode',
    'system',
  );
  static final Setting<String> lightThemePresetId = Setting<String>(
    'appearance/theme.light_preset_id',
    'boomondai',
  );
  static final Setting<String> darkThemePresetId = Setting<String>(
    'appearance/theme.dark_preset_id',
    'boomondai',
  );

  /// Serialised [ThemeOverride] as `Map<String, dynamic>?`. Null = no override.
  static final Setting<Map<String, dynamic>?> themeOverride =
      Setting<Map<String, dynamic>?>('appearance/theme.override', null);

  /// Serialised list of [CustomThemePreset] maps.
  static final Setting<List<Map<String, dynamic>>> customThemePresets =
      Setting<List<Map<String, dynamic>>>(
        'appearance/theme.custom_presets',
        [],
      );

  // ---------------------------------------------------------------------------
  // Sync deletion
  // ---------------------------------------------------------------------------

  /// How many days soft-deleted synced rows remain recoverable after delete.
  /// `0` means purge as soon as sync safety allows.
  static final Setting<int> syncDeletionRetentionDays = Setting<int>(
    'sync/deletion.retention_days',
    90,
  );

  /// How long a sync client remains active for tombstone cleanup safety.
  static final Setting<int> syncActiveClientWindowDays = Setting<int>(
    'sync/deletion.active_client_window_days',
    90,
  );

  static final Setting<bool> studySessionCardStageUseCardAsContainer =
      Setting<bool>('study_session/card_stage.use_card_as_container', true);

  // ---------------------------------------------------------------------------
  // Media
  // ---------------------------------------------------------------------------

  static final Setting<bool> uiSoundsEnabled = Setting<bool>(
    'media/ui_sounds.enabled',
    true,
  );

  static final Setting<bool> buttonDownSoundEnabled = Setting<bool>(
    'media/button.down_sound_enabled',
    true,
  );

  static final Setting<bool> buttonUpSoundEnabled = Setting<bool>(
    'media/button.up_sound_enabled',
    true,
  );

  static final Setting<bool> studySessionSoundsEnabled = Setting<bool>(
    'media/study_session.sounds_enabled',
    true,
  );

  static final ui = <SettingTileEntry<dynamic>>[
    SettingTileEntry<bool>(
      setting: reviewRemindersEnabled,
      description: 'Daily reminder to review your due cards.',
    ),
    SettingTileEntry<int>(
      setting: reviewReminderHour,
      description: 'When to send the daily review reminder.',
      visibleWhen: (ctrl) => ctrl.get(reviewRemindersEnabled),
      builder: (context, ctrl, setting) => _TimeSettingTile(
        label: _timeLabelFromKey(setting.key),
        description: 'When to send the daily review reminder.',
        hour: ctrl.get(reviewReminderHour),
        minute: ctrl.get(reviewReminderMinute),
        onTimePicked: (picked) async {
          await ctrl.set(reviewReminderHour, picked.hour);
          await ctrl.set(reviewReminderMinute, picked.minute);
        },
      ),
    ),
    SettingTileEntry<bool>(
      setting: streakRemindersEnabled,
      description: 'Evening nudge to keep your streak alive.',
    ),
    SettingTileEntry<int>(
      setting: streakReminderHour,
      description: 'When to send the streak reminder.',
      visibleWhen: (ctrl) => ctrl.get(streakRemindersEnabled),
      builder: (context, ctrl, setting) => _TimeSettingTile(
        label: _timeLabelFromKey(setting.key),
        description: 'When to send the streak reminder.',
        hour: ctrl.get(streakReminderHour),
        minute: ctrl.get(streakReminderMinute),
        onTimePicked: (picked) async {
          await ctrl.set(streakReminderHour, picked.hour);
          await ctrl.set(streakReminderMinute, picked.minute);
        },
      ),
    ),
    SettingTileEntry<String>(
      setting: themeMode,
      description: 'Use the system theme, light theme, or dark theme.',
    ),
    SettingTileEntry<String>(
      setting: lightThemePresetId,
      description: 'Theme preset used when the app is in light mode.',
    ),
    SettingTileEntry<String>(
      setting: darkThemePresetId,
      description: 'Theme preset used when the app is in dark mode.',
    ),
    SettingTileEntry<int>(
      setting: syncDeletionRetentionDays,
      description: 'Days soft-deleted synced rows remain recoverable.',
    ),
    SettingTileEntry<int>(
      setting: syncActiveClientWindowDays,
      description: 'Days a sync client remains active for cleanup safety.',
    ),
    SettingTileEntry<bool>(
      setting: studySessionCardStageUseCardAsContainer,
      description: 'Display study cards inside the physical card container.',
    ),
    SettingTileEntry<bool>(
      setting: uiSoundsEnabled,
      description: 'Play interaction sounds across the app.',
    ),
    SettingTileEntry<bool>(
      setting: buttonDownSoundEnabled,
      description: 'Play the sound when a button is pressed down.',
      visibleWhen: (ctrl) => ctrl.get(uiSoundsEnabled),
    ),
    SettingTileEntry<bool>(
      setting: buttonUpSoundEnabled,
      description: 'Play the sound when a button press is released.',
      visibleWhen: (ctrl) => ctrl.get(uiSoundsEnabled),
    ),
    SettingTileEntry<bool>(
      setting: studySessionSoundsEnabled,
      description: 'Play sounds during study and drill sessions.',
      visibleWhen: (ctrl) => ctrl.get(uiSoundsEnabled),
    ),
  ];

  static List<String> get pagePaths {
    final paths = <String>{};
    for (final entry in ui) {
      final pagePath = entry.path.pagePath;
      if (pagePath.isNotEmpty) {
        paths.add(pagePath);
      }
    }
    return paths.toList()..sort();
  }

  static String pageUrl(String pagePath) {
    return '/settings/${Uri.encodeComponent(pagePath)}';
  }

  static List<SettingTileEntry<dynamic>> uiForPage(String pagePath) => [
    for (final entry in ui)
      if (entry.path.pagePath == pagePath) entry,
  ];
}

String _timeLabelFromKey(String key) {
  final section = SettingPath.parse(key).section;
  final words = '$section reminder time'.replaceAll('_', ' ');
  return words.isEmpty ? key : '${words[0].toUpperCase()}${words.substring(1)}';
}

class _TimeSettingTile extends StatelessWidget {
  const _TimeSettingTile({
    required this.label,
    required this.description,
    required this.hour,
    required this.minute,
    required this.onTimePicked,
  });

  final String label;
  final String description;
  final int hour;
  final int minute;
  final Future<void> Function(TimeOfDay picked) onTimePicked;

  String get _formatted {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );
    if (picked != null) await onTimePicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(description),
      trailing: TextButton(
        onPressed: () => _pick(context),
        child: Text(_formatted),
      ),
      onTap: () => _pick(context),
    );
  }
}
