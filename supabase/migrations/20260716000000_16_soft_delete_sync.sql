ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS deleted_at timestamptz;

ALTER TABLE streaks
  ADD COLUMN IF NOT EXISTS deleted_at timestamptz;

ALTER TABLE decks
  ADD COLUMN IF NOT EXISTS deleted_at timestamptz;

ALTER TABLE deck_listings
  ADD COLUMN IF NOT EXISTS deleted_at timestamptz;

ALTER TABLE card_templates
  ADD COLUMN IF NOT EXISTS deleted_at timestamptz;

ALTER TABLE study_cards
  ADD COLUMN IF NOT EXISTS deleted_at timestamptz;

ALTER TABLE fsrs_cards
  ADD COLUMN IF NOT EXISTS deleted_at timestamptz;

CREATE INDEX IF NOT EXISTS idx_profiles_deleted_at ON profiles(deleted_at);
CREATE INDEX IF NOT EXISTS idx_streaks_deleted_at ON streaks(deleted_at);
CREATE INDEX IF NOT EXISTS idx_decks_deleted_at ON decks(deleted_at);
CREATE INDEX IF NOT EXISTS idx_deck_listings_deleted_at ON deck_listings(deleted_at);
CREATE INDEX IF NOT EXISTS idx_card_templates_deleted_at ON card_templates(deleted_at);
CREATE INDEX IF NOT EXISTS idx_study_cards_deleted_at ON study_cards(deleted_at);
CREATE INDEX IF NOT EXISTS idx_fsrs_cards_deleted_at ON fsrs_cards(deleted_at);
