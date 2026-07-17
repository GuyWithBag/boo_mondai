# Sync deletion implementation plan

## Objective

Implement sync deletion using soft-deleted domain rows with configurable
retention and active-client safety.

Important terminology:

```txt
tombstone = the original synced row with deleted_at != null
```

This plan does not reintroduce the old separate `SyncDeletion` model/table.

The desired behavior:

```txt
signed-in delete -> soft-deleted domain row -> sync deletion -> eventually purge
guest delete     -> hard delete locally
discard sync     -> local wins and remote mirrors local
```

## Phase 1: Model fields

Add retention fields to synced mutable entities.

Required fields:

```txt
deleted_at timestamptz null
purge_after timestamptz null
```

Existing `deletedAt` should remain on mutable synced models.

Add `purgeAfter` to the same model layer if the app needs local cleanup decisions.

Likely affected models:

- `MutableEntity`
- `Deck`
- `DeckListing`
- `CardTemplate`
- `StudyCard`
- `FsrsCard`
- `Profile`
- `Streak`

## Phase 2: Supabase migration

Create a migration that adds:

```sql
alter table decks add column if not exists purge_after timestamptz;
alter table deck_listings add column if not exists purge_after timestamptz;
alter table card_templates add column if not exists purge_after timestamptz;
alter table study_cards add column if not exists purge_after timestamptz;
alter table fsrs_cards add column if not exists purge_after timestamptz;
alter table profiles add column if not exists purge_after timestamptz;
alter table streaks add column if not exists purge_after timestamptz;
```

Add indexes:

```sql
create index if not exists idx_decks_purge_after on decks(purge_after);
```

Repeat for each table with `purge_after`.

## Phase 3: Client identity

Add a durable local client id.

Storage options:

- local Hive box;
- app settings table;
- secure storage is not required unless the id is considered sensitive.

Generate once:

```txt
client_id = uuid
```

Do not regenerate on every launch.

## Phase 4: Remote sync clients table

Add a Supabase table:

```sql
create table if not exists sync_clients (
  id uuid not null,
  user_id uuid not null references profiles(id) on delete cascade,
  device_name text,
  created_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now(),
  last_synced_at timestamptz,
  primary key (id, user_id)
);

create index if not exists idx_sync_clients_user_id on sync_clients(user_id);
create index if not exists idx_sync_clients_last_seen_at on sync_clients(last_seen_at);
create index if not exists idx_sync_clients_last_synced_at on sync_clients(last_synced_at);
```

On sync start or app startup:

```txt
upsert client row
last_seen_at = now
```

After successful sync:

```txt
last_synced_at = now
last_seen_at = now
```

## Phase 5: Deletion policy

Add a deletion policy config.

Minimum shape:

```dart
class SyncDeletionPolicy {
  const SyncDeletionPolicy({
    required this.retention,
    required this.activeClientWindow,
  });

  final Duration retention;
  final Duration activeClientWindow;
}
```

Default suggestion:

```txt
retention = 90 days
activeClientWindow = 90 days
```

Allow retention to be `Duration.zero`.

Interpretation:

```txt
retention == 0
  -> no backup window after sync safety
  -> still soft-delete signed-in rows first
```

## Phase 6: Delete operations

Signed-in delete:

```txt
deletedAt = now
purgeAfter = now + retention
updatedAt = now
```

Guest delete:

```txt
hard delete local rows
```

Cascade delete should still remove or soft-delete children before parents.

## Phase 7: Sync reads

Keep current rule:

```txt
normal reads hide deleted rows
sync reads include deleted rows
```

Sync indexes must include soft-deleted rows until they are purged.

## Phase 8: Discard local-wins reconciliation

Keep the current discard fix:

```txt
push local row to remote
fetch saved remote row
apply saved remote row locally
```

This handles Supabase `updated_at` triggers and prevents the same discard plan from appearing on the next sync.

Remote-only rows during discard:

```txt
delete remote row
do not mirror locally
```

## Phase 9: Tombstone cleanup

Implement cleanup as an RPC or service.

Inputs:

```txt
user_id
active_client_window
```

Compute:

```sql
oldest_active_sync = min(last_synced_at)
from sync_clients
where user_id = target_user_id
and last_seen_at >= now() - active_client_window
and last_synced_at is not null
```

Purge condition:

```txt
deleted_at is not null
and purge_after <= now
and (
  no active synced clients exist
  or deleted_at < oldest_active_sync
)
```

Run purge in child-to-parent order:

```txt
fsrs_cards
study_cards
card_templates
deck_listings
decks
streaks
profiles only with extreme care
```

Review logs need a separate decision because they are append-only.

## Phase 10: Stale clients

If a client is older than `activeClientWindow`, it stops blocking purge.

When that stale client returns, it should either:

- do a normal sync and accept conflict outcomes; or
- detect staleness and force a full refresh from remote.

Recommended later improvement:

```txt
if now - last_synced_at > activeClientWindow:
  require full refresh before allowing outbound pushes
```

This prevents very old devices from resurrecting purged data.

## Phase 11: Tests

Add focused tests for:

- signed-in delete soft-deletes the original domain row;
- guest delete hard-deletes;
- normal reads hide soft-deleted rows;
- sync reads include soft-deleted rows;
- discard pushes local and mirrors saved remote timestamp;
- cleanup does not purge when an active client has not synced after deletion;
- cleanup purges after all active clients synced and retention elapsed;
- retention `0` still keeps the soft-deleted row until sync safety is satisfied.

## Open questions

- Where should retention be configured: local user setting, remote profile setting, or app constant?
- Should "Recently Deleted" be exposed in the UI?
- Should stale clients force a full refresh before any outbound sync?
- Should append-only review logs ever be purged?
