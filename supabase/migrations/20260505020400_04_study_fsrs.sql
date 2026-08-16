-- ══════════════════════════════════════════════════════
-- 6. LOCAL STUDY DATA (Review Cards & Logs)
-- ══════════════════════════════════════════════════════

CREATE TABLE study_cards (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  is_reversed bool NOT NULL DEFAULT false,
  deck_id     uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  deleted_at  timestamptz,
  purge_after timestamptz,
  UNIQUE (template_id, is_reversed)
);
ALTER TABLE study_cards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "study_cards: read access" ON study_cards FOR SELECT USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = study_cards.deck_id AND (d.visibility_state IN ('public', 'unlisted') OR d.profile_id = current_profile_id())));
CREATE POLICY "study_cards: owner manages" ON study_cards FOR ALL USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = study_cards.deck_id AND d.profile_id = current_profile_id()));
CREATE INDEX idx_study_cards_deleted_at ON study_cards(deleted_at);
CREATE INDEX idx_study_cards_purge_after ON study_cards(purge_after);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON study_cards FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime(updated_at);

CREATE TABLE user_study_cards_tags (
  profile_id     uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  study_cards_id uuid NOT NULL REFERENCES study_cards(id) ON DELETE CASCADE,
  tag_id         uuid NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  created_at     timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (profile_id, study_cards_id, tag_id)
);
ALTER TABLE user_study_cards_tags ENABLE ROW LEVEL SECURITY;
CREATE POLICY "user_study_cards_tags: private" ON user_study_cards_tags FOR ALL USING (profile_id = current_profile_id());

CREATE TABLE drill_sessions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id     uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  deck_id         uuid REFERENCES decks(id) ON DELETE SET NULL,
  session_type    text NOT NULL DEFAULT 'drill',
  previewed       bool NOT NULL DEFAULT false,
  total_questions int  NOT NULL DEFAULT 0,
  correct_count   int  NOT NULL DEFAULT 0,
  started_at      timestamptz NOT NULL DEFAULT now(),
  completed_at    timestamptz
);
ALTER TABLE drill_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "drill_sessions: owner manages" ON drill_sessions FOR ALL USING (profile_id = current_profile_id());

CREATE TABLE review_sessions (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id     uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  deck_id        uuid REFERENCES decks(id) ON DELETE SET NULL,
  session_type   text NOT NULL DEFAULT 'review',
  total_cards    int  NOT NULL DEFAULT 0,
  cards_reviewed int  NOT NULL DEFAULT 0,
  started_at     timestamptz NOT NULL DEFAULT now(),
  completed_at   timestamptz
);
ALTER TABLE review_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "review_sessions: owner manages" ON review_sessions FOR ALL USING (profile_id = current_profile_id());

CREATE TABLE drill_answers (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id  uuid         NOT NULL REFERENCES drill_sessions(id) ON DELETE CASCADE,
  card_id     uuid         NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  user_answer text         NOT NULL,
  type        study_rating NOT NULL,
  created_at  timestamptz  NOT NULL DEFAULT now()
);
ALTER TABLE drill_answers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "drill_answers: owner manages" ON drill_answers FOR ALL USING (EXISTS (SELECT 1 FROM drill_sessions ds WHERE ds.id = drill_answers.session_id AND ds.profile_id = current_profile_id()));

CREATE TABLE fsrs_cards (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id     uuid NOT NULL REFERENCES profiles(id)     ON DELETE CASCADE,
  study_cards_id uuid NOT NULL REFERENCES study_cards(id) ON DELETE CASCADE,
  state          jsonb NOT NULL DEFAULT '{}',
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now(),
  deleted_at     timestamptz,
  purge_after    timestamptz
);
ALTER TABLE fsrs_cards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "fsrs_cards: owner manages" ON fsrs_cards FOR ALL USING (profile_id = current_profile_id());
CREATE INDEX idx_fsrs_cards_deleted_at ON fsrs_cards(deleted_at);
CREATE INDEX idx_fsrs_cards_purge_after ON fsrs_cards(purge_after);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON fsrs_cards FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime(updated_at);

CREATE TABLE review_logs (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  fsrs_card_id uuid NOT NULL REFERENCES fsrs_cards(id) ON DELETE CASCADE,
  log          jsonb NOT NULL DEFAULT '{}',
  created_at   timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE review_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "review_logs: owner manages" ON review_logs FOR ALL USING (EXISTS (SELECT 1 FROM fsrs_cards fc WHERE fc.id = review_logs.fsrs_card_id AND fc.profile_id = current_profile_id()));

CREATE TABLE streaks (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id         uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  current_streak     int  NOT NULL DEFAULT 0,
  longest_streak     int  NOT NULL DEFAULT 0,
  last_activity_date date,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  deleted_at         timestamptz,
  purge_after        timestamptz
);
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "streaks: owner manages" ON streaks FOR ALL USING (profile_id = current_profile_id());
CREATE INDEX idx_streaks_deleted_at ON streaks(deleted_at);
CREATE INDEX idx_streaks_purge_after ON streaks(purge_after);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON streaks FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime(updated_at);

CREATE VIEW leaderboard_entries WITH (security_invoker = true) AS
SELECT
  p.id AS profile_id,
  jsonb_build_object(
    'id', p.id,
    'username', p.username,
    'avatar_url', p.avatar_url,
    'created_at', p.created_at
  ) AS user_profile,
  COALESCE(SUM(ds.correct_count), 0)::int AS drill_score,
  COALESCE(rc.review_count, 0)::int       AS review_count
FROM profiles p
LEFT JOIN drill_sessions ds ON ds.profile_id = p.id AND ds.completed_at IS NOT NULL
LEFT JOIN (
  SELECT fc.profile_id, COUNT(*)::int AS review_count
  FROM review_logs rl JOIN fsrs_cards fc ON fc.id = rl.fsrs_card_id GROUP BY fc.profile_id
) rc ON rc.profile_id = p.id
WHERE p.role = 'group_a_participant'
GROUP BY p.id, p.username, p.avatar_url, p.created_at, rc.review_count
ORDER BY drill_score DESC;



-- ── Sync clients & tombstone retention ─────────────────
CREATE TABLE sync_clients (
  id uuid NOT NULL,
  profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  device_name text,
  created_at timestamptz NOT NULL DEFAULT now(),
  last_seen_at timestamptz NOT NULL DEFAULT now(),
  last_synced_at timestamptz,
  PRIMARY KEY (id, profile_id)
);

ALTER TABLE sync_clients ENABLE ROW LEVEL SECURITY;

CREATE POLICY "sync_clients: owner select"
  ON sync_clients FOR SELECT
  USING (profile_id = current_profile_id());

CREATE POLICY "sync_clients: owner insert"
  ON sync_clients FOR INSERT
  WITH CHECK (profile_id = current_profile_id());

CREATE POLICY "sync_clients: owner update"
  ON sync_clients FOR UPDATE
  USING (profile_id = current_profile_id())
  WITH CHECK (profile_id = current_profile_id());

CREATE POLICY "sync_clients: owner delete"
  ON sync_clients FOR DELETE
  USING (profile_id = current_profile_id());

CREATE INDEX idx_sync_clients_profile_id ON sync_clients(profile_id);
CREATE INDEX idx_sync_clients_last_seen_at ON sync_clients(last_seen_at);
CREATE INDEX idx_sync_clients_last_synced_at ON sync_clients(last_synced_at);

CREATE OR REPLACE FUNCTION purge_sync_tombstones(
  active_client_window interval DEFAULT interval '90 days'
) RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  target_profile_id uuid;
  oldest_active_sync timestamptz;
BEGIN
  target_profile_id := current_profile_id();

  IF target_profile_id IS NULL THEN
    RAISE EXCEPTION 'purge_sync_tombstones requires an authenticated profile';
  END IF;

  SELECT min(last_synced_at)
    INTO oldest_active_sync
  FROM sync_clients
  WHERE sync_clients.profile_id = target_profile_id
    AND last_seen_at >= now() - active_client_window
    AND last_synced_at IS NOT NULL;

  DELETE FROM fsrs_cards
  WHERE profile_id = target_profile_id
    AND deleted_at IS NOT NULL
    AND purge_after IS NOT NULL
    AND purge_after <= now()
    AND (oldest_active_sync IS NULL OR deleted_at < oldest_active_sync);

  DELETE FROM study_cards sc
  USING decks d
  WHERE sc.deck_id = d.id
    AND d.profile_id = target_profile_id
    AND sc.deleted_at IS NOT NULL
    AND sc.purge_after IS NOT NULL
    AND sc.purge_after <= now()
    AND (oldest_active_sync IS NULL OR sc.deleted_at < oldest_active_sync);

  DELETE FROM card_templates ct
  USING decks d
  WHERE ct.deck_id = d.id
    AND d.profile_id = target_profile_id
    AND ct.deleted_at IS NOT NULL
    AND ct.purge_after IS NOT NULL
    AND ct.purge_after <= now()
    AND (oldest_active_sync IS NULL OR ct.deleted_at < oldest_active_sync);

  DELETE FROM deck_listings dl
  USING decks d
  WHERE dl.deck_id = d.id
    AND d.profile_id = target_profile_id
    AND dl.deleted_at IS NOT NULL
    AND dl.purge_after IS NOT NULL
    AND dl.purge_after <= now()
    AND (oldest_active_sync IS NULL OR dl.deleted_at < oldest_active_sync);

  DELETE FROM decks
  WHERE profile_id = target_profile_id
    AND deleted_at IS NOT NULL
    AND purge_after IS NOT NULL
    AND purge_after <= now()
    AND (oldest_active_sync IS NULL OR deleted_at < oldest_active_sync);

  DELETE FROM streaks
  WHERE profile_id = target_profile_id
    AND deleted_at IS NOT NULL
    AND purge_after IS NOT NULL
    AND purge_after <= now()
    AND (oldest_active_sync IS NULL OR deleted_at < oldest_active_sync);
END;
$$;
