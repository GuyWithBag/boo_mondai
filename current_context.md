# BooMondai — Current Context
> Last updated: 2026-03-28
> Use this file to resume any session. It is the single source of truth for
> decisions made in conversations that are not yet reflected in code.

---

## 1. Model changes already applied (this session)

The following changes were made to `lib/models/` and `supabase/schema.sql`:

| What changed | File | Detail |
|---|---|---|
| `TypeAnswerMode` enum deleted | `type_answer_mode.dart` (tombstone) | Replaced by `QuestionType.identification` |
| `type_answer` DB column removed | `schema.sql` | No backwards compat needed (pre-prod) |
| `QuestionType.readAndComplete` removed | `question_type.dart` | Merged into `fillInTheBlanks` (now supports 1+ blanks) |
| `QuestionType.identification` added | `question_type.dart` | Show front, type answer, self-grade |
| `QuestionType.wordScramble` added | `question_type.dart` | Tap shuffled chips to reconstruct sentence |
| `DeckCard.typeAnswer` removed | `deck_card.dart` | |
| `DeckCard.identificationAnswer` added | `deck_card.dart` | Comma-sep accepted answers for identification |
| `deck_cards.identification_answer` added | `schema.sql` | Nullable text column |
| `deck_editor_page.dart` updated | | Handles all 6 question types in UI |

Reference docs updated: `references/deck_psuedo_class_diagram.md`, `references/deck_card_system.md` (new AI generation guide).

---

## 2. Pending: Quiz Session Overhaul

### 2a. Bug fix — answer recognition (とり not matched)
- Root cause: `CardProvider.fetchCards` likely doesn't join the `notes` table, so `card.notes` is empty → `primaryNote` is null → `checkAnswer` always returns false.
- Fix: ensure Supabase query for cards left-joins `notes`, `mc_options`, `fitb_segments`, `mm_pairs`.
- Confirmed by user: front/back shows correctly in editor (so notes DO load in the editor's fetch path, but not in the quiz path).

### 2b. Local-first quiz (no Supabase blocking during quiz)
- **All Supabase writes during a quiz session are deferred** until `_completeSession()`.
- `startSession`: create `QuizSession` object in memory only (do NOT insert to Supabase yet).
- `submitSelfRating`: save `QuizAnswer` in-memory `_answers` list only (no `insertQuizAnswer` call).
- `_completeSession`: batch-insert the session row + all answer rows + FSRS enrollment all at once at the end.
- This eliminates the latency the user was experiencing after each self-rating.

### 2c. Three-strike rule (per session, per card)
- Track `_wrongCounts: Map<String, int>` (cardId → wrong count) in `QuizQueueController` or `QuizProvider`.
- On `submitAnswer` wrong: increment count for that card.
- If count reaches 3: do NOT requeue. Instead, auto-enroll in FSRS with `Rating.again` (1) and record a `QuizAnswer(isCorrect: false, selfRating: 1)`.
- UI: show a counter chip below/on the card: `"Attempt 2 / 3"`. Chip turns red at 3.
- Animation on 3rd strike: brief flash/shake, then card disappears from queue.

### 2d. Question type UI — quiz_session_page.dart

Each question type needs its own UI widget in `quiz_session_page.dart`:

| Type | Quiz UI |
|---|---|
| `flashcard` | Show front → tap "Show Answer" button → back revealed → self-rate. No text input. |
| `identification` | Show front → text input → submit → show correct answer if wrong → self-rate. |
| `multipleChoice` | Show front prompt → 4 tappable option buttons → wrong = highlight wrong red + correct green → requeue. Correct = self-rate. |
| `fillInTheBlanks` | Show all blanks at once (e.g. `"___ means ___ in English"`) → user fills all blanks in one submit → self-rate. |
| `wordScramble` | Shuffled word chips at bottom, target reconstruction area at top. User presses "Submit" to check. Self-rate. |
| `matchMadness` | One card = one full game. All mm_pairs shown (terms left, matches right). User taps to connect pairs. Manual self-rate after game ends. |

### 2e. Anki-style FSRS counter in quiz_session_page
- Show 3 numbers in the quiz app bar (or below progress bar), FSRS-state-based:
  - **Blue — New**: cards with FSRS `state = 0` (never reviewed)
  - **Red — Learning**: cards with FSRS `state = 1` or `state = 3` (learning / relearning)
  - **Green — Review**: cards with FSRS `state = 2` (in review phase)
- These numbers reflect the FSRS state of the cards **being reviewed in this session** (not the entire deck).
- Same indicator should appear on the card item in the review page (like Anki's card badges).

---

## 3. Pending: Review Page Overhaul

### 3a. Post-quiz flow
1. Quiz completes → navigate to **Results page** (existing).
2. Results page shows a prompt: **"You have cards to review"** — grouped by deck, each deck shows how many cards are due.
3. Two buttons: **[Review Now]** and **[Maybe Later]**.
4. [Review Now] navigates to the **Review page**.

### 3b. FSRS enrollment
- Cards answered correctly (rating 2/3/4) → enrolled in FSRS normally.
- Cards that hit 3 strikes (auto-ejected) → enrolled with `Rating.again (1)`.
- Label in UI for 3-strike cards: **"Review Later"** (with tooltip: "This card was moved to FSRS review").
- All enrolled cards appear on the review page immediately after quiz.

### 3c. Early review rule
- Cards due **within the next hour**: shown as reviewable immediately.
- Cards due **more than 1 hour away**: listed with their due countdown but greyed out/locked.
- Use **actual `DateTime.now()`** as the FSRS review timestamp (natural FSRS behaviour — slightly shorter next interval since elapsed_days < scheduled_days, which is the same as Anki's behaviour).

### 3d. FSRS due indicator format
```
Due in 0d 0h 10m 23s
Overdue since 1d 3h 22m 0s
```

---

## 4. Pending: Sync System

### 4a. Architecture
- **App is local-first**. All reads/writes go to Hive first. Supabase is a sync target, not the source of truth during a session.
- **Sync is manual** (user presses a sync button) EXCEPT when `is_published` flips to true (which queues immediately).
- Sync button location: **/my-decks page** and **review page**.

### 4b. Sync button behaviour
- One button that does **push + pull** for decks.
- Push: local changes → Supabase (only cards where local `updated_at > remote updated_at`).
- Pull: Supabase changes → local Hive cache.
- **Cancel sync button**: visible during sync. Cancels the entire process (any partially synced decks remain as-is; the next sync will retry them).
- Show **"Last synced at: [timestamp]"** somewhere visible.

### 4c. Sync unit and order
- Sync unit: **per deck**, diff by `card.updated_at`.
- Sync order when multiple decks have changes: **alphabetical**.
- Push and pull are sequential (one deck at a time, alphabetically).

### 4d. Conflict resolution

**Your own deck (you are the creator):**
- Local always wins. Push local state to Supabase.

**Copied deck — routine sync:**
- Local version is treated as your own copy; local always wins for your copy.

**Copied deck — "Update from original author" action:**
- A separate explicit user action (not automatic).
- Shows a diff UI: **"Author changed X cards. [Accept All] / [Review One by One]"**.
- "Review one by one" shows each changed card side by side (author's vs yours) and the user picks per card.

### 4e. is_published property
- New boolean column on `decks` table: `is_published bool NOT NULL DEFAULT false`.
- When `is_published` flips true: deck is queued for sync immediately AND a toast appears: **"Your deck will be published after your next sync."**
- Deck appears in the online browser only after sync completes.
- Cards edited after `is_published=true` still queue for manual sync (no auto-push on card edit).
- A user who **copied** a deck can re-publish it as their own independent deck (with attribution `source_deck_id`).

### 4f. Pending schema change
Add to `decks` table:
```sql
is_published bool NOT NULL DEFAULT false
```
Migration:
```sql
ALTER TABLE decks ADD COLUMN IF NOT EXISTS is_published bool NOT NULL DEFAULT false;
```

---

## 5. Pending: /my-decks Page Changes

- **Local-first**: reads from Hive first, shows cached data immediately.
- **No auto-fetch** on page load (except on first load if cache is empty, or if the user just copied a deck from the browser).
- **Manual refresh button** (pull icon) in app bar: triggers `DeckProvider.fetchDecks()`.
- **Delete deck**: any deck (own or copied) can be deleted. Deletes from Hive immediately. On next sync, Supabase is updated to match local state (remote deletion handled during push).
- **Confirmation dialog** before delete.

---

## 6. Pending: deck_editor_page.dart — Local-first

- All card edits go to **Hive only**. No Supabase call on save.
- A **"Push Changes"** button per deck (in the deck editor or deck detail page) triggers sync for that specific deck.
- `CardProvider.addCard` / `updateCard` / `deleteCard`: write to Hive, mark deck as having local changes, do NOT call Supabase.

---

## 7. Pending: class_diagram.md Update

- Add detailed comments explaining the deck/card system and FSRS review system.
- Explain the relationship between `DeckCard` → `FsrsCardState` → `ReviewLogEntry`.
- Explain the quiz flow from model perspective.
- Already-done model changes (section 1 above) must be reflected.

---

## 8. Pending: sync_system.md

- Write a detailed sequence diagram + explanation of the sync system (see section 4).
- Cover: quiz session sync, deck/card sync, FSRS sync, `is_published` flow, conflict resolution.
- Diagrams needed:
  1. Full quiz session flow (start → answer → 3-strike → self-grade → complete → local save → sync)
  2. Deck/card edit flow (edit locally → save to Hive → push button → Supabase)
  3. FSRS review flow (quiz complete → enroll → review page → review → sync)
  4. is_published flow

---

## 9. Resolved Design Decisions (finalised)

- **FSRS early review < 1 hour**: Cards due within 1 hour are immediately reviewable. Cards due > 1 hour are greyed out with countdown. Use `DateTime.now()` as FSRS review timestamp (same as Anki).
- **matchMadness self-rating**: After all pairs are matched, self-rate buttons (Again/Hard/Good/Easy) appear. Matched pair tiles are visually disabled/locked. Card counts as one answer in the queue.
- **fillInTheBlanks multi-blank**: ALL blanks must be correct for the card to pass. No partial credit. If any blank is wrong, whole card is requeued.
- **fillInTheBlanks sentence display**: One sentence with multiple `___` blanks shown together. Each segment shares the same `fullText`; each has a different blank position and its own text input. Inputs are stacked below (or inline) the sentence. On submit all blanks are checked at once.
- **`is_published` toast**: Shows `"Your deck will be published after your next sync."` with a **[Sync Now]** shortcut button that triggers the sync action immediately.

---

## 10. Files that still need to be updated

All items from this section have been completed across Phases 4–6.

## 11. Phase Plan

| Phase | Name | Status | Summary |
|---|---|---|---|
| Phase 1 | Quiz local-first + 3-strike | ✅ Done | No Supabase during quiz; auto-eject at 3 strikes; batch-insert on complete |
| Phase 2 | Quiz session UI — 6 question types | ✅ Done | flashcard, identification, MC, FITB, wordScramble, matchMadness; Anki counter; strike chip |
| Phase 3 | Post-quiz review flow + FSRS early-review | ✅ Done | "Review now?" prompt; 1-hour early-review window; upcoming-cards countdown |
| Phase 4 | Local-first sync system | ✅ Done | CardProvider/DeckProvider Hive-first; dirty flag; pushDeck; deck delete local-first |
| Phase 5 | Bug fix + schema | ✅ Done | fetchCards join already correct (prior session); added is_published to schema.sql |
| Phase 6 | Documentation | ✅ Done | Wrote references/sync_system.md (4 sequence diagrams); updated references/class_diagram.md with full model + local-first architecture |

---

## 12. Completed (this session)

| Phase | Name | What was done |
|---|---|---|
| Phase 1 | **Quiz local-first + 3-strike** | `QuizQueueController`: per-card wrong-count tracking, auto-eject at 3 strikes with `Rating.again`. `QuizProvider`: no Supabase writes during quiz (fully in-memory), batch-inserts session + all answers + FSRS enrollment in one go at `_completeSession`. `SupabaseService`: `batchInsertQuizAnswers`. |
| Phase 2 | **Quiz session UI — all 6 question types** | `quiz_session_page.dart`: full UI for flashcard (tap-to-reveal), identification (text input + self-rate), multipleChoice (4-button tap), fillInTheBlanks (multi-blank inline inputs), wordScramble (chip tap-to-reconstruct), matchMadness (pair-tap game). Anki-style New/Learning/Review counter in app bar. Strike chip showing attempt count. `QuizProvider`: added `revealAnswer`, `submitIdentificationAnswer`, `submitFitbAnswers`. |
| Phase 3 | **Post-quiz review flow + FSRS early-review** | `QuizProvider`: `enrolledCards`, `reviewableNowCount`, `reviewLaterCount` getters. `FsrsProvider`: 1-hour early-review window, `upcomingCards` (sorted by due). `quiz_result_page.dart`: "Review now?" prompt with ready/later card counts, "Review Later" label for 3-strike ejected cards. `review_page.dart`: FSRS state badge (New/Learning/Review), upcoming-cards list with live `Due in Xd Xh Xm Xs` / `Overdue since …` countdown. |
| Phase 4 | **Local-first sync system** | `HiveService`: `saveDeck`, `deleteDeck`, `getUserDecks`. `SupabaseService`: `upsertCardRow`, `deleteChildrenByCardId`, `deleteOrphanCards`, `batchInsertNotes/MCOptions/FITBSegments/MMPairs`. `CardProvider`: full local-first rewrite — all mutations hit Hive only, per-deck dirty flag, `pushDeck` batch-syncs to Supabase. `DeckProvider`: `loadFromCache`, local-first `deleteDeck` (Hive immediate, Supabase best-effort). `deck_list_page.dart`: cache-first load, manual refresh button, delete with confirm dialog. `deck_editor_page.dart`: `_PushButton` shown when deck is dirty. `FsrsService`: fixed `Rating.values` off-by-one (1-indexed → subtract 1). All tests updated and passing (153 total). |
| Phase 5 | **Bug fix + schema** | Confirmed `SupabaseService.fetchCards` already had correct join (`*, notes(*), mc_options(*), fitb_segments(*), mm_pairs!card_id(*)`). Added `is_published bool NOT NULL DEFAULT false` column to `decks` table in `supabase/schema.sql` with explanatory comment. |
| Phase 6 | **Documentation** | `references/sync_system.md`: wrote full sync design document covering architecture overview, sync rules table, and 4 sequence diagrams (quiz session, deck/card edit, FSRS review, is_published flow) plus conflict resolution and error handling tables. `references/class_diagram.md`: full rewrite — Section 1a shows Deck/DeckCard/Note/Options/Segments/Pairs with the computed-getter note on `question`/`answer`; Section 1b shows Quiz/FSRS/Streak models; Section 2 shows all Providers and Services updated to reflect local-first CardProvider, new HiveService/SupabaseService methods, and FsrsService rating note. |
