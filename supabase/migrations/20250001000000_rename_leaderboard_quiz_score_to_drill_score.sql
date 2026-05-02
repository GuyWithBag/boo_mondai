-- ══════════════════════════════════════════════════════
-- Migration: rename leaderboard view quiz_score → drill_score
--
-- CREATE OR REPLACE VIEW cannot rename existing columns; use
-- ALTER VIEW ... RENAME COLUMN instead (PostgreSQL 14+).
-- ══════════════════════════════════════════════════════

ALTER VIEW leaderboard RENAME COLUMN quiz_score TO drill_score;
