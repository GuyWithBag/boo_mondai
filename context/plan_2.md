# Change Review Plan

## Goal

Build the sync/download/import-export review flow shown in:

- `context/design/sync_changes.page.png`
- `context/design/sync_results.loading.page.png`
- `context/design/sync_results.page.png`

The page must work for:

- normal sync
- online deck downloads
- import/export operations

This should not be implemented as a sync-only feature. Sync, downloads, and
import/export are all producers of one shared change-review model.

## Naming Decision

There is no longer a need for `SyncChangeLog`.

Delete:

- `lib/features/sync/models/sync_change_log.dart`
- `lib/features/sync/models/sync_change_type.dart`
- `ImportExportChangeLog`
- `ImportExportChangeType`

Replace them with a generic change-review model, probably under:

```text
lib/features/change_review/
```

Use names like:

- `ChangeLog`
- `ChangeType`
- `ChangeReviewPlan`
- `ChangeReviewItem`
- `ChangeFieldDiff`

`SyncChangeLog` is too narrow because downloads and import/export need the same
representation. `ImportExportChangeLog` is also too narrow because it is only a
message log and does not carry enough structured before/after data for the new
UI.

## Core Model

Create:

```text
lib/features/change_review/models/change_type.dart
lib/features/change_review/models/change_source.dart
lib/features/change_review/models/change_review_status.dart
lib/features/change_review/models/change_field_diff.dart
lib/features/change_review/models/change_log.dart
lib/features/change_review/models/change_review_plan.dart
lib/features/change_review/models/models.barrel.dart
```

Suggested shape:

```dart
enum ChangeType {
  added,
  modified,
  removed,
  skipped,
}

enum ChangeSource {
  sync,
  deckDownload,
  importExport,
}

enum ChangeReviewStatus {
  idle,
  previewing,
  reviewing,
  applying,
  completed,
  failed,
  canceled,
}

class ChangeFieldDiff {
  const ChangeFieldDiff({
    required this.field,
    this.before,
    this.after,
  });

  final String field;
  final Object? before;
  final Object? after;
}

class ChangeLog {
  const ChangeLog({
    required this.type,
    required this.source,
    required this.entityType,
    required this.entityId,
    required this.title,
    this.subtitle,
    this.before,
    this.after,
    this.fields = const [],
  });

  final ChangeType type;
  final ChangeSource source;
  final String entityType;
  final String entityId;
  final String title;
  final String? subtitle;
  final Object? before;
  final Object? after;
  final List<ChangeFieldDiff> fields;
}

class ChangeReviewPlan {
  const ChangeReviewPlan({
    required this.id,
    required this.source,
    required this.title,
    required this.status,
    required this.changes,
    this.progress,
    this.errorMessage,
  });

  final String id;
  final ChangeSource source;
  final String title;
  final ChangeReviewStatus status;
  final List<ChangeLog> changes;
  final double? progress;
  final String? errorMessage;

  int get addedCount;
  int get modifiedCount;
  int get removedCount;
}
```

## Operation Store

Replace or rename `SyncOperationLog` into a source-neutral store:

```text
lib/features/change_review/change_review_store.dart
```

Responsibilities:

- hold active and completed `ChangeReviewPlan`s in memory
- update status and progress
- attach structured changes
- expose `activePlans`, `plans`, and `planById`
- notify pages when status/progress/changes update

This replaces sync-specific operation state. The sync feature can still start a
plan, but it should not own the generic change UI state.

## Sync Refactor

Current files to change:

- `lib/features/sync/models/sync_result.dart`
- `lib/features/sync/models/sync_operation.dart`
- `lib/features/sync/sync.service.dart`
- `lib/features/sync/sync_operation_log.dart`
- `lib/features/sync/models/models.barrel.dart`

Changes:

1. Remove `SyncChangeLog` and `SyncChangeType`.
2. Make `SyncResult.changes` use `List<ChangeLog>`.
3. Make `SyncOperation` either disappear or become a thin wrapper around
   `ChangeReviewPlan`.
4. Change `SyncService.pull` and `SyncService.push` to emit `ChangeLog`.
5. Use `ChangeType.added` for remote/local records that did not exist.
6. Use `ChangeType.modified` for newer records replacing older records.
7. Use `ChangeType.skipped` only for records intentionally ignored.

First pass can stay result-viewer only:

```text
sync runs -> changes are applied -> completed page -> show results
```

True pre-apply sync review can come after the UI is stable:

```text
preview sync -> show changes -> user approves -> apply sync
```

## Deck Downloads Refactor

Current files to change:

- `lib/features/deck_downloads/deck_downloads.service.dart`
- `lib/features/deck_downloads/models/deck_download_plan.dart`
- `lib/features/deck_downloads/models/deck_download_result.dart`

Changes:

1. Replace `List<SyncChangeLog>` with `List<ChangeLog>`.
2. Map download changes to `ChangeSource.deckDownload`.
3. Emit `ChangeType.added` for a new local deck and copied card templates.
4. Emit `ChangeType.modified` when the published deck/card is newer.
5. Emit `ChangeType.removed` when a local card points to a source template that
   no longer exists remotely.
6. For the deck-added visual block, render the existing/default deck view state
   for now.

Downloads can support a real preview flow earlier than sync because
`DeckDownloadPlan` already fetches remote/local data before applying changes.

Target flow:

```text
previewDeckDownload -> change review page -> Looks Good -> applyDeckDownload
```

This means splitting current `downloadDeck` into:

- `previewDeckDownload`
- `applyDeckDownloadPlan`
- optional convenience method for places that do not need review

## Import/Export Refactor

Current files to change:

- `lib/features/import_export/models/import_export_change_log.dart`
- `lib/features/import_export/import_export.service.dart`
- `lib/features/import_export/import_export.controller.dart`
- `lib/features/import_export/import_export.local.db.dart`
- `lib/features/import_export/models/import_export_backup.dto.dart`

No backwards compatibility is required, so replace the old import/export log
model instead of adapting around it.

Changes:

1. Delete `ImportExportChangeLog` and `ImportExportChangeType`.
2. Rename the file or move shared pieces into `change_review`.
3. Change `ImportExportResult<T>` and `ImportExportBatchResult<T>` to use
   `List<ChangeLog> changes`.
4. Replace controller state `latestChangeLogs` with `latestChanges`.
5. Update backup JSON from old message logs to serialized generic change logs.
6. For card import preview, emit structured changes before applying decisions.
7. For deck import/update, emit deck field diffs and card template changes.

Import/export should become:

```text
preview import -> show changes -> apply import
```

Export operations do not need pre-apply review because they do not mutate local
deck/card data, but they can still produce a completed result page if useful.

## Field Diff Strategy

The detailed review page needs structured field-level values, not only messages.

For card templates, support at least:

- `frontText`
- `backText`
- `promptText`
- `questionPrompt`
- `acceptedAnswers`
- `options`
- `segments`
- `pairs`
- `sentenceToScramble`
- `tags`

Do not try to make every card type perfect in the first pass. Add a helper like:

```text
lib/features/change_review/change_review_diff.service.dart
```

Responsibilities:

- compare `Deck` values
- compare `CardTemplate` values by runtime type
- compare tag lists
- create short display labels and field diffs

For unsupported fields, emit a conservative item-level `ChangeType.modified`
with a clear title.

## UI Pages

Create:

```text
lib/features/change_review/change_review.page.dart
lib/features/change_review/change_review.controller.dart
lib/features/change_review/change_review.barrel.dart
lib/features/change_review/widgets/change_summary_chips.dart
lib/features/change_review/widgets/change_review_card.dart
lib/features/change_review/widgets/change_field_diff.dart
lib/features/change_review/widgets/change_review_actions.dart
lib/features/change_review/widgets/change_review_loading_view.dart
lib/features/change_review/widgets/change_review_complete_view.dart
lib/features/change_review/widgets/widgets.barrel.dart
```

Add route:

```text
/change-review/:planId
```

Render states:

- `applying` or `previewing`: centered sync icon, title, percent, progress bar,
  cancel button
- `completed`: centered sync icon, summary chips, Show Results, Done, Discard
  Changes
- `reviewing`: detailed list of changes with Back, Discard, Looks Good
- `failed`: existing error state pattern

## UI Styling

Use `AppTokens`.

Page:

- background: `tokens.colorPageBackground`
- cards: `tokens.colorSurfaceBackground`
- borders/dividers: `tokens.colorBorderNeutralSubtle`
- main text: `tokens.colorTextBaseline`
- secondary text: `tokens.colorTextSecondary`
- muted previous values: `tokens.colorTextMuted`

Change color mapping:

- `ChangeType.added`: success tokens
  - `tokens.colorActionSuccess`
  - `tokens.colorActionSuccessBackground`
  - `tokens.colorActionSuccessBorder`
- `ChangeType.modified`: hard-rating tokens
  - `tokens.colorRatingHardText`
  - `tokens.colorRatingHardBackground`
  - `tokens.colorRatingHardBorder`
- `ChangeType.removed`: again-rating tokens
  - `tokens.colorRatingAgainText`
  - `tokens.colorRatingAgainBackground`
  - `tokens.colorRatingAgainBorder`

Skipped changes can use neutral text/border tokens.

## Button Semantics

`Looks Good`:

- applies the pending plan when the operation supports preview/apply
- for already-applied result pages, it should not appear

`Discard`:

- cancels and drops a pending preview
- must not delete already-applied local data unless a rollback feature exists

`Discard Changes` on the completed page:

- only show if the operation is still pending
- if the operation already applied, either hide this button or rename it to
  `Close`

`Cancel`:

- first pass can mark the plan as canceled if work has not reached the apply
  step
- do not pretend in-flight database/network operations can always be canceled

## Implementation Order

1. Create `change_review` models and store.
2. Remove `SyncChangeLog` and `ImportExportChangeLog`.
3. Convert sync result models to generic `ChangeLog`.
4. Convert deck download plans/results to generic `ChangeLog`.
5. Convert import/export result and batch result to generic `ChangeLog`.
6. Add `ChangeReviewDiffService` for deck/template/tag diffs.
7. Build the three UI states from the design images.
8. Add `/change-review/:planId` route.
9. Wire downloads to true preview/apply first.
10. Wire import deck/card import to preview/apply.
11. Keep sync as apply-then-results until a safe preview/apply sync refactor is
    done.
12. Add tests for:
    - summary counts
    - token mapping by change type
    - deck download change mapping
    - import card decision mapping
    - sync result mapping

## Acceptance Criteria

- No `SyncChangeLog` remains.
- No `ImportExportChangeLog` remains.
- Sync, deck downloads, and import/export all produce `List<ChangeLog>`.
- The change review page can render added, modified, and removed counts.
- Added uses success colors.
- Modified uses hard colors.
- Removed uses again colors.
- Deck-added cards use the default deck view state for now.
- Import/export no longer relies on message-only logs for review UI.
- `flutter test` passes.
