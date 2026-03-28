# Often-Overlooked Mistakes

Patterns that have caused real bugs in this codebase. Read before generating code.

---

## 1. Hive stores nested maps as `Map<dynamic, dynamic>`, not `Map<String, dynamic>`

**What went wrong:** `DeckCard.fromJson` cast nested lists directly as `List<Map<String, dynamic>>`. At runtime, Hive deserialised them as `List<Map<dynamic, dynamic>>`, causing a type error that crashed the app on startup.

**Rule:** Whenever reading a nested object from Hive, always wrap the cast:
```dart
// ✗ Wrong — crashes at runtime
Note.fromJson(n as Map<String, dynamic>)

// ✓ Correct
Note.fromJson(Map<String, dynamic>.from(n as Map))
```

This applies to every model that stores nested lists in Hive (notes, mc_options, fitb_segments, mm_pairs, etc.).

---

## 2. `fetchCards` on page mount overwrites unsaved local (Hive-only) changes

**What went wrong:** `DeckDetailPage` always called `fetchCards(deckId)` in its `useEffect`, which fetched from Supabase and replaced in-memory cards. Any edits made in `DeckEditorPage` (which writes only to Hive) were silently lost on navigation back.

**Rule:** Before fetching from the network, check whether cards are already loaded for the same deck:
```dart
useEffect(() {
  final provider = context.read<CardProvider>();
  if (provider.currentDeckId == deckId && provider.cards.isNotEmpty) {
    return null; // skip — keep local state
  }
  Future.microtask(() => provider.fetchCards(deckId));
  return null;
}, [deckId]);
```

---

## 3. FITB "multiple blanks" broken by complex comma-escape parsing

**What went wrong:** An attempt to support `\,` as an escaped comma used a char-by-char parser that failed to split correctly. `fish,hello` was treated as one answer instead of two.

**Rule:** Keep the split logic dead simple. Escape sequences in user-facing text fields add hidden complexity with no payoff:
```dart
// ✓ Simple and correct
List<String> _splitFitbAnswers(String raw) =>
    raw.split(',').map((a) => a.trim()).where((a) => a.isNotEmpty).toList();
```

If commas-in-answers are ever needed, handle it at the data model level (JSON array field), not via string escaping in a plain text field.

---

## 4. `_buildSomething()` private methods instead of named widget classes

**What went wrong:** Build methods were split with `Widget _buildHeader()`, `Widget _buildBody()`, etc. Per CLAUDE.md rules, this is forbidden — it hides widgets from the inspector, prevents `const` constructors, and makes extraction harder.

**Rule:** Always extract to a named class, even for screen-local widgets:
```dart
// ✗ Wrong
Widget _buildPublishToggle() => SwitchListTile(...);

// ✓ Correct — named class at the bottom of the same file
class _PublishToggle extends StatelessWidget { ... }
```

---

## 5. Sync button hidden in a popup menu instead of a visible UI element

**What went wrong:** The "push changes" action was buried in a `PopupMenuButton` on deck cards. Users couldn't find it because popup menus are hidden until tapped.

**Rule:** For actions users need to discover and use regularly (like syncing), surface them as visible icon buttons in the AppBar or a dedicated button row. Reserve popup menus for secondary/destructive actions (delete, rename) that should not be front-and-center.

---

## 6. No multi-select for bulk delete on list/grid pages

**What went wrong:** The delete action was only accessible via a popup menu on individual items. Users who wanted to delete multiple decks had no way to do it.

**Rule:** For list/grid pages where bulk operations are likely, implement long-press to enter selection mode:
- Long press → enter selection mode, toggle the pressed item
- Tap in selection mode → toggle selection
- Replace AppBar with selection AppBar (count + delete/action buttons)
- Show selection indicators on each card

---

## 7. Shell pages missing their own AppBar

**What went wrong:** Shell pages (`HomePage`, `DeckListPage`, `AccountPage`) are children of `ResponsiveScaffold`, which provides the outer Scaffold + NavigationBar. Without their own inner Scaffold, they had no AppBar and looked unfinished.

**Rule:** Shell pages should have their own inner `Scaffold` with an `AppBar`. Flutter supports nested Scaffolds cleanly — the inner AppBar appears at the top, the outer NavigationBar stays at the bottom. This is the correct pattern for this app.

---

## 8. `loadFromCache` result ignored — always triggering a slow network fetch

**What went wrong:** `DeckListPage` called `loadFromCache(userId)` but then always called `fetchUserDecks` regardless, causing a loading spinner on every mount even when cached data was already present.

**Rule:** `loadFromCache` returns the count of cached items. Only fetch from the network when the cache is empty:
```dart
final cachedCount = deckProv.loadFromCache(userId);
if (cachedCount == 0) {
  Future.microtask(() => deckProv.fetchUserDecks(userId));
}
```

---

## 9. `copyWith` missing sentinel for nullable fields

**What went wrong:** Models with nullable fields used a plain `String?` parameter in `copyWith`. This made it impossible to explicitly set those fields to `null` — the caller couldn't distinguish "set to null" from "keep existing value".

**Rule:** Use the sentinel pattern for every nullable field in `copyWith`:
```dart
const Object _sentinel = Object();

DeckCard copyWith({
  Object? sourceCardId = _sentinel,
  ...
}) => DeckCard(
  sourceCardId: sourceCardId == _sentinel
      ? this.sourceCardId
      : sourceCardId as String?,
  ...
);
```

---

## 10. Provider not loading persisted state from Hive on construction

**What went wrong:** `CardProvider` had a `lastSyncedAt` field that was always `null` on startup because no one restored it from Hive in the constructor. The "last synced" timestamp was lost on every app restart.

**Rule:** Providers that persist state to Hive must restore it in their constructor:
```dart
CardProvider({required HiveService hiveService, ...})
    : _hive = hiveService, ... {
  _lastSyncedAt = _hive.getLastSyncedAt(); // restore persisted value
}
```

---

## 11. Duplicating Supabase write logic in `pushDeck` and `syncAll`

**What went wrong:** `pushDeck` and `syncAll` would each contain the full Supabase write sequence (deleteOrphanCards, upsertCardRow, deleteChildren, batchInsert × 4). Duplicated logic diverges silently.

**Rule:** Extract the pure data-write logic into a private `_pushDeckBody` method with no loading-flag side effects. Public methods manage flags and delegate to it:
```dart
Future<void> _pushDeckBody(String deckId) async { /* pure write */ }

Future<void> pushDeck(String deckId) async {
  _isPushing = true; notifyListeners();
  try { await _pushDeckBody(deckId); } finally { _isPushing = false; ... }
}

Future<bool> syncAll(List<String> deckIds) async {
  _isSyncing = true; notifyListeners();
  for (final id in deckIds) { await _pushDeckBody(id); } ...
}
```

---

## 12. `useEffect` dependency array mistakes

Common mistakes:

| Pattern | Problem |
|---|---|
| `const []` when effect depends on changing values | Effect never re-runs |
| `[mutableList]` as dependency | Reference equality fails; may loop |
| Missing `[deckId]` on a per-deck fetch | Stale data when navigating between decks |
| Watching provider inside effect instead of build | Misses updates, stale closure |

**Rule:**
- `const []` → mount-once effects only
- `[someId]` → effects that depend on a specific ID
- Never use mutable collections as dependencies
- Prefer `context.watch<Provider>()` in build over watching inside useEffect

---

## 13. Context captured in async callbacks after `context.pop()`

**What went wrong:** A SnackBar action's `onPressed` used `context.read<Provider>()` inside a closure. After `context.pop()` the page was unmounted, and calling `context.read` on a dead context caused a framework error.

**Rule:** Capture provider references (not context) before the pop:
```dart
final cardProv = context.read<CardProvider>(); // capture before pop
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    action: SnackBarAction(
      label: 'Sync Now',
      onPressed: () => cardProv.pushDeck(deckId), // uses captured ref
    ),
  ),
);
context.pop(); // pop after showing snackbar
```

---

## 14. `DeckProvider.createDeck` hardcodes `is_public: true`

**What went wrong:** The `createDeck` method had `'is_public': true` hardcoded, ignoring whatever the user set in the UI. There was no way to create a private deck.

**Rule:** Any field the user can control must flow through as a parameter — don't assume defaults in the provider internals:
```dart
// ✓ Correct — caller decides
Future<Deck?> createDeck(String userId, String title, String shortDesc,
    String lang, {bool isPublic = true}) async {
  final data = {
    ...
    'is_public': isPublic, // from caller
  };
}
```

---

## 15. Not checking `deck.isUneditable` before allowing card edits

**What went wrong:** Premade decks marked `isUneditable = true` could still be navigated to the card editor, because the edit button tap was not gated on this flag.

**Rule:** Always check `deck.isUneditable` (and `deck.isPremade`) before showing edit, add, or delete card actions. The `_CardTile` in `deck_detail_page.dart` shows an "Uneditable" chip when this flag is set — use the same flag to disable the edit icon and editor navigation.
