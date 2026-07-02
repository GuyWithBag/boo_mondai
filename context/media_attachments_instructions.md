# Media Attachment + Import/Export Bundle — Agent Instructions

## Context

You are working on `boo_mondai`, a local-first Flutter vocabulary app.
Architecture: **Controller → Service → Remote/Local DB → Helper**
File naming: `<file_name>.<domain>.dart`
State: Provider + ChangeNotifier for shared state, flutter_hooks for local UI state
Local DB: Hive
Remote DB: Supabase
Routing: go_router

**This task is logic only. Do not create or modify any UI files, widgets,
screens, or dialogs. Stop at the service/controller boundary.**

**Before touching any DB operation (Hive box, Supabase table, type adapter),
read the relevant local and remote DB files first. Do not assume box names,
field indices, table names, or column shapes. Read them.**

---

## Packages

Before writing any code, read `pubspec.yaml`.

**`archive`** — for ZIP creation and extraction. If not present, add it using
the Dart MCP `pub add` tool. Do not manually edit `pubspec.yaml` for this —
use the MCP tool.

**`file_picker`** — for selecting `.boomondai.zip` files from the device. If
not present, add it using the Dart MCP `pub add` tool.

After adding packages, confirm they are resolvable before proceeding.

---

## 1. Model Changes — Attachment Models

### 1.1 Read first

Read the current `CardMediaAttachment` model file (and any related attachment
model files) before making any changes. Note existing fields, Hive field
indices, and `dart_mappable` annotations.

### 1.2 Sealed base class — `CardAttachment`

Create a sealed class that both attachment types extend:

```dart
sealed class CardAttachment {
  String get id;
  String get templateId;
  AttachmentType get type;
  String get label;
  String? get altText;
  DateTime get createdAt;
}
```

Place this in a new file following the project's file naming convention.

### 1.3 `CardMediaAttachment extends CardAttachment`

Refactor the existing `CardMediaAttachment` to extend `CardAttachment`. Field
changes from the original:

- Rename `kind` → `type`, type becomes `AttachmentType`
- Add `label` — `String`, required
- Add `localPath` — `String?`, nullable, device-only, never synced
- Keep `storagePath`, `publicUrl`, `mimeType`, `altText`, `createdAt`, `id`,
  `templateId` unchanged

Final shape (do not copy Hive field indices from here — read the file):

```dart
final String id;
final String templateId;
final AttachmentType type;
final String label;
final String storagePath;
final String? publicUrl;
final String? localPath;   // local-only, excluded from all sync payloads
final String mimeType;
final String? altText;
final DateTime createdAt;
```

### 1.4 `CardLinkAttachment extends CardAttachment`

Create a new model for external URL attachments:

```dart
final String id;
final String templateId;
final AttachmentType type;
final String label;
final String url;           // external URL, the only media reference
final String? altText;
final DateTime createdAt;
```

`CardLinkAttachment` has no `storagePath`, `publicUrl`, `localPath`, or
`mimeType`. It is online-only by design. No local download is attempted for
link attachments.

### 1.5 `AttachmentType` enum

Create or rename to `AttachmentType`. Apply to both `CardMediaAttachment` and
`CardLinkAttachment`. Values at minimum: `image`, `audio`. Read the existing
enum before touching it — preserve any values already there.

### 1.6 `CardTemplate` — attachment list

Read the `CardTemplate` model. Replace the existing attachment field (likely
`List<CardMediaAttachment>`) with:

```dart
List<CardAttachment> attachments;
```

This single list holds both `CardMediaAttachment` and `CardLinkAttachment`
instances. Do not use two separate lists.

### 1.7 Hive adapters

After all model changes, regenerate Hive type adapters by running
`build_runner` as the project already does. Do not manually write adapter code.
Assign the next available field index to each new field — read existing
annotations to find the current highest index.

`CardLinkAttachment` needs its own Hive type adapter. Read how
`CardMediaAttachment`'s adapter is registered to follow the same pattern.

### 1.8 Sync payload

Find where `CardMediaAttachment` is serialized for Supabase sync. Two rules:

- Exclude `localPath` from the payload — never send to or read from Supabase
- `CardLinkAttachment` syncs only: `id`, `templateId`, `type`, `label`, `url`,
  `altText`, `createdAt`

Read the remote DB file to understand the current sync shape before changing
anything.

---

## 2. Label Validation

### 2.1 Validation rules

- Required, non-empty
- Unique per deck: across all `CardAttachment` records (both
  `CardMediaAttachment` and `CardLinkAttachment`) belonging to any template in
  the same deck
- Forbidden characters: `/ \ : * ? " < > |`
- Validation lives in a helper. The service calls the helper and surfaces
  errors via return types, not exceptions. No silent sanitization.

### 2.2 Fallback for generated labels

When a label is not provided (programmatic creation, import), generate:

```
new-file-<n>
```

where `<n>` is the next integer such that the result is unique within the deck.
Start at 1.

### 2.3 Helper — `attachment_label.helper.dart`

Pure functions, no state, no dependencies:

```dart
// Returns an error string if invalid, null if valid
String? validateAttachmentLabel(String label, List<String> existingLabels);

// Returns next available fallback label
String generateFallbackLabel(List<String> existingLabels);

// Strips forbidden characters and trims — used only during import,
// never silently on user input
String sanitizeLabel(String raw);
```

---

## 3. Media Resolution

### 3.1 Helper function

Add to an appropriate helper file:

```dart
// For CardMediaAttachment: localPath first, publicUrl as fallback
// For CardLinkAttachment: url directly
String? resolveAttachmentUri(CardAttachment attachment) {
  return switch (attachment) {
    CardMediaAttachment a => a.localPath ?? a.publicUrl,
    CardLinkAttachment a  => a.url,
  };
}
```

### 3.2 Usage

Find every place in the codebase that reads `publicUrl` or `storagePath` from
an attachment to display or play it. Replace with `resolveAttachmentUri()`.
Read each file before editing.

---

## 4. Local Media Storage — `media_storage.service.dart`

Create a new service file for local media operations.

### 4.1 Save bytes locally

```dart
Future<String> saveMediaLocally({
  required String attachmentId,
  required Uint8List bytes,
  required String mimeType,
});
```

- Directory: `getApplicationDocumentsDirectory()/media/`
- Filename: `<attachmentId>.<ext>` where ext comes from `extensionFromMimeType()`
- Returns the absolute file path
- Creates the directory if it does not exist
- Does not apply to `CardLinkAttachment` — links are never downloaded

### 4.2 Delete local file

```dart
Future<void> deleteMediaLocally(String localPath);
```

Used when an attachment is deleted. Check file exists before deleting.

### 4.3 MIME helper — `mime.helper.dart`

Pure function:

```dart
String extensionFromMimeType(String mimeType);
```

Cover at minimum: `image/jpeg → jpg`, `image/png → png`, `image/webp → webp`,
`audio/mpeg → mp3`, `audio/ogg → ogg`, `audio/wav → wav`. Return `bin` as
fallback for unknown types.

---

## 5. Export — `exportDeckBundle()`

### 5.1 Read first

Read `import_export.service.dart` fully before writing anything. Understand
existing export methods, return types, and how attachments are currently
serialized.

### 5.2 Method signature

```dart
Future<File> exportDeckBundle(String deckId);
```

Returns a `.boomondai.zip` file written to the app's cache directory.

### 5.3 ZIP structure

```
<deck-title>.boomondai.zip
  manifest.json
  media/
    <attachment-id>.<ext>    ← CardMediaAttachment files only
```

`CardLinkAttachment` entries appear in the manifest but have no file in
`media/` — they are URL-only.

### 5.4 Manifest shape

```json
{
  "format": "boo_mondai_deck_bundle_v1",
  "exported_at": "<ISO8601>",
  "source_user_id": "<current user id>",
  "deck": { },
  "card_templates": [
    {
      "id": "...",
      "attachments": [
        {
          "attachment_source": "media",
          "id": "...",
          "template_id": "...",
          "type": "image",
          "label": "...",
          "storage_path": "...",
          "public_url": "...",
          "mime_type": "image/jpeg",
          "alt_text": "...",
          "created_at": "...",
          "content_path": "media/<attachment-id>.<ext>",
          "byte_size": 12345
        },
        {
          "attachment_source": "link",
          "id": "...",
          "template_id": "...",
          "type": "image",
          "label": "...",
          "url": "https://...",
          "alt_text": "...",
          "created_at": "..."
        }
      ]
    }
  ]
}
```

`attachment_source` is `"media"` or `"link"` — used by import to reconstruct
the correct type. `localPath` is always excluded.

### 5.5 Media sourcing (CardMediaAttachment only)

For each `CardMediaAttachment`, resolve bytes in this order:

1. If `localPath` is set and the file exists on disk, read from disk
2. Otherwise download from `publicUrl`
3. If both fail, log a warning, skip the file, set `content_path` to null in
   the manifest for that attachment

For `CardLinkAttachment`, write only the manifest entry. No file is added to
the ZIP.

### 5.6 ZIP construction

Use the `archive` package. Do not use any other ZIP library. Build the archive
in memory, then write to disk as a single operation.

---

## 6. Import — `importDeckBundle()`

### 6.1 Read first

Read `import_export.service.dart` fully. Read local DB files to understand how
decks and templates are inserted. Read `_copyTemplate()` specifically — it
currently drops attachments, which must be fixed as part of this task.

### 6.2 File selection

Use `file_picker` to let the caller pick a `.boomondai.zip` file. The picker
call belongs in the controller, not the service. The service receives a `File`
object.

Filter to `.zip` or `.boomondai.zip` extension. Read `file_picker`
documentation via the Dart MCP before implementing.

### 6.3 Method signatures

```dart
// In the service:
Future<ImportResult> importDeckBundle(File bundleFile, ImportOptions options);

// Sealed result type — follow the existing ImportExportResult pattern in
// the codebase if one exists, otherwise create:
sealed class ImportResult {}
class ImportSuccess extends ImportResult { final String deckId; }
class ImportFailure extends ImportResult { final String reason; }
```

### 6.4 `ImportOptions`

```dart
enum ImportMatchStrategy { byId, byFrontText, byFrontAndBackText }
enum ImportConflictStrategy { skip, overwrite, keepNewer }

class ImportOptions {
  final ImportMatchStrategy matchStrategy;
  final ImportConflictStrategy conflictStrategy;
}
```

### 6.5 Import flow

**Step 1 — Pick and extract**
Extract the ZIP to a temp directory using the `archive` package.
Read `manifest.json`. Parse deck, templates, and attachments.

**Step 2 — Determine ownership**
Compare `source_user_id` in manifest to the current user's ID.

- Match → own backup path (section 6.6)
- No match → shared bundle path (section 6.7)

**Step 3 — Merge detection**
Before any write, check if a matching deck exists locally:

1. By ID (if IDs are being preserved)
2. By title (fallback)

Apply `ImportOptions` if a match is found. Insert as new if no match.

**Step 4 — Reconstruct attachments**
For each attachment entry in the manifest, read `attachment_source`:

- `"media"` → reconstruct as `CardMediaAttachment`
- `"link"` → reconstruct as `CardLinkAttachment`

**Step 5 — Fix `_copyTemplate()`**
Pass `attachments` through when copying/reconstructing templates. Do not drop
them. Rewrite `templateId` on each attachment after ID rewriting.

**Step 6 — Media files (CardMediaAttachment only)**
For each `CardMediaAttachment` whose `content_path` is not null:
- Read the file bytes from the temp extraction directory
- Call `saveMediaLocally()` with the (possibly rewritten) attachment ID
- Set `localPath` on the reconstructed attachment

`CardLinkAttachment` entries are skipped in this step.

**Step 7 — Label uniqueness**
After ID rewriting, collect all labels across both attachment types within the
deck. If any duplicates exist, apply `generateFallbackLabel()` to the
conflicting entries.

**Step 8 — Save**
Write deck, templates, and all attachments to Hive via the local DB layer.
Do not write directly to Hive boxes in the service.

**Step 9 — Cleanup**
Delete the temp extraction directory regardless of success or failure.
Use a try/finally block.

### 6.6 Own backup path (source_user_id matches)

- Preserve all IDs as-is
- Upsert deck and templates by existing ID

### 6.7 Shared bundle path (source_user_id differs)

ID rewriting — before any Hive write:

```
newDeckId       = Uuid().v4()
templateIdMap   = { oldTemplateId: Uuid().v4(), ... }
attachmentIdMap = { oldAttachmentId: Uuid().v4(), ... }
```

Rewrite:
- `deck.id` → `newDeckId`
- each `template.id` → `templateIdMap[old]`
- each `template.deckId` → `newDeckId`
- each `attachment.id` → `attachmentIdMap[old]`
- each `attachment.templateId` → `templateIdMap[oldTemplateId]`

---

## 7. Deck Download — Media Phase

### 7.1 Read first

Read the existing deck download flow and `DownloadCheckpoint` before adding
anything. Understand current phases and how checkpoint state is persisted.

### 7.2 New phase

Add a `media` phase to `DownloadCheckpoint` after templates are saved:

```
metadata  → fetch deck + templates, save to Hive
media     → iterate CardMediaAttachment records, download, write localPath
```

`CardLinkAttachment` records are skipped in the media phase — they are
URL-only and require no download.

### 7.3 Checkpoint tracking

The checkpoint must track which attachment IDs have been downloaded. On
pause/resume, skip IDs already in the checkpoint. Do not re-download completed
files.

### 7.4 Media download

For each `CardMediaAttachment` in the downloaded deck:
- Download bytes from `publicUrl`
- Call `saveMediaLocally()` with the attachment ID
- Update the attachment record in Hive with the new `localPath`
- Mark the attachment ID as complete in the checkpoint

Read the local DB file to understand how to update an existing attachment
record. Do not assume the update method signature.

---

## 8. What Not To Do

- Do not create or modify any UI, widget, screen, or dialog files. Logic only.
- Do not write directly to Hive boxes in the service or controller. Go through
  the local DB layer.
- Do not include `localPath` in any Supabase payload.
- Do not silently sanitize labels on user input. `sanitizeLabel()` is for
  import only.
- Do not assume Hive field indices. Read the existing adapter or annotations.
- Do not hardcode the documents directory path. Use
  `getApplicationDocumentsDirectory()`.
- Do not generate new IDs at sync time. ID rewriting is import-time only.
- Do not skip reading `_copyTemplate()` — the attachment-dropping bug must be
  fixed.
- Do not use two separate attachment lists on `CardTemplate`. Use
  `List<CardAttachment>`.
- Do not download or cache `CardLinkAttachment` URLs. They are online-only.
- Do not manually edit `pubspec.yaml` for new packages. Use the Dart MCP
  `pub add` tool.
