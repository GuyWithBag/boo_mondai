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
    INSERT INTO deck_vote_events (deck_id, profile_id, old_vote_value, new_vote_value)
    VALUES (NEW.deck_id, NEW.profile_id, NULL, NEW.vote_value);
  ELSIF (TG_OP = 'UPDATE' AND OLD.vote_value IS DISTINCT FROM NEW.vote_value) THEN
    INSERT INTO deck_vote_events (deck_id, profile_id, old_vote_value, new_vote_value)
    VALUES (NEW.deck_id, NEW.profile_id, OLD.vote_value, NEW.vote_value);
  ELSIF (TG_OP = 'DELETE') THEN
    IF EXISTS (SELECT 1 FROM decks WHERE id = OLD.deck_id) THEN
      INSERT INTO deck_vote_events (deck_id, profile_id, old_vote_value, new_vote_value)
      VALUES (OLD.deck_id, OLD.profile_id, OLD.vote_value, NULL);
    END IF;
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
  WHERE deck_id = NEW.deck_id AND profile_id = NEW.profile_id;

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
  IF (
    OLD.vote_value_at_creation IS DISTINCT FROM NEW.vote_value_at_creation
    OR OLD.title IS DISTINCT FROM NEW.title
    OR OLD.body IS DISTINCT FROM NEW.body
  ) THEN
    INSERT INTO deck_vote_review_edit_logs (
      review_id, edited_by, old_vote_value_at_creation, new_vote_value_at_creation, old_title, new_title, old_body, new_body
    ) VALUES (
      OLD.id, NEW.profile_id, OLD.vote_value_at_creation, NEW.vote_value_at_creation, OLD.title, NEW.title, OLD.body, NEW.body
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;
CREATE TRIGGER trigger_log_deck_vote_review_edit BEFORE UPDATE ON deck_vote_reviews FOR EACH ROW EXECUTE FUNCTION log_deck_vote_review_edit();

CREATE OR REPLACE FUNCTION log_deck_vote_review_comment_edit() RETURNS TRIGGER AS $$
BEGIN
  IF (OLD.body IS DISTINCT FROM NEW.body) THEN
    INSERT INTO deck_vote_review_comment_edit_logs (comment_id, edited_by, old_body, new_body)
    VALUES (OLD.id, NEW.profile_id, OLD.body, NEW.body);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;
CREATE TRIGGER trigger_log_deck_vote_review_comment_edit BEFORE UPDATE ON deck_vote_review_comments FOR EACH ROW EXECUTE FUNCTION log_deck_vote_review_comment_edit();

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
    VALUES (OLD.id, NEW.profile_id, OLD.body, NEW.body);
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
