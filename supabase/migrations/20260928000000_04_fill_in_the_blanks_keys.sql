ALTER TABLE card_templates
  ADD COLUMN fill_in_the_blank_keys jsonb NOT NULL DEFAULT '[]'::jsonb;

DROP TABLE IF EXISTS fill_in_the_blank_segments;
