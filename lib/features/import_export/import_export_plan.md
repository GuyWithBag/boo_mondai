# Import Export Feature Plan

## Goal

Build an `import_export` feature for local deck and card movement.

The feature should support:

- Exporting one deck.
- Exporting multiple decks.
- Importing one deck.
- Importing multiple decks.
- Exporting cards from a deck.
- Importing cards into a deck.
- Detecting similar imported cards before applying changes.
- Returning change logs for every import/export action.
- Persisting backup/import history locally.

No widgets are part of this phase.

## Export Format

Use JSON.

The service should produce app-native JSON maps that can be encoded later by a controller, file picker flow, share sheet, or backup system.

The deck export payload should include:

- Deck metadata.
- Card templates.
- Tags.
- Media references such as image/audio URLs.

The payload should not include binary media files. Media URLs should be copied as-is.

## Payload Direction

Payload direction answers the question: should service methods accept raw JSON strings or already-decoded Dart maps?

Chosen contract:

- Service layer accepts decoded `Map<String, dynamic>` and `List<Map<String, dynamic>>`.
- Service layer also accepts raw JSON strings through convenience methods.
- Controller layer can call either form depending on what the future widget receives.

Reason:

- Decoded-map methods keep the import/export core easy to test.
- Raw JSON methods are useful for file import, clipboard import, and backup restore flows.
- The JSON methods should decode and validate input, then delegate to the decoded-map methods.

Example shape:

```dart
final payload = jsonDecode(rawJson) as Map<String, dynamic>;
final result = await ImportExportService.importDeck(payload);
```

The service should also provide:

```dart
Future<ImportExportResult<Deck>> importDeckJson(String rawJson);
Future<ImportExportBatchResult<Deck>> importDecksJson(String rawJson);
Future<ImportCardsPlan> previewCardImportJson({
  required String deckId,
  required String rawJson,
});
```

## Import Deck Behavior

The user should be able to choose the import mode from UI, likely a modal.

Supported import modes:

- Create as new local deck.
- Update an existing local deck.
- Skip.

The service should not show the modal. It should expose enough data for a controller/widget to present the choice.

Recommended structure:

- A preview/plan method detects whether the payload looks related to an existing local deck.
- The caller chooses the import action.
- An apply method performs the chosen action and returns change logs.

## Multiple Deck Import

Multiple deck import should support partial success.

One invalid deck payload should not block the full batch. The result should include per-deck change logs and failures.

Recommended result shape:

- Imported/updated deck ids.
- Skipped deck ids or payload labels.
- Per-deck change logs.
- Per-deck errors.

## Card Export

Card export should export selected cards from one deck.

Supported scopes:

- All cards in a deck.
- A selected list of template ids.

The exported card payload should include:

- Card template base fields.
- Subtype-specific fields.
- Nested options/segments/pairs.
- Tags.
- Media URL references.
- Source template id when present.

## Card Import Into Deck

Card import should support a two-step flow.

First step: preview.

- Parse incoming card templates.
- Compare against existing templates in the target deck.
- Build similarity candidates.
- Return an import plan.

Second step: apply.

- The user chooses one action per candidate.
- The service creates, updates, or skips cards based on those choices.
- The service returns change logs.
- Study cards are reconciled after template changes.

## Similar Card Detection

Similarity detection should be configurable.

Default behavior:

- Compare all supported prompt/answer-ish fields.
- Prefer exact `sourceTemplateId` matches when present.
- Then use fuzzy text similarity.

Configurable options:

- Similarity threshold.
- Which fields participate in matching.
- Whether `sourceTemplateId` matching is enabled.
- Whether matching is limited to the same card type.

Recommended default threshold:

- `85` for likely duplicates.

## Candidate Actions

The user should be able to choose one of three actions for each candidate:

- Update existing.
- Import as new.
- Skip.

The plan should not automatically update similar cards. It should return candidates and let the caller decide.

## Change Logs

Every operation should return in-memory change logs.

Change log entries should include:

- Operation type: created, updated, skipped, failed.
- Entity type: deck, card template, tag, backup.
- Entity id when available.
- Human-readable message.
- Optional metadata with before/after references.

Examples:

- Created deck `Japanese N5`.
- Updated card template `犬 -> dog`.
- Skipped imported card because user chose skip.
- Failed to import deck because payload version is unsupported.

## Local Backup History

Import/export history should be persisted to a local table.

Recommended local model:

- `ImportExportBackup`
- `id`
- `operation`
- `type`
- `id`
- `title`
- `payload`
- `changeLogs`
- `createdAt`

This should use a local Hive DB, similar to other `LocalDB` repositories.

Remote sync is not required for this phase.

## Proposed Files

```text
lib/features/import_export/
  import_export.barrel.dart
  import_export.controller.dart
  import_export.service.dart
  import_export.local.db.dart
  import_export_plan.md
  models/
    import_export_backup.dto.dart
    import_export_change_record.dart
    import_export_options.dart
    import_export_payload.dart
    import_export_plan.dart
    models.barrel.dart
```

## Service Responsibilities

`ImportExportService` should be static unless there is a strong reason to inject dependencies.

Responsibilities:

- Export one deck.
- Export multiple decks.
- Import one deck from decoded JSON payload.
- Import multiple decks from decoded JSON payloads.
- Export cards from a deck.
- Preview card import into a deck.
- Apply card import choices.
- Reconcile study cards after card import.
- Return change logs.
- Persist local backup/import history.

## Controller Responsibilities

`ImportExportController` should own UI-facing state only.

Responsibilities:

- Store current loading/error state.
- Hold current import preview plan.
- Hold latest change logs.
- Decode raw JSON strings if needed.
- Call service methods.
- Expose methods widgets can call later.

The controller should not contain fuzzy matching or persistence rules.

## Explicit Non-Goals For This Phase

- No widgets.
- No file picker.
- No CSV import/export.
- No binary media packaging.
- No cloud backup sync.
- No UI for viewing edit logs.
- No automatic merge without user-selected choices.
