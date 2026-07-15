# Applying the Stored Media / Sync Refactor Recommendations

This document describes how to apply the recommendations from:

- `documentation/stored_media_sync_refactor_review.md`
- `documentation/stored_media_sync_refactor_graphs.md`
- `documentation/architecture/project_file_patterns.md`

It is written as a step-by-step implementation plan plus a manual checklist.

## Refactor Goals

The target outcome:

1. Keep sync strategy generic.
2. Keep `DeckSyncSession` focused on session/dependency strategy assembly.
3. Move media upload workflows into feature services/preprocessors.
4. Centralize local and remote media path building.
5. Centralize stored-media upload execution.
6. Move profile avatar media logic out of `AuthController`.
7. Reduce subtype coupling in deck sync.
8. Preserve current behavior unless intentionally changed.

No backwards-compatibility shims are required unless explicitly needed for local
data migration.

## Target File Layout

Recommended new/changed files:

```text
lib/features/stored_media/stored_media_paths.helper.dart
lib/features/sync_deck/sync_preprocessors/sync_deck.deck_media_preprocessor.dart
lib/features/sync_deck/sync_preprocessors/sync_deck.deck_listing_media_preprocessor.dart
lib/features/sync_deck/sync_preprocessors/sync_deck.card_template_media_preprocessor.dart
lib/features/sync_deck/sync_preprocessors/sync_deck.card_template_media_fields.helper.dart
lib/features/profile/profile_media.service.dart
lib/core/helpers/media_remote_paths.helper.dart
lib/core/services/stored_media_upload.service.dart
```

`sync_deck` is treated as its own feature-specific domain. Generic utilities
that do not naturally belong to deck sync go to `core`.

Each new folder should have a `.barrel.dart`, and exports should roll up to
`lib.barrel.dart`. Consumers should import from `lib.barrel.dart` using `show`.

Possible rename later:

```text
BucketSupabaseRemoteDB -> SupabaseStorageBucket
PublicBucketRemoteDB -> PublicMediaStorage
PrivateBucketRemoteDB -> PrivateMediaStorage
```

Do renames only if you are ready to update all imports and documentation.

## Phase 1: Extract Local Stored Media Paths

### Problem

Local media paths are constructed in multiple places:

- `FolderPaths.deckCoverImage(...)`
- `FolderPaths.deckListingFeaturedImage(...)`
- UI toolbar callbacks building `StoredMediaPath.folder(...)`
- `AuthController` using `StoredMediaPath.app(name: 'profileAvatar')`

This spreads domain path rules across helpers, pages, and controllers.

### Implementation

Create:

```text
lib/features/stored_media/stored_media_paths.helper.dart
```

Recommended API:

```dart
abstract final class StoredMediaPathHelper {
  /// Returns the local stored-media path for a deck cover image.
  static StoredMediaPath deckCoverImage({required String deckTitle}) { ... }

  /// Returns the local stored-media path for a listing featured image.
  static StoredMediaPath deckListingFeaturedImage({
    required String deckTitle,
    required int index,
  }) { ... }

  /// Returns the local stored-media path for a markdown attachment.
  static StoredMediaPath deckAttachment({
    required String deckTitle,
    required String fileName,
  }) { ... }

  /// Returns the singleton local stored-media path for the current profile avatar.
  static StoredMediaPath profileAvatar() { ... }
}
```

If you decide to move away from deck-title local paths, use deck ids:

```dart
static StoredMediaPath deckCoverImage({required String deckId}) { ... }
```

But that is a behavioral/local-data migration decision. Do it deliberately.

### Replace usages

Replace:

```dart
FolderPaths.deckCoverImage(deck.title).toStoredMediaPath()
```

with:

```dart
StoredMediaPathHelper.deckCoverImage(deckTitle: deck.title)
```

Replace toolbar-created paths:

```dart
StoredMediaPath.folder(
  folderPath: '${deck.title}/media',
  name: FileHelper.fileNameWithoutExtension(file.name),
)
```

with:

```dart
StoredMediaPathHelper.deckAttachment(
  deckTitle: deck.title,
  fileName: file.name,
)
```

Replace:

```dart
const StoredMediaPath.app(name: 'profileAvatar')
```

with:

```dart
StoredMediaPathHelper.profileAvatar()
```

### Manual checklist

- [ ] Create `StoredMediaPathHelper`.
- [ ] Add doc comments to public helper methods.
- [ ] Export it through folder barrels up to `lib.barrel.dart`.
- [ ] Move deck cover path logic into it.
- [ ] Move featured image path logic into it.
- [ ] Move markdown attachment path logic into it.
- [ ] Move profile avatar path logic into it.
- [ ] Replace path construction in deck services.
- [ ] Replace path construction in markdown toolbar call sites.
- [ ] Replace path construction in auth/profile code.
- [ ] Decide whether `FolderPaths` should remain or be renamed/removed.

## Phase 2: Extract Remote Media Paths

### Problem

Remote bucket paths are raw strings spread across sync/profile code.

These paths are security-sensitive because storage RLS expects:

```text
users/{profileId}/...
```

### Implementation

Create:

```text
lib/core/helpers/media_remote_paths.helper.dart
```

Recommended API:

```dart
abstract final class MediaRemotePathHelper {
  /// Returns the public bucket object path for a deck cover image.
  static String deckCoverImage({
    required String profileId,
    required String deckId,
  }) { ... }

  static String deckListingFeaturedImage({
    required String profileId,
    required String deckId,
    required int index,
  }) { ... }

  static String deckMarkdownAttachment({
    required String profileId,
    required String deckId,
    required String fileName,
  }) { ... }

  static String cardMarkdownAttachment({
    required String profileId,
    required String deckId,
    required String templateId,
    required String field,
    required String fileName,
  }) { ... }

  static String cardMediaField({
    required String profileId,
    required String deckId,
    required String templateId,
    required String field,
    required String fileName,
  }) { ... }

  static String profileAvatar({required String profileId}) { ... }
}
```

Also include a filename helper if useful:

```dart
static String fileNameFromStoredMedia(StoredMedia storedMedia, int index) { ... }
```

### Replace usages

Replace:

```dart
'users/$userId/decks/${deck.id}/cover'
```

with:

```dart
MediaRemotePathHelper.deckCoverImage(
  profileId: userId,
  deckId: deck.id,
)
```

Replace:

```dart
'users/${profile.id}/profile/avatar'
```

with:

```dart
MediaRemotePathHelper.profileAvatar(profileId: profile.id)
```

### Manual checklist

- [ ] Create `MediaRemotePathHelper`.
- [ ] Add doc comments explaining that `users/{profileId}` is required by storage RLS.
- [ ] Export it through core barrels up to `lib.barrel.dart`.
- [ ] Move deck cover remote path.
- [ ] Move featured image remote path.
- [ ] Move deck markdown remote path.
- [ ] Move card markdown remote path.
- [ ] Move card explicit media remote path.
- [ ] Move profile avatar remote path.
- [ ] Confirm every returned path starts with `users/{profileId}/`.
- [ ] Remove raw storage path string construction from feature workflows.

## Phase 3: Extract Stored Media Upload Executor

### Problem

`SyncMediaReferenceApplier` and `SyncMediaSourceApplier` duplicate:

- file lookup
- file read
- bucket upload
- `StoredMedia.remoteUrl` update

### Implementation

Create:

```text
lib/core/services/stored_media_upload.service.dart
```

Recommended API:

```dart
abstract final class StoredMediaUploadService {
  /// Uploads a local stored-media file and records the returned remote value.
  static Future<String?> upload({
    required StoredMedia storedMedia,
    required BucketSupabaseRemoteDB bucket,
    required String remotePath,
    bool upsert = true,
  }) async { ... }
}
```

Behavior:

1. Check local file exists.
2. Read bytes.
3. Upload through bucket.
4. Mark stored media as uploaded.
5. Return uploaded bucket value.
6. Return `null` if the local file does not exist.

Move this logic out of:

- `SyncMediaReferenceApplier`
- `SyncMediaSourceApplier`

Also move:

```dart
SyncMediaReferenceApplier.updateStoredMediaRemoteUrl(...)
```

to:

```dart
StoredMediaService.markUploaded(...)
```

or:

```dart
StoredMediaUploadService.markUploaded(...)
```

Preferred: `StoredMediaService.markUploaded`, because the operation updates
stored-media metadata.

### Manual checklist

- [ ] Create `StoredMediaUploadService`.
- [ ] Add `StoredMediaService.markUploaded`.
- [ ] Add concise doc comments to both public APIs.
- [ ] Export through barrels up to `lib.barrel.dart`.
- [ ] Update `SyncMediaReferenceApplier` to resolve by path only, then delegate upload.
- [ ] Update `SyncMediaSourceApplier` to resolve by source only, then delegate upload.
- [ ] Remove duplicate `File(...).readAsBytes()` logic from both appliers.
- [ ] Run targeted analyzer.

## Phase 4: Move Deck Media Preprocessing Out of `DeckSyncSession`

### Problem

`DeckSyncSession` directly preprocesses deck cover and deck markdown.

### Implementation

Create:

```text
lib/features/sync_deck/sync_preprocessors/sync_deck.deck_media_preprocessor.dart
```

Recommended API:

```dart
abstract final class DeckMediaSyncPreprocessor {
  /// Uploads deck-owned local media before the deck row is pushed remotely.
  static Future<Deck> preprocessPushItem({
    required Deck deck,
    required DeckSyncSession session,
  }) async { ... }
}
```

Move from `DeckSyncSession`:

- cover reference building
- deck long-description markdown upload/rewrite
- deck cover upload predicate if it remains deck-specific

Then in `DeckSyncSession`:

```dart
preprocessPushItem: (deck, session) =>
    DeckMediaSyncPreprocessor.preprocessPushItem(
      deck: deck,
      session: session,
    ),
```

### Manual checklist

- [ ] Create `DeckMediaSyncPreprocessor`.
- [ ] Create/update `lib/features/sync_deck/sync_deck.barrel.dart`.
- [ ] Export `sync_deck` through `features.barrel.dart` and `lib.barrel.dart`.
- [ ] Move `_preprocessDeckPushItem`.
- [ ] Replace raw paths with `StoredMediaPathHelper` and `MediaRemotePathHelper`.
- [ ] Remove deck media helper methods from `DeckSyncSession`.
- [ ] Confirm deck sync still passes `remoteStorage`/bucket dependency.
- [ ] Run targeted analyzer.

## Phase 5: Move Deck Listing Media Preprocessing Out

### Problem

`DeckSyncSession` directly preprocesses featured images.

### Implementation

Create:

```text
lib/features/sync_deck/sync_preprocessors/sync_deck.deck_listing_media_preprocessor.dart
```

Recommended API:

```dart
abstract final class DeckListingMediaSyncPreprocessor {
  /// Uploads deck-listing local media before the listing row is pushed remotely.
  static Future<DeckListing> preprocessPushItem({
    required DeckListing listing,
    required DeckSyncSession session,
  }) async { ... }
}
```

Move from `DeckSyncSession`:

- `_preprocessDeckListingPushItem`
- `_deckListingFeaturedImageReference`
- featured image remote path building
- featured image local path building

### Manual checklist

- [ ] Create `DeckListingMediaSyncPreprocessor`.
- [ ] Export it through `sync_deck.barrel.dart`.
- [ ] Move listing featured image preprocessing.
- [ ] Replace path construction with helpers.
- [ ] Remove listing media methods from `DeckSyncSession`.
- [ ] Run targeted analyzer.

## Phase 6: Move Card Template Media Preprocessing Out

### Problem

`DeckSyncSession` knows every card template subtype and every media/text field.

### Implementation

Create:

```text
lib/features/sync_deck/sync_preprocessors/sync_deck.card_template_media_preprocessor.dart
lib/features/sync_deck/sync_preprocessors/sync_deck.card_template_media_fields.helper.dart
```

`CardTemplateMediaSyncPreprocessor` should own:

```dart
/// Uploads card-template local media before the template row is pushed remotely.
static Future<CardTemplate> preprocessPushItem({
  required CardTemplate template,
  required DeckSyncSession session,
})
```

`CardTemplateMediaFieldsHelper` should own subtype-specific field descriptors.

Possible descriptor classes:

```dart
class MarkdownMediaField<T> {
  final String name;
  final String Function(T item) read;
  final T Function(T item, String value) write;
}

class MediaSourceField<T> {
  final String name;
  final String? Function(T item) read;
  final T Function(T item, String? value) write;
}
```

The preprocessor can:

1. Ask helper for markdown fields.
2. Ask helper for media source fields.
3. Loop fields.
4. Upload/rewrite.
5. Return updated template.

This keeps subtype knowledge out of `DeckSyncSession`. Keep these descriptors in
`sync_deck` while they are sync-only. Move them to `features/cards` only if they
become general card-template metadata.

### Manual checklist

- [ ] Create `CardTemplateMediaSyncPreprocessor`.
- [ ] Create field descriptor classes.
- [ ] Create `CardTemplateMediaFieldsHelper`.
- [ ] Keep each descriptor class/enum in its own file unless it is only a typedef.
- [ ] Add doc comments to descriptor classes explaining how read/write callbacks work.
- [ ] Use `get*`/`set*` names for getter/setter-like callback fields.
- [ ] Move subtype switch out of `DeckSyncSession`.
- [ ] Replace `dynamic` lists with concrete descriptor loops.
- [ ] Replace path construction with `MediaRemotePathHelper`.
- [ ] Run targeted analyzer.

## Phase 7: Move Profile Avatar Logic Out of `AuthController`

### Problem

`AuthController` directly constructs storage upload behavior.

### Implementation

Create:

```text
lib/features/profile/profile_media.service.dart
```

Recommended API:

```dart
abstract final class ProfileMediaService {
  /// Stores a picked avatar file locally and updates the local profile timestamp.
  static Future<Profile?> saveAvatarImage({
    required Profile profile,
    required PlatformFile file,
  }) async { ... }

  /// Uploads a pending local avatar and rewrites `Profile.avatarUrl`.
  static Future<Profile> uploadAvatarIfNeeded({
    required Profile profile,
    required BucketSupabaseRemoteDB bucket,
  }) async { ... }
}
```

Then `AuthController.updateAvatarImage` becomes:

```dart
var updated = await ProfileMediaService.saveAvatarImage(
  profile: currentProfile,
  file: file,
);
if (updated == null) return;

if (AuthService.isAuthenticatedRemote) {
  updated = await ProfileMediaService.uploadAvatarIfNeeded(
    profile: updated,
    bucket: RemoteDB.publicBucket,
  );
  await RemoteDB.profile.upsert(updated);
}
notifyListeners();
```

Also update `updateDisplayName` if you still want it to opportunistically upload
pending avatar media before profile remote upsert.

### Manual checklist

- [ ] Create `ProfileMediaService`.
- [ ] Export it through profile barrels up to `lib.barrel.dart`.
- [ ] Move avatar local save into it.
- [ ] Move avatar upload into it.
- [ ] Replace profile avatar path with `StoredMediaPathHelper.profileAvatar`.
- [ ] Replace remote path with `MediaRemotePathHelper.profileAvatar`.
- [ ] Remove `SyncMediaReference` construction from `AuthController`.
- [ ] Run targeted analyzer.

## Phase 8: Decide Bucket Strategy

### Option A: Public-only media

Use this if all current media is intended to be publicly readable when linked.

Actions:

- [ ] Remove `PrivateBucketRemoteDB`.
- [ ] Remove `Env.privateMediaBucket`.
- [ ] Simplify migration if not already applied.
- [ ] Rename bucket classes if desired.
- [ ] Update docs to say the app currently only supports public media.

### Option B: Public/private media

Use this if private media is a real requirement.

Actions:

- [ ] Keep private bucket.
- [ ] Rename `remoteUrl` to something neutral like `remoteReference`.
- [ ] Add signed URL display flow.
- [ ] Store private bucket paths, not public URLs.
- [ ] Add media visibility/purpose model.

Do not rely on folder RLS in a public bucket for private reads. Public bucket
objects are publicly readable.

## Phase 9: Improve Markdown Rewriting

### Problem

The current markdown rewriter is regex-based.

### Implementation options

Short-term:

- [ ] Rename or document it as simple inline markdown only.
- [ ] Add tests for simple image/link attachments.
- [ ] Add tests for URLs with parentheses so limitations are visible.

Long-term:

- [ ] Use a markdown AST parser if available.
- [ ] Rewrite only image/link destination nodes.
- [ ] Preserve labels/titles/escaping.

## Phase 10: Define Media Cleanup

### Problem

Upload exists, cleanup does not.

### Define behavior for:

- replacing cover image
- replacing featured image
- removing markdown attachment
- deleting deck
- deleting card template
- deleting profile avatar
- deleting local cached media only
- deleting remote bucket object

### Possible implementation

Create:

```text
lib/features/stored_media/stored_media_cleanup.service.dart
```

or feature-specific cleanup services:

```text
lib/features/decks/deck_media_cleanup.service.dart
lib/features/profile/profile_media_cleanup.service.dart
```

Manual checklist:

- [ ] Decide whether old remote files are deleted immediately on replacement.
- [ ] Decide whether deletion is best-effort or tracked/retried.
- [ ] Decide whether local cache deletion should delete remote media.
- [ ] Add cleanup to deck cascade deletion if desired.
- [ ] Add cleanup to profile avatar deletion/replacement if desired.

## Final Target `DeckSyncSession`

After the refactor, `DeckSyncSession` should mostly look like:

```dart
NewestWinsSyncStrategy<Deck>(
  ...
  preprocessPushItem: (deck, session) =>
      DeckMediaSyncPreprocessor.preprocessPushItem(
        deck: deck,
        session: session,
      ),
)
```

```dart
NewestWinsSyncStrategy<DeckListing>(
  ...
  preprocessPushItem: (listing, session) =>
      DeckListingMediaSyncPreprocessor.preprocessPushItem(
        listing: listing,
        session: session,
      ),
)
```

```dart
NewestWinsSyncStrategy<CardTemplate>(
  ...
  preprocessPushItem: (template, session) =>
      CardTemplateMediaSyncPreprocessor.preprocessPushItem(
        template: template,
        session: session,
      ),
)
```

The session can still assemble strategies, but it should not know the details of
every media field.

## Manual Master Checklist

### Barrels and files

- [ ] Every new folder has a `.barrel.dart`.
- [ ] New public files export upward to `lib.barrel.dart`.
- [ ] New consumers import from `lib.barrel.dart` using `show`.
- [ ] Each class/enum/model/helper/service lives in a separate file.
- [ ] Typedefs may stay beside their tightly scoped usage.

### Path helpers

- [ ] Add `StoredMediaPathHelper`.
- [ ] Add `MediaRemotePathHelper`.
- [ ] Remove raw local path construction from UI/controller code.
- [ ] Remove raw remote path construction from sync/profile code.

### Upload execution

- [ ] Add `StoredMediaUploadService`.
- [ ] Add `StoredMediaService.markUploaded`.
- [ ] Make reference/source appliers delegate to upload service.
- [ ] Remove duplicate file read/upload code.

### Preprocessors

- [ ] Add `DeckMediaSyncPreprocessor`.
- [ ] Add `DeckListingMediaSyncPreprocessor`.
- [ ] Add `CardTemplateMediaSyncPreprocessor`.
- [ ] Add `CardTemplateMediaFieldsHelper`.
- [ ] Remove card subtype switch from `DeckSyncSession`.

### Profile

- [ ] Add `ProfileMediaService`.
- [ ] Remove bucket/media-reference construction from `AuthController`.
- [ ] Confirm profile avatar still uploads before remote profile upsert.

### Bucket decision

- [ ] Decide public-only vs public/private.
- [ ] Remove speculative private bucket if not needed.
- [ ] If private remains, rename `remoteUrl` and implement signed URL rendering.

### Markdown

- [ ] Decide if regex parser is acceptable.
- [ ] Add tests around markdown rewriting.
- [ ] Consider AST-based rewrite later.

### Cleanup

- [ ] Define remote media deletion behavior.
- [ ] Define local cached media deletion behavior.
- [ ] Add cleanup service if required.

### Validation

- [ ] Run `dart format` on changed files.
- [ ] Run targeted `dart analyze` on changed files.
- [ ] Run `flutter analyze` and separate existing warnings from new issues.
- [ ] Test cover image upload.
- [ ] Test featured image upload.
- [ ] Test deck long-description markdown attachment upload.
- [ ] Test card markdown attachment upload.
- [ ] Test explicit card image/audio upload.
- [ ] Test profile avatar upload.
