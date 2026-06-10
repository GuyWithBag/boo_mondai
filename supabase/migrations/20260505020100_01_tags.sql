-- ══════════════════════════════════════════════════════
-- 3. TAGS DICTIONARY
-- ══════════════════════════════════════════════════════

CREATE TABLE tags (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid REFERENCES profiles(id) ON DELETE CASCADE,
  name        text NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT tags_user_name_unique UNIQUE NULLS NOT DISTINCT (user_id, name)
);

ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
CREATE POLICY "tags: read own or global" ON tags FOR SELECT USING (user_id = current_profile_id() OR user_id IS NULL);
CREATE POLICY "tags: insert own" ON tags FOR INSERT WITH CHECK (user_id = current_profile_id());
CREATE POLICY "tags: update own" ON tags FOR UPDATE USING (user_id = current_profile_id()) WITH CHECK (user_id = current_profile_id());
CREATE POLICY "tags: delete own" ON tags FOR DELETE USING (user_id = current_profile_id());
CREATE INDEX ON tags (user_id);
CREATE INDEX ON tags (name);

