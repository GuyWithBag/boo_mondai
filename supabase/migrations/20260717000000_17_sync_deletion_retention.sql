-- Sync deletion retention and active-client cleanup safety.

ALTER TABLE profiles ADD COLUMN IF NOT EXISTS purge_after timestamptz;
ALTER TABLE streaks ADD COLUMN IF NOT EXISTS purge_after timestamptz;
ALTER TABLE decks ADD COLUMN IF NOT EXISTS purge_after timestamptz;
ALTER TABLE deck_listings ADD COLUMN IF NOT EXISTS purge_after timestamptz;
ALTER TABLE card_templates ADD COLUMN IF NOT EXISTS purge_after timestamptz;
ALTER TABLE study_cards ADD COLUMN IF NOT EXISTS purge_after timestamptz;
ALTER TABLE fsrs_cards ADD COLUMN IF NOT EXISTS purge_after timestamptz;

CREATE INDEX IF NOT EXISTS idx_profiles_purge_after ON profiles(purge_after);
CREATE INDEX IF NOT EXISTS idx_streaks_purge_after ON streaks(purge_after);
CREATE INDEX IF NOT EXISTS idx_decks_purge_after ON decks(purge_after);
CREATE INDEX IF NOT EXISTS idx_deck_listings_purge_after ON deck_listings(purge_after);
CREATE INDEX IF NOT EXISTS idx_card_templates_purge_after ON card_templates(purge_after);
CREATE INDEX IF NOT EXISTS idx_study_cards_purge_after ON study_cards(purge_after);
CREATE INDEX IF NOT EXISTS idx_fsrs_cards_purge_after ON fsrs_cards(purge_after);

CREATE TABLE IF NOT EXISTS sync_clients (
  id uuid NOT NULL,
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  device_name text,
  created_at timestamptz NOT NULL DEFAULT now(),
  last_seen_at timestamptz NOT NULL DEFAULT now(),
  last_synced_at timestamptz,
  PRIMARY KEY (id, user_id)
);

ALTER TABLE sync_clients ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "sync_clients: owner select" ON sync_clients;
DROP POLICY IF EXISTS "sync_clients: owner insert" ON sync_clients;
DROP POLICY IF EXISTS "sync_clients: owner update" ON sync_clients;
DROP POLICY IF EXISTS "sync_clients: owner delete" ON sync_clients;

CREATE POLICY "sync_clients: owner select"
  ON sync_clients FOR SELECT
  USING (user_id = current_profile_id());

CREATE POLICY "sync_clients: owner insert"
  ON sync_clients FOR INSERT
  WITH CHECK (user_id = current_profile_id());

CREATE POLICY "sync_clients: owner update"
  ON sync_clients FOR UPDATE
  USING (user_id = current_profile_id())
  WITH CHECK (user_id = current_profile_id());

CREATE POLICY "sync_clients: owner delete"
  ON sync_clients FOR DELETE
  USING (user_id = current_profile_id());

CREATE INDEX IF NOT EXISTS idx_sync_clients_user_id ON sync_clients(user_id);
CREATE INDEX IF NOT EXISTS idx_sync_clients_last_seen_at ON sync_clients(last_seen_at);
CREATE INDEX IF NOT EXISTS idx_sync_clients_last_synced_at ON sync_clients(last_synced_at);

CREATE OR REPLACE FUNCTION purge_sync_tombstones(
  active_client_window interval DEFAULT interval '90 days'
) RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  profile_id uuid;
  oldest_active_sync timestamptz;
BEGIN
  profile_id := current_profile_id();

  IF profile_id IS NULL THEN
    RAISE EXCEPTION 'purge_sync_tombstones requires an authenticated profile';
  END IF;

  SELECT min(last_synced_at)
    INTO oldest_active_sync
  FROM sync_clients
  WHERE user_id = profile_id
    AND last_seen_at >= now() - active_client_window
    AND last_synced_at IS NOT NULL;

  DELETE FROM fsrs_cards
  WHERE user_id = profile_id
    AND deleted_at IS NOT NULL
    AND purge_after IS NOT NULL
    AND purge_after <= now()
    AND (oldest_active_sync IS NULL OR deleted_at < oldest_active_sync);

  DELETE FROM study_cards sc
  USING decks d
  WHERE sc.deck_id = d.id
    AND d.user_id = profile_id
    AND sc.deleted_at IS NOT NULL
    AND sc.purge_after IS NOT NULL
    AND sc.purge_after <= now()
    AND (oldest_active_sync IS NULL OR sc.deleted_at < oldest_active_sync);

  DELETE FROM card_templates ct
  USING decks d
  WHERE ct.deck_id = d.id
    AND d.user_id = profile_id
    AND ct.deleted_at IS NOT NULL
    AND ct.purge_after IS NOT NULL
    AND ct.purge_after <= now()
    AND (oldest_active_sync IS NULL OR ct.deleted_at < oldest_active_sync);

  DELETE FROM deck_listings dl
  USING decks d
  WHERE dl.deck_id = d.id
    AND d.user_id = profile_id
    AND dl.deleted_at IS NOT NULL
    AND dl.purge_after IS NOT NULL
    AND dl.purge_after <= now()
    AND (oldest_active_sync IS NULL OR dl.deleted_at < oldest_active_sync);

  DELETE FROM decks
  WHERE user_id = profile_id
    AND deleted_at IS NOT NULL
    AND purge_after IS NOT NULL
    AND purge_after <= now()
    AND (oldest_active_sync IS NULL OR deleted_at < oldest_active_sync);

  DELETE FROM streaks
  WHERE user_id = profile_id
    AND deleted_at IS NOT NULL
    AND purge_after IS NOT NULL
    AND purge_after <= now()
    AND (oldest_active_sync IS NULL OR deleted_at < oldest_active_sync);
END;
$$;
