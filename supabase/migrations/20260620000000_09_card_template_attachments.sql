-- ══════════════════════════════════════════════════════
-- CARD TEMPLATE MEDIA ATTACHMENTS
-- ══════════════════════════════════════════════════════

CREATE TABLE card_template_attachments (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id       uuid NOT NULL REFERENCES card_templates(id) ON DELETE CASCADE,
  type              text NOT NULL CHECK (type IN ('image', 'audio')),
  label             text NOT NULL,
  attachment_source text NOT NULL DEFAULT 'media',
  storage_path      text,
  public_url        text,
  url               text,
  mime_type         text,
  alt_text          text,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT card_template_attachments_source_check
    CHECK (attachment_source IN ('media', 'link')),
  CONSTRAINT card_template_attachments_media_shape_check
    CHECK (
      (attachment_source = 'media' AND storage_path IS NOT NULL AND mime_type IS NOT NULL AND url IS NULL)
      OR
      (attachment_source = 'link' AND url IS NOT NULL AND storage_path IS NULL AND mime_type IS NULL)
    )
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
        OR d.profile_id = current_profile_id()
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
      AND d.profile_id = current_profile_id()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM card_templates ct
    JOIN decks d ON d.id = ct.deck_id
    WHERE ct.id = card_template_attachments.template_id
      AND d.profile_id = current_profile_id()
  )
);

CREATE INDEX ON card_template_attachments (template_id);
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON card_template_attachments
  FOR EACH ROW
  EXECUTE FUNCTION extensions.moddatetime(updated_at);

-- ══════════════════════════════════════════════════════
-- PUBLIC / PRIVATE MEDIA STORAGE
-- ══════════════════════════════════════════════════════

INSERT INTO storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
VALUES
  (
    'public-media',
    'public-media',
    true,
    10485760,
    ARRAY[
      'image/jpeg',
      'image/png',
      'image/webp',
      'audio/mpeg',
      'audio/ogg',
      'audio/wav',
      'video/mp4',
      'video/webm'
    ]
  ),
  (
    'private-media',
    'private-media',
    false,
    10485760,
    ARRAY[
      'image/jpeg',
      'image/png',
      'image/webp',
      'audio/mpeg',
      'audio/ogg',
      'audio/wav',
      'video/mp4',
      'video/webm'
    ]
  )
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

CREATE POLICY "public-media: public read"
ON storage.objects
FOR SELECT
USING (bucket_id = 'public-media');

CREATE POLICY "public-media: owner insert"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'public-media'
  AND (storage.foldername(name))[1] = 'users'
  AND (storage.foldername(name))[2] = current_profile_id()::text
);

CREATE POLICY "public-media: owner update"
ON storage.objects
FOR UPDATE
TO authenticated
USING (
  bucket_id = 'public-media'
  AND (storage.foldername(name))[1] = 'users'
  AND (storage.foldername(name))[2] = current_profile_id()::text
)
WITH CHECK (
  bucket_id = 'public-media'
  AND (storage.foldername(name))[1] = 'users'
  AND (storage.foldername(name))[2] = current_profile_id()::text
);

CREATE POLICY "public-media: owner delete"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'public-media'
  AND (storage.foldername(name))[1] = 'users'
  AND (storage.foldername(name))[2] = current_profile_id()::text
);

CREATE POLICY "private-media: owner read"
ON storage.objects
FOR SELECT
TO authenticated
USING (
  bucket_id = 'private-media'
  AND (storage.foldername(name))[1] = 'users'
  AND (storage.foldername(name))[2] = current_profile_id()::text
);

CREATE POLICY "private-media: owner insert"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'private-media'
  AND (storage.foldername(name))[1] = 'users'
  AND (storage.foldername(name))[2] = current_profile_id()::text
);

CREATE POLICY "private-media: owner update"
ON storage.objects
FOR UPDATE
TO authenticated
USING (
  bucket_id = 'private-media'
  AND (storage.foldername(name))[1] = 'users'
  AND (storage.foldername(name))[2] = current_profile_id()::text
)
WITH CHECK (
  bucket_id = 'private-media'
  AND (storage.foldername(name))[1] = 'users'
  AND (storage.foldername(name))[2] = current_profile_id()::text
);

CREATE POLICY "private-media: owner delete"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'private-media'
  AND (storage.foldername(name))[1] = 'users'
  AND (storage.foldername(name))[2] = current_profile_id()::text
);
