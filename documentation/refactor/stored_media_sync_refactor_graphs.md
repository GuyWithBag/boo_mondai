# Stored Media / Sync Refactor Graphs

This companion document visualizes the issues listed in
`stored_media_sync_refactor_review.md`.

The diagrams are intentionally architecture-focused. They are meant to make
coupling, repeated logic, and possible extraction boundaries easier to review.

## Current High-Level Coupling

Deck-sync-specific files should live under `lib/features/sync_deck/`. Generic
helpers and services shown in the target diagrams should live under `lib/core/`
when they are reusable and not owned by one feature.

```mermaid
flowchart TD
    DeckSyncSession["DeckSyncSession"]

    DeckSyncSession --> StrategyFactory["sync strategy construction"]
    DeckSyncSession --> DeckMedia["deck cover media preprocessing"]
    DeckSyncSession --> ListingMedia["deck listing featured media preprocessing"]
    DeckSyncSession --> CardMedia["card-template media preprocessing"]
    DeckSyncSession --> MarkdownRewrite["markdown upload/rewrite"]
    DeckSyncSession --> RemotePaths["remote bucket path strings"]
    DeckSyncSession --> UploadPolicy["stored-media upload predicate"]
    DeckSyncSession --> PublicBucket["PublicBucketRemoteDB"]
    DeckSyncSession --> StoredMediaService["StoredMediaService"]
    DeckSyncSession --> ImageHelper["ImageHelper"]

    CardMedia --> FlashcardTemplate["FlashcardTemplate"]
    CardMedia --> IdentificationTemplate["IdentificationTemplate"]
    CardMedia --> MultipleChoiceTemplate["MultipleChoiceTemplate"]
    CardMedia --> WordScrambleTemplate["WordScrambleTemplate"]
    CardMedia --> FillInTheBlanksTemplate["FillInTheBlanksTemplate"]
    CardMedia --> MatchMadnessTemplate["MatchMadnessTemplate"]

    StrategyFactory --> Decks["Decks"]
    StrategyFactory --> DeckListings["DeckListings"]
    StrategyFactory --> CardTemplates["CardTemplates"]
    StrategyFactory --> StudyCards["StudyCards"]
    StrategyFactory --> FsrsCards["FsrsCards"]
    StrategyFactory --> ReviewLogs["ReviewLogs"]
    StrategyFactory --> SyncDeletions["SyncDeletions"]
```

Problem shown: `DeckSyncSession` is the central node for too many unrelated
concerns.

## Current Media Upload Paths

```mermaid
flowchart TD
    subgraph LocalInput["Local media input"]
        CoverPick["deck cover picker"]
        FeaturedPick["featured image picker"]
        MarkdownAttach["markdown toolbar attachment"]
        AvatarPick["profile avatar picker"]
    end

    CoverPick --> StoredMedia["StoredMedia row + local file"]
    FeaturedPick --> StoredMedia
    MarkdownAttach --> StoredMedia
    AvatarPick --> StoredMedia

    StoredMedia --> StoredMediaFile["StoredMediaFile / local id"]
    StoredMedia --> RemoteUrl["StoredMedia.remoteUrl"]

    subgraph SyncApply["Sync/apply or profile write"]
        DeckPreprocess["Deck preprocess"]
        ListingPreprocess["DeckListing preprocess"]
        CardPreprocess["CardTemplate preprocess"]
        ProfileUpload["AuthController profile avatar upload"]
    end

    DeckPreprocess --> Bucket["public-media bucket"]
    ListingPreprocess --> Bucket
    CardPreprocess --> Bucket
    ProfileUpload --> Bucket

    Bucket --> PublicUrl["public URL"]
    PublicUrl --> RemoteUrl
    PublicUrl --> RemoteRows["remote Postgres rows"]
```

Problem shown: the same upload concept is reached from multiple feature paths,
but upload execution is not centralized enough.

## Duplicate Upload Logic

```mermaid
flowchart LR
    RefApplier["SyncMediaReferenceApplier"]
    SourceApplier["SyncMediaSourceApplier"]

    RefResolve["resolve StoredMedia by StoredMediaFile"]
    SourceResolve["resolve StoredMedia by local:/remote source"]

    ReadFile1["read File(storedMedia.localPath)"]
    Upload1["bucket.uploadBytes(...)"]
    Update1["update StoredMedia.remoteUrl"]

    ReadFile2["read File(storedMedia.localPath)"]
    Upload2["bucket.uploadBytes(...)"]
    Update2["update StoredMedia.remoteUrl"]

    RefApplier --> RefResolve --> ReadFile1 --> Upload1 --> Update1
    SourceApplier --> SourceResolve --> ReadFile2 --> Upload2 --> Update2
```

Preferred extraction:

```mermaid
flowchart LR
    RefApplier["SyncMediaReferenceApplier"]
    SourceApplier["SyncMediaSourceApplier"]

    RefResolve["resolve by StoredMediaFile"]
    SourceResolve["resolve by source string"]

    UploadService["StoredMediaUploadService.upload"]
    ReadFile["read local file"]
    Upload["bucket.uploadBytes"]
    MarkUploaded["StoredMediaService.markUploaded"]

    RefApplier --> RefResolve --> UploadService
    SourceApplier --> SourceResolve --> UploadService
    UploadService --> ReadFile --> Upload --> MarkUploaded
```

## Current Card-Template Coupling

```mermaid
flowchart TD
    CardPreprocess["_preprocessCardTemplatePushItem"]

    CardPreprocess --> Switch["switch(template subtype)"]

    Switch --> Flashcard["_preprocessFlashcardTemplate"]
    Switch --> Identification["_preprocessIdentificationTemplate"]
    Switch --> MultipleChoice["_preprocessMultipleChoiceTemplate"]
    Switch --> WordScramble["_preprocessWordScrambleTemplate"]
    Switch --> FillBlanks["_preprocessFillInTheBlanksTemplate"]
    Switch --> MatchMadness["_preprocessMatchMadnessTemplate"]

    Flashcard --> CardMarkdown["upload markdown fields"]
    Identification --> CardMarkdown
    MultipleChoice --> CardMarkdown
    WordScramble --> CardMarkdown
    FillBlanks --> CardMarkdown
    MatchMadness --> CardMarkdown

    Flashcard --> CardSource["upload explicit media source fields"]
    Identification --> CardSource
    MultipleChoice --> CardSource
    WordScramble --> CardSource
```

Problem shown: every new card subtype expands the deck sync session.

Descriptor-based alternative:

```mermaid
flowchart TD
    CardPreprocessor["CardTemplateMediaSyncPreprocessor"]
    FieldRegistry["CardTemplateMediaFields registry/visitor"]

    CardPreprocessor --> FieldRegistry
    FieldRegistry --> MarkdownFields["MarkdownMediaField descriptors"]
    FieldRegistry --> SourceFields["MediaSourceField descriptors"]

    MarkdownFields --> MarkdownRewriter["SyncMarkdownMediaApplier"]
    SourceFields --> SourceUploader["SyncMediaSourceApplier"]

    MarkdownRewriter --> UploadService["StoredMediaUploadService"]
    SourceUploader --> UploadService
```

## Current Markdown Attachment Rewrite Flow

```mermaid
sequenceDiagram
    participant User
    participant Toolbar
    participant MarkdownHelper
    participant StoredMedia
    participant SyncMarkdownMediaApplier
    participant SyncMediaSourceApplier
    participant Bucket
    participant RemoteDB

    User->>Toolbar: Insert attachment
    Toolbar->>MarkdownHelper: toPickedFileMediaMarkdownFormat(file)
    MarkdownHelper->>StoredMedia: storeFile(...)
    MarkdownHelper-->>Toolbar: markdown source local:{storedMediaId}

    User->>SyncMarkdownMediaApplier: Apply sync
    SyncMarkdownMediaApplier->>SyncMarkdownMediaApplier: regex match markdown links/images
    SyncMarkdownMediaApplier->>SyncMediaSourceApplier: uploadSource(local:{id})
    SyncMediaSourceApplier->>StoredMedia: getById(id)
    SyncMediaSourceApplier->>Bucket: uploadBytes(...)
    Bucket-->>SyncMediaSourceApplier: public URL
    SyncMediaSourceApplier->>StoredMedia: update remoteUrl
    SyncMediaSourceApplier-->>SyncMarkdownMediaApplier: public URL
    SyncMarkdownMediaApplier->>SyncMarkdownMediaApplier: rewrite source
    SyncMarkdownMediaApplier-->>RemoteDB: rewritten markdown in entity upsert
```

Risk shown: markdown parsing is regex-based, not AST-based.

## Current Profile Avatar Coupling

```mermaid
flowchart TD
    AuthController["AuthController"]

    AuthController --> StoreFile["StoredMediaService.storeFile"]
    AuthController --> BuildReference["construct SyncMediaReference<Profile>"]
    AuthController --> ApplyUpload["SyncMediaReferenceApplier.apply"]
    AuthController --> LocalProfile["LocalDB.profile.upsert"]
    AuthController --> RemoteProfile["RemoteDB.profile.upsert"]
    ApplyUpload --> PublicBucket["RemoteDB.publicBucket"]
    ApplyUpload --> StoredMedia["StoredMedia.remoteUrl update"]
```

Preferred split:

```mermaid
flowchart TD
    AuthController["AuthController"]
    ProfileService["ProfileService / ProfileMediaService"]
    AvatarStore["saveAvatar(file)"]
    AvatarUpload["uploadAvatarIfAuthenticated(profile)"]
    UploadService["StoredMediaUploadService"]
    LocalProfile["LocalDB.profile"]
    RemoteProfile["RemoteDB.profile"]

    AuthController --> ProfileService
    ProfileService --> AvatarStore --> LocalProfile
    ProfileService --> AvatarUpload --> UploadService
    AvatarUpload --> RemoteProfile
```

## Bucket Abstraction Decision

```mermaid
flowchart TD
    Decision{"Does the app need private media reads?"}

    Decision -- "No" --> PublicOnly["Use one public-media bucket"]
    PublicOnly --> Simplify["Remove PrivateBucketRemoteDB / private bucket config"]
    PublicOnly --> StorePublicUrl["Store public URLs in rows"]

    Decision -- "Yes" --> PublicPrivate["Keep public-media + private-media"]
    PublicPrivate --> RenameRemote["Rename remoteUrl to remoteReference"]
    PublicPrivate --> SignedUrls["Add signed URL display/download flow"]
    PublicPrivate --> StorePath["Store private storage paths, not public URLs"]
```

Key rule: RLS folder policies in a public bucket protect writes, not private
reads.

## Local vs Remote Path Coupling

```mermaid
flowchart LR
    subgraph LocalPaths["Current local paths"]
        DeckTitlePath["{deckTitle}/media/..."]
        ProfileAppPath["StoredMediaFile.app(profileAvatar)"]
        UiAttachmentPath["UI-created StoredMediaFile.folder(...)"]
    end

    subgraph RemotePaths["Current remote paths"]
        UserPrefix["users/{profileId}/..."]
        DeckIdPath["decks/{deckId}/..."]
        CardIdPath["cards/{templateId}/..."]
        AvatarPath["profile/avatar"]
    end

    DeckTitlePath -. rename risk .-> DeckRename["deck rename must move local files"]
    UiAttachmentPath -. duplicated construction .-> UiWidgets["UI widgets know storage paths"]
    UserPrefix -. RLS dependency .-> RlsPolicy["storage RLS path segment check"]
```

Preferred helpers:

```mermaid
flowchart TD
    DecksDirectoryPaths["DecksDirectoryPaths"]
    MediaRemotePaths["MediaRemotePaths"]

    DecksDirectoryPaths --> LocalDeckCover["deckCover(deckId/title)"]
    DecksDirectoryPaths --> LocalFeatured["deckFeaturedImage(...)"]
    DecksDirectoryPaths --> LocalAttachment["deck/card attachment(...)"]
    DecksDirectoryPaths --> LocalAvatar["profileAvatar(...)"]

    MediaRemotePaths --> RemoteDeckCover["users/{profileId}/decks/{deckId}/cover"]
    MediaRemotePaths --> RemoteFeatured["users/{profileId}/decks/{deckId}/featured/imageN"]
    MediaRemotePaths --> RemoteMarkdown["users/{profileId}/.../markdown/..."]
    MediaRemotePaths --> RemoteAvatar["users/{profileId}/profile/avatar"]
```

## `StoredMediaService` Responsibility Spread

`MediaRemotePaths` and `StoredMediaUploadService` are expected to be core-level
building blocks because they are reusable across deck, card, profile, and future
media features.

```mermaid
flowchart TD
    StoredMediaService["StoredMediaService"]

    StoredMediaService --> Picker["file picker"]
    StoredMediaService --> FileRead["read picked file bytes"]
    StoredMediaService --> FileWrite["write local files"]
    StoredMediaService --> LocalDb["LocalDB.storedMedia metadata"]
    StoredMediaService --> HttpDownload["HTTP remoteToLocal download"]
    StoredMediaService --> RenameMove["rename/move folders"]
    StoredMediaService --> DeleteFiles["delete local files"]
    StoredMediaService --> Resolve["resolve by id/path/remoteUrl"]
```

Possible internal split:

```mermaid
flowchart TD
    StoredMediaFacade["StoredMediaService facade"]

    StoredMediaFacade --> MediaPicker["MediaPickerService"]
    StoredMediaFacade --> FileStore["StoredMediaFileStore"]
    StoredMediaFacade --> MetadataRepo["StoredMediaLocalDB / repository"]
    StoredMediaFacade --> CacheService["StoredMediaCacheService"]
    StoredMediaFacade --> PathService["StoredMediaPathService"]
```

## Sync Preview vs Apply

```mermaid
sequenceDiagram
    participant Preview
    participant ChangePlan
    participant Apply
    participant Bucket
    participant LocalDB
    participant RemoteDB

    Preview->>ChangePlan: compare indexes and changed fields
    Note over Preview: must not upload media

    ChangePlan-->>Apply: user approves
    Apply->>Bucket: upload pending local media
    Bucket-->>Apply: public URL/path
    Apply->>LocalDB: update StoredMedia.remoteUrl
    Apply->>LocalDB: upsert rewritten entity
    Apply->>RemoteDB: upsert rewritten entity
```

Review question: should preview display "pending media upload" explicitly when
the final URL does not exist yet?

## Media Deletion / Cleanup Gap

```mermaid
flowchart TD
    Events["Media-changing events"]

    Events --> ReplaceCover["replace cover image"]
    Events --> ReplaceFeatured["replace featured image"]
    Events --> RemoveMarkdown["remove markdown attachment"]
    Events --> DeleteDeck["delete deck"]
    Events --> DeleteCard["delete card template"]
    Events --> DeleteAvatar["delete profile avatar"]

    ReplaceCover --> Orphan["possible orphaned bucket object"]
    ReplaceFeatured --> Orphan
    RemoveMarkdown --> Orphan
    DeleteDeck --> Orphan
    DeleteCard --> Orphan
    DeleteAvatar --> Orphan

    Orphan --> FutureCleanup["future MediaGarbageCollector / cleanup service"]
```

## Proposed Target Architecture

All public files in this target architecture should export through folder
barrels up to `lib.barrel.dart`, and consumers should import from
`lib.barrel.dart` using `show`.

```mermaid
flowchart TD
    DeckSyncSession["DeckSyncSession"]
    StrategyFactory["SyncDeckStrategyFactory"]

    DeckSyncSession --> StrategyFactory

    StrategyFactory --> DeckPre["DeckMediaSyncPreprocessor"]
    StrategyFactory --> ListingPre["DeckListingMediaSyncPreprocessor"]
    StrategyFactory --> CardPre["CardTemplateMediaSyncPreprocessor"]

    AuthController["AuthController"] --> ProfileMedia["ProfileMediaService"]

    DeckPre --> MediaPaths["MediaRemotePaths"]
    ListingPre --> MediaPaths
    CardPre --> MediaPaths
    ProfileMedia --> MediaPaths

    DeckPre --> StoredPaths["DecksDirectoryPaths"]
    ListingPre --> StoredPaths
    ProfileMedia --> StoredPaths

    CardPre --> CardFields["CardTemplateMediaFields"]
    CardFields --> MarkdownFields["markdown field descriptors"]
    CardFields --> SourceFields["media source field descriptors"]

    DeckPre --> MarkdownRewriter["MarkdownMediaUploadRewriter"]
    CardPre --> MarkdownRewriter
    CardPre --> SourceUploader["MediaSourceUploadRewriter"]

    MarkdownRewriter --> UploadService["StoredMediaUploadService"]
    SourceUploader --> UploadService
    DeckPre --> UploadService
    ListingPre --> UploadService
    ProfileMedia --> UploadService

    UploadService --> StoredMediaService["StoredMediaService"]
    UploadService --> Bucket["Supabase media bucket"]
```

## Suggested Refactor Phases

```mermaid
gantt
    title Stored Media / Sync Refactor Phases
    dateFormat  X
    axisFormat %s

    section Phase 1
    Extract MediaRemotePaths and DecksDirectoryPaths      :p1, 0, 1

    section Phase 2
    Extract StoredMediaUploadService                  :p2, after p1, 1

    section Phase 3
    Move deck/listing/card/profile media logic out    :p3, after p2, 1

    section Phase 4
    Replace card subtype boilerplate with descriptors :p4, after p3, 1

    section Phase 5
    Decide public-only vs public/private buckets      :p5, after p4, 1

    section Phase 6
    Define media deletion and cleanup behavior        :p6, after p5, 1
```
