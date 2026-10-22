# Sync deletion: problems and solutions

## Goal

Deletion should be easy to reason about:

- if a signed-in user deletes local synced data, that deletion should sync to Supabase;
- if a guest deletes local data, it should be physically removed because there is no remote account to inform;
- the change tracker should show deletion as a normal entity change, not as a separate `SyncDeletion` object;
- after resolving a sync review, running sync again should show "already up to date".

## Problem 1: hard delete cannot sync by itself

If a row is physically removed locally before sync runs, the sync planner no longer has the row data or timestamp. The planner can only see:

```txt
local:  missing
remote: exists
```

Without extra information, that looks exactly like "remote has a row local does not have yet", so the planner pulls the remote row back down instead of deleting it remotely.

That is why the previous implementation used a separate `SyncDeletion` table: it preserved a tombstone after the original row disappeared.

## Problem 2: `SyncDeletion` made the change tracker confusing

The deletion event showed up as a changed `SyncDeletion` record instead of a deleted `Deck`, `DeckListing`, `CardTemplate`, etc.

That is technically workable, but it is not the model users or developers expect. The change tracker should say:

```txt
DeckListing removed
```

not:

```txt
SyncDeletion added/removed
```

The change tracker should describe domain entities, not sync infrastructure.

## Solution 1: soft delete synced mutable entities

Synced mutable entities should keep a nullable `deletedAt` field:

```dart
DateTime? deletedAt;
```

Deleting while signed in should update the row:

```txt
deleted_at = now
updated_at = now
```

The row remains available to the sync planner as a tombstone. In this design,
"tombstone" means the original domain row with `deleted_at != null`, not a
separate `SyncDeletion` row. Since it still has an id and timestamp, normal
newest-wins sync can propagate it.

The sync planner can then map:

```txt
deleted_at != null
```

to:

```dart
ChangeType.removed
```

That means deletion appears as a normal `ChangedEntity` removal.

## Solution 2: hide soft-deleted rows in normal reads

Soft-deleted rows should not appear in normal app UI.

The base local and remote DB repositories should apply this by default:

```txt
normal reads: deleted_at is null
sync reads:   include deleted rows
```

This keeps feature code simpler:

- UI queries do not need to remember `deletedAt == null` everywhere.
- Sync queries explicitly request soft-deleted domain rows.
- The sync engine can still see deletions.

## Solution 3: guest accounts hard delete

Guests have no remote account, so there is nowhere to push soft-deleted deletion
markers.

For guests, delete operations should physically remove local rows instead of soft-deleting them.

Expected behavior:

```txt
signed-in delete -> soft delete original row -> sync deletion to remote
guest delete     -> hard delete -> local-only removal
```

For cascade deletes, guest hard deletion also needs to remove dependent local rows, including review logs that would otherwise point at deleted FSRS cards.

## Problem 3: discard should not mean cancel

In sync review, "Cancel" and "Discard" are different operations.

Cancel means:

```txt
stop this sync review and do not change local or remote data
```

Discard means:

```txt
keep local data and make remote match local data
```

So discard is not a no-op. It is a local-wins sync resolution.

## Solution 4: discard applies a local-wins plan

When the user presses Discard:

- existing local push items are pushed to remote;
- inbound remote conflicts are overwritten with the local version;
- rows that exist only remotely are deleted remotely;
- deletion should run child tables before parent tables to avoid foreign-key problems.

In practice, discard needs table-level remote delete hooks because generic sync cannot guess each table's primary key shape:

```txt
decks         -> id
deck_listings -> deck_id
study_cards   -> id
fsrs_cards    -> id
review_logs   -> id
```

## Problem 4: Supabase `updated_at` triggers can make discard appear to fail

The sync comparison is timestamp based:

```txt
if remote.updated_at > local.updated_at:
  pull remote
```

If Supabase has `moddatetime(updated_at)` triggers, then pushing a local row to remote changes the remote timestamp to server `now()`.

After discard:

```txt
local data       == remote data
local updated_at <  remote updated_at
```

The next sync sees the newer remote timestamp and plans the same inbound change again, even though the data now matches.

This is why discard can look like it did nothing.

## Solution options for `updated_at`

### Option A: keep Supabase triggers and re-fetch after push

Flow:

```txt
push local row to remote
fetch saved remote row
upsert fetched remote row locally
```

This keeps Supabase as the timestamp authority. It is safer if remote/admin/server-side code can edit synced rows.

Downside: discard and push flows need extra fetches and are more complex.

### Option B: remove Supabase `updated_at` automation for synced tables

Flow:

```txt
local app sets updatedAt
sync pushes that exact timestamp
Supabase stores it unchanged
```

This makes Supabase a replica of local app state. It is simpler if synced rows are only edited through the local app and sync code.

Required discipline:

- every local mutation must bump `updatedAt`;
- soft deletes must bump both `deletedAt` and `updatedAt`;
- remote writes should not silently change `updated_at`;
- any future server-side mutation must explicitly participate in the same timestamp rules.

Given the current architecture, where editing happens locally and Supabase mostly stores the cloud copy, Option B is easier to reason about.

## Recommended model

Use this rule set:

```txt
Local app owns synced entity state.
Supabase stores the cloud replica.
updatedAt is part of the synced data.
deletedAt marks the original row as the tombstone for signed-in deletion.
guest deletion hard-deletes local rows.
discard means local-wins and mutates remote.
cancel means stop review and mutate nothing.
```

For this model, remove automatic Supabase `updated_at` triggers from synced mutable tables and rely on the app to set `updatedAt`.

Tables likely in scope:

- `profiles`
- `streaks`
- `decks`
- `deck_listings`
- `card_templates`
- `study_cards`
- `fsrs_cards`

Append-only tables such as `review_logs` should be considered separately. They usually do not need soft deletion or newest-wins conflict resolution.

## Expected final behavior

### Signed-in deletion

```txt
delete deck listing
-> local deck_listing.deletedAt = now
-> sync shows DeckListing removed
-> apply pushes the soft-deleted row to remote
-> normal reads hide the listing
```

### Guest deletion

```txt
delete deck listing
-> local deck_listing row is physically deleted
-> no soft-deleted sync row is created
```

### Discard sync changes

```txt
remote has newer conflicting data
user presses Discard
-> local version is pushed to remote
-> remote-only rows are deleted remotely
-> next sync sees matching ids and timestamps
-> already up to date
```
