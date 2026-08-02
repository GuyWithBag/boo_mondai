-- Rename profile-owned ownership columns from user_id to profile_id.
-- These rows are owned by profiles.id, not auth.users.id.

ALTER TABLE decks RENAME COLUMN user_id TO profile_id;
ALTER TABLE drill_sessions RENAME COLUMN user_id TO profile_id;
ALTER TABLE review_sessions RENAME COLUMN user_id TO profile_id;
ALTER TABLE fsrs_cards RENAME COLUMN user_id TO profile_id;
ALTER TABLE streaks RENAME COLUMN user_id TO profile_id;
ALTER TABLE sync_clients RENAME COLUMN user_id TO profile_id;
ALTER TABLE deck_votes RENAME COLUMN user_id TO profile_id;
ALTER TABLE deck_vote_events RENAME COLUMN user_id TO profile_id;
ALTER TABLE deck_vote_reviews RENAME COLUMN user_id TO profile_id;
ALTER TABLE deck_vote_review_comments RENAME COLUMN user_id TO profile_id;
ALTER TABLE deck_comments RENAME COLUMN user_id TO profile_id;
ALTER TABLE research_profiles RENAME COLUMN user_id TO profile_id;
ALTER TABLE survey_responses RENAME COLUMN user_id TO profile_id;
ALTER TABLE vocabulary_test_results RENAME COLUMN user_id TO profile_id;
ALTER TABLE user_study_cards_tags RENAME COLUMN user_id TO profile_id;

ALTER TABLE decks RENAME CONSTRAINT decks_user_id_fkey TO decks_profile_id_fkey;
ALTER TABLE drill_sessions RENAME CONSTRAINT drill_sessions_user_id_fkey TO drill_sessions_profile_id_fkey;
ALTER TABLE review_sessions RENAME CONSTRAINT review_sessions_user_id_fkey TO review_sessions_profile_id_fkey;
ALTER TABLE fsrs_cards RENAME CONSTRAINT fsrs_cards_user_id_fkey TO fsrs_cards_profile_id_fkey;
ALTER TABLE streaks RENAME CONSTRAINT streaks_user_id_fkey TO streaks_profile_id_fkey;
ALTER TABLE sync_clients RENAME CONSTRAINT sync_clients_user_id_fkey TO sync_clients_profile_id_fkey;
ALTER TABLE deck_votes RENAME CONSTRAINT deck_votes_user_id_fkey TO deck_votes_profile_id_fkey;
ALTER TABLE deck_vote_events RENAME CONSTRAINT deck_vote_events_user_id_fkey TO deck_vote_events_profile_id_fkey;
ALTER TABLE deck_vote_reviews RENAME CONSTRAINT deck_vote_reviews_user_id_fkey TO deck_vote_reviews_profile_id_fkey;
ALTER TABLE deck_vote_review_comments RENAME CONSTRAINT deck_vote_review_comments_user_id_fkey TO deck_vote_review_comments_profile_id_fkey;
ALTER TABLE deck_comments RENAME CONSTRAINT deck_comments_user_id_fkey TO deck_comments_profile_id_fkey;
ALTER TABLE research_profiles RENAME CONSTRAINT research_profiles_user_id_fkey TO research_profiles_profile_id_fkey;
ALTER TABLE survey_responses RENAME CONSTRAINT survey_responses_user_id_fkey TO survey_responses_profile_id_fkey;
ALTER TABLE survey_responses RENAME CONSTRAINT survey_responses_research_profile_user_id_fkey TO survey_responses_research_profile_profile_id_fkey;
ALTER TABLE vocabulary_test_results RENAME CONSTRAINT vocabulary_test_results_user_id_fkey TO vocabulary_test_results_profile_id_fkey;
ALTER TABLE vocabulary_test_results RENAME CONSTRAINT vocabulary_test_results_research_profile_user_id_fkey TO vocabulary_test_results_research_profile_profile_id_fkey;
ALTER TABLE user_study_cards_tags RENAME CONSTRAINT user_study_cards_tags_user_id_fkey TO user_study_cards_tags_profile_id_fkey;

ALTER INDEX IF EXISTS idx_sync_clients_user_id RENAME TO idx_sync_clients_profile_id;
ALTER INDEX IF EXISTS deck_votes_user_id_idx RENAME TO deck_votes_profile_id_idx;
ALTER INDEX IF EXISTS deck_vote_events_user_id_changed_at_idx RENAME TO deck_vote_events_profile_id_changed_at_idx;
ALTER INDEX IF EXISTS deck_vote_reviews_user_id_created_at_idx RENAME TO deck_vote_reviews_profile_id_created_at_idx;
ALTER INDEX IF EXISTS deck_vote_review_comments_user_id_created_at_idx RENAME TO deck_vote_review_comments_profile_id_created_at_idx;
ALTER INDEX IF EXISTS deck_comments_user_id_created_at_idx RENAME TO deck_comments_profile_id_created_at_idx;

DROP POLICY IF EXISTS "sync_clients: owner select" ON sync_clients;
DROP POLICY IF EXISTS "sync_clients: owner insert" ON sync_clients;
DROP POLICY IF EXISTS "sync_clients: owner update" ON sync_clients;
DROP POLICY IF EXISTS "sync_clients: owner delete" ON sync_clients;

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

DROP POLICY IF EXISTS "deck_votes: manage own" ON deck_votes;
CREATE POLICY "deck_votes: manage own" ON deck_votes FOR ALL USING (profile_id = current_profile_id()) WITH CHECK (profile_id = current_profile_id());

DROP POLICY IF EXISTS "deck_vote_events: read own or researcher" ON deck_vote_events;
CREATE POLICY "deck_vote_events: read own or researcher" ON deck_vote_events FOR SELECT
  USING (profile_id = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

DROP POLICY IF EXISTS "deck_vote_reviews: insert own vote review" ON deck_vote_reviews;
DROP POLICY IF EXISTS "deck_vote_reviews: update own" ON deck_vote_reviews;
CREATE POLICY "deck_vote_reviews: insert own vote review" ON deck_vote_reviews FOR INSERT
  WITH CHECK (profile_id = current_profile_id() AND EXISTS (SELECT 1 FROM deck_votes dv WHERE dv.deck_id = deck_vote_reviews.deck_id AND dv.profile_id = current_profile_id()));
CREATE POLICY "deck_vote_reviews: update own" ON deck_vote_reviews FOR UPDATE
  USING (profile_id = current_profile_id())
  WITH CHECK (profile_id = current_profile_id());

DROP POLICY IF EXISTS "deck_vote_review_comments: insert own" ON deck_vote_review_comments;
DROP POLICY IF EXISTS "deck_vote_review_comments: update own" ON deck_vote_review_comments;
CREATE POLICY "deck_vote_review_comments: insert own" ON deck_vote_review_comments FOR INSERT
  WITH CHECK (
    profile_id = current_profile_id()
    AND EXISTS (
      SELECT 1 FROM deck_vote_reviews r
      JOIN decks d ON d.id = r.deck_id
      WHERE r.id = deck_vote_review_comments.review_id
        AND (d.visibility_state IN ('public', 'unlisted') OR d.profile_id = current_profile_id())
    )
  );
CREATE POLICY "deck_vote_review_comments: update own" ON deck_vote_review_comments FOR UPDATE
  USING (profile_id = current_profile_id())
  WITH CHECK (profile_id = current_profile_id());

DROP POLICY IF EXISTS "deck_comments: insert own" ON deck_comments;
DROP POLICY IF EXISTS "deck_comments: update own" ON deck_comments;
CREATE POLICY "deck_comments: insert own" ON deck_comments FOR INSERT
  WITH CHECK (profile_id = current_profile_id() AND EXISTS (SELECT 1 FROM decks d WHERE d.id = deck_comments.deck_id AND (d.visibility_state IN ('public', 'unlisted') OR d.profile_id = current_profile_id())));
CREATE POLICY "deck_comments: update own" ON deck_comments FOR UPDATE
  USING (profile_id = current_profile_id())
  WITH CHECK (profile_id = current_profile_id());

DROP POLICY IF EXISTS "research_profiles: select access" ON research_profiles;
CREATE POLICY "research_profiles: select access" ON research_profiles FOR SELECT TO authenticated USING (profile_id = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

DROP POLICY IF EXISTS "survey_responses: insert own" ON survey_responses;
DROP POLICY IF EXISTS "survey_responses: read own or researcher" ON survey_responses;
CREATE POLICY "survey_responses: insert own" ON survey_responses FOR INSERT WITH CHECK (profile_id = current_profile_id());
CREATE POLICY "survey_responses: read own or researcher" ON survey_responses FOR SELECT USING (profile_id = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

DROP POLICY IF EXISTS "vocabulary_test_results: insert own" ON vocabulary_test_results;
DROP POLICY IF EXISTS "vocabulary_test_results: read own or researcher" ON vocabulary_test_results;
CREATE POLICY "vocabulary_test_results: insert own" ON vocabulary_test_results FOR INSERT WITH CHECK (profile_id = current_profile_id());
CREATE POLICY "vocabulary_test_results: read own or researcher" ON vocabulary_test_results FOR SELECT USING (profile_id = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

DROP POLICY IF EXISTS "user_study_cards_tags: private" ON user_study_cards_tags;
CREATE POLICY "user_study_cards_tags: private" ON user_study_cards_tags FOR ALL USING (profile_id = current_profile_id());

DROP POLICY IF EXISTS "drill_sessions: owner manages" ON drill_sessions;
CREATE POLICY "drill_sessions: owner manages" ON drill_sessions FOR ALL USING (profile_id = current_profile_id());

DROP POLICY IF EXISTS "review_sessions: owner manages" ON review_sessions;
CREATE POLICY "review_sessions: owner manages" ON review_sessions FOR ALL USING (profile_id = current_profile_id());

DROP POLICY IF EXISTS "fsrs_cards: owner manages" ON fsrs_cards;
CREATE POLICY "fsrs_cards: owner manages" ON fsrs_cards FOR ALL USING (profile_id = current_profile_id());

DROP POLICY IF EXISTS "streaks: owner manages" ON streaks;
CREATE POLICY "streaks: owner manages" ON streaks FOR ALL USING (profile_id = current_profile_id());

DROP POLICY IF EXISTS "deck_votes: read all" ON deck_votes;
CREATE POLICY "deck_votes: read all" ON deck_votes FOR SELECT USING (true);

DROP VIEW IF EXISTS leaderboard_entries;

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
