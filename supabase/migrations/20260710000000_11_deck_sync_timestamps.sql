ALTER TABLE study_cards
  ADD COLUMN created_at timestamptz NOT NULL DEFAULT now(),
  ADD COLUMN updated_at timestamptz NOT NULL DEFAULT now();

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON study_cards
  FOR EACH ROW
  EXECUTE FUNCTION extensions.moddatetime(updated_at);

ALTER TABLE card_template_attachments
  ADD COLUMN updated_at timestamptz NOT NULL DEFAULT now();

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON card_template_attachments
  FOR EACH ROW
  EXECUTE FUNCTION extensions.moddatetime(updated_at);

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON deck_listings
  FOR EACH ROW
  EXECUTE FUNCTION extensions.moddatetime(updated_at);
