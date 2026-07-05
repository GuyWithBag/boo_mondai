# Change Tracker

The change tracker is the shared review and progress layer for workflows that
need to show users what will change before, during, or after a mutation. It is
implemented in `lib/features/change_tracker/` and currently supports sync, deck
download, and import/export change descriptions.

## Responsibilities

- `ChangedEntity` describes one entity-level change, such as adding a deck,
  modifying a card template, or pulling a newer sync row.
- `ChangedProperty` describes field-level before/after detail for modified
  records.
- `ChangePlan<TPayload>` pairs display-ready change records with the
  workflow payload needed to apply the plan later.
- `ChangeResult<TValue>` reports the domain result and the records that were
  actually applied.
- `ChangeTrackerEntry` is the live state for one tracked operation.
- `ChangeTrackerService` owns entries and deferred apply callbacks without
  depending on Flutter UI notification APIs.
- `ChangeTrackerController` adapts a `ChangeTrackerService` for UI listeners.
  It can be provided globally for routed review flows or created locally with
  `useChangeTrackerController()` around a feature-owned service.

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
        Preview["ChangePlan&lt;TPayload&gt;"]
        Result["ChangeResult&lt;TValue&gt;"]
        Record[ChangedEntity]
        Property[ChangedProperty]
        Comparer[ChangeDifferenceHelper]
    end

    subgraph Tracker[Change tracker runtime]
        ServiceRuntime[ChangeTrackerService]
        DownloadServiceRuntime[Deck download ChangeTrackerService]
        Controller[ChangeTrackerController]
        Hook[useChangeTrackerController]
        Entry[ChangeTrackerEntry]
        Status[ChangeTrackerStatus]
    end

    subgraph UI[UI surfaces]
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
    Sync --> Controller
    AppServices --> DeckDownloads
    DeckDownloads --> DownloadServiceRuntime
    Controller --> ServiceRuntime
    Hook --> Controller
    Hook --> DownloadServiceRuntime
    ServiceRuntime --> Entry
    DownloadServiceRuntime --> Entry
    Entry --> Status
    Entry --> Record
    UI --> Controller
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
starts an explicit `ChangeTrackerEntry` with an `onApply` callback, builds
`syncPlan`, then moves the entry into review when changes exist. `SyncPage`
owns the user actions: it routes to the change-review page, applies the entry,
or discards it. The callback closes over the completed plan and calls
`applySync()` only after the user confirms.

```mermaid
sequenceDiagram
    participant UI as View decks / sync UI
    participant SyncPage as SyncPage
    participant Controller as ChangeTrackerController
    participant Service as SyncService
    participant Local as HiveLocalDB
    participant Remote as SupabaseRemoteDB

    UI->>Service: sync(localDb, remoteDb, userId, changeTrackerController)
    Service->>Controller: start(entry: ChangeTrackerEntry(sync, planning), onApply)
    Service->>Controller: update(status: fetching, progress)
    Service->>Remote: selectMany(user_id)
    Service->>Local: selectMany()
    Service->>Service: compare timestamps and build ChangePlan

    alt no differences
        Service->>Controller: update(status: alreadyUpToDate, progress: 1)
    else differences found
        Service->>Controller: update(status: reviewing, changes, progress: 1)
        UI->>SyncPage: render current sync entry
        SyncPage->>UI: context.push('/change-review/:entryId')
        SyncPage->>Controller: apply(entryId)
        Controller->>Service: onApply()
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

Some feature screens read the shared controller from Provider. Review routes
resolve an entry by id so they always render the latest immutable entry
instance. Feature-owned trackers, such as deck downloads, create a local
controller with `useChangeTrackerController(service: featureService.tracker)`.

```mermaid
flowchart TD
    Provider[ChangeNotifierProvider<br/>in main.dart]
    FeatureService[Feature service-owned<br/>ChangeTrackerService]
    Hook[useChangeTrackerController]
    Controller[ChangeTrackerController]
    EntryList[entries / activeEntries]
    Entry[entryById(entryId)]
    Page[ChangeTrackerPage]
    Summary[ChangeTrackerSummaryChips]
    Card[ChangeTrackerCard]
    Diff[ChangedPropertyBlock]
    Actions[ChangeTrackerActions]

    Provider --> Controller
    FeatureService --> Hook
    Hook --> Controller
    Controller --> EntryList
    Controller --> Entry
    Entry --> Page
    Page --> Summary
    Page --> Card
    Card --> Diff
    Page --> Actions
    Actions -->|DISCARD| Controller
    Actions -->|LOOKS GOOD| Controller
```

## Implementation Notes

- Entries are immutable snapshots. Service mutations replace entries and invoke
  `onChanged`; controllers bridge that into `notifyListeners()`.
- Entries are newest-first in `ChangeTrackerController.entries`.
- `start()` takes an explicit `ChangeTrackerEntry`; callers construct the entry
  so the service only registers and tracks it.
- `activeEntries` includes `planning`, `fetching`, `reviewing`, `applying`, and
  `paused`.
- `clearFinished()` removes terminal entries and any stale apply callbacks.
- `cancel()` removes a pending apply callback before marking the entry canceled.
- `fail()` stores user-visible error text and calls the base controller error
  hook through `setError`.
- The tracker is not durable storage. If a workflow needs resume behavior, it
  must persist its own checkpoint and then report resumed state back through the
  tracker.
