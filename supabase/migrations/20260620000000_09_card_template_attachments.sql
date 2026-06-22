-- ══════════════════════════════════════════════════════
-- CARD TEMPLATE MEDIA ATTACHMENTS
-- ══════════════════════════════════════════════════════

CREATE TABLE card_template_attachments (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id  uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  kind         text NOT NULL CHECK (kind IN ('image', 'audio')),
  storage_path text NOT NULL,
  public_url   text,
  mime_type    text,
  alt_text     text,
  created_at   timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE card_template_attachments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "card_template_attachments: read access"
ON card_template_attachments
FOR SELECT
USING (
  EXISTS (
    SELECT 1
    FROM card_templates ct
    JOIN decks d ON d.id = ct.deck_id
    WHERE ct.id = card_template_attachments.template_id
      AND (
        d.visibility_state IN ('public', 'unlisted')
        OR d.user_id = current_profile_id()
      )
  )
);

CREATE POLICY "card_template_attachments: owner manages"
ON card_template_attachments
FOR ALL
USING (
  EXISTS (
    SELECT 1
    FROM card_templates ct
    JOIN decks d ON d.id = ct.deck_id
    WHERE ct.id = card_template_attachments.template_id
      AND d.user_id = current_profile_id()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM card_templates ct
    JOIN decks d ON d.id = ct.deck_id
    WHERE ct.id = card_template_attachments.template_id
      AND d.user_id = current_profile_id()
  )
);

CREATE INDEX ON card_template_attachments (template_id);
