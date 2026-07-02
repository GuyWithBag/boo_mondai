ALTER TABLE card_template_attachments
  RENAME COLUMN kind TO type;

ALTER TABLE card_template_attachments
  ADD COLUMN label text,
  ADD COLUMN attachment_source text NOT NULL DEFAULT 'media',
  ADD COLUMN url text,
  ALTER COLUMN storage_path DROP NOT NULL;

UPDATE card_template_attachments
SET mime_type = 'application/octet-stream'
WHERE mime_type IS NULL;

UPDATE card_template_attachments
SET label = 'new-file-' || row_number
FROM (
  SELECT id, row_number() OVER (PARTITION BY template_id ORDER BY created_at, id) AS row_number
  FROM card_template_attachments
) numbered
WHERE card_template_attachments.id = numbered.id
  AND card_template_attachments.label IS NULL;

ALTER TABLE card_template_attachments
  ALTER COLUMN label SET NOT NULL,
  ADD CONSTRAINT card_template_attachments_source_check
    CHECK (attachment_source IN ('media', 'link')),
  ADD CONSTRAINT card_template_attachments_type_check
    CHECK (type IN ('image', 'audio')),
  ADD CONSTRAINT card_template_attachments_media_shape_check
    CHECK (
      (attachment_source = 'media' AND storage_path IS NOT NULL AND mime_type IS NOT NULL AND url IS NULL)
      OR
      (attachment_source = 'link' AND url IS NOT NULL AND storage_path IS NULL AND mime_type IS NULL)
    );
