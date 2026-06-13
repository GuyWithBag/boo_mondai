create extension if not exists moddatetime schema extensions;

-- ══════════════════════════════════════════════════════
-- 4. DECKS & LISTINGS (STOREFRONT)
-- ══════════════════════════════════════════════════════

CREATE TABLE decks (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title             text NOT NULL,
  short_description text NOT NULL DEFAULT '',
  long_description  text NOT NULL DEFAULT '',
  cover_image_url   text,
  is_premade        bool NOT NULL DEFAULT false,
  visibility_state  visibility_state NOT NULL DEFAULT 'private',
  is_published      bool NOT NULL DEFAULT false,
  is_editable       bool NOT NULL DEFAULT true,
  card_count        int  NOT NULL DEFAULT 0,
  version           text NOT NULL DEFAULT '1.0.0',
  build_number      int  NOT NULL DEFAULT 1,

  -- Provenance & Styling
  source_deck_id    uuid REFERENCES decks(id) ON DELETE SET NULL,
  design_config     jsonb,

  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE decks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "decks: read access" ON decks FOR SELECT USING (visibility_state IN ('public', 'unlisted') OR user_id = current_profile_id());
CREATE POLICY "decks: owner insert" ON decks FOR INSERT WITH CHECK (user_id = current_profile_id());
CREATE POLICY "decks: owner update" ON decks FOR UPDATE USING (user_id = current_profile_id()) WITH CHECK (user_id = current_profile_id());
CREATE POLICY "decks: owner delete" ON decks FOR DELETE USING (user_id = current_profile_id());
CREATE INDEX ON decks (user_id);
CREATE INDEX ON decks (visibility_state);
CREATE INDEX ON decks (source_deck_id);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON decks FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

-- ── DECK LISTINGS (The Storefront Metadata) ───────────
CREATE TABLE deck_listings (
  deck_id          uuid PRIMARY KEY REFERENCES decks(id) ON DELETE CASCADE,
  upvotes_count    int NOT NULL DEFAULT 0,
  downvotes_count  int NOT NULL DEFAULT 0,
  downloads_count  int NOT NULL DEFAULT 0,
  favorites_count  int NOT NULL DEFAULT 0,
  forks_count      int NOT NULL DEFAULT 0,
  comments_count   int NOT NULL DEFAULT 0,
  reviews_count    int NOT NULL DEFAULT 0,
  reports_count    int NOT NULL DEFAULT 0,
  featured_cards   jsonb NOT NULL DEFAULT '[]',
  featured_images  text[] NOT NULL DEFAULT '{}',
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE deck_listings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_listings: read all" ON deck_listings FOR SELECT USING (true);
CREATE POLICY "deck_listings: owner insert" ON deck_listings FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM decks WHERE id = deck_listings.deck_id AND user_id = current_profile_id()));
CREATE POLICY "deck_listings: owner update" ON deck_listings FOR UPDATE
  USING (EXISTS (SELECT 1 FROM decks WHERE id = deck_listings.deck_id AND user_id = current_profile_id()));

CREATE INDEX idx_listings_upvotes ON deck_listings(upvotes_count DESC);
CREATE INDEX idx_listings_downloads ON deck_listings(downloads_count DESC);

-- ── deck_tags ─────────────────────────────────────────
CREATE TABLE deck_tags (
  deck_id uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  tag_id  uuid NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (deck_id, tag_id)
);
ALTER TABLE deck_tags ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_tags: read access" ON deck_tags FOR SELECT USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = deck_tags.deck_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "deck_tags: owner manages" ON deck_tags FOR ALL USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = deck_tags.deck_id AND d.user_id = current_profile_id())) WITH CHECK (EXISTS (SELECT 1 FROM decks d WHERE d.id = deck_tags.deck_id AND d.user_id = current_profile_id()));
CREATE INDEX ON deck_tags (tag_id);
