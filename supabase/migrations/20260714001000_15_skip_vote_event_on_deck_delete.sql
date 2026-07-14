-- Avoid FK failures when deleting a deck.
--
-- Deleting a deck cascades to deck_votes. The deck_votes DELETE trigger used to
-- insert a deck_vote_events row that referenced the same deck while the parent
-- deck delete was in progress, which could violate deck_vote_events_deck_id_fkey
-- and abort the whole cascade.

CREATE OR REPLACE FUNCTION record_deck_vote_event() RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO deck_vote_events (deck_id, user_id, old_vote_value, new_vote_value)
    VALUES (NEW.deck_id, NEW.user_id, NULL, NEW.vote_value);
  ELSIF (TG_OP = 'UPDATE' AND OLD.vote_value IS DISTINCT FROM NEW.vote_value) THEN
    INSERT INTO deck_vote_events (deck_id, user_id, old_vote_value, new_vote_value)
    VALUES (NEW.deck_id, NEW.user_id, OLD.vote_value, NEW.vote_value);
  ELSIF (TG_OP = 'DELETE') THEN
    IF EXISTS (SELECT 1 FROM decks WHERE id = OLD.deck_id) THEN
      INSERT INTO deck_vote_events (deck_id, user_id, old_vote_value, new_vote_value)
      VALUES (OLD.deck_id, OLD.user_id, OLD.vote_value, NULL);
    END IF;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;
