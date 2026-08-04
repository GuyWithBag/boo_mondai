-- Store identification accepted answers as ordered answer objects instead of
-- comma-separated text.

CREATE OR REPLACE FUNCTION migrate_identification_accepted_answers(
  template_id uuid,
  accepted_answers text
)
RETURNS jsonb
LANGUAGE sql
AS $$
  SELECT CASE
    WHEN accepted_answers IS NULL OR btrim(accepted_answers) = '' THEN '[]'::jsonb
    ELSE (
      SELECT COALESCE(
        jsonb_agg(
          jsonb_build_object(
            'id', gen_random_uuid()::text,
            'template_id', template_id::text,
            'display_order', part.display_order - 1,
            'answer', btrim(part.answer),
            'casing_type', 'any'
          )
          ORDER BY part.display_order
        ),
        '[]'::jsonb
      )
      FROM unnest(string_to_array(accepted_answers, ',')) WITH ORDINALITY
        AS part(answer, display_order)
      WHERE btrim(part.answer) <> ''
    )
  END;
$$;

ALTER TABLE card_templates
ALTER COLUMN accepted_answers DROP DEFAULT;

ALTER TABLE card_templates
ALTER COLUMN accepted_answers TYPE jsonb
USING migrate_identification_accepted_answers(id, accepted_answers);

ALTER TABLE card_templates
ALTER COLUMN accepted_answers SET DEFAULT '[]'::jsonb;

DROP FUNCTION migrate_identification_accepted_answers(uuid, text);
