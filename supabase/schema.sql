-- ══════════════════════════════════════════════════════
-- BooMondai — Supabase PostgreSQL Schema
-- Run this in the Supabase SQL Editor to set up all tables
-- ══════════════════════════════════════════════════════

-- ── Extensions ────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS moddatetime SCHEMA extensions;

-- ══════════════════════════════════════════════════════
-- CORE TABLES
-- ══════════════════════════════════════════════════════

-- ── profiles ──────────────────────────────────────────
CREATE TABLE profiles (
  id            uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email         text NOT NULL,
  display_name  text NOT NULL,
  role          text NOT NULL DEFAULT 'group_a_participant'
                CHECK (role IN ('group_a_participant', 'group_b_participant', 'researcher')),
  avatar_url    text,
  target_language text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "profiles: users read all" ON profiles FOR SELECT USING (true);
CREATE POLICY "profiles: users update own" ON profiles FOR UPDATE USING (auth.uid() = id) WITH CHECK (auth.uid() = id);
CREATE POLICY "profiles: users insert own" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

-- ── decks ──────────────────────────────────────────
CREATE TABLE decks (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  creator_id      uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title           text NOT NULL,
  description     text NOT NULL DEFAULT '',
  target_language text NOT NULL,
  is_premade      bool NOT NULL DEFAULT false,
  is_public       bool NOT NULL DEFAULT true,
  card_count      int NOT NULL DEFAULT 0,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE decks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "decks: anyone reads public" ON decks FOR SELECT USING (is_public = true OR auth.uid() = creator_id);
CREATE POLICY "decks: users manage own" ON decks FOR ALL USING (auth.uid() = creator_id) WITH CHECK (auth.uid() = creator_id);
CREATE INDEX ON decks (creator_id);
CREATE INDEX ON decks (target_language);
CREATE INDEX ON decks (is_public);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON decks FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

-- ── deck_cards ──────────────────────────────────────────
CREATE TABLE deck_cards (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  deck_id            uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  question           text NOT NULL,
  answer             text NOT NULL,
  question_image_url text,
  answer_image_url   text,
  sort_order         int NOT NULL DEFAULT 0,
  created_at         timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE deck_cards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_cards: readable if deck is accessible" ON deck_cards FOR SELECT
  USING (EXISTS (SELECT 1 FROM decks WHERE decks.id = deck_cards.deck_id AND (decks.is_public = true OR decks.creator_id = auth.uid())));
CREATE POLICY "deck_cards: creator manages" ON deck_cards FOR ALL
  USING (EXISTS (SELECT 1 FROM decks WHERE decks.id = deck_cards.deck_id AND decks.creator_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM decks WHERE decks.id = deck_cards.deck_id AND decks.creator_id = auth.uid()));
CREATE INDEX ON deck_cards (deck_id);

-- ── quiz_sessions ──────────────────────────────────────────
CREATE TABLE quiz_sessions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  deck_id         uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  previewed       bool NOT NULL DEFAULT false,
  total_questions int NOT NULL,
  correct_count   int NOT NULL DEFAULT 0,
  started_at      timestamptz NOT NULL DEFAULT now(),
  completed_at    timestamptz
);
ALTER TABLE quiz_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "quiz_sessions: users manage own" ON quiz_sessions FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE INDEX ON quiz_sessions (user_id);
CREATE INDEX ON quiz_sessions (deck_id);

-- ── quiz_answers ──────────────────────────────────────────
CREATE TABLE quiz_answers (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id  uuid NOT NULL REFERENCES quiz_sessions(id) ON DELETE CASCADE,
  card_id     uuid NOT NULL REFERENCES deck_cards(id) ON DELETE CASCADE,
  user_answer text NOT NULL,
  is_correct  bool NOT NULL,
  self_rating int CHECK (self_rating BETWEEN 1 AND 4),
  answered_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE quiz_answers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "quiz_answers: users manage own" ON quiz_answers FOR ALL
  USING (EXISTS (SELECT 1 FROM quiz_sessions WHERE quiz_sessions.id = quiz_answers.session_id AND quiz_sessions.user_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM quiz_sessions WHERE quiz_sessions.id = quiz_answers.session_id AND quiz_sessions.user_id = auth.uid()));
CREATE INDEX ON quiz_answers (session_id);
CREATE INDEX ON quiz_answers (card_id);

-- ── fsrs_cards ──────────────────────────────────────────
CREATE TABLE fsrs_cards (
  id              text PRIMARY KEY,
  user_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  card_id         uuid NOT NULL REFERENCES deck_cards(id) ON DELETE CASCADE,
  due             timestamptz NOT NULL,
  stability       double precision NOT NULL,
  difficulty      double precision NOT NULL,
  elapsed_days    int NOT NULL DEFAULT 0,
  scheduled_days  int NOT NULL DEFAULT 0,
  reps            int NOT NULL DEFAULT 0,
  lapses          int NOT NULL DEFAULT 0,
  state           int NOT NULL DEFAULT 0,
  last_review     timestamptz,
  updated_at      timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE fsrs_cards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "fsrs_cards: users manage own" ON fsrs_cards FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE INDEX ON fsrs_cards (user_id);
CREATE INDEX ON fsrs_cards (user_id, due);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON fsrs_cards FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

-- ── review_logs ──────────────────────────────────────────
CREATE TABLE review_logs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  card_id         uuid NOT NULL REFERENCES deck_cards(id) ON DELETE CASCADE,
  rating          int NOT NULL CHECK (rating BETWEEN 1 AND 4),
  scheduled_days  int NOT NULL,
  elapsed_days    int NOT NULL,
  review          timestamptz NOT NULL,
  state           int NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE review_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "review_logs: users manage own" ON review_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE INDEX ON review_logs (user_id);
CREATE INDEX ON review_logs (card_id);

-- ── streaks ──────────────────────────────────────────
CREATE TABLE streaks (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  current_streak      int NOT NULL DEFAULT 0,
  longest_streak      int NOT NULL DEFAULT 0,
  last_activity_date  date,
  updated_at          timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "streaks: users manage own" ON streaks FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE INDEX ON streaks (user_id);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON streaks FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

-- ── leaderboard (view) ──────────────────────────
CREATE OR REPLACE VIEW leaderboard AS
SELECT
  p.id AS user_id,
  p.display_name,
  p.target_language,
  COALESCE(SUM(qs.correct_count), 0)::int AS quiz_score,
  COALESCE(rc.review_count, 0)::int AS review_count,
  COALESCE(s.current_streak, 0) AS current_streak
FROM profiles p
LEFT JOIN quiz_sessions qs ON qs.user_id = p.id AND qs.completed_at IS NOT NULL
LEFT JOIN (SELECT user_id, COUNT(*)::int AS review_count FROM review_logs GROUP BY user_id) rc ON rc.user_id = p.id
LEFT JOIN streaks s ON s.user_id = p.id
WHERE p.role = 'group_a_participant'
GROUP BY p.id, p.display_name, p.target_language, rc.review_count, s.current_streak
ORDER BY quiz_score DESC;

-- ══════════════════════════════════════════════════════
-- RESEARCH TABLES
-- ══════════════════════════════════════════════════════

-- ── research_users ──────────────────────────────────────
CREATE TABLE research_users (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  role            text NOT NULL CHECK (role IN ('group_a_participant', 'group_b_participant')),
  target_language text NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_users: researchers manage" ON research_users FOR ALL
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE POLICY "research_users: users read own" ON research_users FOR SELECT USING (auth.uid() = user_id);
CREATE INDEX ON research_users (user_id);

-- ── research_codes ──────────────────────────────────────
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
CREATE POLICY "research_codes: researchers manage" ON research_codes FOR ALL
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE POLICY "research_codes: participants redeem" ON research_codes FOR UPDATE
  USING (used_by IS NULL) WITH CHECK (auth.uid() = used_by);
CREATE POLICY "research_codes: participants read own" ON research_codes FOR SELECT
  USING (auth.uid() = used_by OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_codes (code);
CREATE INDEX ON research_codes (created_by);

-- ── research_proficiency_screener ────────────────────────
CREATE TABLE research_proficiency_screener (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  item_1            int NOT NULL CHECK (item_1 BETWEEN 1 AND 5),
  item_2            int NOT NULL CHECK (item_2 BETWEEN 1 AND 5),
  item_3            int NOT NULL CHECK (item_3 BETWEEN 1 AND 5),
  item_4            int NOT NULL CHECK (item_4 BETWEEN 1 AND 5),
  item_5            int NOT NULL CHECK (item_5 BETWEEN 1 AND 5),
  item_6            int NOT NULL CHECK (item_6 BETWEEN 1 AND 5),
  proficiency_level text NOT NULL CHECK (proficiency_level IN ('none', 'beginner', 'elementary', 'intermediate', 'advanced')),
  submitted_at      timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_proficiency_screener ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_proficiency_screener: users insert own" ON research_proficiency_screener FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_proficiency_screener: read" ON research_proficiency_screener FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_proficiency_screener (user_id);

-- ── research_language_interest ────────────────────────
CREATE TABLE research_language_interest (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  item_1       int NOT NULL CHECK (item_1 BETWEEN 1 AND 5),
  item_2       int NOT NULL CHECK (item_2 BETWEEN 1 AND 5),
  item_3       int NOT NULL CHECK (item_3 BETWEEN 1 AND 5),
  item_4       int NOT NULL CHECK (item_4 BETWEEN 1 AND 5),
  item_5       int NOT NULL CHECK (item_5 BETWEEN 1 AND 5),
  submitted_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_language_interest ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_language_interest: users insert own" ON research_language_interest FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_language_interest: read" ON research_language_interest FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_language_interest (user_id);

-- ── research_vocabulary_test ────────────────────────
CREATE TABLE research_vocabulary_test (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  test_set     text NOT NULL CHECK (test_set IN ('A', 'B')),
  score        int NOT NULL CHECK (score BETWEEN 0 AND 30),
  answers      jsonb NOT NULL,
  submitted_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, test_set)
);
ALTER TABLE research_vocabulary_test ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_vocabulary_test: users insert own" ON research_vocabulary_test FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_vocabulary_test: read" ON research_vocabulary_test FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_vocabulary_test (user_id);

-- ── research_experience_survey ────────────────────────
CREATE TABLE research_experience_survey (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  time_point   text NOT NULL CHECK (time_point IN ('short_term', 'long_term')),
  enjoyment_1  int NOT NULL CHECK (enjoyment_1 BETWEEN 1 AND 5),
  enjoyment_2  int NOT NULL CHECK (enjoyment_2 BETWEEN 1 AND 5),
  enjoyment_3  int NOT NULL CHECK (enjoyment_3 BETWEEN 1 AND 5),
  enjoyment_4  int NOT NULL CHECK (enjoyment_4 BETWEEN 1 AND 5),
  enjoyment_5  int NOT NULL CHECK (enjoyment_5 BETWEEN 1 AND 5),
  engagement_1 int NOT NULL CHECK (engagement_1 BETWEEN 1 AND 5),
  engagement_2 int NOT NULL CHECK (engagement_2 BETWEEN 1 AND 5),
  engagement_3 int NOT NULL CHECK (engagement_3 BETWEEN 1 AND 5),
  engagement_4 int NOT NULL CHECK (engagement_4 BETWEEN 1 AND 5),
  engagement_5 int NOT NULL CHECK (engagement_5 BETWEEN 1 AND 5),
  motivation_1 int NOT NULL CHECK (motivation_1 BETWEEN 1 AND 5),
  motivation_2 int NOT NULL CHECK (motivation_2 BETWEEN 1 AND 5),
  motivation_3 int NOT NULL CHECK (motivation_3 BETWEEN 1 AND 5),
  motivation_4 int NOT NULL CHECK (motivation_4 BETWEEN 1 AND 5),
  motivation_5 int NOT NULL CHECK (motivation_5 BETWEEN 1 AND 5),
  submitted_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, time_point)
);
ALTER TABLE research_experience_survey ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_experience_survey: users insert own" ON research_experience_survey FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_experience_survey: read" ON research_experience_survey FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_experience_survey (user_id);

-- ── research_preview_usefulness (Group A only) ────────────
CREATE TABLE research_preview_usefulness (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  item_1       int NOT NULL CHECK (item_1 BETWEEN 1 AND 5),
  item_2       int NOT NULL CHECK (item_2 BETWEEN 1 AND 5),
  item_3       int NOT NULL CHECK (item_3 BETWEEN 1 AND 5),
  item_4       int NOT NULL CHECK (item_4 BETWEEN 1 AND 5),
  item_5       int NOT NULL CHECK (item_5 BETWEEN 1 AND 5),
  submitted_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_preview_usefulness ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_preview_usefulness: group_a insert own" ON research_preview_usefulness FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_preview_usefulness: read" ON research_preview_usefulness FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_preview_usefulness (user_id);

-- ── research_fsrs_usefulness (Group A only) ────────────
CREATE TABLE research_fsrs_usefulness (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  item_1       int NOT NULL CHECK (item_1 BETWEEN 1 AND 5),
  item_2       int NOT NULL CHECK (item_2 BETWEEN 1 AND 5),
  item_3       int NOT NULL CHECK (item_3 BETWEEN 1 AND 5),
  item_4       int NOT NULL CHECK (item_4 BETWEEN 1 AND 5),
  item_5       int NOT NULL CHECK (item_5 BETWEEN 1 AND 5),
  submitted_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_fsrs_usefulness ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_fsrs_usefulness: group_a insert own" ON research_fsrs_usefulness FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_fsrs_usefulness: read" ON research_fsrs_usefulness FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_fsrs_usefulness (user_id);

-- ── research_ugc_perception (both groups) ────────────
CREATE TABLE research_ugc_perception (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  item_1       int NOT NULL CHECK (item_1 BETWEEN 1 AND 5),
  item_2       int NOT NULL CHECK (item_2 BETWEEN 1 AND 5),
  item_3       int NOT NULL CHECK (item_3 BETWEEN 1 AND 5),
  item_4       int NOT NULL CHECK (item_4 BETWEEN 1 AND 5),
  item_5       int NOT NULL CHECK (item_5 BETWEEN 1 AND 5),
  item_6       int NOT NULL CHECK (item_6 BETWEEN 1 AND 5),
  submitted_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_ugc_perception ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_ugc_perception: users insert own" ON research_ugc_perception FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_ugc_perception: read" ON research_ugc_perception FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_ugc_perception (user_id);

-- ── research_sus (Group A only) ────────────
CREATE TABLE research_sus (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  item_1       int NOT NULL CHECK (item_1 BETWEEN 1 AND 5),
  item_2       int NOT NULL CHECK (item_2 BETWEEN 1 AND 5),
  item_3       int NOT NULL CHECK (item_3 BETWEEN 1 AND 5),
  item_4       int NOT NULL CHECK (item_4 BETWEEN 1 AND 5),
  item_5       int NOT NULL CHECK (item_5 BETWEEN 1 AND 5),
  item_6       int NOT NULL CHECK (item_6 BETWEEN 1 AND 5),
  item_7       int NOT NULL CHECK (item_7 BETWEEN 1 AND 5),
  item_8       int NOT NULL CHECK (item_8 BETWEEN 1 AND 5),
  item_9       int NOT NULL CHECK (item_9 BETWEEN 1 AND 5),
  item_10      int NOT NULL CHECK (item_10 BETWEEN 1 AND 5),
  sus_score    double precision NOT NULL,
  submitted_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_sus ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_sus: group_a insert own" ON research_sus FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_sus: read" ON research_sus FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_sus (user_id);
