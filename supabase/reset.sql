-- ══════════════════════════════════════════════════════
-- BooMondai — Full Reset
-- Drops every app table and view so schema.sql can be
-- pasted and run fresh. auth.users is NOT touched.
--
-- Order: leaf tables first, then tables they reference.
-- CASCADE handles any FK edges we miss.
-- ══════════════════════════════════════════════════════

-- ── View ─────────────────────────────────────────────
DROP VIEW  IF EXISTS leaderboard CASCADE;

-- ── Research ─────────────────────────────────────────
DROP TABLE IF EXISTS research_sus                   CASCADE;
DROP TABLE IF EXISTS research_ugc_perception        CASCADE;
DROP TABLE IF EXISTS research_fsrs_usefulness       CASCADE;
DROP TABLE IF EXISTS research_preview_usefulness    CASCADE;
DROP TABLE IF EXISTS research_experience_survey     CASCADE;
DROP TABLE IF EXISTS research_vocabulary_test       CASCADE;
DROP TABLE IF EXISTS research_language_interest     CASCADE;
DROP TABLE IF EXISTS research_proficiency_screener  CASCADE;
DROP TABLE IF EXISTS research_codes                 CASCADE;
DROP TABLE IF EXISTS research_users                 CASCADE;

-- ── Quiz ─────────────────────────────────────────────
DROP TABLE IF EXISTS quiz_answers   CASCADE;
DROP TABLE IF EXISTS quiz_sessions  CASCADE;

-- ── FSRS / review ────────────────────────────────────
DROP TABLE IF EXISTS review_logs  CASCADE;
DROP TABLE IF EXISTS fsrs_cards   CASCADE;

-- ── Card content ─────────────────────────────────────
DROP TABLE IF EXISTS mm_pairs       CASCADE;
DROP TABLE IF EXISTS fitb_segments  CASCADE;
DROP TABLE IF EXISTS mc_options     CASCADE;
DROP TABLE IF EXISTS notes          CASCADE;

-- ── Core ─────────────────────────────────────────────
DROP TABLE IF EXISTS deck_cards  CASCADE;
DROP TABLE IF EXISTS decks       CASCADE;
DROP TABLE IF EXISTS streaks     CASCADE;
DROP TABLE IF EXISTS profiles    CASCADE;

-- ══════════════════════════════════════════════════════
-- Done. Now paste and run schema.sql, then seed.sql.
-- ══════════════════════════════════════════════════════
