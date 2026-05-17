# BooMondai — Current Context
> Last updated: 2026-05-17
> Use this file to resume a session. It should describe the real repo state,
> not the original plan.

---

## 0. Branch / Git State

- Active branch: `rework`
- Local branch status at last update: `rework` is **ahead of `origin/rework` by 1 commit**.
- Last local commit:
  - `30cd266 chore(repo): sync generated files and context`
- Push attempt failed because the non-interactive shell could not read GitHub HTTPS credentials:
  - `fatal: could not read Username for 'https://github.com': No such device or address`
- To publish the last local commit, run from an authenticated terminal:

```bash
git push origin rework
```

Recent commits on `rework`:

| Commit | Message |
|---|---|
| `30cd266` | `chore(repo): sync generated files and context` |
| `bf36ecd` | `fix(hive): register deck browser adapters` |
| `2e858a6` | `refactor(app): migrate services and UI to repository API` |
| `364726d` | `feat(models): add deck browser DTOs` |
| `55e4b5d` | `refactor(controllers): use repository primary-key API` |
| `279b07d` | `fix(schema): align fsrs ownership with profiles` |
| `cfa4788` | `fix(schema): timestamp deck tag join rows` |
| `6437713` | `refactor(database): support map-based primary keys` |

---

## 1. Database Base Refactor — Done

The old id-only repository base classes were replaced with map-based primary-key APIs so tables with composite keys can be represented correctly.

### 1a. `SupabaseRemoteDB<T>`

File: `lib/database/remote/supabase_remotedb.dart`

Current design:

- Subclasses provide:
  - `tableName`
  - `fromMap`
  - `toMap`
  - `primaryKeyFromItem(T item)`
- Primary keys are passed as `Map<String, Object?>`, not as a single string id.
- `primaryKeyColumns` was intentionally removed.
- `primaryKeyFromItem` was kept because it prevents repeated PK construction at call sites for item-based operations.
- Logging only runs in debug mode.
- Generic CRUD now supports single-column and composite primary keys.
- `upsert` still uses Supabase/PostgREST `onConflict` where needed because Supabase must know which unique constraint or column set to target for conflict resolution.

Important API shape:

```dart
typedef RemotePrimaryKey = Map<String, Object?>;

Future<List<T>> selectMany({Map<String, Object?>? filters});
Future<T?> selectByPk(RemotePrimaryKey primaryKey);
Future<T> insert(T item);
Future<void> update(T item);
Future<void> upsert(T item, {String? onConflict});
Future<void> delete(T item);
Future<void> deleteByPk(RemotePrimaryKey primaryKey);
```

### 1b. `HiveLocalDB<T>`

File: `lib/database/local/hive_localdb.dart`

Current design:

- Subclasses provide:
  - `boxName`
  - `primaryKeyFromItem(T item)`
- `boxName` should match the Supabase table name.
- Hive keys are encoded primary-key maps.
- Composite keys are encoded with sorted JSON keys so the same logical PK always maps to the same Hive key regardless of map insertion order.
- Logging only runs in debug mode.

Example Hive box keys:

```text
{"id":"deck_123"}
{"deck_id":"deck_123","tag_id":"tag_456"}
{"card_template_id":"card_123","tag_id":"tag_456"}
```

The encoded key is only the Hive storage key. The model stored as the value still contains the normal fields.

---

## 2. Schema Updates — Done

File: `supabase/migrations/20260505020000_init_v2.sql`

The current migration was edited directly because the project is not production yet.

Changes applied:

- Added timestamps to join rows that needed them:
  - `deck_tags.created_at`
  - `card_template_tags.created_at`
- Aligned FSRS/user-owned review tables with the local profile model by referencing `profiles(id)` where appropriate.
- Added/fixed helper logic for current profile id in RLS.
- Added/kept `deck_listings.created_at`.
- Updated comments/trigger areas that were inconsistent with the new schema direction.

Do not add a new migration file yet unless the project starts treating migrations as production history.

---

## 3. Model Refactor — Done

Model work added the public deck browser/storefront model layer and fixed DTO assumptions that were wrong for composite keys.

### 3a. Base DTO Changes

File: `lib/models/dto.dart`

The previous `DTO` / `WriteOnceDTO` base classes assumed every model has:

- `id`
- `createdAt`
- `updatedAt`

That assumption is false. Some tables are join tables with composite keys, and some tables do not have all timestamp columns.

The base DTO concept was reduced/removed from places where it forced the wrong shape. Models now own their actual schema instead of inheriting a fake universal primary key.

### 3b. New / Expanded Models

Key files in `lib/models/dtos/`:

- `deck.dto.dart`
- `tag.dto.dart`
- `deck_listing.dto.dart`
- `deck_tag.dto.dart`
- `card_template_tag.dto.dart`
- `user_review_card_tag.dto.dart`
- `visibility_state.dto.dart`

`Deck` was expanded for the online browser:

- `userId`
- `shortDescription`
- `longDescription`
- `coverImageUrl`
- `sourceDeckId`
- `visibilityState`
- `isPublished`
- `isEditable`
- `version`
- `buildNumber`
- `tags: List<Tag>`
- `listing: DeckListing?`

New models support:

- Global/user tags
- Deck listings/storefront stats
- Deck/tag join rows
- Card-template/tag join rows
- User review-card tags
- Visibility state enum

### 3c. Hive Adapter Registration

File: `lib/hive/adapters.dart`

New models were registered:

- `VisibilityState`
- `Tag`
- `DeckListing`
- `DeckTag`
- `CardTemplateTag`
- `UserReviewCardTag`

Generated Hive files were rebuilt after registration.

---

## 4. Database Classes — Done

Database classes in `lib/database/local/` and `lib/database/remote/` were migrated to the new primary-key API.

New/updated DB classes include:

- `DeckRemoteDB` / `DeckLocalDB`
- `DeckListingRemoteDB` / `DeckListingLocalDB`
- `TagRemoteDB` / `TagsLocalDB`
- `DeckTagRemoteDB` / `DeckTagLocalDB`
- `CardTemplateRemoteDB` / `CardTemplateLocalDB`
- `CardTemplateTagsRemoteDB` / `CardTemplateTagLocalDB`
- `ReviewCardRemoteDB` / `ReviewCardLocalDB`
- `DrillSessionRemoteDB` / `DrillSessionLocalDB`
- `UserReviewCardTagRemoteDB` / `UserReviewCardTagLocalDB`
- FSRS/review/profile/streak related DB classes

Barrel files were regenerated/updated after file additions and renames.

---

## 5. Controller Refactor — Done

Controllers in `lib/controllers/` were migrated away from the old id-only repository API.

Known completed work:

- Replaced old calls like `getById`, `put`, `delete(id)` where they conflicted with the new DB API.
- Migrated controllers to item-based or map-PK repository calls.
- Updated online browser controller for the new deck/tag data.
- `dart analyze lib/controllers` was clean at the time of the controller commit.

Relevant commit:

- `55e4b5d refactor(controllers): use repository primary-key API`

---

## 6. Services / Pages / Widgets Refactor — Done

Services, pages, and widgets were migrated to the new repository API and online deck browser structure.

Relevant commit:

- `2e858a6 refactor(app): migrate services and UI to repository API`

### 6a. Online Deck Browser

Current files:

- `lib/pages/view_decks_online_page.dart`
- `lib/controllers/view_decks_online_page_controller.dart`
- `lib/widgets/online_deck_detail_sheet.dart`
- `lib/widgets/online_deck_browser/filter_bar.dart`
- `lib/widgets/online_deck_browser/browse_deck_tile.dart`

The page currently supports:

- Search
- Tag filtering
- Pull-to-refresh
- Public deck list
- Deck tags display
- Bottom-sheet deck details

The previous note saying `online_deck_detail_sheet.dart` was entirely commented out is outdated. It was rebuilt during the app/UI migration.

### 6b. Widget Barrels

Many `*.barrel.dart` files under `lib/widgets/` were regenerated/updated.

This is expected because the widget structure changed and generated exports were synced.

---

## 7. Current Verification State

Last known verification:

- Full `dart analyze` was run after the app/UI refactor.
- It exited with code `0`.
- Only info-level lints remained.

No new verification has been run after the final context/generated-files commit.

Recommended next verification before major new work:

```bash
dart analyze
```

---

## 8. Remaining Product Work

The core database/model/controller/widget refactor is done. The next work should be product behavior, not repository plumbing.

### 8a. Drill Session Overhaul

Still relevant unless verified against current code:

- Fix answer recognition if any drill path still fails to load answer/template data correctly.
- Keep drill local-first: no Supabase blocking during card answering.
- Keep/verify three-strike behavior per session/card.
- Verify all six question type UIs:
  - `flashcard`
  - `identification`
  - `multipleChoice`
  - `fillInTheBlanks`
  - `wordScramble`
  - `matchMadness`
- Verify Anki-style FSRS counter:
  - New
  - Learning/Relearning
  - Review

### 8b. Review Page

Still relevant unless verified against current code:

- Post-drill prompt: review now vs later.
- FSRS enrollment for correctly answered cards.
- FSRS enrollment with `Rating.again` for three-strike cards.
- Early-review rule:
  - Due within 1 hour: reviewable.
  - Due more than 1 hour away: shown locked/greyed with countdown.
- Due indicator format:

```text
Due in 0d 0h 10m 23s
Overdue since 1d 3h 22m 0s
```

### 8c. Sync System

Design decision remains:

- App is local-first.
- Hive is the source of truth during app use.
- Supabase is a sync target.
- Sync is manual except publish-related queueing.

Still to verify/complete:

- Sync button on `/my-decks`.
- Sync button on review page.
- Cancel sync behavior.
- Last-synced timestamp display.
- Per-deck sync ordered alphabetically.
- Conflict handling:
  - Own deck: local wins.
  - Copied deck routine sync: local wins for the user's copy.
  - Explicit "Update from original author": diff UI.

### 8d. `/my-decks`

Still relevant unless verified against current code:

- Reads Hive first.
- No auto-fetch unless cache is empty or a copied browser deck needs hydration.
- Manual refresh button pulls from remote.
- Delete deck locally immediately with confirmation.
- Remote deletion handled on next sync.

### 8e. Deck Editor

Still relevant unless verified against current code:

- Card edits write to Hive first.
- No Supabase write on every edit.
- Push changes button per deck.
- Dirty-state indicator.

---

## 9. Resolved Design Decisions

- Composite primary keys are represented as maps in repository APIs.
- Hive encodes primary-key maps to stable JSON strings for storage keys.
- `boxName` should match the Supabase table name.
- Repository logging should only run in debug mode.
- Do not keep deprecated compatibility methods just to hide migration errors.
- `primaryKeyColumns` was removed.
- `primaryKeyFromItem` was kept.
- `onConflict` is still needed for Supabase upserts where conflict target is not the default primary key or where the database needs an explicit composite unique target.
- Directly edit `20260505020000_init_v2.sql` while pre-production.
- Use `VisibilityState` instead of `isPublic`.
- Use `isPublished` to mean "this deck should be published/synced to the browser".
- A copied deck may later be re-published as the user's own independent deck with `sourceDeckId` attribution.

---

## 10. Files / Areas Most Likely To Need Attention Next

Start here when resuming:

- `lib/pages/view_decks_online_page.dart`
- `lib/widgets/online_deck_detail_sheet.dart`
- `lib/widgets/online_deck_browser/`
- `lib/controllers/view_decks_online_page_controller.dart`
- `lib/controllers/my_decks_page_controller.dart`
- `lib/controllers/deck_editor_page_controller.dart`
- `lib/controllers/drill_session_controller.dart`
- `lib/controllers/review_session_controller.dart`
- `lib/database/local/hive_localdb.dart`
- `lib/database/remote/supabase_remotedb.dart`
- `supabase/migrations/20260505020000_init_v2.sql`

Before editing, check:

```bash
git status --short --branch
dart analyze
```

---

## 11. Previous Phase Plan Status

The old phase plan in this file was stale. The accurate status is:

| Area | Status |
|---|---|
| Database base refactor | Done |
| Schema alignment for current refactor | Done |
| Model/browser DTOs | Done |
| Hive adapter registration | Done |
| Database class migration | Done |
| Controller migration | Done |
| Services/pages/widgets migration | Done |
| Generated mappers/barrels sync | Done locally in `30cd266`; push still needed |
| Product behavior verification | Still needed |
| Sync UX completion/verification | Still needed |

