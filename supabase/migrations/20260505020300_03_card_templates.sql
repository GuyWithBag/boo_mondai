-- ══════════════════════════════════════════════════════
-- 5. CARD TEMPLATES & TYPES
-- ══════════════════════════════════════════════════════

CREATE TABLE card_templates (
  id                   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  deck_id              uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  type                 text NOT NULL CHECK (type IN ('flashcard', 'identification', 'multiple_choice', 'fill_in_the_blanks', 'word_scramble', 'match_madness')),
  sort_order           int  NOT NULL DEFAULT 0,

  -- Provenance & Styling
  source_template_id   uuid REFERENCES card_templates(id) ON DELETE SET NULL,
  design_config        jsonb,

  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),

  front_text           text,
  back_text            text,
  front_image_url      text,
  back_image_url       text,
  front_audio_url      text,
  back_audio_url       text,
  card_type            card_type,
  prompt_text          text,
  accepted_answers     text,
  question_prompt      text,
  sentence_to_scramble text,
  image_url            text,
  audio_url            text
);
ALTER TABLE card_templates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "card_templates: read access" ON card_templates FOR SELECT USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = card_templates.deck_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "card_templates: owner insert" ON card_templates FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM decks d WHERE d.id = card_templates.deck_id AND d.user_id = current_profile_id()));
CREATE POLICY "card_templates: owner update" ON card_templates FOR UPDATE USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = card_templates.deck_id AND d.user_id = current_profile_id())) WITH CHECK (EXISTS (SELECT 1 FROM decks d WHERE d.id = card_templates.deck_id AND d.user_id = current_profile_id()));
CREATE POLICY "card_templates: owner delete" ON card_templates FOR DELETE USING (EXISTS (SELECT 1 FROM decks d WHERE d.id = card_templates.deck_id AND d.user_id = current_profile_id()));
CREATE INDEX ON card_templates (deck_id);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON card_templates FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);

-- ── card_template_tags ────────────────────────────────
CREATE TABLE card_template_tags (
  template_id uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  tag_id      uuid NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  created_at  timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (template_id, tag_id)
);
ALTER TABLE card_template_tags ENABLE ROW LEVEL SECURITY;
CREATE POLICY "card_template_tags: read access" ON card_template_tags FOR SELECT USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = card_template_tags.template_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "card_template_tags: owner manages" ON card_template_tags FOR ALL USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = card_template_tags.template_id AND d.user_id = current_profile_id())) WITH CHECK (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = card_template_tags.template_id AND d.user_id = current_profile_id()));

-- ── template specifics (MCQ, FITB, Match Madness) ─────
CREATE TABLE multiple_choice_options (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id   uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  option_text   text NOT NULL,
  is_correct    bool NOT NULL DEFAULT false,
  display_order int  NOT NULL DEFAULT 0
);
ALTER TABLE multiple_choice_options ENABLE ROW LEVEL SECURITY;
CREATE POLICY "multiple_choice_options: read access" ON multiple_choice_options FOR SELECT USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = multiple_choice_options.template_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "multiple_choice_options: owner manages" ON multiple_choice_options FOR ALL USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = multiple_choice_options.template_id AND d.user_id = current_profile_id()));

CREATE TABLE fill_in_the_blank_segments (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  card_id        uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  full_text      text NOT NULL,
  blank_start    int  NOT NULL,
  blank_end      int  NOT NULL,
  correct_answer text NOT NULL,
  CONSTRAINT fitb_blank_order CHECK (blank_start < blank_end)
);
ALTER TABLE fill_in_the_blank_segments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "fitb_segments: read access" ON fill_in_the_blank_segments FOR SELECT USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = fill_in_the_blank_segments.card_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "fitb_segments: owner manages" ON fill_in_the_blank_segments FOR ALL USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = fill_in_the_blank_segments.card_id AND d.user_id = current_profile_id()));

CREATE TABLE match_madness_pairs (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id        uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  source_template_id uuid REFERENCES card_templates(id) ON DELETE SET NULL,
  term               text NOT NULL,
  match              text NOT NULL,
  is_auto_picked     bool NOT NULL DEFAULT false,
  display_order      int  NOT NULL DEFAULT 0
);
ALTER TABLE match_madness_pairs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "match_madness: read access" ON match_madness_pairs FOR SELECT USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = match_madness_pairs.template_id AND (d.visibility_state IN ('public', 'unlisted') OR d.user_id = current_profile_id())));
CREATE POLICY "match_madness: owner manages" ON match_madness_pairs FOR ALL USING (EXISTS (SELECT 1 FROM card_templates ct JOIN decks d ON d.id = ct.deck_id WHERE ct.id = match_madness_pairs.template_id AND d.user_id = current_profile_id()));

