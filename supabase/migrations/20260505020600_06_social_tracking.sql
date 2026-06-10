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
  old_vote_value_at_creation int NOT NULL CHECK (old_vote_value_at_creation IN (1, -1)),
  new_vote_value_at_creation int NOT NULL CHECK (new_vote_value_at_creation IN (1, -1)),
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

CREATE TABLE deck_vote_review_comments (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  review_id         uuid NOT NULL REFERENCES deck_vote_reviews(id) ON DELETE CASCADE,
  user_id           uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  parent_comment_id uuid,
  body              text NOT NULL,
  is_deleted        bool NOT NULL DEFAULT false,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  UNIQUE (id, review_id),
  CONSTRAINT deck_vote_review_comments_parent_fk
    FOREIGN KEY (parent_comment_id, review_id)
    REFERENCES deck_vote_review_comments(id, review_id)
    ON DELETE CASCADE
);
ALTER TABLE deck_vote_review_comments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_vote_review_comments: read visible" ON deck_vote_review_comments FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM deck_vote_reviews r
    JOIN decks d ON d.id = r.deck_id
    WHERE r.id = deck_vote_review_comments.review_id
      AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())
  ));
CREATE POLICY "deck_vote_review_comments: insert own" ON deck_vote_review_comments FOR INSERT
  WITH CHECK (
    user_id = current_profile_id()
    AND EXISTS (
      SELECT 1 FROM deck_vote_reviews r
      JOIN decks d ON d.id = r.deck_id
      WHERE r.id = deck_vote_review_comments.review_id
        AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())
    )
  );
CREATE POLICY "deck_vote_review_comments: update own" ON deck_vote_review_comments FOR UPDATE
  USING (user_id = current_profile_id())
  WITH CHECK (user_id = current_profile_id());
CREATE INDEX ON deck_vote_review_comments (review_id, created_at) WHERE parent_comment_id IS NULL;
CREATE INDEX ON deck_vote_review_comments (parent_comment_id, created_at);
CREATE INDEX ON deck_vote_review_comments (user_id, created_at DESC);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON deck_vote_review_comments FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

CREATE TABLE deck_vote_review_comment_edit_logs (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  comment_id  uuid NOT NULL REFERENCES deck_vote_review_comments(id) ON DELETE CASCADE,
  edited_by   uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  old_body    text NOT NULL,
  new_body    text NOT NULL,
  edited_at   timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE deck_vote_review_comment_edit_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_vote_review_comment_edit_logs: read visible" ON deck_vote_review_comment_edit_logs FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM deck_vote_review_comments c
    JOIN deck_vote_reviews r ON r.id = c.review_id
    JOIN decks d ON d.id = r.deck_id
    WHERE c.id = deck_vote_review_comment_edit_logs.comment_id
      AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())
  ));
CREATE INDEX ON deck_vote_review_comment_edit_logs (comment_id, edited_at DESC);

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
  deck_id    uuid NOT NULL CONSTRAINT deck_favorites_deck_id_fkey REFERENCES decks(id) ON DELETE CASCADE,
  user_id    uuid NOT NULL CONSTRAINT deck_favorites_user_id_fkey REFERENCES profiles(id) ON DELETE CASCADE,
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

