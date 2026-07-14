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

DROP POLICY IF EXISTS "public-media: public read" ON storage.objects;
DROP POLICY IF EXISTS "public-media: owner insert" ON storage.objects;
DROP POLICY IF EXISTS "public-media: owner update" ON storage.objects;
DROP POLICY IF EXISTS "public-media: owner delete" ON storage.objects;
DROP POLICY IF EXISTS "private-media: owner read" ON storage.objects;
DROP POLICY IF EXISTS "private-media: owner insert" ON storage.objects;
DROP POLICY IF EXISTS "private-media: owner update" ON storage.objects;
DROP POLICY IF EXISTS "private-media: owner delete" ON storage.objects;

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
