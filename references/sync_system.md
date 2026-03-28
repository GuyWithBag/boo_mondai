# BooMondai — Sync System
> Last updated: 2026-03-28

BooMondai is **local-first**. Hive is the source of truth for all reads and writes
during a session. Supabase is a sync target — it is never read during normal app
use (except on first load when the Hive cache is empty).

---

## Architecture overview

```
┌──────────────────────────────────────────────────────────┐
│  UI / Providers                                          │
│  All reads → Hive     All writes → Hive first            │
└──────────────────────┬───────────────────────────────────┘
                       │ sync (push / pull)
┌──────────────────────▼───────────────────────────────────┐
│  Supabase (PostgreSQL)                                   │
│  Receives pushes, serves as remote backup + auth source  │
└──────────────────────────────────────────────────────────┘
```

### Sync rules

| Operation | Direction | Trigger |
|---|---|---|
| Card edits (add/update/delete/reorder) | Hive only → Supabase on demand | "Push" button per deck |
| Deck CRUD | Hive immediate, Supabase best-effort | Delete: fire-and-forget. Create/Update: Supabase on next push |
| Quiz answers + session | Memory during quiz, Supabase on complete | Auto on `completeSession()` |
| FSRS card states | Hive primary, Supabase on review | Auto on `submitReview()` |
| Review logs | Hive primary, Supabase on review | Auto on `submitReview()` |
| Streaks | Hive primary, Supabase on activity | Auto on `recordActivity()` |

---

## Flow 1 — Quiz session (start → answer → complete → sync)

```
User                  QuizProvider              Hive          Supabase
 │                         │                     │               │
 │── startSession() ──────►│                     │               │
 │                         │ build QuizSession    │               │
 │                         │ in memory (no DB)    │               │
 │                         │ init QuizQueueController             │
 │                         │                     │               │
 │── submitAnswer(wrong) ──►│                     │               │
 │                         │ increment wrongCount │               │
 │                         │ requeue card         │               │
 │                         │                     │               │
 │── submitAnswer(wrong, 3rd time) ──────────────►│               │
 │                         │ auto-eject card      │               │
 │                         │ record QuizAnswer    │               │
 │                         │   (isCorrect:false,  │               │
 │                         │    selfRating:1)     │               │
 │                         │ in-memory _answers   │               │
 │                         │                     │               │
 │── submitAnswer(correct) ►│                     │               │
 │                         │ await self-rating    │               │
 │                         │                     │               │
 │── submitSelfRating(3) ──►│                     │               │
 │                         │ record QuizAnswer    │               │
 │                         │   (selfRating:3)     │               │
 │                         │ advance queue        │               │
 │                         │                     │               │
 │  (queue empty)          │                     │               │
 │                         │── _completeSession() │               │
 │                         │   set completedAt    │               │
 │                         │   ──────────────────────────────────►│
 │                         │   insertQuizSession()                 │
 │                         │   batchInsertQuizAnswers()            │
 │                         │                     │               │
 │                         │── enrollCardsFromQuiz()              │
 │                         │   for each rated card:               │
 │                         │   FsrsService.enrollCard()           │
 │                         │   ─────────────────►│               │
 │                         │   saveFsrsCard()     │               │
 │                         │   saveReviewLog()    │               │
 │                         │                     │──────────────►│
 │                         │                     │ upsertFsrsCard()
 │                         │                     │ insertReviewLog()
 │                         │                     │               │
 │◄── isComplete=true ──────│                     │               │
```

**Key invariant:** No Supabase call is made until `_completeSession()`. This
eliminates per-answer network latency. If Supabase fails, the quiz result is lost
for the remote but FSRS state is already saved in Hive.

---

## Flow 2 — Deck/card edit (edit locally → save to Hive → push button)

```
User                  CardProvider              Hive          Supabase
 │                         │                     │               │
 │── addCard() ────────────►│                     │               │
 │                         │ build DeckCard       │               │
 │                         │ assign UUIDs (uuid)  │               │
 │                         │ ─────────────────────►               │
 │                         │ saveCards(deckId,    │               │
 │                         │   [newCard])         │               │
 │                         │ mark deckId dirty    │               │
 │◄── isDirty=true ─────────│                     │               │
 │                         │                     │               │
 │── (more edits…) ────────►│ each: Hive write,   │               │
 │                         │ stay dirty           │               │
 │                         │                     │               │
 │── (tap Push button) ────►│                     │               │
 │                         │── pushDeck(deckId)   │               │
 │                         │   isPushing=true     │               │
 │                         │                     │──────────────►│
 │                         │   deleteOrphanCards()                │
 │                         │   (removes remotely deleted cards)   │
 │                         │                     │               │
 │                         │   for each local card:               │
 │                         │   ──────────────────────────────────►│
 │                         │   upsertCardRow()                    │
 │                         │   deleteChildrenByCardId()           │
 │                         │   batchInsertNotes()                 │
 │                         │   batchInsertMCOptions()             │
 │                         │   batchInsertFITBSegments()          │
 │                         │   batchInsertMMPairs()               │
 │                         │                     │               │
 │                         │ _dirtyDeckIds.remove │               │
 │                         │ isPushing=false      │               │
 │◄── isDirty=false ────────│                     │               │
```

**Child sync strategy:** On each push the card row is upserted, then all
children are **deleted and re-inserted** (`deleteChildrenByCardId` + batch inserts).
This keeps the sync logic simple and avoids per-child diffing.

**Orphan deletion:** `deleteOrphanCards` fetches remote card IDs for the deck,
computes the diff against local IDs, and deletes only the extras. This handles
cards the user deleted locally.

---

## Flow 3 — FSRS review (review page → submit → sync)

```
User                  FsrsProvider              Hive          Supabase
 │                         │                     │               │
 │── fetchDueCards() ──────►│                     │               │
 │                         │ getAllFsrsCards(user) │               │
 │                         │◄────────────────────►│               │
 │                         │ filter due <= now+1h │               │
 │                         │ getCards('') for     │               │
 │                         │ DeckCard lookup cache│               │
 │◄── dueCards populated ───│                     │               │
 │                         │                     │               │
 │── submitReview(3) ───────►│                     │               │
 │                         │ FsrsService          │               │
 │                         │   .reviewCard(state, 3)              │
 │                         │ ─────────────────────►               │
 │                         │ saveFsrsCard(updated)│               │
 │                         │ saveReviewLog(entry) │               │
 │                         │                     │               │
 │                         │   ── try sync ──────────────────────►│
 │                         │   upsertFsrsCard()   │               │
 │                         │   insertReviewLog()  │               │
 │                         │   ── on AppException: silent ────────│
 │                         │                     │               │
 │                         │ _currentIndex++      │               │
 │◄── currentReviewCard ────│                     │               │
 │   advances to next       │                     │               │
```

**Offline tolerance:** FSRS and review log writes go to Hive synchronously.
The Supabase sync is wrapped in a separate try/catch — a network failure is
silently ignored. The data is safe in Hive and will reach Supabase on the
next review attempt.

**Early-review window:** Cards due within 1 hour of `DateTime.now()` are
considered immediately reviewable. Cards due further away go into `upcomingCards`
(shown locked with a countdown on the review page).

---

## Flow 4 — is_published (flip → toast → push → visible in browser)

```
User                  DeckProvider / UI         Hive          Supabase
 │                         │                     │               │
 │── toggle isPublished ───►│                     │               │
 │                         │ updateDeck(          │               │
 │                         │   deck.copyWith(     │               │
 │                         │   isPublished:true)) │               │
 │                         │ ─────────────────────►               │
 │                         │ saveDeck(deck)       │               │
 │                         │                     │               │
 │                         │ CardProvider         │               │
 │                         │ .markDirty(deckId)   │               │
 │                         │                     │               │
 │◄── SnackBar shown ───────│                     │               │
 │   "Your deck will be     │                     │               │
 │    published after       │                     │               │
 │    your next sync."      │                     │               │
 │   [Sync Now] button      │                     │               │
 │                         │                     │               │
 │── tap [Sync Now] ───────►│                     │               │
 │                         │── pushDeck(deckId) ─────────────────►│
 │                         │   (same as Flow 2)   │               │
 │                         │   updateDeck(id, {   │               │
 │                         │   is_published:true})│               │
 │                         │                     │──────────────►│
 │                         │                     │ deck visible   │
 │                         │                     │ in browser     │
```

**Browser visibility rule:** A deck only appears in the Online Browser after
`is_published=true` has been synced to Supabase. Setting it locally shows the
toast but does not immediately expose the deck to other users.

---

## Conflict resolution

### Your own deck (you are the creator)
- Local always wins. `pushDeck` overwrites the remote state entirely.

### Copied deck — routine sync
- The copy is your independent deck. Local always wins for your copy.

### Copied deck — "Update from original author"
This is a **separate explicit user action**, not automatic:
1. App detects `source_deck_id != null` and `remote updated_at > local updated_at`.
2. Shows a diff UI: **"Author changed X cards. [Accept All] / [Review One by One]"**.
3. "Accept All" replaces local content nodes with the author's version.
4. "Review one by one" shows each changed card side by side — user picks per card.
5. After the user decides, the result is saved to Hive and marked dirty for next push.

---

## Dirty flag and push button visibility

- `CardProvider._dirtyDeckIds: Set<String>` — tracks which deck IDs have local-only changes.
- `CardProvider.isDirty(deckId)` — returns true when the Push button should be shown.
- `CardProvider.isPushing` — true while `pushDeck()` is running (shows a spinner).
- The Push button appears in the deck editor app bar whenever `isDirty(deckId)` is true.
- After `pushDeck()` succeeds, `isDirty(deckId)` returns false and the button hides.

---

## Error handling

| Scenario | Behaviour |
|---|---|
| Supabase unreachable during `pushDeck` | `_error` is set; deck stays dirty; user can retry |
| Supabase unreachable during FSRS sync | Silently swallowed; Hive data preserved |
| Supabase unreachable during quiz complete | Quiz session + answers lost remotely; FSRS saved locally |
| `deleteOrphanCards` fails | `pushDeck` aborts early; deck stays dirty |
