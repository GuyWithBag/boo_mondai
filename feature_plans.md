# Feature Plans

Future improvements planned but out of v1.0 scope.

---

## Card Update System (Smart Merge)

**Context:** When a consumer copies an author's card (`sourceCardId` is set), the current
"Update" button replaces ALL local edits with the author's latest version — a full overwrite.

### Planned improvements

| # | Feature | Description |
|---|---------|-------------|
| 1 | **Field-level diff** | Show the consumer exactly which fields changed before they accept the update (e.g. front text changed, back text unchanged). |
| 2 | **Selective field update** | Let the consumer pick which fields to pull from the source (keep my back text, take author's new image). |
| 3 | **Consumer-edit priority** | If the consumer has edited a field after the last sync timestamp, treat their version as canonical and skip that field during auto-update. Only overwrite fields the consumer hasn't touched. |
| 4 | **Conflict resolution UI** | When both author and consumer have edited the same field since last sync, surface a side-by-side diff and let the consumer choose per-field. |
| 5 | **Sync timestamp tracking** | Store `last_synced_at` on copied cards so the diff is accurate (only changes made *after* the last sync are considered conflicting). |
| 6 | **Bulk update** | "Update all outdated cards in this deck" button that applies the safe consumer-priority merge to every card with a newer source version. |

### Schema additions (future)
```sql
ALTER TABLE deck_cards ADD COLUMN last_synced_at timestamptz;
ALTER TABLE deck_cards ADD COLUMN consumer_edited_fields text[] DEFAULT '{}';
```

---

## Multi-Author Provenance

**Context:** `source_card_id` is a single pointer — it only tracks *one* hop back. This breaks
down as soon as cards are copied more than once, or a user's deck contains cards from several
different original authors.

### Problem scenarios

#### Chain copying (A → B → C)
1. Researcher creates card A.
2. Alice copies it → her card B has `source_card_id = A.id`.
3. Bob copies Alice's deck → his card C has `source_card_id = B.id` (Alice's copy, not the
   original).
4. Researcher updates A. Bob's C now has a stale grandparent, but the app only walks one level,
   so the "Update" button fetches B (Alice's potentially-stale copy), not A.

#### Mixed-author deck
A user builds a personal deck by copying cards from five different public decks. Each card
points to a different original author. The "Update all" button must resolve five independent
sources without confusing which source belongs to which card.

### Planned solutions

| # | Feature | Description |
|---|---------|-------------|
| 1 | **Root source tracking** | Add `root_card_id uuid` alongside `source_card_id`. Always points to the *original* author's card, never a middleman copy. Set once at copy time by walking the chain upstream until `source_card_id IS NULL`. |
| 2 | **Author identity on cards** | Store `original_creator_id uuid` on each card so the UI can show "Originally by @Researcher" even when the direct source is an intermediary. |
| 3 | **Per-card update source choice** | In the "Update" UI, let the user choose between pulling from the direct source (the person they copied from) or the root source (the ultimate original author). |
| 4 | **Deck-level source map** | Show a summary per deck: "5 cards from @Researcher, 3 from @Alice, 2 original". Each source group can be updated independently. |
| 5 | **Stale chain detection** | When the direct source (`source_card_id`) itself has a newer `source_card_id` update, warn the user that their update target is itself outdated. |

### Schema additions (future)
```sql
ALTER TABLE deck_cards ADD COLUMN root_card_id uuid REFERENCES deck_cards(id) ON DELETE SET NULL;
ALTER TABLE deck_cards ADD COLUMN original_creator_id uuid REFERENCES profiles(id) ON DELETE SET NULL;
CREATE INDEX ON deck_cards (root_card_id);
CREATE INDEX ON deck_cards (original_creator_id);
```

### Copy-time logic (future)
When copying a card with an existing `source_card_id`:
- `source_card_id` = the card being directly copied (unchanged — preserves the immediate lineage)
- `root_card_id` = source card's `root_card_id` if non-null, otherwise `source_card_id` (walk to root in one query)
- `original_creator_id` = resolved root card's `deck.creator_id`

---

## Online Deck Browser — Advanced Filtering

**Context:** The initial `/online-deck-browser` supports filtering by tags and target language.

### Planned improvements

| # | Feature | Description |
|---|---------|-------------|
| 1 | **Full-text search** | Search deck titles and descriptions via Supabase `pg_trgm` similarity or `websearch_to_tsquery`. |
| 2 | **Sort options** | Sort by newest, most copied, most cards, alphabetical. |
| 3 | **Popularity signal** | Track copy count per deck (`copy_count int DEFAULT 0`) incremented on copy. Surface as a badge. |
| 4 | **Deck preview modal** | Quick-look sheet showing first 5 cards before committing to copy. |
| 5 | **Saved/bookmarked decks** | Users can bookmark decks without copying; revisit later. |

---

## Leaderboard

**Context:** Leaderboard is now a section within `/home` (top 5 preview) with a "See All" link to `/leaderboard`.

### Planned improvements

| # | Feature | Description |
|---|---------|-------------|
| 1 | **Friends leaderboard** | Filter to only show users you follow / are friends with. |
| 2 | **Weekly leaderboard** | Reset weekly to encourage re-engagement. |
| 3 | **Language-specific board** | Already supported by `target_language` filter; surface more prominently. |

---

## Named Versions & Update Log

**Context:** `Deck` now has a `version` string (e.g. `"1.0.0"`, user-editable) and a `build_number` int
(server auto-incremented on every save). This mirrors the Google Play versioning model.

### Planned improvements

| # | Feature | Description |
|---|---------|-------------|
| 1 | **Version bump UI** | When saving a deck, show a dialog prompting the author to optionally bump `version` (patch / minor / major). `build_number` always increments automatically. |
| 2 | **Update log (changelog)** | Add an `update_log` table keyed on `(deck_id, build_number)` with a `message text` column. Authors write a short release note per save (optional). |
| 3 | **Version badge on deck tile** | Show `v{version}+{buildNumber}` on the deck detail page and in the online browser. |
| 4 | **Consumer update notifications** | When a source deck's `build_number` exceeds the `build_number` recorded at copy time, surface a "New version available" badge on the consumer's copied deck. |
| 5 | **Pinned version copies** | Let consumers optionally pin their copy to a specific `build_number` so they never receive auto-update prompts. |

### Schema additions (future)
```sql
CREATE TABLE deck_update_log (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  deck_id      uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  build_number int  NOT NULL,
  message      text NOT NULL DEFAULT '',
  published_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (deck_id, build_number)
);
-- Track which build_number a consumer copied at
ALTER TABLE decks ADD COLUMN source_build_number int;
```

---

## Comment Section with Replies

**Context:** Deck detail and online browser pages currently have no social layer. Adding
comments would increase community engagement and surface quality feedback for deck authors.

### Planned design

- Comments live on a deck (not on individual cards).
- Two-level threading only: top-level comments + direct replies (no deep nesting).
- Authors can pin one comment (e.g. "Known issue: card 5 has a typo — will fix in v1.1").

### Planned improvements

| # | Feature | Description |
|---|---------|-------------|
| 1 | **Top-level comments** | Any authenticated user can post a comment on a public deck. |
| 2 | **Replies** | Users can reply to any top-level comment (one level deep). |
| 3 | **Author pin** | Deck owner can pin one comment to the top of the thread. |
| 4 | **Soft delete** | Comments are soft-deleted (body replaced with "[deleted]") so thread structure is preserved. |
| 5 | **Moderation** | Deck owner can delete any comment on their own deck. |
| 6 | **Upvotes** | Simple thumbs-up count per comment, visible but not required to post. |

### Schema additions (future)
```sql
CREATE TABLE deck_comments (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  deck_id     uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  author_id   uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  parent_id   uuid REFERENCES deck_comments(id) ON DELETE CASCADE,
  body        text NOT NULL,
  is_pinned   bool NOT NULL DEFAULT false,
  is_deleted  bool NOT NULL DEFAULT false,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE deck_comments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_comments: anyone reads" ON deck_comments FOR SELECT USING (true);
CREATE POLICY "deck_comments: users insert own" ON deck_comments FOR INSERT WITH CHECK (auth.uid() = author_id);
CREATE POLICY "deck_comments: author or deck owner soft-delete" ON deck_comments FOR UPDATE
  USING (
    auth.uid() = author_id OR
    EXISTS (SELECT 1 FROM decks WHERE decks.id = deck_comments.deck_id AND decks.creator_id = auth.uid())
  );
CREATE INDEX ON deck_comments (deck_id);
CREATE INDEX ON deck_comments (parent_id);
```
