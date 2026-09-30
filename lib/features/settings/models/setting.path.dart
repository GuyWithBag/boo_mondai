/// Stable, serialisable identifiers for application settings.
enum SettingPath {
  reviewRemindersEnabled('notifications/review/reminders_enabled'),
  reviewReminderHour('notifications/review/reminder_hour'),
  reviewReminderMinute('notifications/review/reminder_minute'),
  streakRemindersEnabled('notifications/streak/reminders_enabled'),
  streakReminderHour('notifications/streak/reminder_hour'),
  streakReminderMinute('notifications/streak/reminder_minute'),
  studyDeckNotificationsEnabled('notifications/study_deck/enabled'),
  themeMode('appearance/theme/mode'),
  lightThemePresetId('appearance/theme/light_preset_id'),
  darkThemePresetId('appearance/theme/dark_preset_id'),
  themeOverride('appearance/theme/override'),
  customThemePresets('appearance/theme/custom_presets'),
  syncDeletionRetentionDays('sync/deletion/retention_days'),
  syncActiveClientWindowDays('sync/deletion/active_client_window_days'),
  studySessionCardStageUseCardAsContainer(
    'study_session/card_stage/use_card_as_container',
  ),
  uiSoundsEnabled('media/ui_sounds/enabled'),
  buttonDownSoundEnabled('media/ui_sounds/button_down_enabled'),
  buttonUpSoundEnabled('media/ui_sounds/button_up_enabled'),
  studySessionSoundsEnabled('media/study_session/sounds_enabled'),
  disableOnlineFeatures('developer/disabled_online_features');

  const SettingPath(this.value);

  final String value;
  String get pagePath => value.split('/').first;
  String get section => value.split('/')[1];
  String get name => value.split('/').last;
}
