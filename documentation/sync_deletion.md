# Sync deletion design

## Purpose

Sync deletion needs to solve two separate problems:

1. A deleted entity must stay visible to sync long enough for every relevant device to learn about the deletion.
2. Deleted data should be recoverable for a configurable amount of time, including a `0` retention setting.

In this design, a tombstone is not a separate model or table. The tombstone is
the original domain row with `deleted_at` set.

Example:

```txt
deck_listings row
deck_id: abc
deleted_at: 2026-07-17T10:00:00Z
```

That row is still a `DeckListing`. It is not a `SyncDeletion`.

## Core model

Synced mutable tables use soft deletion:

```txt
deleted_at timestamptz null
purge_after timestamptz null
```

Normal app reads hide rows where `deleted_at` is not null.

Sync reads include soft-deleted domain rows so deletion markers can move between
local and remote.

## Delete behavior

### Signed-in account

Deleting a synced entity soft-deletes the original row:

```txt
deleted_at = now
purge_after = now + configured retention
updated_at = now
```

The row is hidden from normal UI, but sync can still see it and propagate the
deletion. The change tracker should still report the domain entity as removed,
for example `DeckListing removed`, not `SyncDeletion added`.

### Guest account

Guest accounts have no remote account to inform, so guest deletion should hard-delete local rows immediately.

```txt
guest delete -> local hard delete
```

There is no soft-deleted sync row for guest-only data.

## Retention policy

Retention controls how long deleted data remains recoverable.

Examples:

```txt
retention = 90 days -> keep soft-deleted/recoverable data for 90 days
retention = 0 days  -> purge as soon as sync safety allows
```

Important: retention `0` should not mean "hard-delete signed-in rows
immediately." For signed-in accounts, the soft-deleted row is still needed until
other devices have learned about the deletion.

So:

```txt
retention > 0:
  purge after retention and sync safety are satisfied

retention == 0:
  purge after sync safety is satisfied
```

## Client sync tracking

Fixed retention windows are simple, but they can still fail for devices that are offline longer than the retention window.

Example:

```txt
Jan 10: Phone deletes a deck.
Jan 11: Server purges the soft-deleted deck row.
Jan 20: Laptop syncs for the first time since Jan 1.
```

The laptop never saw the soft-deleted row. It still has the old deck locally, so
it may upload the deck again and resurrect the deletion.

To avoid that, track each active sync client:

```txt
client_id
user_id
last_synced_at
last_seen_at
created_at
device_name nullable
```

Each app install gets a stable `client_id`.

On the remote table, use `(client_id, user_id)` as the key. The same app install
can sign into different accounts over time, so `client_id` alone is not unique
across users.

After a successful sync, update that client's `last_synced_at`.

Then cleanup can ask:

```txt
Has every active client synced after this deletion?
```

The safe purge condition is:

```txt
deleted_at < min(last_synced_at of active clients)
```

Combined with retention:

```txt
now >= purge_after
and deleted_at < min(last_synced_at of active clients)
```

## Active clients

A client should not block cleanup forever.

Define an active client as one seen recently:

```txt
last_seen_at >= now - active_client_window
```

A practical default:

```txt
active_client_window = 90 days
```

If a device has not synced or checked in for longer than the active window, it
no longer prevents soft-deleted row cleanup.

If that stale device returns later, it may need a full refresh or conflict
handling if it still has rows whose soft-deleted remote copies were already
purged.

## Cleanup rule

A soft-deleted synced row is safe to hard-delete when:

```txt
deleted_at is not null
and now >= purge_after
and deleted_at < oldest active client's last_synced_at
```

If there are no other active clients, cleanup may purge after `purge_after`.

Cleanup must respect dependency order.

Typical child-to-parent order:

```txt
review_logs
fsrs_cards
study_cards
card_templates
deck_listings
decks
```

Only tables that support soft deletion should participate in cleanup.
Append-only tables need separate rules.

## Discard behavior

Discard in sync review means local wins:

```txt
keep local data
make remote match local data
```

When discard pushes a local row to remote, Supabase may update `updated_at` using server-side triggers.

To avoid repeat sync plans, the app should:

```txt
push local row to remote
fetch saved remote row
upsert saved remote row locally
```

This mirrors the final remote timestamp locally, so the next sync sees both sides as equal.

## Summary

Use this model:

```txt
soft delete for signed-in synced entities
hard delete for guest-only data
configurable retention, including 0
client_id + last_synced_at for safe cleanup
cleanup only after retention and active-client sync safety
```
