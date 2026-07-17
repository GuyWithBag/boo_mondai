# Change Tracker

The change tracker is the shared review and progress layer for workflows that
need to show users what will change before, during, or after a mutation. It is
implemented in `lib/features/change_tracker/` and currently supports sync, deck
download, and import/export change descriptions.

## Responsibilities

- `ChangedEntity<TEntity>` describes one typed entity-level change, such as
  adding a deck, modifying a card template, or pulling a newer sync row. Its
  `beforeChange` and `afterChange` snapshots use `TEntity`.
- `ChangedProperty<TValue>` describes field-level before/after detail for one
  typed property value.
- `PreviewedChangePlan<TPayload, TEntity>` pairs display-ready change records with the
  typed workflow payload needed to apply the plan later.
- `ChangeResult<TValue, TEntity>` reports the domain result and the typed
  records that were actually applied.
- `ChangeBatchResult<TValue>` reports partial success for batch import/export
  operations, including successful values, human-readable failures, and change
  records from successful items.
- `ChangeTrackerEntry` is the live state for one tracked operation.
- `ChangeTrackerService` owns entries and deferred apply callbacks without
  depending on Flutter UI notification APIs.
- `ChangeTrackerController` adapts a `ChangeTrackerService` for UI listeners.
  `useChangeTrackerController()` creates this adapter around either a default
  in-memory service or a feature-owned service.
- `ChangeTrackerRouteArgs` carries the routed entry id plus the registered
  `ChangeTrackerService.id` so `ChangeTrackerPage` resolves live entries from
  the correct service through `ServiceRegistry`.

## Component Map

```mermaid
flowchart LR
    subgraph Workflows
        Sync[SyncService]
        DeckDownloads[DeckDownloadsService]
        ImportExport[ImportExportService]
        AppServices[Services.deckDownloads]
    end

    subgraph DataModels[Change data models]
        Preview["PreviewedChangePlan&lt;TPayload, TEntity&gt;"]
        Result["ChangeResult&lt;TValue, TEntity&gt;"]
        BatchResult["ChangeBatchResult&lt;TValue&gt;"]
        Record["ChangedEntity&lt;TEntity&gt;"]
        Property["ChangedProperty&lt;TValue&gt;"]
        Comparer[ChangedEntityHelper]
    end

    subgraph Tracker[Change tracker runtime]
        Registry[ServiceRegistry]
        ServiceRuntime[ChangeTrackerService]
        Controller[ChangeTrackerController]
        Hook[useChangeTrackerController]
        Entry[ChangeTrackerEntry]
        Status[ChangeTrackerStatus]
    end

    subgraph UI[UI surfaces]
        RouteArgs[ChangeTrackerRouteArgs]
        ReviewPage[ChangeTrackerPage]
        SyncPage[SyncPage]
        Downloads[Deck downloads UI]
        Widgets[Summary chips / cards / diffs]
    end

    Sync --> Preview
    DeckDownloads --> Preview
    ImportExport --> Preview
    Comparer --> Property
    Property --> Record
    Preview --> Record
    Result --> Record
    BatchResult --> Record
    Sync --> Controller
    AppServices --> DeckDownloads
    DeckDownloads --> ServiceRuntime
    Registry --> ServiceRuntime
    Controller --> ServiceRuntime
    Hook --> Controller
    ServiceRuntime --> Entry
    Entry --> Status
    Entry --> Record
    SyncPage --> RouteArgs
    RouteArgs --> ReviewPage
    ReviewPage --> Widgets
    SyncPage --> Widgets
    Downloads --> Entry
```

## Review-First Lifecycle

The common flow computes a dry-run plan, asks the user to confirm it, then
applies the captured payload.

```mermaid
stateDiagram-v2
    [*] --> planning: start(entry)
    planning --> fetching: load/check data
    fetching --> reviewing: change plan ready
    fetching --> alreadyUpToDate: no actionable changes
    fetching --> failed: fetch/compare error
    planning --> alreadyUpToDate: no actionable changes
    planning --> failed: planning error
    reviewing --> applying: user accepts / apply()
    reviewing --> canceled: user discards
    applying --> completed: apply callback returns
    applying --> failed: apply callback throws
    applying --> paused: workflow supports pause
    paused --> applying: resume
    completed --> [*]
    failed --> [*]
    canceled --> [*]
    alreadyUpToDate --> [*]
```

## Sync Sequence

Sync is the clearest review-first user of the tracker. `SyncService.sync()`
starts an explicit `ChangeTrackerEntry` with an `onChangeApply` callback, builds a
`PreviewedChangePlan<StrategySyncPlanPayload<TContext>, Object?>`, then moves the
entry into review when changes exist. `SyncPage` owns the user actions: it routes to
the change-review page with the registered tracker service id and entry id,
applies the entry, or discards it. The callback closes over the completed plan
and applies the planned `SyncPlanStep`s only after the user confirms.

```mermaid
sequenceDiagram
    participant UI as View decks / sync UI
    participant SyncController as Workflow controller
    participant SyncPage as SyncPage
    participant Controller as ChangeTrackerController
    participant ReviewPage as ChangeTrackerPage
    participant Service as SyncService
    participant Local as HiveLocalDB
    participant Remote as SupabaseRemoteDB

    UI->>SyncController: sync(changeTrackerController)
    SyncController->>Service: sync(localDb, remoteDb, userId, changeTrackerController)
    Service->>Controller: start(entry: ChangeTrackerEntry(sync, planning), onChangeApply)
    Service->>Controller: update(status: fetching, progress)
    Service->>Remote: selectMany(user_id)
    Service->>Local: selectMany()
    Service->>Service: compare timestamps and build PreviewedChangePlan

    alt no differences
        Service->>Controller: update(status: alreadyUpToDate, progress: 1)
    else differences found
        Service->>Controller: update(status: reviewing, changes, progress: 1)
        Controller-->>SyncController: notifyListeners()
        SyncController-->>SyncPage: currentEntry + changeTrackerService
        SyncPage->>ReviewPage: context.push('/change-review/:serviceId/:entryId')
        ReviewPage->>Controller: ServiceRegistry.maybeById(serviceId)
        ReviewPage->>Controller: useChangeTrackerController(service)
        ReviewPage->>Controller: entryById(entryId)
        ReviewPage->>Controller: apply(entryId)
        Controller->>Service: onChangeApply()
        Service->>Local: upsert pulled records
        Service->>Remote: upsert pushed records
        Service-->>Controller: applied ChangedEntity list
        Controller->>Controller: complete(entryId, changes)
    end
```

## Deck Download Sequence

Deck download can use the tracker as a progress surface while the mutation is
already running. The service still emits `ChangedEntity` values, but the entry
may move from planning directly into applying and can pause around persisted
download checkpoints. Unlike sync, deck downloads own their tracker service via
`DeckDownloadsService.changeTrackerService`; UI pages wrap that feature-owned
service with `useChangeTrackerController()` when they need to render download
state.

```mermaid
sequenceDiagram
    participant UI as Deck listing/download UI
    participant Hook as useChangeTrackerController
    participant Service as DeckDownloadsService
    participant Tracker as ChangeTrackerService
    participant Remote as Published deck tables
    participant Local as LocalDB + checkpoints

    UI->>Service: Services.deckDownloads
    UI->>Hook: useChangeTrackerController(Service.changeTrackerService)
    Hook-->>UI: ChangeTrackerController for download UI
    UI->>Service: downloadDeck(sourceDeck)
    Service->>Tracker: start(entry: ChangeTrackerEntry(deckDownload, planning))
    Service->>Remote: load deck metadata and template count
    Service->>Service: previewDeckDownload(sourceDeck)
    Service->>Local: create/update download checkpoint
    Service->>Tracker: update(status: applying, progress)

    loop fetch template pages
        Service->>Remote: selectManyPaged(deck_id, offset, pageSize)
        Service->>Local: upsert fetched data/checkpoint
        Service->>Tracker: update(progress)
    end

    alt user paused between pages
        Service->>Local: checkpoint(status: paused)
        Service->>Tracker: update(status: paused)
    else completed
        Service->>Local: finalize local deck/templates
        Service->>Tracker: complete(changes)
    end
```

## UI Consumption

Feature screens create a `ChangeTrackerController` with
`useChangeTrackerController()`. When no service is supplied, the hook creates a
controller around a fresh in-memory `ChangeTrackerService`. Feature-owned
trackers, such as deck downloads, pass their long-lived service into the hook
with `useChangeTrackerController(service: featureService.changeTrackerService)`.

Review routes keep the tracker service id and entry id in the URL. The owning
service is resolved through `ServiceRegistry`, and `ChangeTrackerPage` wraps
that service with the hook before resolving `entryById(entryId)`. If the route
is opened without a registered in-memory service or the entry has been removed,
the page treats it as missing and returns to the previous route.

```mermaid
flowchart TD
    DefaultHook[useChangeTrackerController()]
    FeatureService[Feature service-owned<br/>ChangeTrackerService]
    Registry[ServiceRegistry]
    FeatureHook[useChangeTrackerController(service)]
    Controller[ChangeTrackerController]
    EntryList[entries / activeEntries]
    Entry[entryById(entryId)]
    RouteArgs[ChangeTrackerRouteArgs<br/>serviceId + entryId]
    Page[ChangeTrackerPage]
    Summary[ChangeTrackerSummaryChips]
    Section[ChangedEntitySection]
    Diff[ChangedPropertyBlock]
    Actions[Discard / Looks Good / Back]

    DefaultHook --> Controller
    FeatureService --> FeatureHook
    FeatureService --> Registry
    Registry --> Page
    FeatureHook --> Controller
    Controller --> EntryList
    Controller --> Entry
    RouteArgs --> Page
    Page --> Controller
    Entry --> Page
    Page --> Summary
    Page --> Section
    Section --> Diff
    Page --> Actions
    Actions -->|DISCARD| Controller
    Actions -->|LOOKS GOOD| Controller
```

## Implementation Notes

- Entries are immutable snapshots. Service mutations replace entries and invoke
  registered change listeners; controllers bridge that into
  `notifyListeners()`.
- Entries are newest-first in `ChangeTrackerService.entries` and
  `ChangeTrackerController.entries`.
- Entries record `startedAt` when constructed and `finishedAt` when completed,
  failed, or canceled.
- `start()` takes an explicit `ChangeTrackerEntry`; callers construct the entry
  so the service only registers and tracks it.
- `start()` type-erases stored entries to `Object?` internally while preserving
  the typed entry returned to the caller.
- `ChangedEntity.changedProperties` stores `List<ChangedProperty<Object?>>`
  because a single entity diff can contain heterogeneous field values, such as a
  `String` title, `DateTime` update timestamp, `bool` flag, or list field.
- `apply()` moves the entry to `applying`, runs the registered callback when one
  exists, completes with the callback's applied changes, removes the callback,
  and returns an error object to the controller if the callback fails.
- If no apply callback is registered, `apply()` simply completes the entry. This
  supports workflows like deck download that mutate while reporting progress.
- `activeEntries` includes `planning`, `fetching`, `reviewing`, `applying`, and
  `paused`.
- `clearFinished()` removes terminal entries and any stale apply callbacks.
- `remove()` deletes an entry from memory and removes its pending apply
  callback.
- `cancel()` removes a pending apply callback before marking the entry canceled.
- `fail()` stores user-visible error text and calls the base controller error
  hook through `setError`.
- `pause()` and `resume()` only update tracker state. The owning workflow must
  implement the real pause signal and resume behavior.
- The tracker is not durable storage. If a workflow needs resume behavior, it
  must persist its own checkpoint and then report resumed state back through the
  tracker.
