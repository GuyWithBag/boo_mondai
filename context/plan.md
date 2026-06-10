# Drift Migration Plan

## Goal

Move BooMondai local persistence from Hive plus hand-written DTO repositories to Drift-backed SQLite, while keeping Supabase as the remote sync backend.

The app should use generated Drift table rows, companions, and typed queries for local data instead of maintaining parallel DTOs solely for local storage. Supabase remains Postgres and keeps its existing migrations, RLS policies, functions, and remote schema contract.

Local Supabase development database:

```text
postgresql://postgres:postgres@127.0.0.1:54322/postgres
```

Use this connection string only for local schema inspection, migration validation, and tooling. Do not bake it into app runtime code or committed production config.

## Key Decision

Keep the current repository layout. The Flutter app stays at the repo root, and shared Drift code goes under `packages/`.

```text
boo_mondai/
├── lib/                         # existing Flutter app
├── pubspec.yaml                 # existing app package
├── packages/
│   ├── boo_mondai_db/           # pure Dart Drift database package
│   └── boo_mondai_migrations/   # Dart migration/schema tooling package
├── supabase/
│   └── migrations/              # remote Postgres migrations
└── context/
```

## What "Mirror Supabase" Means

Drift uses SQLite locally, while Supabase uses Postgres remotely. The SQL in `supabase/migrations/20260505020000_init_v2.sql` cannot be reused directly because it contains Postgres-only features such as enum types, extensions, RLS policies, functions, triggers, views, and JSON semantics.

For this project, "mirror Supabase" should mean:

- Use the same table names for sync-relevant local tables where practical.
- Use the same column names where practical.
- Keep UUIDs as `TEXT` locally.
- Store Postgres enums as `TEXT` locally with Dart enum type converters.
- Store Postgres `jsonb` fields as SQLite `TEXT` using JSON converters.
- Preserve `created_at`, `updated_at`, ownership fields, and sync-critical foreign keys.
- Skip remote-only behavior locally, including RLS policies, Supabase auth helpers, storage policies, remote aggregate views, and server-side triggers.

This keeps sync straightforward without forcing SQLite to pretend it is Postgres.

## Package Layout

### `packages/boo_mondai_db`

Pure Dart package containing:

```text
packages/boo_mondai_db/
├── pubspec.yaml
├── lib/
│   ├── boo_mondai_db.dart
│   └── src/
│       ├── database.dart
│       ├── tables/
│       ├── daos/
│       ├── converters/
│       ├── migrations/
│       └── sync/
└── test/
```

Responsibilities:

- Define Drift tables.
- Define generated database class.
- Define DAOs and typed query methods.
- Define local type converters.
- Define schema versions and migration steps.
- Accept an injected `QueryExecutor` or `DatabaseConnection` instead of importing Flutter, FFI, or web-only Drift backends directly.
- Expose a small public API through `boo_mondai_db.dart`.

The shared database class should import only `package:drift/drift.dart`. Platform-specific database opening belongs in the Flutter app, not in this pure Dart package.

### Abstract Local DAO Base

Use an abstract base class for the new Drift-backed local DB/DAO classes so table-specific DAOs share logging, guarded execution, and naming conventions without recreating a generic Hive-style repository.

Recommended shape:

```dart
typedef DriftPrimaryKey = Map<String, Object?>;

abstract class AppDriftDao {
  AppDriftDao(this.db);

  final BooMondaiDatabase db;

  String get tableName;

  Future<T> guard<T>(
    Future<T> Function() fn, {
    required String action,
  }) async {
    // Centralized debug logging and exception mapping.
    return fn();
  }
}
```

For entity tables, add a narrower abstract class only when it removes real duplication:

```dart
abstract class EntityDriftDao<Row, InsertableRow> extends AppDriftDao {
  EntityDriftDao(super.db);

  DriftPrimaryKey primaryKeyFromRow(Row row);
}
```

Do not force every table into a single generic CRUD abstraction. Drift's generated tables, companions, composite keys, joins, and watched queries are strongly typed, and a too-generic base class would hide useful SQL shape. Keep common concerns in the abstract base, then implement typed methods in table-specific DAOs such as `DecksDao`, `CardTemplatesDao`, and `FsrsCardsDao`.

### `packages/boo_mondai_migrations`

Pure Dart CLI/tooling package containing:

```text
packages/boo_mondai_migrations/
├── pubspec.yaml
├── bin/
│   └── validate_schema.dart
└── test/
```

Responsibilities:

- Run Drift schema validation.
- Check generated schema snapshots.
- Optionally compare Supabase table contracts against local Drift tables.
- Provide migration-focused tests separate from Flutter widget tests.

This package should depend on `boo_mondai_db` by path.

## App Dependency Changes

Root `pubspec.yaml` should eventually depend on the local database package:

```yaml
dependencies:
  boo_mondai_db:
    path: packages/boo_mondai_db
  drift_flutter: ^0.3.1-wip
  path_provider: ^2.1.5
```

The root app can remove direct Hive dependencies once all Hive local repositories are gone. The Flutter app should own the platform-specific opening code, using `driftDatabase` from `package:drift_flutter` for native and web support where possible.

Expected database package dependencies:

```yaml
dependencies:
  drift: ^2.33.0
  uuid: ^4.5.1

dev_dependencies:
  build_runner: ^2.15.0
  drift_dev: ^2.33.0
  test: ^1.25.0
```

If a separate pure Dart CLI opens SQLite databases directly, that CLI package should depend on `sqlite3` instead of making the shared database package depend on a native backend.

For Flutter web, include the Drift web assets in `web/`:

- `sqlite3.wasm`
- `drift_worker.dart.js`

The app connection should pass these files through Drift web options. Production hosting must serve `.wasm` files as `application/wasm`. COOP/COEP headers can improve web persistence performance, but they need explicit testing because they may interfere with popup-based auth flows.

## Code Generation Mode

Use Drift modular code generation for this project.

Reasoning:

- BooMondai has many tables.
- A single generated `database.g.dart` would become large.
- Modular generation keeps generated files closer to their table or query files.
- Drift's docs call out modular generation as intended for larger projects with many tables or views.

Add `build.yaml` in `packages/boo_mondai_db` with the default Drift builder disabled and `drift_dev:analyzer` plus `drift_dev:modular` enabled.

Recommended initial options:

```yaml
targets:
  $default:
    builders:
      drift_dev:
        enabled: false
      drift_dev:analyzer:
        enabled: true
        options: &drift_options
          store_date_time_values_as_text: true
          named_parameters: true
          sql:
            dialect: sqlite
            options:
              version: "3.39"
      drift_dev:modular:
        enabled: true
        options: *drift_options
```

`store_date_time_values_as_text: true` makes the DateTime decision explicit and readable. Revisit only if profiling shows timestamp comparisons need integer storage.

## Migration Scope

Replace both:

- Hive-backed local storage.
- DTO classes that exist primarily to shuttle local database rows around.

Do not remove all Dart models blindly. Keep domain/value objects where they express app behavior better than database rows, for example UI-only filters, computed session state, theme token objects, and external package models.

## Local Data Policy

Local storage can be reset. No Hive-to-Drift data migration is required.

The app should include a one-time cleanup path during the transition:

- Stop opening old Hive boxes.
- Delete or ignore old Hive data directories after Drift is enabled.
- Remove guest Hive migration logic after equivalent Drift behavior exists.

## Schema Groups

Implement the Drift schema in groups that match the Supabase migration and current feature folders.

### Core Identity

- `profiles`
- cached active profile or app session metadata
- `user_settings`
- theme overrides and custom theme presets, if they remain persisted locally

### Deck Authoring

- `tags`
- `decks`
- `deck_tags`
- `card_templates`
- `card_template_tags`
- `multiple_choice_options`
- `fill_in_the_blank_segments`
- `match_madness_pairs`

### Card Template Polymorphism

Keep the database shape aligned with Supabase:

- one `card_templates` table for common template identity plus type-specific scalar columns
- child tables for repeated/normalized data:
  - `multiple_choice_options`
  - `fill_in_the_blank_segments`
  - `match_madness_pairs`
  - `card_template_tags`

Do not create separate Drift tables named `flashcard_templates`, `identification_templates`, and so on unless the remote schema changes too. The current Supabase contract already stores all template types in `card_templates` using the `type` discriminator and nullable type-specific columns.

Keep polymorphic Dart behavior as domain/query models, not as separate local storage DTOs:

```text
CardTemplates table row + joined child rows
└── CardTemplateDomain / existing CardTemplate subclass
    ├── FlashcardTemplate.checkAnswer()
    ├── IdentificationTemplate.checkAnswer()
    ├── MultipleChoiceTemplate.checkAnswer()
    ├── FillInTheBlanksTemplate.checkAnswer()
    ├── MatchMadnessTemplate.checkAnswer()
    └── WordScrambleTemplate.checkAnswer()
```

The recommended implementation is:

- Drift stores generated rows and companions matching the local SQLite schema.
- `CardTemplatesDao` exposes row-level methods for inserts, updates, deletes, and joins.
- A small `CardTemplateAssembler` or DAO method converts a joined Drift result into the existing `CardTemplate` subclass when UI/study logic needs `checkAnswer`.
- Writes go the other direction through explicit companion builders, for example `CardTemplateWriteMapper.toCardTemplatesCompanion(template)`.

This means a Dart class like `FlashcardTemplate extends CardTemplate` remains useful for behavior, but it should not own a Drift `Table` instance. A Drift table is schema metadata; a `CardTemplate` object is an app/domain value.

### Study Runtime

- `study_cards`
- `user_study_cards_tags`
- `drill_sessions`
- `drill_answers`
- `review_sessions`

### FSRS

- `fsrs_cards`
- `review_logs`
- due-review query indexes
- deck-level due counts and review summaries as queries, not stored DTOs unless profiling proves storage is needed

### Storefront And Social

- `deck_listings`
- `deck_votes`
- `deck_vote_reviews`
- `deck_vote_review_comments`
- `deck_comments`
- `deck_downloads`
- `deck_favorites`
- `deck_reports`
- edit log tables where the app needs offline access

### Research

- `research_profiles`
- `research_codes`
- `survey_responses`
- `vocabulary_test_results`

Research tables may be implemented later if they are remote-only in practice.

## Type Mapping Rules

Use consistent mappings across all tables:

| Supabase/Postgres | Drift/SQLite | Dart |
| --- | --- | --- |
| `uuid` | `TEXT` | `String` or typed id wrapper later |
| `text` | `TEXT` | `String` |
| `boolean` | `BOOLEAN` | `bool` |
| `integer` | `INTEGER` | `int` |
| `double precision` | `REAL` | `double` |
| `timestamptz` | `INTEGER` or `TEXT` | `DateTime` |
| `jsonb` | `TEXT` | `Map/List` via converter |
| Postgres enum | `TEXT` | Dart enum via converter |

Prefer storing `DateTime` in UTC. Pick one representation early and use it everywhere.

## Sync Direction

The app should move toward a sync layer that depends on Drift DAOs locally and Supabase repositories remotely.

Initial shape:

```text
Feature service
├── local DAO from boo_mondai_db
└── remote Supabase repository
```

Long-term shape:

```text
Feature service
├── local Drift DAO
├── remote Supabase data source
└── sync coordinator
```

The current generic `SyncService<T extends DTO>` should be replaced because Drift rows and Supabase maps will not share a single DTO type cleanly.

RLS policies remain entirely on Supabase. Drift/SQLite does not enforce Supabase RLS locally. Local DAOs should filter by active profile/deck ownership for user experience and data isolation, but the authoritative security check happens when PostgREST/Supabase receives the insert, update, delete, or select. If a local row violates RLS, the push fails and the sync adapter must surface or record that failure.

Use table-specific sync adapters:

- `pullRemoteSince(lastPulledAt)`
- `upsertLocalFromRemote(remoteRow)`
- `pendingLocalChanges()`
- `pushLocalChange(change)`
- `markSynced(rowId, remoteUpdatedAt)`

Add local sync metadata where needed:

- `sync_status`
- `last_synced_at`
- `deleted_at` for tombstones where deletes must sync
- `dirty_fields` only if partial-field conflict handling becomes necessary

### Drift To Supabase Writes

Do not insert Drift table classes directly into Supabase. The write path should be explicit:

```text
Drift row/companion
└── table-specific sync payload or map
    └── SupabaseRemoteDB.upsert/insert/update
```

For example:

```dart
final row = await cardTemplatesDao.selectById(id);
final payload = CardTemplateSyncMapper.rowToRemoteMap(row);
await cardTemplatesRemoteDB.upsertMap(payload);
```

The exact method names can change, but the boundary should stay table-specific. A mapper is still needed at sync boundaries because:

- Drift uses generated row/companion classes.
- Supabase writes use JSON-like `Map<String, dynamic>` payloads and PostgREST column names.
- joined relation fields such as `tags`, `options`, `segments`, and `pairs` must not be written to the parent table.
- DateTime, enum, JSON, tombstone, and sync metadata conversions need one obvious home.

Keep mappers small and directional:

- `remoteMapToCompanion`
- `rowToRemoteMap`
- `domainToCompanion`
- `joinedRowsToDomain`

Avoid rebuilding one large app-wide DTO mapper layer. Keep mappers beside the DAO/sync adapter for the table group they serve.

## DAO Naming

DAO method names should reflect SQL commands and query shape. Avoid vague repository names like `getDecks`, `saveDeck`, `removeDeck`, or `loadCards`.

Preferred naming:

| Operation | Method name examples |
| --- | --- |
| `SELECT` one row | `selectById`, `selectByPrimaryKey`, `selectActiveProfile` |
| `SELECT` many rows | `selectAll`, `selectByDeckId`, `selectDueCards` |
| watched `SELECT` | `watchAll`, `watchById`, `watchByDeckId`, `watchDueCards` |
| `INSERT` | `insertOne`, `insertMany` |
| `UPDATE` | `updateOne`, `updateById`, `updateFsrsState` |
| `UPSERT` | `upsertOne`, `upsertMany`, `upsertFromRemote` |
| `DELETE` | `deleteById`, `deleteByPrimaryKey`, `deleteByDeckId` |
| aggregate `SELECT` | `countDueCards`, `sumReviewXp`, `selectDeckStats` |

Use feature-specific words only after the SQL command. For example, prefer `selectDueCards(deckId)` over `getDueCards(deckId)`, and `upsertFromRemote(row)` over `saveRemoteRow(row)`.

## Implementation Phases

### Phase 1: Scaffold Packages

- Add `packages/boo_mondai_db`.
- Add `packages/boo_mondai_migrations`.
- Wire path dependencies.
- Add Drift modular build configuration.
- Add app-level database connection code using `drift_flutter`.
- Add web database assets and connection options if web remains a supported target during the first slice.
- Add a smoke test that opens an in-memory Drift database.

### Phase 2: Port Core Schema

- Add tables for profiles, decks, tags, card templates, study cards, FSRS cards, and review logs.
- Add enum and JSON converters.
- Generate Drift code.
- Add schema tests for table creation and basic inserts.

### Phase 3: Replace Local Repository Base

- Introduce Drift DAOs equivalent to current `HiveLocalDB` use cases:
  - `selectAll`
  - `selectByPrimaryKey`
  - `insertOne`
  - `upsertOne`
  - `deleteByPrimaryKey`
  - `watchAll`
  - `watchByPrimaryKey`
- Replace feature local repositories one group at a time.
- Keep public feature service APIs stable where possible to limit UI churn.

### Phase 4: Replace Hive Initialization

- Remove Hive initialization from `lib/main.dart`.
- Initialize the Drift database once at app startup.
- Provide the database through the existing provider/service registration pattern.
- Stop registering Hive adapters.

### Phase 5: Replace DTO-Dependent Sync

- Replace `SyncService<T extends DTO>` with table-specific sync adapters.
- Keep Supabase remote repositories initially if that lowers risk.
- Convert remote maps directly into Drift companions or sync payload objects.
- Remove DTO mappers only after their callers are gone.

### Phase 6: Port Remaining Tables

- Port storefront, comments, votes, research, settings, imports/exports, and cached profile tables.
- Replace query-specific DTOs with Drift joins or typed result classes where possible.
- Keep view-only remote models only when they represent Supabase views or RPC output that has no local table.

### Phase 7: Cleanup

- Remove Hive dependencies and generated adapters.
- Remove obsolete local DB classes.
- Remove DTOs that no longer have app/domain value.
- Remove generic DTO base classes if no longer used.
- Update docs and context files.

## Testing Plan

For `boo_mondai_db`:

- In-memory database open/close test.
- Table insert/select/update/delete tests.
- DAO watch stream tests for critical screens.
- Export Drift schema snapshots after every schema version.
- Generate migration test helpers with `dart run drift_dev schema generate`.
- Migration tests between schema versions with `SchemaVerifier`.
- Sync metadata tests for dirty, synced, and deleted states.
- Debug-only runtime schema validation in app builds once migrations exist.

For the Flutter app:

- Smoke widget test with a test database provider.
- Deck list loads from Drift.
- Deck editing writes through Drift.
- FSRS review updates card state and writes review log.
- Settings persist across app restart.

Before major merge points, run:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format lib test packages
flutter analyze
flutter test
```

For package-only work, also run:

```bash
cd packages/boo_mondai_db
dart test
dart run build_runner build --delete-conflicting-outputs
dart run drift_dev schema generate drift_schemas test/generated_migrations
```

## Risks And Decisions To Revisit

- Drift generated row classes are database records, not always ideal domain models. Some UI/domain models should stay.
- Supabase views and RPC outputs may still need lightweight response models.
- Web SQLite support needs explicit validation before Hive is removed for web builds.
- Conflict resolution needs a clear policy before full offline editing is enabled.
- JSON-heavy card content may be easier to sync but harder to query. Normalize fields that the app filters or joins on.
- Removing DTOs all at once is high risk. Remove them only after each feature compiles and tests through Drift.

## Recommended First Implementation Slice

Start with decks, tags, card templates, study cards, FSRS cards, and review logs.

This slice proves the main offline learning loop:

- create or load deck
- load cards
- review due cards
- update FSRS state
- write review history
- watch local changes in UI

After that works, move settings and profile caching, then storefront/social tables.
