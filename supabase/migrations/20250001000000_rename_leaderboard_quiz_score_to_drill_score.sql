-- ══════════════════════════════════════════════════════
-- Migration: rename leaderboard view quiz_score → drill_score
--
-- The Dart model exposes the field as `drillScore` and the
-- LeaderboardEntryMapper keys on `drillScore`. The live view
-- was using `quiz_score` as the column alias; this migration
-- recreates the view with the correct alias `drill_score` so
-- the PostgREST response matches the mapper without any
-- client-side key renaming.
-- ══════════════════════════════════════════════════════

CREATE OR REPLACE VIEW leaderboard AS
SELECT
  p.id                                    AS user_id,
  p.display_name,
  p.target_language,
  COALESCE(SUM(qs.correct_count), 0)::int AS drill_score,
  COALESCE(rc.review_count, 0)::int       AS review_count,
  COALESCE(s.current_streak, 0)           AS current_streak
FROM profiles p
LEFT JOIN quiz_sessions qs
  ON qs.user_id = p.id AND qs.completed_at IS NOT NULL
LEFT JOIN (
  SELECT user_id, COUNT(*)::int AS review_count
  FROM review_logs
  GROUP BY user_id
) rc ON rc.user_id = p.id
LEFT JOIN streaks s ON s.user_id = p.id
WHERE p.role = 'group_a_participant'
GROUP BY
  p.id,
  p.display_name,
  p.target_language,
  rc.review_count,
  s.current_streak
ORDER BY drill_score DESC;
