# Convert Stateful Hooks And Helper Mutations To Controller + Service Pattern

Use this guide when converting BooMondai Flutter code that currently keeps
screen/sheet state in ad hoc hooks, `useState`, direct database listeners, or
helper methods that mutate `LocalDB`.

The target architecture is:

```text
Widget / Sheet / Page
  -> custom hook
      -> feature Controller extends Controller
          -> domain Service
              -> LocalDB / RemoteDB
          -> parent/list controller refresh when needed
```

The canonical example is the `ViewDeckSingleSheet` refactor:

```text
ViewDeckSingleSheet
  -> useViewDeckSingleSheet(...)
      -> ViewDeckSingleSheetController extends Controller
          -> DecksService
              -> LocalDB.deck.upsert(...)
```

## Goals

- Keep widgets declarative and mostly read-only.
- Keep custom hooks thin: create the controller, listen to it, dispose it.
- Keep UI orchestration in controllers: modals, loading flags, navigation, local
  view state, notifying listeners.
- Keep domain mutations in services: validation, trimming, copyWith, DB writes,
  and returning updated domain objects.
- Keep helpers pure: display labels, fallback text, formatting, object lookup for
  read-only display.
- Avoid `useState` or `ValueNotifier` scattered through hooks when the state
  belongs to a feature controller.
- Avoid direct Hive/DB listenables in a hook unless the feature truly needs to
  react to external DB changes while open.

## When To Apply This Pattern

Apply this conversion when you see one or more of these:

- A custom hook returns a plain object/controller that does not extend
  `Controller` / `ChangeNotifier`.
- A hook owns feature state with `useState`, `ValueNotifier`, or
  `useListenable(LocalDB.someBox.listenable())`.
- A widget receives an initial model, saves a change, but keeps rendering the
  original model.
- A helper named `*Helper` performs DB writes or meaningful business mutations.
- A controller calls a helper method like `Helper.updateX(...)` and then reloads
  parent state.
- A widget passes stale constructor arguments to app bars, bottom nav bars, chips,
  or body widgets after a controller has a newer active model.
- Multiple controller methods repeat this shape:

```dart
final updated = await SomeHelper.updateThing(...);
if (updated) parentController.load();
```

Prefer this converted shape:

```dart
final updatedThing = await SomeService.updateThing(...);
_applyUpdatedThing(updatedThing);
```

## When Not To Apply This Pattern

Do not force this pattern when:

- The widget is trivial and has only local ephemeral UI state, such as hover,
  animation, or a one-off text field draft that never leaves the widget.
- The hook wraps an existing reusable UI controller such as a physical card,
  animation, selection, or editor controller that already has a narrow purpose.
- The data truly must live-update from external database writes while the view is
  open. In that case, the controller may subscribe to the DB listenable internally
  and call `notifyListeners()`, but the widget should still listen only to the
  controller.
- The operation is pure formatting or label selection. That belongs in a helper,
  not in a service or controller.

## Responsibility Boundaries

### Widget

Widgets should:

- Call the custom hook once near the top of `build`.
- Read state from the returned controller.
- Pass controller methods as callbacks.
- Use the controller's active model, not the original constructor argument, after
  the hook has been created.

Good:

```dart
final sheet = useViewDeckSingleSheet(
  context: context,
  initialDeck: deck,
  controller: decksController,
);
final activeDeck = sheet.deck;

return Scaffold(
  bottomNavBar: ViewDeckSingleBottomNavBar(deck: activeDeck),
  body: _Body(sheet: sheet),
);
```

Avoid:

```dart
final sheet = useViewDeckSingleSheet(...);

return Scaffold(
  bottomNavBar: ViewDeckSingleBottomNavBar(deck: deck), // stale
  body: _Body(sheet: sheet),
);
```

### Custom Hook

Hooks should be lifecycle glue only:

- Create the controller with `useMemoized`.
- Include stable identity keys, usually the model id and parent controller.
- Call `useListenable(controller)`.
- Dispose the controller with `useEffect`.
- Return the controller.

Template:

```dart
SomeFeatureController useSomeFeatureController({
  required BuildContext context,
  required SomeModel initialModel,
  required ParentController parentController,
}) {
  final controller = useMemoized(
    () => SomeFeatureController(
      initialModel: initialModel,
      context: context,
      parentController: parentController,
    ),
    [initialModel.id, parentController],
  );

  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}
```

Avoid putting feature state directly in the hook:

```dart
final isSaving = useState(false);
final model = LocalDB.model.selectByPk({'id': initialModel.id});
return SomeController(model: model, isSaving: isSaving.value);
```

That makes the hook a second state owner and weakens the controller.

### Controller

Feature controllers should extend `Controller` from
`lib/core/controllers/controller.dart`.

Controllers should own:

- Active screen/sheet model, for example `_deck`.
- UI state flags, for example `_isSavingPublishState`.
- Modals and confirmation flows.
- Navigation/pop behavior that depends on `BuildContext`.
- Parent/list refresh calls.
- `notifyListeners()` calls after state changes.

Controllers should not:

- Contain persistence details beyond calling a service.
- Build updated domain objects inline if that is business logic shared by other
  screens.
- Write to `LocalDB` from many methods when a service would centralize the rules.
- Expose mutable fields directly.

Template:

```dart
class SomeFeatureController extends Controller {
  SomeFeatureController({
    required SomeModel initialModel,
    required BuildContext context,
    required ParentController parentController,
  }) : _context = context,
       _parentController = parentController,
       _model = initialModel;

  final BuildContext _context;
  final ParentController _parentController;

  SomeModel _model;
  bool _isSaving = false;

  SomeModel get model => _model;
  bool get isSaving => _isSaving;

  void _setModel(SomeModel value) {
    _model = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  void _applyUpdatedModel(SomeModel? updatedModel) {
    if (updatedModel == null) return;

    _setModel(updatedModel);
    _parentController.load();
  }

  Future<void> updateName(String value) async {
    final updatedModel = await SomeService.updateName(
      model: _model,
      value: value,
    );
    _applyUpdatedModel(updatedModel);
  }
}
```

### Service

Services should own domain mutation rules and persistence:

- Validate editability/permissions.
- Normalize inputs.
- Skip no-op changes.
- Build updated domain objects with `copyWith`.
- Set timestamps such as `updatedAt`.
- Write to `LocalDB` / `RemoteDB`.
- Return the updated object when a mutation happens.
- Return `null` when no mutation happened.

Use feature/domain services such as:

```text
lib/features/decks/decks.service.dart
lib/features/study_session/study_card.service.dart
lib/features/deck_downloads/deck_downloads.service.dart
```

Template:

```dart
abstract final class SomeService {
  static Future<SomeModel?> update({
    required SomeModel model,
    String? name,
    String? description,
    bool? isPublished,
  }) async {
    final updatesEditableField = name != null || description != null;
    if (updatesEditableField && !model.isEditable) {
      return null;
    }

    var updatedModel = model;
    var changed = false;

    if (name != null) {
      final trimmedName = name.trim();
      if (trimmedName.isEmpty) {
        return null;
      }
      if (trimmedName != model.name) {
        updatedModel = updatedModel.copyWith(name: trimmedName);
        changed = true;
      }
    }

    if (description != null) {
      final trimmedDescription = description.trim();
      if (trimmedDescription != model.description) {
        updatedModel = updatedModel.copyWith(
          description: trimmedDescription,
        );
        changed = true;
      }
    }

    if (isPublished != null && isPublished != model.isPublished) {
      updatedModel = updatedModel.copyWith(isPublished: isPublished);
      changed = true;
    }

    if (!changed) {
      return null;
    }

    updatedModel = updatedModel.copyWith(
      updatedAt: DateTime.now(),
    );

    await LocalDB.someModel.upsert(updatedModel);
    return updatedModel;
  }
}
```

For simple scalar fields on the same aggregate, prefer one typed `update(...)`
method with optional named parameters over many tiny service methods. The
controller can still expose readable UI callbacks:

```dart
Future<void> updateName(String value) async {
  final updatedModel = await SomeService.update(
    model: _model,
    name: value,
  );
  _applyUpdatedModel(updatedModel);
}
```

Keep separate service methods for operations that are structurally different,
such as file conversion, child object creation, syncing, import/export, or
multi-table writes.

### Helper

Helpers should be pure read/display utilities:

- Fallback display labels.
- Formatting.
- Selecting display text.
- Read-only lookup helpers if already established locally.

Good helper methods:

```dart
static String title(Deck deck) {
  return deck.title.isEmpty ? 'Untitled deck' : deck.title;
}

static String visibilityLabel(Deck deck) {
  return switch (deck.visibilityState) {
    VisibilityState.private => 'Private',
    VisibilityState.public => 'Public',
    VisibilityState.unlisted => 'Unlisted',
  };
}
```

Avoid helper methods that write to DB:

```dart
static Future<bool> setTitle(...) async {
  await LocalDB.deck.upsert(...);
  return true;
}
```

Move those to a service.

## Choosing The Right Service

Put an operation in the service for the aggregate being mutated.

Example: updating deck tags belongs in `DecksService`, not `TagsService`, because
the persisted aggregate is the deck:

```dart
static Future<Deck?> setTags({
  required Deck deck,
  required List<String> tagNames,
}) async {
  // normalize names, create missing Tag values, copy deck.tags, upsert deck
}
```

Create or use `TagsService` only for tag-domain operations where `Tag` itself is
the aggregate:

- Create standalone tags.
- Rename tags globally.
- Merge duplicate tags.
- Delete tags.
- Search/filter tag catalog.
- Normalize a user's tag library independent of any deck/card.

Use the same rule for other relationships:

- "Update this deck's cover image" -> `DecksService`.
- "Update this card template's tags" -> card/template service.
- "Rename the tag everywhere" -> `TagsService`.
- "Sync study cards for this deck" -> `StudyCardService` if the aggregate is the
  generated study-card set.

## Migration Checklist

1. Identify the current state owners.

   Look for `useState`, `ValueNotifier`, direct `LocalDB.*.box.listenable()`,
   constructor models that never update, and helper mutation calls.

2. Decide the active model.

   Pick the model the screen/sheet should render after edits, such as `_deck`,
   `_profile`, `_listing`, or `_template`.

3. Convert the feature controller.

   Make it extend `Controller`, store private mutable state, expose getters, and
   call `notifyListeners()` through small setter helpers.

4. Simplify the hook.

   Replace hook-owned state with:

   ```dart
   final controller = useMemoized(...);
   useListenable(controller);
   useEffect(() => controller.dispose, [controller]);
   return controller;
   ```

5. Move DB writes from helpers to a service.

   The service should return the updated object or `null`. Keep helpers pure.

6. Make controller methods call the service.

   Prefer:

   ```dart
   final updatedDeck = await DecksService.update(
     deck: _deck,
     title: value,
   );
   _applyUpdatedDeck(updatedDeck);
   ```

   over:

   ```dart
   final updated = await ViewDeckSingleHelper.updateTextField(...);
   if (updated) _parentController.load();
   ```

7. Update all widgets to use the controller's active model.

   Search the widget file for the original constructor argument. After the hook,
   app bars, chips, bottom nav bars, and body widgets should usually use
   `controller.model` or an `activeModel` local variable.

8. Export new services from the relevant barrel.

   For example:

   ```dart
   export 'decks.service.dart';
   ```

   Add this only to the relevant feature barrel. Generated barrel comments may
   exist, but local manual export additions are acceptable when the project is
   already using barrel imports and the new class is imported through
   `lib.barrel.dart`.

9. Remove stale imports.

   Common removals after conversion:

   - `hive_ce_flutter.dart` when the hook no longer listens to Hive.
   - `ValueNotifier` when saving state moves into the controller.
   - `LocalDB` from the controller when only the service writes.
   - model imports from helper files after mutation methods are removed.

10. Format and analyze the touched files.

   Run targeted checks first:

   ```bash
   dart format <touched files>
   dart analyze <touched files>
   ```

   Use broader `flutter analyze` / `flutter test` when the change touches shared
   behavior, generated exports, or multiple features.

## Detailed Before / After

### Before: hook listens to DB but still uses stale initial model

```dart
ViewDeckSingleSheetController useViewDeckSingleSheet({
  required BuildContext context,
  required Deck initialDeck,
  required ViewDecksLocalController controller,
}) {
  final deckListenable = useMemoized(() => LocalDB.deck.box.listenable());
  useListenable(deckListenable);

  final deck = initialDeck;
  final isSavingPublishState = useState(false);

  return ViewDeckSingleSheetController(
    deck: deck,
    isSavingPublishState: isSavingPublishState.value,
    context: context,
    parentController: controller,
    isSavingPublishStateNotifier: isSavingPublishState,
  );
}
```

Problem: the hook rebuilds when the DB changes, but it still returns
`initialDeck`, so the UI keeps rendering stale data.

### After: hook listens to controller only

```dart
ViewDeckSingleSheetController useViewDeckSingleSheet({
  required BuildContext context,
  required Deck initialDeck,
  required ViewDecksLocalController controller,
}) {
  final sheetController = useMemoized(
    () => ViewDeckSingleSheetController(
      initialDeck: initialDeck,
      context: context,
      parentController: controller,
    ),
    [initialDeck.id, controller],
  );

  useListenable(sheetController);
  useEffect(() => sheetController.dispose, [sheetController]);

  return sheetController;
}
```

### Before: helper mutates database

```dart
static Future<bool> updateTextField({
  required Deck deck,
  required String value,
  required bool allowEmpty,
  required String Function(Deck deck) selectCurrentValue,
  required Deck Function(Deck deck, String value) copyWithValue,
}) async {
  if (!deck.isEditable) {
    return false;
  }

  final trimmedValue = value.trim();
  if (!allowEmpty && trimmedValue.isEmpty) {
    return false;
  }
  if (trimmedValue == selectCurrentValue(deck)) {
    return false;
  }

  final updatedDeck = copyWithValue(
    deck,
    trimmedValue,
  ).copyWith(updatedAt: DateTime.now());

  await LocalDB.deck.upsert(updatedDeck);
  return true;
}
```

Problem: the helper name implies display utility, but it hides persistence and
business mutation behavior.

### After: service mutates and returns updated object

```dart
static Future<Deck?> update({
  required Deck deck,
  String? title,
  String? shortDescription,
  String? longDescription,
  bool? isPublished,
}) async {
  final updatesEditableField =
      title != null || shortDescription != null || longDescription != null;
  if (updatesEditableField && !deck.isEditable) return null;

  var updatedDeck = deck;
  var changed = false;

  if (title != null) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return null;
    if (trimmedTitle != deck.title) {
      updatedDeck = updatedDeck.copyWith(title: trimmedTitle);
      changed = true;
    }
  }

  if (shortDescription != null) {
    final value = shortDescription.trim();
    if (value != deck.shortDescription) {
      updatedDeck = updatedDeck.copyWith(shortDescription: value);
      changed = true;
    }
  }

  if (longDescription != null) {
    final value = longDescription.trim();
    if (value != deck.longDescription) {
      updatedDeck = updatedDeck.copyWith(longDescription: value);
      changed = true;
    }
  }

  if (isPublished != null && isPublished != deck.isPublished) {
    updatedDeck = updatedDeck.copyWith(isPublished: isPublished);
    changed = true;
  }

  if (!changed) return null;

  updatedDeck = updatedDeck.copyWith(updatedAt: DateTime.now());
  await LocalDB.deck.upsert(updatedDeck);
  return updatedDeck;
}
```

The controller can still keep specific UI callback names while using the generic
service update:

```dart
Future<void> setTitle(String value) async {
  final updatedDeck = await DecksService.update(
    deck: _deck,
    title: value,
  );
  _applyUpdatedDeck(updatedDeck);
}
```

## Handling Parent Controllers

If a screen-specific controller edits one item that also appears in a parent
list, update local state first, then refresh the parent list:

```dart
void _applyUpdatedDeck(Deck? updatedDeck) {
  if (updatedDeck == null) return;

  _setDeck(updatedDeck);
  _parentController.load();
}
```

This keeps the open sheet responsive while still letting the parent page reflect
the DB state.

If the parent controller has a targeted method such as `replaceDeck(updatedDeck)`,
prefer that over a full reload when it is correct and already established.

## Handling Saving And Loading Flags

Use controller fields for action-specific flags:

```dart
bool _isSavingPublishState = false;

bool get isSavingPublishState => _isSavingPublishState;

void _setSavingPublishState(bool value) {
  _isSavingPublishState = value;
  notifyListeners();
}
```

Use `try/finally`:

```dart
_setSavingPublishState(true);
try {
  final updatedDeck = await DecksService.update(
    deck: _deck,
    isPublished: isPublished,
  );
  _applyUpdatedDeck(updatedDeck);
} finally {
  _setSavingPublishState(false);
}
```

Use inherited `setLoading` / `setError` from `Controller` for broad screen-level
loading and error state. Use dedicated private flags for narrower UI controls
when the whole screen should not enter a loading state.

## Handling BuildContext

Controllers may hold `BuildContext` when they are sheet/page scoped and need to:

- Show modals.
- Push routes.
- Pop the current route/sheet.
- Check `_context.mounted` after an async gap.

Always check mounted before navigation after `await`:

```dart
if (_context.mounted) {
  Navigator.of(_context).pop();
}
```

Avoid passing `BuildContext` into services. Services should not show UI or
navigate.

## Handling Database Listenables

Default: do not listen to DB boxes in hooks for this pattern.

For self-owned edits, the service returns the updated object and the controller
sets local state immediately.

Only subscribe to `LocalDB.*.box.listenable()` when external writers must update
the open view live. If needed, subscribe inside the controller, not the hook:

```dart
late final Listenable _dbListenable;

SomeController(...) {
  _dbListenable = LocalDB.someBox.box.listenable();
  _dbListenable.addListener(_syncFromDb);
}

void _syncFromDb() {
  final latest = LocalDB.someBox.selectByPk({'id': _model.id});
  if (latest == null || latest == _model) return;

  _model = latest;
  notifyListeners();
}

@override
void dispose() {
  _dbListenable.removeListener(_syncFromDb);
  super.dispose();
}
```

Do not combine hook-level DB listenables with controller-owned state unless there
is a strong reason. It creates two sources of truth.

## Return Value Conventions For Services

Use these conventions consistently:

- `Future<Model?>`: mutation may be skipped because the value is unchanged,
  invalid, or not editable.
- `Future<Model>`: mutation should always happen if the caller already confirmed
  and guarded the action.
- `Future<void>`: use only when the caller does not need an updated object.

For UI edits, prefer returning `Model?`; it lets the controller update local state
without re-reading from DB.

## Naming Conventions

- Controller class: `FeatureThingController`, for example
  `ViewDeckSingleSheetController`.
- Hook: `useFeatureThing`, for example `useViewDeckSingleSheet`.
- Service: domain/aggregate name + `Service`, for example `DecksService`.
- Helper: feature name + `Helper`, but only for pure display/read helpers.
- Private state setter: `_setDeck`, `_setSavingPublishState`.
- Apply service result: `_applyUpdatedDeck`, `_applyUpdatedProfile`,
  `_applyUpdatedTemplate`.

## Common Pitfalls

- Updating only the body to use `controller.model` while the app bar or bottom
  nav still uses the stale constructor argument.
- Keeping a `useState` flag in the hook after the controller exists.
- Returning `bool` from a service and forcing the controller to re-read from DB.
  Prefer returning the updated object.
- Creating one service method per simple scalar field when those fields share the
  same validation/write path. Prefer one typed `update(...)` method with optional
  named parameters for simple fields, while keeping complex operations separate.
- Moving a helper mutation into a service but leaving old imports and method
  names behind.
- Putting UI confirmation modals in the service. Keep them in the controller.
- Putting DB writes directly in the widget callback.
- Calling `notifyListeners()` repeatedly during one logical update when one call
  after assigning state would be enough.
- Forgetting to dispose controllers created with `useMemoized`.
- Using `initialModel` in the widget after creating the controller.

## Verification Checklist

Before finishing a conversion:

- Search for old helper mutation calls:

  ```bash
  rg -n "Helper\\.update|updateTextField\\(" lib/features/<feature>
  ```

- Search for stale constructor model usage in the widget file.
- Confirm the custom hook contains no feature state except controller lifecycle.
- Confirm the controller extends `Controller`.
- Confirm the service owns all DB writes for the moved operations.
- Confirm helpers no longer import mutation-only dependencies.
- Run formatting:

  ```bash
  dart format <touched files>
  ```

- Run targeted analysis:

  ```bash
  dart analyze <touched files>
  ```

- Run broader tests/analyze when the service is shared or the operation affects
  multiple screens.

## Quick Classification Table

| Code | Destination |
| --- | --- |
| `useMemoized`, `useListenable`, `useEffect(dispose)` | custom hook |
| Active model state such as `_deck` | controller |
| UI-only saving flags | controller |
| Modal confirmations | controller |
| Navigation and `context.mounted` checks | controller |
| Parent list refresh | controller |
| Input normalization and no-op checks | service |
| `copyWith(... updatedAt: DateTime.now())` | service |
| `LocalDB.*.upsert(...)` | service |
| Remote persistence | service |
| Fallback display labels | helper |
| Formatting display dates/names/visibility labels | helper |
| Standalone tag create/rename/delete/search | `TagsService` |
| Assigning tags to a deck | `DecksService` |

## Preferred End State

After conversion, it should be easy to describe the flow:

```text
User edits field
  -> widget calls controller.updateField
  -> controller calls domain service
  -> service validates, writes DB, returns updated object
  -> controller stores updated object and notifies listeners
  -> hook rebuilds widget
  -> widget renders controller.model everywhere
```

If the flow cannot be described this way, re-check whether state, persistence, or
display logic is still in the wrong layer.
