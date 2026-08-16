-- User settings (local-first with optional remote sync)
-- One row per profile.

CREATE TABLE user_settings (
  id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id            uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  theme_mode_name       text NOT NULL DEFAULT 'system' CHECK (theme_mode_name IN ('system', 'light', 'dark')),
  light_theme_preset_id text NOT NULL DEFAULT 'boomondai',
  dark_theme_preset_id  text NOT NULL DEFAULT 'boomondai',
  theme_override        jsonb,
  custom_theme_presets  jsonb NOT NULL DEFAULT '[]'::jsonb,
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_settings: read own"
  ON user_settings FOR SELECT
  USING (profile_id = current_profile_id());

CREATE POLICY "user_settings: insert own"
  ON user_settings FOR INSERT
  WITH CHECK (profile_id = current_profile_id());

CREATE POLICY "user_settings: update own"
  ON user_settings FOR UPDATE
  USING (profile_id = current_profile_id())
  WITH CHECK (profile_id = current_profile_id());

CREATE POLICY "user_settings: delete own"
  ON user_settings FOR DELETE
  USING (profile_id = current_profile_id());

CREATE INDEX idx_user_settings_profile_id ON user_settings (profile_id);
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON user_settings
  FOR EACH ROW
  EXECUTE FUNCTION extensions.moddatetime(updated_at);
