# Image sync problem

## Current behavior

Deck sync currently handles card template attachments, but it does not fully handle deck-level images.

### Card template attachments

Card template attachments are synced by `CardAttachmentSyncStrategy`.

For local media attachments, the strategy uploads the local file to Supabase Storage before writing the remote attachment row. After upload, it stores the remote storage path / public URL back into the attachment.

So card template attachments are covered by sync.

### Deck cover image

Deck cover images are not fully synced.

`Deck.coverImageUrl` is currently treated as a normal deck field. If it already contains a remote path or remote URL, it can be synced as part of the `decks` row.

But if `coverImageUrl` points to a local image file, `DecksRemoteDB.toMap()` explicitly writes `cover_image_url` as `null` instead of uploading the image.

That means local deck cover images are not uploaded during deck sync.

### Deck listing featured images

Deck listing featured images have the same problem.

`DeckListingsRemoteDB.toMap()` filters `featuredImages` down to remote paths only. Local image paths are discarded for remote writes.

That means local featured images are not uploaded during deck sync.

## Summary

```txt
Card template attachments      yes, uploaded and synced
Deck cover image               no, local image is not uploaded
Deck listing featured images   no, local images are not uploaded
Remote image URLs              yes, synced as normal fields
```

## Recommended fix

Do not force image upload behavior into the generic row sync blindly. Media needs a pre-upload step before the row is written remotely.

Before pushing a `Deck`:

1. Check whether `coverImageUrl` is a local path.
2. If it is local, upload the file to Supabase Storage.
3. Replace `coverImageUrl` with the remote storage path / public URL.
4. Upsert the remote deck row.
5. Update the local deck row with the remote image reference.

Before pushing a `DeckListing`:

1. Check each `featuredImages` entry.
2. Upload local image paths to Supabase Storage.
3. Replace local paths with remote storage paths / public URLs.
4. Upsert the remote deck listing row.
5. Update the local listing row with the remote image references.

## Availability check requirement

`doesItNeedSync` / `DeckSyncAvailabilitySnapshot` must also detect local images that need upload.

Timestamps alone are not enough because the row may already exist remotely while the local image field still points to a local-only file.

The sync availability check should treat these as needing sync:

- `Deck.coverImageUrl` is a local path.
- Any `DeckListing.featuredImages` entry is a local path.

## Implementation direction

The cleanest implementation is to mirror the attachment approach:

- keep generic row comparison for normal data;
- add image preparation before remote upsert;
- make the local row store the remote image reference after a successful upload;
- make the availability snapshot aware of local images that still need upload.

