# Stored Media / Sync Refactor Review

This document lists naming issues, coupling, over-abstractions, duplicated logic,
and questionable design boundaries in the current stored-media and sync upload
implementation.

Scope is intentionally limited to:

- local stored media
- Supabase bucket media upload
- deck/card/profile media sync
- markdown attachment rewriting
- sync preview/apply interaction around media

It does not review unrelated app sync behavior except where stored media touches
it.

## High-Priority Issues

### `DeckSyncSession` is doing too much

`DeckSyncSession` should live in the dedicated deck-sync feature domain:

```text
lib/features/sync_deck/
```

The current session owns all of this:

- sync dependency container
- sync strategy construction
- deck cover upload preprocessing
- deck listing featured image upload preprocessing
- markdown upload/rewrite for deck descriptions
- card-template subtype dispatch
- card-template markdown field upload/rewrite
- card-template explicit media field upload
- remote storage path construction
- local stored-media upload predicate logic

This is too much coupling in one class.

The class name says "session", but the file behaves like:

- a dependency graph
- a sync strategy factory
- a media sync service
- a card-template media visitor
- a bucket path builder

Recommended split:

| Current responsibility | Better owner |
|---|---|
| `DeckSyncSession` constructor dependencies | `DeckSyncSession` |
| `getStrategies()` | `DeckSyncStrategyFactory` or keep in session if intentionally lightweight |
| Deck media preprocessing | `DeckMediaSyncPreprocessor` |
| Deck listing media preprocessing | `DeckListingMediaSyncPreprocessor` |
| Card template media preprocessing | `CardTemplateMediaSyncPreprocessor` |
| Bucket path strings | `MediaRemotePaths` in `core` |
| Upload predicate | shared media upload policy/helper in `core` if generic |

The main reason to split this is not style. The current file makes it too easy
to add more media/entity-specific sync behavior into the session until it
becomes the sync god object.

### Card media preprocessing is tightly coupled to every card subtype

`DeckSyncSession` currently switches over:

- `FlashcardTemplate`
- `IdentificationTemplate`
- `MultipleChoiceTemplate`
- `WordScrambleTemplate`
- `FillInTheBlanksTemplate`
- `MatchMadnessTemplate`

That means every new card type requires editing deck sync internals.

This is a feature coupling problem:

```text
sync_deck/sync_deck.session.dart
  knows every card template subtype
  knows every markdown-bearing field
  knows every media-bearing field
```

Better options:

1. Add a card-template media descriptor/visitor in `sync_deck` if it is only
   used for sync upload behavior.

   Example shape:

   ```dart
   abstract final class CardTemplateMediaReferences {
     static Future<CardTemplate> uploadMedia(...)
   }
   ```

2. Push field descriptors closer to the models.

   Example shape:

   ```dart
   extension CardTemplateMediaFields on CardTemplate {
     List<MarkdownMediaField<CardTemplate>> get markdownMediaFields;
     List<MediaSourceField<CardTemplate>> get mediaSourceFields;
   }
   ```

3. Use a visitor object for card-template subtypes.

   If the descriptors become general card metadata, move them to
   `lib/features/cards/`. If they only exist for deck-sync upload behavior,
   keep them in `lib/features/sync_deck/`.

Current risk: deck sync becomes the central place that must understand every
new learning/card feature.

### Profile avatar upload is in `AuthController`

`AuthController.updateAvatarImage` now handles:

- storing a local file
- uploading media to Supabase Storage
- updating `StoredMedia.remoteUrl`
- rewriting `Profile.avatarUrl`
- remote profile upsert

That is too much persistence/storage logic in a UI/controller class.

Better owner:

```text
ProfileMediaService
ProfileAvatarService
ProfileSyncService
```

Recommended shape:

```dart
final updated = await ProfileMediaService.saveAvatar(file);
await ProfileMediaService.uploadAvatarIfAuthenticated(updated);
```

or:

```dart
await ProfileService.updateAvatarImage(file);
```

The controller should coordinate UI state and call a service. It should not
construct `SyncMediaReference<Profile>` directly.

### `SyncMediaReferenceApplier` reaches into `LocalDB`

`SyncMediaReferenceApplier.updateStoredMediaRemoteUrl` directly calls:

```dart
LocalDB.storedMedia.upsert(...)
```

This couples a generic sync helper to the global local database singleton.

Problems:

- Harder to test.
- Hidden side effect.
- Makes the helper less generic than the name implies.
- Prevents use with a different stored-media repository.

Better shape:

```dart
SyncMediaReferenceApplier.apply(
  storedMediaDb: LocalDB.storedMedia,
  ...
)
```

or move the update method into `StoredMediaService`:

```dart
StoredMediaService.markUploaded(storedMedia, remoteUrl)
```

The latter is probably better because updating stored media metadata is a
stored-media concern, not a sync-media-reference concern.

### `SyncMediaSourceApplier` duplicates upload logic

`SyncMediaReferenceApplier` and `SyncMediaSourceApplier` both do the same core
steps:

1. Find `StoredMedia`.
2. Read file bytes.
3. Upload bytes to bucket.
4. Update `StoredMedia.remoteUrl`.
5. Return uploaded value.

They only differ in how the stored media is found:

- by `StoredMediaFile`
- by source string (`local:` or remote URL)

This repeated upload pipeline should be in one lower-level helper.

Recommended shape:

```dart
StoredMediaUploadService.upload(
  storedMedia: storedMedia,
  bucket: bucket,
  remotePath: remotePath,
  upsert: upsert,
)
```

Then:

```dart
SyncMediaReferenceApplier
  -> resolve by StoredMediaFile
  -> StoredMediaUploadService.upload(...)

SyncMediaSourceApplier
  -> resolve by source
  -> StoredMediaUploadService.upload(...)
```

This would remove duplicate file-read/upload/update behavior.

### Markdown parsing with regex is fragile

`SyncMarkdownMediaApplier` uses:

```dart
r'(!?\[[^\]]*\]\()([^)]+)(\))'
```

This works for simple markdown links/images but will fail or behave incorrectly
for valid markdown cases such as:

- URLs with `)` characters
- escaped brackets
- nested brackets in labels
- reference-style markdown links
- autolinks
- images inside links
- titles: `![alt](url "title")`

This may be acceptable as a short-term helper, but it should be marked as a
limited parser.

Better options:

1. Use the markdown package AST if available from the existing markdown stack.
2. Create a small parser specifically for inline link/image destinations.
3. Explicitly document that only simple inline links/images are rewritten.

If the app allows user-authored markdown, silent incorrect rewrites can corrupt
content.

### Sync preview may not show media-upload rewrites accurately

The media upload and entity rewrite happen during sync apply, not preview.
That is correct because preview must not upload remote files.

But the preview may show the entity as it exists before media rewrite. Example:

```text
coverImageUrl still points to old remote URL
StoredMedia has new local file pending upload
preview shows changed deck/listing fields without showing the future URL rewrite
apply uploads and mutates entity
```

This is not necessarily wrong, but it should be intentional.

Possible improvement:

- preview should show "media upload pending" as a changed property or metadata
- do not show the final URL since it does not exist yet
- show a stable label like `coverImageUrl: pending media upload`

This would make review/apply behavior less surprising.

## Naming Issues

### `remoteStorage`

In `DeckSyncSession`, the bucket dependency is named:

```dart
final PublicBucketRemoteDB remoteStorage;
```

Issues:

- "remote storage" is vague.
- Type is specifically public bucket.
- If private bucket support remains, this name hides which bucket is being used.

Better names:

```dart
publicMediaBucket
mediaBucket
deckMediaBucket
```

If only public media will be supported, use:

```dart
publicMediaBucket
```

### `BucketSupabaseRemoteDB`

The class name mirrors `SupabaseRemoteDB`, but storage buckets are not DBs.

Current:

```dart
BucketSupabaseRemoteDB
PublicBucketRemoteDB
PrivateBucketRemoteDB
```

Potentially better:

```dart
SupabaseStorageBucket
PublicMediaStorage
PrivateMediaStorage
SupabaseBucketStorage
```

The current name was chosen for consistency with repository naming, but it still
blurs "DB table repository" and "storage bucket client".

If you want stricter naming, remove `DB` from bucket classes.

### `uploadImage`

`BucketSupabaseRemoteDB` exposes both:

```dart
uploadBytes(...)
uploadImage(...)
```

But `uploadImage` currently just delegates to `uploadBytes`; it does not enforce
image MIME types, image-specific validation, resizing, metadata, or extensions.

So either:

- remove `uploadImage`, or
- make it actually image-specific.

Current naming implies behavior that does not exist.

### `StoredMediaFile.app`

```dart
StoredMediaFile.app(name: 'profileAvatar')
```

The name "app" is ambiguous. It means "global/single stored-media namespace",
not app asset or app-level file.

Better names:

```dart
StoredMediaFile.global(...)
StoredMediaFile.singleton(...)
StoredMediaFile.keyed(...)
StoredMediaFile.named(...)
```

The current `isApp` flag is also vague.

### `remoteUrl`

`StoredMedia.remoteUrl` is used for public URLs. Documentation also says private
buckets would store paths.

If private buckets remain, `remoteUrl` becomes inaccurate because private bucket
upload returns a storage path, not a URL.

Better names:

```dart
remoteReference
remoteSource
remoteStorageValue
uploadedValue
```

If the app standardizes on only public buckets, `remoteUrl` is fine.

### `SyncMediaSourceApplier`

"Source" means a string that can be:

- `local:{storedMediaId}`
- remote URL

That is not obvious from the class name.

Possible clearer names:

```dart
SyncMediaUriApplier
SyncMediaSourceStringApplier
StoredMediaSourceUploader
MediaSourceUploadRewriter
```

The current name is acceptable but slightly vague.

### `SyncMarkdownMediaApplier`

"Applier" is consistent with `SyncMediaReferenceApplier`, but the class is
really a markdown rewriter/uploader.

Possible clearer names:

```dart
SyncMarkdownMediaRewriter
MarkdownMediaUploadRewriter
MarkdownAttachmentUploader
```

### `FolderPaths`

`FolderPaths` currently only contains deck media paths:

```dart
deckMedia
deckCoverImage
deckListingFeaturedImage
```

If it remains deck-specific, rename to:

```dart
DeckFolderPaths
DeckMediaPaths
DeckStoredMediaPaths
```

If it will become global, it should contain profile/card paths too. Right now
it is global in name but deck-specific in content.

### `DeckSyncPushItemPreprocessor`

The current typedef name is deck-specific even though `NewestWinsSyncStrategy`
is generic.

Better:

```dart
SyncPushItemPreprocessor<T, TContext>
PushItemPreprocessor<T>
SyncItemPreprocessor<T>
```

This is especially relevant if sync eventually supports non-deck contexts.

## Abstraction Problems

### Two different ways to represent uploadable media

Current system has at least two abstractions:

1. `SyncMediaReference<T>`
   - entity field + known `StoredMediaFile`

2. source string upload
   - `local:` or remote URL source + inferred `StoredMedia`

This split is reasonable, but there is no shared domain type for "uploadable
stored media".

Potential shared type:

```dart
class UploadableStoredMedia {
  final StoredMedia storedMedia;
  final String remotePath;
  final String? currentValue;
  final void Function(String uploadedValue) writeBack;
}
```

This could allow markdown, field references, and profile/deck media to share the
same upload executor.

### Remote path construction is scattered and stringly typed

Remote paths are currently built with raw strings:

```dart
'users/$profileId/decks/${deck.id}/cover'
'users/$profileId/decks/$deckId/featured/image$index'
'users/$profileId/decks/$deckId/markdown/...'
'users/${profile.id}/profile/avatar'
```

Issues:

- easy to mistype
- RLS depends on path segment positions
- no centralized policy around user/profile id
- hard to audit path layout

Recommended shared helper:

```dart
abstract final class MediaRemotePaths {
  static String deckCover({required String profileId, required String deckId});
  static String deckFeaturedImage(...);
  static String deckMarkdownAttachment(...);
  static String cardMarkdownAttachment(...);
  static String cardMediaField(...);
  static String profileAvatar({required String profileId});
}
```

This should live in `core` because it is generic, security-sensitive path
infrastructure that can be reused by multiple features.

### Local path construction is inconsistent

Deck cover and featured images use `FolderPaths`.

Markdown attachments use ad-hoc paths from UI call sites:

```dart
StoredMediaFile.folder(
  folderPath: '${deck.title}/media',
  name: FileHelper.fileNameWithoutExtension(file.name),
)
```

Profile avatar uses:

```dart
StoredMediaFile.app(name: 'profileAvatar')
```

This is inconsistent.

Recommended shared local path helper:

```dart
abstract final class DecksDirectoryPaths {
  static StoredMediaFile deckCover(...);
  static StoredMediaFile deckFeaturedImage(...);
  static StoredMediaFile deckAttachment(...);
  static StoredMediaFile cardAttachment(...);
  static StoredMediaFile profileAvatar(...);
}
```

This would remove `StoredMediaFile` construction from UI widgets and controllers.

### The app has no explicit media ownership model

Remote bucket paths encode ownership:

```text
users/{profileId}/...
```

Local paths encode feature organization:

```text
{deckTitle}/media/...
```

But there is no type that says:

- this media belongs to profile X
- this media belongs to deck Y
- this media belongs to card template Z
- this media is public/private
- this media is attachment/cover/avatar/audio

Without an ownership model, path builders and upload preprocessors have to
reconstruct meaning from strings and entity fields.

Potential type:

```dart
class MediaOwner {
  final String profileId;
  final String? deckId;
  final String? cardTemplateId;
}

enum MediaPurpose {
  deckCover,
  deckFeaturedImage,
  markdownAttachment,
  cardImage,
  cardAudio,
  profileAvatar,
}
```

This may be overkill now, but it becomes useful if media cleanup/deletion,
quotas, migrations, or private media are added.

### `StoredMediaService` mixes UI picking, file IO, DB, and HTTP

`StoredMediaService` currently does all of this:

- opens file picker
- reads picked file bytes
- writes files to app documents directory
- updates `LocalDB.storedMedia`
- downloads remote URLs over HTTP
- moves local files when folders are renamed
- deletes local files
- resolves local files by id/path/remote URL

This is convenient but broad.

Potential split:

| Current responsibility | Better owner |
|---|---|
| file picker | `MediaPickerService` |
| local file storage | `StoredMediaFileStore` |
| DB metadata | `StoredMediaRepository` / existing local DB |
| remote download to cache | `StoredMediaCacheService` |
| semantic operations | `StoredMediaService` facade |

You may keep the facade, but the internals are currently tightly coupled.

### Bucket abstractions may be more than needed

There is now a public/private bucket abstraction:

- `BucketSupabaseRemoteDB`
- `PublicBucketRemoteDB`
- `PrivateBucketRemoteDB`

If the app only needs public media, private bucket code is speculative.

Keep both only if private media is a real near-term requirement. Otherwise:

- remove private bucket
- keep one `SupabaseMediaStorage`
- simplify docs/migration/config

Important: RLS folders inside a public bucket do not provide private read
security. If private reads matter, private bucket or signed URLs are still
needed.

## Duplicated or Repetitive Code

### Card-template media rewrite methods are repetitive

Examples in `DeckSyncSession`:

- `_preprocessFlashcardTemplate`
- `_preprocessIdentificationTemplate`
- `_preprocessMultipleChoiceTemplate`
- `_preprocessWordScrambleTemplate`
- `_preprocessFillInTheBlanksTemplate`
- `_preprocessMatchMadnessTemplate`

They repeat this pattern:

```dart
final field = await _uploadCardMarkdown(...);
final media = await _uploadCardMediaSource(...);
return template.copyWith(...);
```

This could be reduced with descriptors:

```dart
MarkdownField<T>(
  name: 'front-text',
  read: (t) => t.frontText,
  write: (t, value) => t.copyWith(frontText: value),
)
```

Same for media fields:

```dart
MediaSourceField<T>(
  name: 'front-image',
  read: (t) => t.frontImageUrl,
  write: (t, value) => t.copyWith(frontImageUrl: value),
)
```

This reduces boilerplate and makes new card media fields easier to add.

### `StoredMedia` copy/update logic is repeated manually

`SyncMediaReferenceApplier.updateStoredMediaRemoteUrl` rebuilds
`StoredMedia(...)` manually.

`StoredMediaService.renameFolderByPrefix` also rebuilds `StoredMedia(...)`
manually.

Potential helper:

```dart
StoredMedia copyStoredMedia(
  StoredMedia media, {
  String? id,
  String? localPath,
  String? remoteUrl,
  DateTime? updatedAt,
})
```

If generated `copyWith` exists, use it. If not, consider adding a method/helper.

### File existence and read logic repeats

Both media appliers do:

```dart
final file = File(storedMedia.localPath);
if (!await file.exists()) continue/return;
await file.readAsBytes()
```

This belongs in a shared upload helper or `StoredMediaService.readBytes`.

### Remote URL/local URL detection appears in multiple places

The logic "empty or not remote URL means needs upload" appears in:

- `SyncMediaReferenceApplier._shouldUploadMediaReference`
- `DeckSyncSession._shouldUploadStoredMedia`
- `SyncMediaSourceApplier.uploadSource`
- remote DB classes that null local-only values

This should be centralized as something like:

```dart
MediaUploadPolicy.shouldUpload(...)
MediaSourceHelper.isRemote(...)
MediaSourceHelper.isLocalReference(...)
```

## Bad or Risky Practices

### Mutating local DB during sync apply preprocessors

The sync preprocessor uploads media and also writes local DB rows:

- rewritten deck/listing/card template
- updated stored media remote URL

This is expected for apply, but it means `preprocessPushItem` is not just a pure
preprocessor. It has side effects:

- storage upload
- stored media update
- local entity upsert

That should be documented clearly in the preprocessor contract. The name
`preprocessPushItem` sounds like it could be pure, but it is not.

Potential better name:

```dart
preparePushItemForApply
applyPushSideEffects
prepareAndPersistPushItem
```

### Public URL is stored as the canonical DB value

For public buckets, `PublicBucketRemoteDB.uploadBytes` returns a public URL and
the app stores that URL in Postgres.

Pros:

- simple rendering
- no need to resolve paths later

Cons:

- if Supabase project URL changes, stored URLs become stale
- if bucket/domain changes, rows need migration
- public URL is less portable than `{bucket, path}`

Alternative:

```dart
store bucket path in DB
resolve public URL at render/API boundary
```

This is a tradeoff. Current design is simpler, but less portable.

### Local stored media ids depend on mutable deck title

Local deck media paths use deck title:

```text
{deckTitle}/media/...
```

The app handles deck rename by moving folders with:

```dart
StoredMediaService.renameFolderByPrefix(...)
```

This works but is fragile.

Issues:

- deck title is mutable
- title may collide
- rename operations must never be missed
- markdown `local:` ids can break if media ids are changed without rewriting
  markdown references

Safer local layout:

```text
decks/{deckId}/media/...
```

Display names can still be shown in UI. Storage should prefer ids.

### Markdown attachment local ids can break on folder renames

Markdown stores `local:{storedMediaId}`. If the stored media id changes due to
folder rename, markdown references must be rewritten too.

Current rename logic moves stored media rows/files, but it is not obvious that
all markdown fields containing old `local:` ids are also rewritten.

Review needed:

- deck long description
- card text fields
- option text
- fill-in-the-blank segments
- match madness pairs

If not handled, old local markdown attachments can stop resolving after deck
rename.

### Media cleanup/deletion is not represented

The system uploads media but does not appear to define cleanup behavior for:

- replacing cover images
- replacing featured images
- removing markdown attachments
- deleting a deck
- deleting card templates
- deleting profile avatar

Storage can accumulate orphaned bucket objects.

Possible future service:

```dart
MediaGarbageCollector
DeckMediaCleanupService
StoredMediaReferenceScanner
```

This should not necessarily run immediately, but the absence should be
intentional.

### `SyncMarkdownMediaApplier` rewrites links without checking media kind

The regex matches both image and normal links. That may be fine because the app
uses normal links for audio attachments.

But it can also upload/rewrite any normal markdown link if it happens to point
to a matching local/remote stored media entry.

This is probably acceptable, but the behavior should be explicit:

- "all local stored-media markdown links are uploadable"
- not only images

### `dynamic` usage in card template preprocessing

`DeckSyncSession` uses:

```dart
final options = <dynamic>[];
...
options.cast()
```

Same for segments and pairs.

This is a smell caused by generated `copyWith` generic typing.

Better:

```dart
final options = <MultipleChoiceOption>[];
final segments = <FillInTheBlankSegment>[];
final pairs = <MatchMadnessPair>[];
```

If imports become noisy, that is another sign this code belongs near the card
feature instead of deck sync.

## Coupling Map

Current dependency direction:

```text
DeckSyncSession
  -> Decks DBs/services/models
  -> DeckListings DBs/services/models
  -> CardTemplates DBs/services/models
  -> all card template subtypes
  -> Study/Fsrs sync services
  -> SyncDeletion
  -> StoredMediaService
  -> StoredMediaFile
  -> FolderPaths
  -> Bucket repository
  -> Markdown media helper
  -> ImageHelper
```

This is high coupling.

Healthier direction:

```text
DeckSyncSession
  -> sync strategy factory
  -> per-entity preprocessors

DeckMediaSyncPreprocessor
  -> deck models/services
  -> stored media upload helper
  -> media path builders

CardTemplateMediaSyncPreprocessor
  -> card models
  -> stored media upload helper
  -> media path builders

ProfileMediaService
  -> profile model/local/remote DB
  -> stored media upload helper

StoredMediaUploadService
  -> StoredMediaService
  -> Bucket repository
```

## Suggested Refactor Plan

### Phase 1: Rename and isolate path builders

Create:

```text
lib/core/helpers/media_remote_paths.helper.dart
lib/features/stored_media/stored_media_paths.helper.dart
```

Move all raw path strings there.

Immediate benefit:

- easier RLS audit
- less string duplication
- clearer public media path convention

### Phase 2: Extract shared upload executor

Create:

```text
lib/core/services/stored_media_upload.service.dart
```

Responsibilities:

- read local file bytes
- upload to bucket
- update `StoredMedia.remoteUrl`
- return uploaded value

Then make both appliers use it.

### Phase 3: Move deck/card/profile media logic out of session/controller

Create:

```text
lib/features/sync_deck/sync_preprocessors/sync_deck.deck_media_preprocessor.dart
lib/features/sync_deck/sync_preprocessors/sync_deck.deck_listing_media_preprocessor.dart
lib/features/sync_deck/sync_preprocessors/sync_deck.card_template_media_preprocessor.dart
lib/features/profile/profile_media.service.dart
```

Keep `DeckSyncSession` as dependency holder/strategy assembly only.

### Phase 4: Replace card subtype boilerplate with descriptors

Create media field descriptors for:

- markdown fields
- source-string media fields

Keep this in `sync_deck` if it is only used by sync upload behavior. Move it to
the card feature only if it becomes general card-template metadata.

Example:

```dart
abstract final class CardTemplateMediaFields {
  static List<MarkdownMediaField<CardTemplate>> markdownFields(...);
  static List<MediaSourceField<CardTemplate>> sourceFields(...);
}
```

### Phase 5: Decide bucket strategy

Choose one:

1. Public-only media for now.
   - Remove private bucket abstraction.
   - Rename storage classes to public media storage.

2. Public/private media as a real supported design.
   - Keep private bucket.
   - Rename `remoteUrl` to a more neutral `remoteReference`.
   - Add signed URL render path.

Do not keep private bucket as speculative complexity unless it has a real near
term use.

### Phase 6: Address deletion/cleanup

Define behavior for:

- local media row deletion
- local file deletion
- bucket object deletion
- orphan cleanup
- deck cascade deletion
- markdown attachment removal

This should probably be separate from data sync tombstones.

## Quick Review Checklist

Use this when reviewing future changes:

- Does each new folder have a `.barrel.dart` and export upward to `lib.barrel.dart`?
- Does the file import from `lib.barrel.dart` with `show`?
- Is every class/enum in a separate file unless it is only a tightly scoped typedef?
- Does this code store local filesystem paths in remote DB rows?
- Does this code upload during preview? It should not.
- Does this code hide bucket path strings in random feature files?
- Does this code depend on mutable names like deck title for durable ids?
- Does this code update `StoredMedia.remoteUrl` after upload?
- Does this code preserve an old remote URL on a newly picked local file?
- Does this code add another subtype switch inside `DeckSyncSession`?
- Does this code make `AuthController` know about storage buckets?
- Does this code parse markdown with assumptions that should be documented?
- Does this code create remote media without any cleanup path?
- Does a confusing public API have a concise Dart doc comment?

## Most Important Changes To Consider First

If only a few items are worth addressing now, prioritize:

1. Extract media remote path builders.
2. Extract shared stored-media upload executor.
3. Move card-template media preprocessing out of `DeckSyncSession`.
4. Move profile avatar upload out of `AuthController`.
5. Decide whether private buckets are real or speculative.
6. Replace deck-title local media paths with deck-id-based paths if possible.
