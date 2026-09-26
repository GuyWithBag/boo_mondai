ALTER TABLE user_settings
  ADD COLUMN review_reminders_enabled boolean NOT NULL DEFAULT false,
  ADD COLUMN review_reminder_hour integer NOT NULL DEFAULT 9,
  ADD COLUMN review_reminder_minute integer NOT NULL DEFAULT 0,
  ADD COLUMN streak_reminders_enabled boolean NOT NULL DEFAULT false,
  ADD COLUMN streak_reminder_hour integer NOT NULL DEFAULT 20,
  ADD COLUMN streak_reminder_minute integer NOT NULL DEFAULT 0,
  ADD COLUMN sync_deletion_retention_days integer NOT NULL DEFAULT 90,
  ADD COLUMN sync_active_client_window_days integer NOT NULL DEFAULT 90,
  ADD COLUMN study_session_card_stage_use_card_as_container boolean NOT NULL DEFAULT true,
  ADD COLUMN ui_sounds_enabled boolean NOT NULL DEFAULT true,
  ADD COLUMN button_down_sound_enabled boolean NOT NULL DEFAULT true,
  ADD COLUMN button_up_sound_enabled boolean NOT NULL DEFAULT true,
  ADD COLUMN study_session_sounds_enabled boolean NOT NULL DEFAULT true;
