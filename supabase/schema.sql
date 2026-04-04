-- ══════════════════════════════════════════════════════
-- BooMondai — Supabase PostgreSQL Schema
-- Derived from Dart models. Models take priority.
-- Serialization rule:
--   dart_mappable models → camelCase quoted column names
--   manual fromJson/toJson models → snake_case unquoted column names
-- All models now use dart_mappable → all tables use camelCase.
-- ══════════════════════════════════════════════════════

CREATE EXTENSION IF NOT EXISTS moddatetime SCHEMA extensions;

-- ══════════════════════════════════════════════════════
-- AUTH & PROFILES
-- UserProfile uses dart_mappable → camelCase columns
-- id = local UUID (offline-first)
-- "userId" = FK to Supabase auth.users
-- ══════════════════════════════════════════════════════

CREATE TABLE profiles (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId"        uuid NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  "userName"      text NOT NULL,
  role            text NOT NULL DEFAULT 'group_a_participant'
                  CHECK (role IN ('group_a_participant', 'group_b_participant', 'researcher')),
  "avatarUrl"     text,
  "targetLanguage" text,
  "createdAt"     timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "profiles: users read all"   ON profiles FOR SELECT USING (true);
CREATE POLICY "profiles: users insert own" ON profiles FOR INSERT WITH CHECK (auth.uid() = "userId");
CREATE POLICY "profiles: users update own" ON profiles FOR UPDATE USING (auth.uid() = "userId") WITH CHECK (auth.uid() = "userId");

-- ══════════════════════════════════════════════════════
-- DECKS
-- Deck uses dart_mappable → camelCase columns
-- ══════════════════════════════════════════════════════

CREATE TABLE decks (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "authorId"         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title              text NOT NULL,
  "shortDescription" text NOT NULL DEFAULT '',
  "longDescription"  text NOT NULL DEFAULT '',
  "targetLanguage"   text NOT NULL,
  tags               text[] NOT NULL DEFAULT '{}',
  "isPremade"        bool NOT NULL DEFAULT false,
  "isPublic"         bool NOT NULL DEFAULT true,
  "isEditable"       bool NOT NULL DEFAULT true,
  "cardCount"        int  NOT NULL DEFAULT 0,
  version            text NOT NULL DEFAULT '1.0.0',
  "buildNumber"      int  NOT NULL DEFAULT 1,
  "sourceDeckId"     uuid REFERENCES decks(id) ON DELETE SET NULL,
  "sourceAuthorId"   uuid REFERENCES profiles(id) ON DELETE SET NULL,
  "isPublished"      bool NOT NULL DEFAULT false,
  "createdAt"        timestamptz NOT NULL DEFAULT now(),
  "updatedAt"        timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE decks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "decks: anyone reads public" ON decks FOR SELECT
  USING ("isPublic" = true OR auth.uid() = "authorId");
CREATE POLICY "decks: users manage own" ON decks FOR ALL
  USING (auth.uid() = "authorId") WITH CHECK (auth.uid() = "authorId");

CREATE INDEX ON decks ("authorId");
CREATE INDEX ON decks ("targetLanguage");
CREATE INDEX ON decks ("isPublic");
CREATE INDEX ON decks ("sourceDeckId");
CREATE INDEX ON decks USING gin (tags);

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON decks
  FOR EACH ROW EXECUTE FUNCTION moddatetime("updatedAt");

-- ══════════════════════════════════════════════════════
-- CARD TEMPLATES (was deck_cards)
-- CardTemplate uses dart_mappable → camelCase columns
-- type column = discriminator key for dart_mappable sealed class
-- ══════════════════════════════════════════════════════

CREATE TABLE card_templates (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "deckId"           uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  type               text NOT NULL CHECK (type IN (
                       'flashcard',
                       'identification',
                       'multiple_choice',
                       'fill_in_the_blanks',
                       'word_scramble',
                       'match_madness'
                     )),
  "sortOrder"        int  NOT NULL DEFAULT 0,
  "sourceTemplateId" uuid REFERENCES card_templates(id) ON DELETE SET NULL,
  "createdAt"        timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE card_templates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "card_templates: readable if deck accessible" ON card_templates FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM decks
    WHERE decks.id = card_templates."deckId"
      AND ("isPublic" = true OR "authorId" = auth.uid())
  ));
CREATE POLICY "card_templates: creator manages" ON card_templates FOR ALL
  USING (EXISTS (
    SELECT 1 FROM decks
    WHERE decks.id = card_templates."deckId" AND "authorId" = auth.uid()
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM decks
    WHERE decks.id = card_templates."deckId" AND "authorId" = auth.uid()
  ));

CREATE INDEX ON card_templates ("deckId");
CREATE INDEX ON card_templates ("sourceTemplateId");

-- ── notes ──────────────────────────────────────────────
-- Content node for a card. Internal storage — snake_case.
-- A flashcard/identification/fitb card has 1+ note rows.
-- match_madness cards have no notes.
CREATE TABLE notes (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  card_id         uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  front_text      text NOT NULL DEFAULT '',
  back_text       text NOT NULL DEFAULT '',
  front_audio_url text,
  back_audio_url  text,
  front_image_url text,
  back_image_url  text,
  is_reverse      bool NOT NULL DEFAULT false,
  created_at      timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE notes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "notes: readable if card accessible" ON notes FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM card_templates ct
    JOIN decks d ON d.id = ct."deckId"
    WHERE ct.id = notes.card_id
      AND (d."isPublic" = true OR d."authorId" = auth.uid())
  ));
CREATE POLICY "notes: creator manages" ON notes FOR ALL
  USING (EXISTS (
    SELECT 1 FROM card_templates ct
    JOIN decks d ON d.id = ct."deckId"
    WHERE ct.id = notes.card_id AND d."authorId" = auth.uid()
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM card_templates ct
    JOIN decks d ON d.id = ct."deckId"
    WHERE ct.id = notes.card_id AND d."authorId" = auth.uid()
  ));

CREATE INDEX ON notes (card_id);

-- ── mc_options ─────────────────────────────────────────
CREATE TABLE mc_options (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  card_id       uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  option_text   text NOT NULL,
  is_correct    bool NOT NULL DEFAULT false,
  display_order int  NOT NULL DEFAULT 0
);

ALTER TABLE mc_options ENABLE ROW LEVEL SECURITY;
CREATE POLICY "mc_options: readable if card accessible" ON mc_options FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM card_templates ct
    JOIN decks d ON d.id = ct."deckId"
    WHERE ct.id = mc_options.card_id
      AND (d."isPublic" = true OR d."authorId" = auth.uid())
  ));
CREATE POLICY "mc_options: creator manages" ON mc_options FOR ALL
  USING (EXISTS (
    SELECT 1 FROM card_templates ct
    JOIN decks d ON d.id = ct."deckId"
    WHERE ct.id = mc_options.card_id AND d."authorId" = auth.uid()
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM card_templates ct
    JOIN decks d ON d.id = ct."deckId"
    WHERE ct.id = mc_options.card_id AND d."authorId" = auth.uid()
  ));

CREATE INDEX ON mc_options (card_id);

-- ── fitb_segments ──────────────────────────────────────
CREATE TABLE fitb_segments (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  card_id        uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  full_text      text NOT NULL,
  blank_start    int  NOT NULL,
  blank_end      int  NOT NULL,
  correct_answer text NOT NULL,
  CONSTRAINT fitb_blank_order CHECK (blank_start < blank_end)
);

ALTER TABLE fitb_segments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "fitb_segments: readable if card accessible" ON fitb_segments FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM card_templates ct
    JOIN decks d ON d.id = ct."deckId"
    WHERE ct.id = fitb_segments.card_id
      AND (d."isPublic" = true OR d."authorId" = auth.uid())
  ));
CREATE POLICY "fitb_segments: creator manages" ON fitb_segments FOR ALL
  USING (EXISTS (
    SELECT 1 FROM card_templates ct
    JOIN decks d ON d.id = ct."deckId"
    WHERE ct.id = fitb_segments.card_id AND d."authorId" = auth.uid()
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM card_templates ct
    JOIN decks d ON d.id = ct."deckId"
    WHERE ct.id = fitb_segments.card_id AND d."authorId" = auth.uid()
  ));

CREATE INDEX ON fitb_segments (card_id);

-- ── mm_pairs ───────────────────────────────────────────
CREATE TABLE mm_pairs (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  card_id        uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  source_card_id uuid REFERENCES card_templates(id) ON DELETE SET NULL,
  term           text NOT NULL,
  match          text NOT NULL,
  is_auto_picked bool NOT NULL DEFAULT false,
  display_order  int  NOT NULL DEFAULT 0
);

ALTER TABLE mm_pairs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "mm_pairs: readable if card accessible" ON mm_pairs FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM card_templates ct
    JOIN decks d ON d.id = ct."deckId"
    WHERE ct.id = mm_pairs.card_id
      AND (d."isPublic" = true OR d."authorId" = auth.uid())
  ));
CREATE POLICY "mm_pairs: creator manages" ON mm_pairs FOR ALL
  USING (EXISTS (
    SELECT 1 FROM card_templates ct
    JOIN decks d ON d.id = ct."deckId"
    WHERE ct.id = mm_pairs.card_id AND d."authorId" = auth.uid()
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM card_templates ct
    JOIN decks d ON d.id = ct."deckId"
    WHERE ct.id = mm_pairs.card_id AND d."authorId" = auth.uid()
  ));

CREATE INDEX ON mm_pairs (card_id);
CREATE INDEX ON mm_pairs (source_card_id);

-- ── card_count trigger ─────────────────────────────────
CREATE OR REPLACE FUNCTION update_deck_card_count() RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE decks SET "cardCount" = (
      SELECT count(*) FROM card_templates WHERE "deckId" = NEW."deckId"
    ) WHERE id = NEW."deckId";
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE decks SET "cardCount" = (
      SELECT count(*) FROM card_templates WHERE "deckId" = OLD."deckId"
    ) WHERE id = OLD."deckId";
  ELSIF TG_OP = 'UPDATE' AND NEW."deckId" IS DISTINCT FROM OLD."deckId" THEN
    UPDATE decks SET "cardCount" = (
      SELECT count(*) FROM card_templates WHERE "deckId" = OLD."deckId"
    ) WHERE id = OLD."deckId";
    UPDATE decks SET "cardCount" = (
      SELECT count(*) FROM card_templates WHERE "deckId" = NEW."deckId"
    ) WHERE id = NEW."deckId";
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_deck_card_count
  AFTER INSERT OR UPDATE OR DELETE ON card_templates
  FOR EACH ROW EXECUTE FUNCTION update_deck_card_count();

-- ══════════════════════════════════════════════════════
-- REVIEW CARDS
-- ReviewCard uses dart_mappable → camelCase columns
-- Links a CardTemplate to an FSRS tracking unit.
-- isReversed tells the drill/review which side to show first.
-- ══════════════════════════════════════════════════════

CREATE TABLE review_cards (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "templateId" uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  "isReversed" bool NOT NULL DEFAULT false,
  "deckId"     uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE
);

ALTER TABLE review_cards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "review_cards: readable if deck accessible" ON review_cards FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM decks
    WHERE decks.id = review_cards."deckId"
      AND ("isPublic" = true OR "authorId" = auth.uid())
  ));
CREATE POLICY "review_cards: creator manages" ON review_cards FOR ALL
  USING (EXISTS (
    SELECT 1 FROM decks
    WHERE decks.id = review_cards."deckId" AND "authorId" = auth.uid()
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM decks
    WHERE decks.id = review_cards."deckId" AND "authorId" = auth.uid()
  ));

CREATE INDEX ON review_cards ("templateId");
CREATE INDEX ON review_cards ("deckId");

-- ══════════════════════════════════════════════════════
-- DRILL SESSIONS
-- DrillSession extends StudySession (dart_mappable) → camelCase columns
-- deckId is nullable (StudySession.deckId is optional)
-- ══════════════════════════════════════════════════════

CREATE TABLE drill_sessions (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId"         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  "deckId"         uuid REFERENCES decks(id) ON DELETE CASCADE,
  previewed        bool NOT NULL DEFAULT false,
  "totalQuestions" int  NOT NULL,
  "correctCount"   int  NOT NULL DEFAULT 0,
  "startedAt"      timestamptz NOT NULL DEFAULT now(),
  "completedAt"    timestamptz
);

ALTER TABLE drill_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "drill_sessions: users manage own" ON drill_sessions FOR ALL
  USING (auth.uid() = "userId") WITH CHECK (auth.uid() = "userId");

CREATE INDEX ON drill_sessions ("userId");
CREATE INDEX ON drill_sessions ("deckId");

-- ══════════════════════════════════════════════════════
-- REVIEW SESSIONS
-- ReviewSession extends StudySession (dart_mappable) → camelCase columns
-- deckId is nullable (StudySession.deckId is optional)
-- ══════════════════════════════════════════════════════

CREATE TABLE review_sessions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId"        uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  "deckId"        uuid REFERENCES decks(id) ON DELETE CASCADE,
  "totalCards"    int  NOT NULL,
  "cardsReviewed" int  NOT NULL DEFAULT 0,
  "startedAt"     timestamptz NOT NULL DEFAULT now(),
  "completedAt"   timestamptz
);

ALTER TABLE review_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "review_sessions: users manage own" ON review_sessions FOR ALL
  USING (auth.uid() = "userId") WITH CHECK (auth.uid() = "userId");

CREATE INDEX ON review_sessions ("userId");
CREATE INDEX ON review_sessions ("deckId");

-- ══════════════════════════════════════════════════════
-- DRILL ANSWERS
-- DrillAnswer uses dart_mappable → camelCase columns
-- type replaces the old is_correct + self_rating columns
-- StudyRating values: incorrect | again | hard | good | easy
-- ══════════════════════════════════════════════════════

CREATE TABLE drill_answers (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "sessionId"  uuid NOT NULL REFERENCES drill_sessions(id) ON DELETE CASCADE,
  "cardId"     uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  "userAnswer" text NOT NULL,
  type         text NOT NULL CHECK (type IN ('incorrect', 'again', 'hard', 'good', 'easy')),
  "createdAt"  timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE drill_answers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "drill_answers: users manage own" ON drill_answers FOR ALL
  USING (EXISTS (
    SELECT 1 FROM drill_sessions
    WHERE drill_sessions.id = drill_answers."sessionId"
      AND drill_sessions."userId" = auth.uid()
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM drill_sessions
    WHERE drill_sessions.id = drill_answers."sessionId"
      AND drill_sessions."userId" = auth.uid()
  ));

CREATE INDEX ON drill_answers ("sessionId");
CREATE INDEX ON drill_answers ("cardId");

-- ══════════════════════════════════════════════════════
-- FSRS CARDS
-- FsrsCard uses dart_mappable → camelCase columns
-- state stores the full fsrs.Card object as JSONB
-- reviewCardId FK → review_cards (not card_templates)
-- ══════════════════════════════════════════════════════

CREATE TABLE fsrs_cards (
  id             text PRIMARY KEY,
  "userId"       uuid NOT NULL REFERENCES profiles(id)     ON DELETE CASCADE,
  "reviewCardId" uuid NOT NULL REFERENCES review_cards(id) ON DELETE CASCADE,
  state          jsonb NOT NULL
);

ALTER TABLE fsrs_cards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "fsrs_cards: users manage own" ON fsrs_cards FOR ALL
  USING (auth.uid() = "userId") WITH CHECK (auth.uid() = "userId");

CREATE INDEX ON fsrs_cards ("userId");
CREATE INDEX ON fsrs_cards ("reviewCardId");

-- ══════════════════════════════════════════════════════
-- REVIEW LOGS
-- FsrsReviewLog uses dart_mappable → camelCase columns
-- cardId (text) → fsrs_cards.id
-- log stores the full fsrs.ReviewLog object as JSONB
-- ══════════════════════════════════════════════════════

CREATE TABLE review_logs (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "cardId"    text NOT NULL REFERENCES fsrs_cards(id) ON DELETE CASCADE,
  log         jsonb NOT NULL,
  "createdAt" timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE review_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "review_logs: users manage own" ON review_logs FOR ALL
  USING (EXISTS (
    SELECT 1 FROM fsrs_cards
    WHERE fsrs_cards.id = review_logs."cardId"
      AND fsrs_cards."userId" = auth.uid()
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM fsrs_cards
    WHERE fsrs_cards.id = review_logs."cardId"
      AND fsrs_cards."userId" = auth.uid()
  ));

CREATE INDEX ON review_logs ("cardId");

-- ══════════════════════════════════════════════════════
-- STREAKS
-- Streak uses dart_mappable → camelCase columns
-- ══════════════════════════════════════════════════════

CREATE TABLE streaks (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId"           uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  "currentStreak"    int  NOT NULL DEFAULT 0,
  "longestStreak"    int  NOT NULL DEFAULT 0,
  "lastActivityDate" date,
  "updatedAt"        timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "streaks: users manage own" ON streaks FOR ALL
  USING (auth.uid() = "userId") WITH CHECK (auth.uid() = "userId");

CREATE INDEX ON streaks ("userId");
CREATE TRIGGER set_streak_updated_at
  BEFORE UPDATE ON streaks
  FOR EACH ROW EXECUTE FUNCTION moddatetime("updatedAt");

-- ══════════════════════════════════════════════════════
-- USER DECK PROGRESS
-- UserDeckProgress uses dart_mappable → camelCase columns
-- Cached stats for fast UI rendering of per-deck progress
-- ══════════════════════════════════════════════════════

CREATE TABLE user_deck_progress (
  id                   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId"             uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  "deckId"             uuid NOT NULL REFERENCES decks(id)    ON DELETE CASCADE,
  "newCardsCount"      int  NOT NULL DEFAULT 0,
  "learningCardsCount" int  NOT NULL DEFAULT 0,
  "reviewCardsCount"   int  NOT NULL DEFAULT 0,
  "totalDrilled"       int  NOT NULL DEFAULT 0,
  "lastStudiedAt"      timestamptz NOT NULL DEFAULT now(),
  UNIQUE ("userId", "deckId")
);

ALTER TABLE user_deck_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "user_deck_progress: users manage own" ON user_deck_progress FOR ALL
  USING (auth.uid() = "userId") WITH CHECK (auth.uid() = "userId");

CREATE INDEX ON user_deck_progress ("userId");
CREATE INDEX ON user_deck_progress ("deckId");

-- ══════════════════════════════════════════════════════
-- LEADERBOARD VIEW
-- LeaderboardEntry uses dart_mappable → camelCase column aliases
-- (userId, userName, targetLanguage, drillScore, reviewCount, currentStreak)
-- review_logs has no userId; join through fsrs_cards to get "userId"
-- ══════════════════════════════════════════════════════

CREATE OR REPLACE VIEW leaderboard AS
SELECT
  p.id                                      AS "userId",
  p."userName"                              AS "userName",
  p."targetLanguage"                        AS "targetLanguage",
  COALESCE(SUM(ds."correctCount"), 0)::int  AS "drillScore",
  COALESCE(rc.review_count, 0)::int         AS "reviewCount",
  COALESCE(s."currentStreak", 0)            AS "currentStreak"
FROM profiles p
LEFT JOIN drill_sessions ds
  ON ds."userId" = p.id AND ds."completedAt" IS NOT NULL
LEFT JOIN (
  SELECT fc."userId" AS uid, COUNT(*)::int AS review_count
  FROM review_logs rl
  JOIN fsrs_cards fc ON fc.id = rl."cardId"
  GROUP BY fc."userId"
) rc ON rc.uid = p.id
LEFT JOIN streaks s ON s."userId" = p.id
WHERE p.role = 'group_a_participant'
GROUP BY p.id, p."userName", p."targetLanguage", rc.review_count, s."currentStreak"
ORDER BY "drillScore" DESC;

-- ══════════════════════════════════════════════════════
-- RESEARCH TABLES
-- All research models now use dart_mappable → camelCase columns.
-- ══════════════════════════════════════════════════════

-- ── research_profiles (was research_users) ─────────────
-- ResearchProfile: id, userId, userName?, firstName, lastName, age, role, targetLanguage, createdAt
CREATE TABLE research_profiles (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId"         uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  "userName"       text,
  "firstName"      text NOT NULL,
  "lastName"       text NOT NULL,
  age              int  NOT NULL,
  role             text NOT NULL CHECK (role IN ('group_a_participant', 'group_b_participant')),
  "targetLanguage" text NOT NULL,
  "createdAt"      timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE research_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_profiles: researchers manage" ON research_profiles FOR ALL
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE POLICY "research_profiles: users read own" ON research_profiles FOR SELECT
  USING (auth.uid() = "userId");
CREATE INDEX ON research_profiles ("userId");

-- ── research_codes ──────────────────────────────────────
-- ResearchCode: id, code, targetRole, unlocks, createdBy, usedBy?, usedAt?, createdAt
CREATE TABLE research_codes (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code         text NOT NULL UNIQUE,
  "targetRole" text NOT NULL,
  unlocks      text NOT NULL,
  "createdBy"  uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  "usedBy"     uuid REFERENCES profiles(id),
  "usedAt"     timestamptz,
  "createdAt"  timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE research_codes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_codes: researchers manage" ON research_codes FOR ALL
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE POLICY "research_codes: participants redeem" ON research_codes FOR UPDATE
  USING ("usedBy" IS NULL) WITH CHECK (auth.uid() = "usedBy");
CREATE POLICY "research_codes: participants read valid" ON research_codes FOR SELECT
  USING (auth.uid() = "usedBy" OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_codes (code);
CREATE INDEX ON research_codes ("createdBy");

-- ── survey_responses ────────────────────────────────────
-- SurveyResponse: id, userId, surveyType, timePoint?, responses (jsonb), computedScore?, submittedAt
-- Single generic table replaces all per-survey-type tables.
-- surveyType values: proficiency_screener | language_interest | experience_survey |
--   preview_usefulness | fsrs_usefulness | ugc_perception | sus
-- timePoint values (experience_survey only): short_term | long_term
CREATE TABLE survey_responses (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId"         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  "surveyType"     text NOT NULL CHECK ("surveyType" IN (
                     'proficiency_screener',
                     'language_interest',
                     'experience_survey',
                     'preview_usefulness',
                     'fsrs_usefulness',
                     'ugc_perception',
                     'sus'
                   )),
  "timePoint"      text CHECK ("timePoint" IN ('short_term', 'long_term')),
  responses        jsonb NOT NULL,
  "computedScore"  double precision,
  "submittedAt"    timestamptz NOT NULL DEFAULT now(),
  -- One response per survey type per user (experience_survey allows two via timePoint)
  UNIQUE ("userId", "surveyType", "timePoint")
);

ALTER TABLE survey_responses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "survey_responses: users insert own" ON survey_responses FOR INSERT
  WITH CHECK (auth.uid() = "userId");
CREATE POLICY "survey_responses: read" ON survey_responses FOR SELECT
  USING (auth.uid() = "userId" OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON survey_responses ("userId");
CREATE INDEX ON survey_responses ("surveyType");

-- ── vocabulary_test_results ─────────────────────────────
-- VocabularyTestResult: id, userId, testSet, score, answers (jsonb), submittedAt
CREATE TABLE vocabulary_test_results (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId"     uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  "testSet"    text NOT NULL CHECK ("testSet" IN ('A', 'B')),
  score        int  NOT NULL CHECK (score BETWEEN 0 AND 30),
  answers      jsonb NOT NULL,
  "submittedAt" timestamptz NOT NULL DEFAULT now(),
  UNIQUE ("userId", "testSet")
);

ALTER TABLE vocabulary_test_results ENABLE ROW LEVEL SECURITY;
CREATE POLICY "vocabulary_test_results: users insert own" ON vocabulary_test_results FOR INSERT
  WITH CHECK (auth.uid() = "userId");
CREATE POLICY "vocabulary_test_results: read" ON vocabulary_test_results FOR SELECT
  USING (auth.uid() = "userId" OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON vocabulary_test_results ("userId");
