-- ══════════════════════════════════════════════════════
-- 3. TAGS DICTIONARY
-- ══════════════════════════════════════════════════════

CREATE TABLE tags (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  name        text NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT tags_profile_name_unique UNIQUE NULLS NOT DISTINCT (profile_id, name)
);

ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
CREATE POLICY "tags: read own or global" ON tags FOR SELECT USING (profile_id = current_profile_id() OR profile_id IS NULL);
CREATE POLICY "tags: insert own" ON tags FOR INSERT WITH CHECK (profile_id = current_profile_id());
CREATE POLICY "tags: update own" ON tags FOR UPDATE USING (profile_id = current_profile_id()) WITH CHECK (profile_id = current_profile_id());
CREATE POLICY "tags: delete own" ON tags FOR DELETE USING (profile_id = current_profile_id());
CREATE INDEX ON tags (profile_id);
CREATE INDEX ON tags (name);

