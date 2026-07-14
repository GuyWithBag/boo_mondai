-- ══════════════════════════════════════════════════════
-- CARD ATTACHMENT STORAGE
-- ══════════════════════════════════════════════════════

INSERT INTO storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
VALUES (
  'card-images',
  'card-images',
  true,
  10485760,
  ARRAY[
    'image/jpeg',
    'image/png',
    'image/webp',
    'audio/mpeg',
    'audio/ogg',
    'audio/wav'
  ]
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

DROP POLICY IF EXISTS "card-images: public read" ON storage.objects;
DROP POLICY IF EXISTS "card-images: owner insert" ON storage.objects;
DROP POLICY IF EXISTS "card-images: owner update" ON storage.objects;
DROP POLICY IF EXISTS "card-images: owner delete" ON storage.objects;

CREATE POLICY "card-images: public read"
ON storage.objects
FOR SELECT
USING (bucket_id = 'card-images');

CREATE POLICY "card-images: owner insert"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'card-images'
  AND (storage.foldername(name))[1] = 'users'
  AND (storage.foldername(name))[2] = current_profile_id()::text
);

CREATE POLICY "card-images: owner update"
ON storage.objects
FOR UPDATE
TO authenticated
USING (
  bucket_id = 'card-images'
  AND (storage.foldername(name))[1] = 'users'
  AND (storage.foldername(name))[2] = current_profile_id()::text
)
WITH CHECK (
  bucket_id = 'card-images'
  AND (storage.foldername(name))[1] = 'users'
  AND (storage.foldername(name))[2] = current_profile_id()::text
);

CREATE POLICY "card-images: owner delete"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'card-images'
  AND (storage.foldername(name))[1] = 'users'
  AND (storage.foldername(name))[2] = current_profile_id()::text
);
