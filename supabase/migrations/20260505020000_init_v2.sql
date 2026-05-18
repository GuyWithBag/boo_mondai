-- ══════════════════════════════════════════════════════
-- BooMondai — Schema V2 (Ultimate Edition)
-- Includes: Core Schema, FSRS, Research Tables,
-- Design Tokens, and the "Storefront" (Deck Listings)
-- ══════════════════════════════════════════════════════

-- ── Extensions ────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS moddatetime SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ══════════════════════════════════════════════════════
-- 1. ENUMS
-- ══════════════════════════════════════════════════════

CREATE TYPE study_rating AS ENUM ('incorrect', 'again', 'hard', 'good', 'easy');
CREATE TYPE card_type AS ENUM ('normal', 'reversed', 'both');
CREATE TYPE visibility_state AS ENUM ('public', 'private', 'unlisted');

-- ══════════════════════════════════════════════════════
-- 2. CORE TABLES & PROFILES
-- ══════════════════════════════════════════════════════

CREATE TABLE profiles (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  username      text NOT NULL,
  role          text,
  avatar_url    text,
  is_anonymous  bool NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT profiles_role_check
    CHECK (role IN ('group_a_participant', 'group_b_participant', 'researcher') OR role IS NULL)
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "profiles: insert own" ON profiles FOR INSERT TO authenticated WITH CHECK ((select auth.uid()) = user_id);
CREATE POLICY "profiles: read all" ON profiles FOR SELECT USING (true);
CREATE POLICY "profiles: update own" ON profiles FOR UPDATE USING ((select auth.uid()) = user_id) WITH CHECK ((select auth.uid()) = user_id);

-- Helper: resolve auth.uid() → profiles.id
CREATE OR REPLACE FUNCTION current_profile_id() RETURNS uuid LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT id FROM profiles WHERE user_id = (select auth.uid()) LIMIT 1
$$;

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

-- ══════════════════════════════════════════════════════
-- 5. CARD TEMPLATES & TYPES
-- ══════════════════════════════════════════════════════

CREATE TABLE card_templates (
  id                   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  deck_id              uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  type                 text NOT NULL CHECK (type IN ('flashcard', 'identification', 'multiple_choice', 'fill_in_the_blanks', 'word_scramble', 'match_madness')),
  sort_order           int  NOT NULL DEFAULT 0,

  -- Provenance & Styling
  source_template_id   uuid REFERENCES card_templates(id) ON DELETE SET NULL,
  design_config        jsonb,

  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),

  front_text           text,
  back_text            text,
  front_image_url      text,
  back_image_url       text,
  front_audio_url      text,
  back_audio_url       text,
  card_type            card_type,
  prompt_text          text,
  accepted_answers     text,
  question_prompt      text,
  sentence_to_scramble text,
  image_url            text,
  audio_url            text
);
ALTER TABLE card_templates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "card_templates: read access" ON card_templates FOR SELECT USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = card_templates.deck_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "card_templates: owner insert" ON card_templates FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM decks d WHERE d.id = card_templates.deck_id AND d.user_id = current_profile_id()));
CREATE POLICY "card_templates: owner update" ON card_templates FOR UPDATE USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = card_templates.deck_id AND d.user_id = current_profile_id())) WITH CHECK (EXISTS (SELECT 1 FROM decks d WHERE d.id = card_templates.deck_id AND d.user_id = current_profile_id()));
CREATE POLICY "card_templates: owner delete" ON card_templates FOR DELETE USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = card_templates.deck_id AND d.user_id = current_profile_id()));
CREATE INDEX ON card_templates (deck_id);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON card_templates FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

-- ── card_template_tags ────────────────────────────────
CREATE TABLE card_template_tags (
  template_id uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  tag_id      uuid NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  created_at  timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (template_id, tag_id)
);
ALTER TABLE card_template_tags ENABLE ROW LEVEL SECURITY;
CREATE POLICY "card_template_tags: read access" ON card_template_tags FOR SELECT USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = card_template_tags.template_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "card_template_tags: owner manages" ON card_template_tags FOR ALL USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = card_template_tags.template_id AND d.user_id = current_profile_id())) WITH CHECK (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = card_template_tags.template_id AND d.user_id = current_profile_id()));

-- ── template specifics (MCQ, FITB, Match Madness) ─────
CREATE TABLE multiple_choice_options (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id   uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  option_text   text NOT NULL,
  is_correct    bool NOT NULL DEFAULT false,
  display_order int  NOT NULL DEFAULT 0
);
ALTER TABLE multiple_choice_options ENABLE ROW LEVEL SECURITY;
CREATE POLICY "multiple_choice_options: read access" ON multiple_choice_options FOR SELECT USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = multiple_choice_options.template_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "multiple_choice_options: owner manages" ON multiple_choice_options FOR ALL USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = multiple_choice_options.template_id AND d.user_id = current_profile_id()));

CREATE TABLE fill_in_the_blank_segments (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  card_id        uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  full_text      text NOT NULL,
  blank_start    int  NOT NULL,
  blank_end      int  NOT NULL,
  correct_answer text NOT NULL,
  CONSTRAINT fitb_blank_order CHECK (blank_start < blank_end)
);
ALTER TABLE fill_in_the_blank_segments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "fitb_segments: read access" ON fill_in_the_blank_segments FOR SELECT USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = fill_in_the_blank_segments.card_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "fitb_segments: owner manages" ON fill_in_the_blank_segments FOR ALL USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = fill_in_the_blank_segments.card_id AND d.user_id = current_profile_id()));

CREATE TABLE match_madness_pairs (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id        uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  source_template_id uuid REFERENCES card_templates(id) ON DELETE SET NULL,
  term               text NOT NULL,
  match              text NOT NULL,
  is_auto_picked     bool NOT NULL DEFAULT false,
  display_order      int  NOT NULL DEFAULT 0
);
ALTER TABLE match_madness_pairs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "match_madness: read access" ON match_madness_pairs FOR SELECT USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = match_madness_pairs.template_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "match_madness: owner manages" ON match_madness_pairs FOR ALL USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = match_madness_pairs.template_id AND d.user_id = current_profile_id()));

-- ══════════════════════════════════════════════════════
-- 6. LOCAL STUDY DATA (Review Cards & Logs)
-- ══════════════════════════════════════════════════════

CREATE TABLE review_cards (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  is_reversed bool NOT NULL DEFAULT false,
  deck_id     uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  UNIQUE (template_id, is_reversed)
);
ALTER TABLE review_cards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "review_cards: read access" ON review_cards FOR SELECT USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = review_cards.deck_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "review_cards: owner manages" ON review_cards FOR ALL USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = review_cards.deck_id AND d.user_id = current_profile_id()));

CREATE TABLE user_review_card_tags (
  user_id        uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  review_card_id uuid NOT NULL REFERENCES review_cards(id) ON DELETE CASCADE,
  tag_id         uuid NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  created_at     timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, review_card_id, tag_id)
);
ALTER TABLE user_review_card_tags ENABLE ROW LEVEL SECURITY;
CREATE POLICY "user_review_card_tags: private" ON user_review_card_tags FOR ALL USING (user_id = current_profile_id());

CREATE TABLE drill_sessions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  deck_id         uuid REFERENCES decks(id) ON DELETE SET NULL,
  session_type    text NOT NULL DEFAULT 'drill',
  previewed       bool NOT NULL DEFAULT false,
  total_questions int  NOT NULL DEFAULT 0,
  correct_count   int  NOT NULL DEFAULT 0,
  started_at      timestamptz NOT NULL DEFAULT now(),
  completed_at    timestamptz
);
ALTER TABLE drill_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "drill_sessions: owner manages" ON drill_sessions FOR ALL USING (user_id = current_profile_id());

CREATE TABLE review_sessions (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  deck_id        uuid REFERENCES decks(id) ON DELETE SET NULL,
  session_type   text NOT NULL DEFAULT 'review',
  total_cards    int  NOT NULL DEFAULT 0,
  cards_reviewed int  NOT NULL DEFAULT 0,
  started_at     timestamptz NOT NULL DEFAULT now(),
  completed_at   timestamptz
);
ALTER TABLE review_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "review_sessions: owner manages" ON review_sessions FOR ALL USING (user_id = current_profile_id());

CREATE TABLE drill_answers (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id  uuid         NOT NULL REFERENCES drill_sessions(id) ON DELETE CASCADE,
  card_id     uuid         NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  user_answer text         NOT NULL,
  type        study_rating NOT NULL,
  created_at  timestamptz  NOT NULL DEFAULT now()
);
ALTER TABLE drill_answers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "drill_answers: owner manages" ON drill_answers FOR ALL USING (EXISTS (SELECT 1 FROM drill_sessions ds WHERE ds.id = drill_answers.session_id AND ds.user_id = current_profile_id()));

CREATE TABLE fsrs_cards (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        uuid NOT NULL REFERENCES profiles(id)     ON DELETE CASCADE,
  review_card_id uuid NOT NULL REFERENCES review_cards(id) ON DELETE CASCADE,
  state          jsonb NOT NULL DEFAULT '{}',
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE fsrs_cards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "fsrs_cards: owner manages" ON fsrs_cards FOR ALL USING (user_id = current_profile_id());
CREATE TRIGGER set_updated_at BEFORE UPDATE ON fsrs_cards FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

CREATE TABLE review_logs (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  fsrs_card_id uuid NOT NULL REFERENCES fsrs_cards(id) ON DELETE CASCADE,
  log          jsonb NOT NULL DEFAULT '{}',
  created_at   timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE review_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "review_logs: owner manages" ON review_logs FOR ALL USING (EXISTS (SELECT 1 FROM fsrs_cards fc WHERE fc.id = review_logs.fsrs_card_id AND fc.user_id = current_profile_id()));

CREATE TABLE streaks (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id            uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  current_streak     int  NOT NULL DEFAULT 0,
  longest_streak     int  NOT NULL DEFAULT 0,
  last_activity_date date,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "streaks: owner manages" ON streaks FOR ALL USING (user_id = current_profile_id());
CREATE TRIGGER set_updated_at BEFORE UPDATE ON streaks FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

CREATE VIEW leaderboard_entries WITH (security_invoker = true) AS
SELECT
  p.user_id,
  COALESCE(SUM(ds.correct_count), 0)::int AS drill_score,
  COALESCE(rc.review_count, 0)::int       AS review_count
FROM profiles p
LEFT JOIN drill_sessions ds ON ds.user_id = p.id AND ds.completed_at IS NOT NULL
LEFT JOIN (
  SELECT fc.user_id, COUNT(*)::int AS review_count
  FROM review_logs rl JOIN fsrs_cards fc ON fc.id = rl.fsrs_card_id GROUP BY fc.user_id
) rc ON rc.user_id = p.user_id
WHERE p.role = 'group_a_participant'
GROUP BY p.user_id, rc.review_count
ORDER BY drill_score DESC;

-- ══════════════════════════════════════════════════════
-- 7. RESEARCH TABLES
-- ══════════════════════════════════════════════════════

CREATE TABLE research_profiles (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  first_name text NOT NULL DEFAULT '',
  last_name  text NOT NULL DEFAULT '',
  age        int  NOT NULL DEFAULT 0,
  role       text NOT NULL CHECK (role IN ('group_a_participant', 'group_b_participant')),
  goal       text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_profiles: select access" ON research_profiles FOR SELECT TO authenticated USING (user_id = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));
CREATE POLICY "research_profiles: researcher manage" ON research_profiles FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

CREATE TABLE research_codes (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code        text NOT NULL UNIQUE,
  target_role text NOT NULL,
  unlocks     text NOT NULL,
  created_by  uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  used_by     uuid REFERENCES profiles(id),
  used_at     timestamptz,
  created_at  timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_codes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_codes: select access" ON research_codes FOR SELECT TO authenticated USING (used_by = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));
CREATE POLICY "research_codes: researcher manage" ON research_codes FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

CREATE TABLE survey_responses (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  survey_type    text NOT NULL,
  time_point     text,
  responses      jsonb NOT NULL DEFAULT '{}',
  computed_score double precision,
  submitted_at   timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, survey_type, time_point)
);
ALTER TABLE survey_responses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "survey_responses: insert own" ON survey_responses FOR INSERT WITH CHECK (user_id = current_profile_id());
CREATE POLICY "survey_responses: read own or researcher" ON survey_responses FOR SELECT USING (user_id = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

CREATE TABLE vocabulary_test_results (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  test_set     text NOT NULL CHECK (test_set IN ('A', 'B')),
  score        int  NOT NULL CHECK (score BETWEEN 0 AND 30),
  answers      jsonb NOT NULL,
  submitted_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, test_set)
);
ALTER TABLE vocabulary_test_results ENABLE ROW LEVEL SECURITY;
CREATE POLICY "vocabulary_test_results: insert own" ON vocabulary_test_results FOR INSERT WITH CHECK (user_id = current_profile_id());
CREATE POLICY "vocabulary_test_results: read own or researcher" ON vocabulary_test_results FOR SELECT USING (user_id = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

-- ══════════════════════════════════════════════════════
-- 8. TRACKING & SOCIAL TABLES
-- ══════════════════════════════════════════════════════

CREATE TABLE deck_votes (
  deck_id    uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  user_id    uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  vote_value int  NOT NULL CHECK (vote_value IN (1, -1)),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (deck_id, user_id)
);
ALTER TABLE deck_votes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_votes: read all" ON deck_votes FOR SELECT USING (true);
CREATE POLICY "deck_votes: manage own" ON deck_votes FOR ALL USING (user_id = current_profile_id()) WITH CHECK (user_id = current_profile_id());
CREATE INDEX ON deck_votes (user_id);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON deck_votes FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

CREATE TABLE deck_vote_events (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  deck_id        uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  user_id        uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  old_vote_value int CHECK (old_vote_value IN (1, -1)),
  new_vote_value int CHECK (new_vote_value IN (1, -1)),
  changed_at     timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT deck_vote_events_changed CHECK (old_vote_value IS DISTINCT FROM new_vote_value)
);
ALTER TABLE deck_vote_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_vote_events: read own or researcher" ON deck_vote_events FOR SELECT
  USING (user_id = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));
CREATE INDEX ON deck_vote_events (user_id, changed_at DESC);
CREATE INDEX ON deck_vote_events (deck_id, changed_at DESC);

CREATE TABLE deck_vote_reviews (
  id                     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  deck_id                uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  user_id                uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  vote_value_at_creation int NOT NULL CHECK (vote_value_at_creation IN (1, -1)),
  title                  text NOT NULL DEFAULT '',
  body                   text NOT NULL,
  is_deleted             bool NOT NULL DEFAULT false,
  created_at             timestamptz NOT NULL DEFAULT now(),
  updated_at             timestamptz NOT NULL DEFAULT now(),
  UNIQUE (deck_id, user_id)
);
ALTER TABLE deck_vote_reviews ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_vote_reviews: read visible" ON deck_vote_reviews FOR SELECT
  USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = deck_vote_reviews.deck_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "deck_vote_reviews: insert own vote review" ON deck_vote_reviews FOR INSERT
  WITH CHECK (user_id = current_profile_id() AND EXISTS (SELECT 1 FROM deck_votes dv WHERE dv.deck_id = deck_vote_reviews.deck_id AND dv.user_id = current_profile_id()));
CREATE POLICY "deck_vote_reviews: update own" ON deck_vote_reviews FOR UPDATE
  USING (user_id = current_profile_id())
  WITH CHECK (user_id = current_profile_id());
CREATE INDEX ON deck_vote_reviews (deck_id, created_at DESC) WHERE is_deleted = false;
CREATE INDEX ON deck_vote_reviews (user_id, created_at DESC);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON deck_vote_reviews FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

CREATE TABLE deck_vote_review_edit_logs (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  review_id   uuid NOT NULL REFERENCES deck_vote_reviews(id) ON DELETE CASCADE,
  edited_by   uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  old_title   text NOT NULL,
  new_title   text NOT NULL,
  old_body    text NOT NULL,
  new_body    text NOT NULL,
  edited_at   timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE deck_vote_review_edit_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_vote_review_edit_logs: read visible" ON deck_vote_review_edit_logs FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM deck_vote_reviews r
    JOIN decks d ON d.id = r.deck_id
    WHERE r.id = deck_vote_review_edit_logs.review_id
      AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())
  ));
CREATE INDEX ON deck_vote_review_edit_logs (review_id, edited_at DESC);

CREATE TABLE deck_comments (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  deck_id           uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  user_id           uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  parent_comment_id uuid,
  body              text NOT NULL,
  is_deleted        bool NOT NULL DEFAULT false,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  UNIQUE (id, deck_id),
  CONSTRAINT deck_comments_parent_fk
    FOREIGN KEY (parent_comment_id, deck_id)
    REFERENCES deck_comments(id, deck_id)
    ON DELETE CASCADE
);
ALTER TABLE deck_comments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_comments: read visible" ON deck_comments FOR SELECT
  USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = deck_comments.deck_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "deck_comments: insert own" ON deck_comments FOR INSERT
  WITH CHECK (user_id = current_profile_id() AND EXISTS (SELECT 1 FROM decks d WHERE d.id = deck_comments.deck_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "deck_comments: update own" ON deck_comments FOR UPDATE
  USING (user_id = current_profile_id())
  WITH CHECK (user_id = current_profile_id());
CREATE INDEX ON deck_comments (deck_id, created_at DESC) WHERE parent_comment_id IS NULL;
CREATE INDEX ON deck_comments (parent_comment_id, created_at);
CREATE INDEX ON deck_comments (user_id, created_at DESC);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON deck_comments FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

CREATE TABLE deck_comment_edit_logs (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  comment_id  uuid NOT NULL REFERENCES deck_comments(id) ON DELETE CASCADE,
  edited_by   uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  old_body    text NOT NULL,
  new_body    text NOT NULL,
  edited_at   timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE deck_comment_edit_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_comment_edit_logs: read visible" ON deck_comment_edit_logs FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM deck_comments c
    JOIN decks d ON d.id = c.deck_id
    WHERE c.id = deck_comment_edit_logs.comment_id
      AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())
  ));
CREATE INDEX ON deck_comment_edit_logs (comment_id, edited_at DESC);

CREATE TABLE deck_downloads (
  deck_id    uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  user_id    uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (deck_id, user_id)
);
ALTER TABLE deck_downloads ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_downloads: insert own" ON deck_downloads FOR INSERT WITH CHECK (user_id = current_profile_id());
CREATE POLICY "deck_downloads: read own" ON deck_downloads FOR SELECT USING (user_id = current_profile_id());

CREATE TABLE deck_favorites (
  deck_id    uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  user_id    uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (deck_id, user_id)
);
ALTER TABLE deck_favorites ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_favorites: manage own" ON deck_favorites FOR ALL USING (user_id = current_profile_id()) WITH CHECK (user_id = current_profile_id());

CREATE TABLE deck_reports (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  deck_id    uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  user_id    uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  reason     text NOT NULL,
  status     text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'dismissed', 'action_taken')),
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE deck_reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_reports: insert own" ON deck_reports FOR INSERT WITH CHECK (user_id = current_profile_id());
CREATE POLICY "deck_reports: read access" ON deck_reports FOR SELECT USING (user_id = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

-- ══════════════════════════════════════════════════════
-- 9. POSTGRES TRIGGERS (AUTOMATION)
-- ══════════════════════════════════════════════════════

-- Create Listing automatically when a Deck is created
CREATE OR REPLACE FUNCTION initialize_deck_listing() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO deck_listings (deck_id) VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_init_deck_listing AFTER INSERT ON decks FOR EACH ROW EXECUTE FUNCTION initialize_deck_listing();

-- Update Votes (Targeting deck_listings)
CREATE OR REPLACE FUNCTION update_deck_vote_counts() RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    IF NEW.vote_value = 1 THEN
      UPDATE deck_listings SET upvotes_count = upvotes_count + 1 WHERE deck_id = NEW.deck_id;
    ELSE
      UPDATE deck_listings SET downvotes_count = downvotes_count + 1 WHERE deck_id = NEW.deck_id;
    END IF;
  ELSIF (TG_OP = 'UPDATE') THEN
    IF OLD.vote_value != NEW.vote_value THEN
      IF NEW.vote_value = 1 THEN
        UPDATE deck_listings SET upvotes_count = upvotes_count + 1, downvotes_count = downvotes_count - 1 WHERE deck_id = NEW.deck_id;
      ELSE
        UPDATE deck_listings SET downvotes_count = downvotes_count + 1, upvotes_count = upvotes_count - 1 WHERE deck_id = NEW.deck_id;
      END IF;
    END IF;
  ELSIF (TG_OP = 'DELETE') THEN
    IF OLD.vote_value = 1 THEN
      UPDATE deck_listings SET upvotes_count = upvotes_count - 1 WHERE deck_id = OLD.deck_id;
    ELSE
      UPDATE deck_listings SET downvotes_count = downvotes_count - 1 WHERE deck_id = OLD.deck_id;
    END IF;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_deck_votes AFTER INSERT OR UPDATE OR DELETE ON deck_votes FOR EACH ROW EXECUTE FUNCTION update_deck_vote_counts();

CREATE OR REPLACE FUNCTION record_deck_vote_event() RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO deck_vote_events (deck_id, user_id, old_vote_value, new_vote_value)
    VALUES (NEW.deck_id, NEW.user_id, NULL, NEW.vote_value);
  ELSIF (TG_OP = 'UPDATE' AND OLD.vote_value IS DISTINCT FROM NEW.vote_value) THEN
    INSERT INTO deck_vote_events (deck_id, user_id, old_vote_value, new_vote_value)
    VALUES (NEW.deck_id, NEW.user_id, OLD.vote_value, NEW.vote_value);
  ELSIF (TG_OP = 'DELETE') THEN
    INSERT INTO deck_vote_events (deck_id, user_id, old_vote_value, new_vote_value)
    VALUES (OLD.deck_id, OLD.user_id, OLD.vote_value, NULL);
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;
CREATE TRIGGER trigger_deck_vote_events AFTER INSERT OR UPDATE OR DELETE ON deck_votes FOR EACH ROW EXECUTE FUNCTION record_deck_vote_event();

CREATE OR REPLACE FUNCTION sync_deck_review_vote_snapshot() RETURNS TRIGGER AS $$
DECLARE
  current_vote int;
BEGIN
  SELECT vote_value INTO current_vote
  FROM deck_votes
  WHERE deck_id = NEW.deck_id AND user_id = NEW.user_id;

  IF current_vote IS NULL THEN
    RAISE EXCEPTION 'A deck vote is required before adding a review';
  END IF;

  NEW.vote_value_at_creation := current_vote;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_sync_deck_review_vote_snapshot BEFORE INSERT ON deck_vote_reviews FOR EACH ROW EXECUTE FUNCTION sync_deck_review_vote_snapshot();

CREATE OR REPLACE FUNCTION log_deck_vote_review_edit() RETURNS TRIGGER AS $$
BEGIN
  IF (OLD.title IS DISTINCT FROM NEW.title OR OLD.body IS DISTINCT FROM NEW.body) THEN
    INSERT INTO deck_vote_review_edit_logs (
      review_id, edited_by, old_title, new_title, old_body, new_body
    ) VALUES (
      OLD.id, NEW.user_id, OLD.title, NEW.title, OLD.body, NEW.body
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;
CREATE TRIGGER trigger_log_deck_vote_review_edit BEFORE UPDATE ON deck_vote_reviews FOR EACH ROW EXECUTE FUNCTION log_deck_vote_review_edit();

CREATE OR REPLACE FUNCTION update_deck_review_counts() RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    IF NEW.is_deleted = false THEN
      UPDATE deck_listings SET reviews_count = reviews_count + 1 WHERE deck_id = NEW.deck_id;
    END IF;
  ELSIF (TG_OP = 'UPDATE') THEN
    IF OLD.is_deleted = true AND NEW.is_deleted = false THEN
      UPDATE deck_listings SET reviews_count = reviews_count + 1 WHERE deck_id = NEW.deck_id;
    ELSIF OLD.is_deleted = false AND NEW.is_deleted = true THEN
      UPDATE deck_listings SET reviews_count = reviews_count - 1 WHERE deck_id = NEW.deck_id;
    END IF;
  ELSIF (TG_OP = 'DELETE') THEN
    IF OLD.is_deleted = false THEN
      UPDATE deck_listings SET reviews_count = reviews_count - 1 WHERE deck_id = OLD.deck_id;
    END IF;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_deck_reviews_count AFTER INSERT OR UPDATE OR DELETE ON deck_vote_reviews FOR EACH ROW EXECUTE FUNCTION update_deck_review_counts();

-- Update Downloads (Targeting deck_listings)
CREATE OR REPLACE FUNCTION update_deck_downloads_count() RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    UPDATE deck_listings SET downloads_count = downloads_count + 1 WHERE deck_id = NEW.deck_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_deck_downloads AFTER INSERT ON deck_downloads FOR EACH ROW EXECUTE FUNCTION update_deck_downloads_count();

-- Update Favorites (Targeting deck_listings)
CREATE OR REPLACE FUNCTION update_deck_favorites_count() RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    UPDATE deck_listings SET favorites_count = favorites_count + 1 WHERE deck_id = NEW.deck_id;
  ELSIF (TG_OP = 'DELETE') THEN
    UPDATE deck_listings SET favorites_count = favorites_count - 1 WHERE deck_id = OLD.deck_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_deck_favorites AFTER INSERT OR DELETE ON deck_favorites FOR EACH ROW EXECUTE FUNCTION update_deck_favorites_count();

-- Update Reports (Targeting deck_listings)
CREATE OR REPLACE FUNCTION update_deck_reports_count() RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    UPDATE deck_listings SET reports_count = reports_count + 1 WHERE deck_id = NEW.deck_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_deck_reports AFTER INSERT ON deck_reports FOR EACH ROW EXECUTE FUNCTION update_deck_reports_count();

-- Update Comments (Targeting deck_listings)
CREATE OR REPLACE FUNCTION log_deck_comment_edit() RETURNS TRIGGER AS $$
BEGIN
  IF (OLD.body IS DISTINCT FROM NEW.body) THEN
    INSERT INTO deck_comment_edit_logs (comment_id, edited_by, old_body, new_body)
    VALUES (OLD.id, NEW.user_id, OLD.body, NEW.body);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;
CREATE TRIGGER trigger_log_deck_comment_edit BEFORE UPDATE ON deck_comments FOR EACH ROW EXECUTE FUNCTION log_deck_comment_edit();

CREATE OR REPLACE FUNCTION update_deck_comments_count() RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    IF NEW.is_deleted = false THEN
      UPDATE deck_listings SET comments_count = comments_count + 1 WHERE deck_id = NEW.deck_id;
    END IF;
  ELSIF (TG_OP = 'UPDATE') THEN
    IF OLD.is_deleted = true AND NEW.is_deleted = false THEN
      UPDATE deck_listings SET comments_count = comments_count + 1 WHERE deck_id = NEW.deck_id;
    ELSIF OLD.is_deleted = false AND NEW.is_deleted = true THEN
      UPDATE deck_listings SET comments_count = comments_count - 1 WHERE deck_id = NEW.deck_id;
    END IF;
  ELSIF (TG_OP = 'DELETE') THEN
    IF OLD.is_deleted = false THEN
      UPDATE deck_listings SET comments_count = comments_count - 1 WHERE deck_id = OLD.deck_id;
    END IF;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_deck_comments AFTER INSERT OR UPDATE OR DELETE ON deck_comments FOR EACH ROW EXECUTE FUNCTION update_deck_comments_count();

-- Update Forks (Targeting deck_listings)
CREATE OR REPLACE FUNCTION update_deck_forks_count() RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT' AND NEW.source_deck_id IS NOT NULL) THEN
    UPDATE deck_listings SET forks_count = forks_count + 1 WHERE deck_id = NEW.source_deck_id;
  ELSIF (TG_OP = 'DELETE' AND OLD.source_deck_id IS NOT NULL) THEN
    UPDATE deck_listings SET forks_count = forks_count - 1 WHERE deck_id = OLD.source_deck_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_deck_forks AFTER INSERT OR DELETE ON decks FOR EACH ROW EXECUTE FUNCTION update_deck_forks_count();
