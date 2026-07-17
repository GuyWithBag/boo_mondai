# Project File Patterns

This document defines the preferred architecture and naming conventions for this
project.

The goal is not to force every file into ceremony. The goal is to make code easy
to find, easy to read, easy to reuse, and difficult to accidentally couple in the
wrong direction.

## Core Principle

Prefer small, readable files with clear responsibility.

Keep feature code separated under:

```text
lib/features/<feature-name>/
```

Each feature should own its controllers, services, DB adapters, widgets, models,
helpers, and feature-specific sync logic unless the code is generic enough to
belong in `core`.

If code can be used widely and repeatedly, and it does not clearly belong to one
feature, put it under:

```text
lib/core/
```

Core is for feature-neutral infrastructure, helpers, shared models, shared
widgets, and generic utilities. If something might possibly be useful later,
can be generic, and does not clearly belong to a feature, prefer putting it in
`core` with a feature-neutral name.

Keep things in separate files by default, even when they are small. This applies
to:

- classes
- enums
- models
- controllers
- services
- helpers
- DB adapters
- widgets
- feature-specific value objects

The main exception is `typedef`. Typedefs may live beside the class/function
that uses them when they are small and tightly scoped.

Names should describe:

- what the thing is
- what it returns
- what it does
- what it is for

The best names should read naturally as a sentence:

```dart
deck.isPublished
profile.hasRemoteAvatar
syncPlan.hasChanges
StoredMediaService.getByRemoteUrl(...)
```

Use verbs for functions when the function performs an action:

```dart
getCoverImageUrl(...)
setDisplayName(...)
uploadBytes(...)
deleteWhere(...)
selectMany(...)
createSignedUrl(...)
```

Supabase-facing code should use Supabase/PostgREST-style verbs where that makes
the behavior clearer:

```dart
selectOne(...)
selectMany(...)
insert(...)
update(...)
upsert(...)
deleteWhere(...)
```

## Common File Types

### `.helper.dart`

Use helper files for reusable, mostly stateless logic.

Helpers are appropriate when:

- the function can be generic
- the function can be reused in future features
- the logic does not naturally belong to one service or controller
- the logic is pure or close to pure
- the file mostly transforms, formats, resolves, compares, validates, or builds
  values

Preferred shape:

```dart
abstract final class SomethingHelper {
  static String getSomethingLabel(...) { ... }
  static bool isSomethingValid(...) { ... }
}
```

Examples:

```dart
ImageHelper.isRemoteUrl(...)
MarkdownHelper.resolveMediaSourceUri(...)
FileHelper.fileNameWithoutExtension(...)
```

If a function can be generic and reused later, it is acceptable to extract it
early into a `something.helper.dart` file.

Do not put side-effect-heavy orchestration into helpers. If the function writes
to DB, uploads, downloads, starts workflows, or coordinates multiple services, it
is probably a service.

### `.service.dart`

Use service files for domain operations and workflow logic.

Services are appropriate when:

- logic coordinates multiple repositories or helpers
- logic performs side effects
- logic belongs to a feature/domain
- logic should be callable from controllers, sync, import/export, or other
  feature workflows

Examples:

```dart
DecksService.setCoverImageUrl(...)
StoredMediaService.storeFile(...)
SyncDeletionService.createDeckScoped(...)
```

Service methods should use verbs:

```dart
storeFile(...)
uploadAvatar(...)
renameFolderByPrefix(...)
deleteDeckCascade(...)
loadRemoteDecksByIdsForSyncSession(...)
```

Services should not become global junk drawers. If a service grows unrelated
responsibilities, split it by domain or workflow.

### `.db.dart`

Use DB files for persistence boundaries.

DB files should know how to:

- select
- insert
- update
- upsert
- delete
- serialize rows
- deserialize rows
- apply table-specific joins
- map primary keys

DB files should not own UI behavior, workflow decisions, or feature orchestration.

Examples:

```dart
DecksRemoteDB
DecksLocalDB
CardTemplatesRemoteDB
StoredMediasLocalDB
PublicBucketRemoteDB
```

Supabase table repositories should extend:

```dart
SupabaseRemoteDB<T>
```

Hive repositories should extend:

```dart
HiveLocalDB<T>
```

Storage buckets are not tables. If bucket abstractions are kept, their names
should make that clear even if they share repository-like structure.

### `.controller.dart`

Controllers are UI-facing state coordinators.

In this project, a controller file often combines:

- the controller class
- the `useController` hook or feature-specific hook that creates it

This is acceptable when the hook is tightly coupled to that controller and does
not deserve its own file.

Controllers should:

- manage UI state
- expose current values to widgets
- call services
- call DBs only for straightforward local reads/writes when that remains simple
- notify listeners
- handle loading/error state

Controllers should not:

- build storage bucket paths
- construct sync media references
- contain complex upload/sync algorithms
- know every subtype of a feature model
- become persistence orchestration layers

If a controller starts coordinating storage, remote DB, local DB, and domain
rules, move that logic into a service.

### `.page.dart`

Page files are route-level UI composition.

Page files should:

- build route/screen layout
- connect controllers to widgets
- define page-level scaffold behavior
- pass callbacks into widgets

Page files should not:

- contain persistence logic
- construct storage paths when that path is a domain convention
- perform sync/upload behavior directly

If a page needs a path or workflow, call a helper/service.

### `models/`

Use `models/` for DTOs, value objects, enum models, and domain data structures.

Models should generally:

- represent app/domain data
- be serializable where needed
- keep behavior small and intrinsic

Good model behavior:

```dart
Deck.isPublished
FillInTheBlankSegment.displayText
CardTemplate.checkAnswer(...)
```

Avoid putting large workflows inside models.

### Feature-specific model groups

When models form a meaningful group, keep them under feature-specific model
folders.

Examples:

```text
lib/features/cards/models/
lib/features/decks/models/
lib/features/sync/models/
lib/features/stored_media/models/
```

This keeps feature concepts near the feature that owns them.

Move a model/helper/contract to core when it can be generic, repeatedly useful,
and not clearly owned by one feature.

## Feature Folder Separation

Default to feature-local ownership:

```text
lib/features/decks/
lib/features/cards/
lib/features/profile/
lib/features/sync/
lib/features/stored_media/
```

Do not put feature-specific behavior in `core`. But if the behavior can be made
generic, might be useful later, and does not naturally belong to one feature,
put the generic version in `core`.

Use `lib/core/` when code is:

- widely reused
- feature-neutral
- not naturally owned by one feature
- infrastructure-like
- generic enough to remain stable across feature changes

Examples:

| Code | Preferred location |
|---|---|
| deck cover path helper | `lib/features/decks/...` or `lib/features/stored_media/...` if shared by stored media |
| card-template media field helper | `lib/features/cards/...` |
| profile avatar service | `lib/features/profile/...` |
| generic media source parser | `lib/core/helpers/...` |

Cross-feature code should have a clear reason to exist outside a feature.

Some domains are feature-specific even when they combine multiple concepts. Keep
those domains as their own feature folders instead of nesting them under another
feature.

Example:

```text
lib/features/sync_deck/
```

Prefer this over:

```text
lib/features/decks/sync/
```

when deck sync has enough models, services, preprocessors, controllers, and
workflow concepts to behave like its own feature domain.

When a feature domain has its own meaningful subdomains, group those files under
named subfolders instead of keeping every file flat at the feature root.

Examples:

```text
lib/features/sync_deck/sync_preprocessors/
lib/features/sync_deck/models/
lib/features/sync_deck/widgets/
```

Use subfolders when the grouped files share a clear purpose and are likely to be
worked on together. For example, deck-sync media preprocessing belongs under:

```text
lib/features/sync_deck/sync_preprocessors/
```

rather than as several unrelated-looking files at:

```text
lib/features/sync_deck/
```

Keep generic sync workflow contracts under the generic sync feature:

```text
lib/features/sync/models/sync.plan_step.dart
lib/features/sync/models/typed_sync.plan_step.dart
```

Keep deck-sync workflow files under the deck-sync feature:

```text
lib/features/sync_deck/sync_deck.session.dart
lib/features/sync_deck/sync_deck.service.dart
lib/features/sync_deck/sync_deck.controller.dart
```

### Feature filename prefixes

When a feature name is a compound domain such as `sync_deck`, use that feature
name as the filename prefix for root-level feature files.

Prefer:

```text
lib/features/sync_deck/sync_deck.session.dart
lib/features/sync_deck/sync_deck.service.dart
lib/features/sync_deck/sync_deck.plan_payload.dart
```

Avoid:

```text
lib/features/sync_deck/deck.sync_session.dart
lib/features/sync_deck/deck.sync_service.dart
lib/features/sync_deck/deck.sync_plan_payload.dart
```

The filename prefix should identify the owning feature domain. The suffix should
identify the role or narrower concept.

## Separate File Rule

Keep every meaningful type in its own file by default.

This includes small enums. For example, prefer:

```text
lib/features/decks/models/visibility_state.dto.dart
lib/features/change_tracker/models/change_type.dart
lib/features/change_tracker/models/change_source.dart
```

over grouping multiple enums or models into one mixed file.

This keeps imports, generated files, ownership, and future edits clearer.

Exception:

- small `typedef`s can stay in the file that uses them when they are not
  reusable enough to deserve their own file

If a typedef becomes reused across files or features, move it to an appropriate
model/helper/contract file.

## Generic Contracts, Interfaces, and Mixins

Interfaces, mixins, and contracts are encouraged when they make code generic and
readable.

Use them when:

- several unrelated classes need the same behavior
- a generic algorithm only needs a small contract
- passing an entire concrete class would create unnecessary coupling
- a function callback communicates intent better than forcing a type hierarchy

Example contract:

```dart
abstract interface class HasId {
  String get id;
}
```

Example function-based contract:

```dart
final String Function(T item) getItemId;
```

This is acceptable and often preferred when a generic implementation only needs
one behavior:

```dart
NewestWinsSyncStrategy<T>(
  getItemId: (item) => item.id,
)
```

You do not need to force a generic `T extends SomeInterface` if a callback is
clearer and less invasive.

For interface, mixin, contract, and callback members, use `get`/`set` prefixes
when the member acts like a getter or setter:

```dart
final String Function(T item) getItemId;
final T Function(T item, String value) setItemTitle;
```

Do not name getter-like callbacks as nouns such as `itemId`. The name should
describe the action the callback performs.

## `dynamic` and Generic Containers

Avoid `dynamic` by default, but it is acceptable when the purpose of a class is
to hold generic executable behavior rather than expose concrete typed data.

Acceptable pattern:

```dart
final items = <CustomClass<dynamic>>[];

for (final item in items) {
  newList.add(item.myFunction('hello'));
}
```

This is acceptable when:

- consumers only need methods defined on `CustomClass`
- the type parameter does not matter to the loop
- the dynamic value is contained and does not leak into domain logic
- using `dynamic` avoids unnecessary type gymnastics

Do not use `dynamic` to avoid modeling a real type or to bypass type errors in
core workflows.

## Naming Guidelines

### Names should read naturally

Prefer:

```dart
Deck.isPublished
Profile.hasAvatar
SyncPlan.hasChanges
StoredMediaService.getByPath(...)
```

Avoid vague names:

```dart
data
thing
handle
process
doStuff
remoteStorage // if the precise bucket matters
```

### Function names should include action verbs

Prefer:

```dart
getById(...)
loadRemoteItems(...)
createFromPreview(...)
uploadBytes(...)
rewriteMarkdown(...)
deleteByPk(...)
```

Avoid noun-only function names unless it is a getter/property.

### Return-oriented names are good

If a function returns a specific value, make that obvious:

```dart
getCoverImageUrl(...)
getFeaturedImages(...)
loadDeletedEntityIds(...)
createSignedUrl(...)
```

### Purpose-oriented names are good

If a class exists for a specific purpose, name that purpose:

```dart
DeckSyncSession
SyncMediaReferenceApplier
StoredMediaPath
CardTemplateMediaSyncPreprocessor
```

If the purpose changes, rename the class.

## Separation Without Over-Coupling

Separation is good when it creates clear ownership.

Separation is bad when it creates too many tiny files that are impossible to
follow or forces every feature through a central abstraction.

Prefer extracting when:

- two or more places repeat the same behavior
- a file knows too many unrelated concepts
- a controller begins doing service work
- a sync class begins knowing feature-specific subtype details
- a helper becomes side-effect-heavy
- a DB class starts owning domain workflow

Avoid extracting when:

- the abstraction has only one unclear use
- the extraction hides simple logic behind vague names
- the abstraction creates more coupling than it removes
- the abstraction cannot be named clearly as a reusable concept

## Reuse Rule

If a function can be generic or reused in the future, it can be extracted.

Preferred destination when the helper is generic or may be repeatedly useful:

```text
lib/core/helpers/something.helper.dart
```

Feature-local helpers are still valid when the logic clearly belongs to one
feature:

```text
lib/features/<feature>/something.helper.dart
```

If it can reasonably be made generic and does not belong anywhere specific,
prefer `core`.

Example:

```dart
abstract final class MediaSourceHelper {
  static bool isLocalReference(String source) { ... }
  static String? getLocalReferenceId(String source) { ... }
}
```

## Dependency Direction

Preferred direction:

```text
page -> controller -> service -> db/helper/model
sync strategy -> preprocessor/service -> db/helper/model
widgets -> controller/service/helper, not remote persistence directly
```

Avoid:

```text
controller -> bucket path construction
page -> StoredMediaPath construction for domain-owned media
db -> controller
helper -> controller
model -> db/service
generic sync -> feature subtype details
```

## Barrel Imports

Use barrel imports as the standard project pattern.

Each folder should have a `.barrel.dart` file that exports its public files
upward until they are available through:

```dart
import 'package:boo_mondai/lib.barrel.dart' show SomeClass, SomeService;
```

Prefer importing from `lib.barrel.dart` with an explicit `show` list.

Do not import deep feature files directly unless there is a specific reason,
such as generated part files, package boundaries, or a temporary migration.

The standard pattern is:

```text
feature file
  -> feature.barrel.dart
  -> features.barrel.dart
  -> lib.barrel.dart
```

Then consumers import:

```dart
import 'package:boo_mondai/lib.barrel.dart' show Deck, DecksService;
```

## Doc Comments and Regular Comments

Use Dart doc comments for public or important declarations:

```dart
/// Uploads pending local media and returns the remote bucket value.
```

Prefer doc comments for:

- classes
- services
- helpers
- public methods
- interfaces
- mixins
- contracts
- confusing fields
- concepts that future readers need to understand from autocomplete or API docs

Doc comments should explain what the declaration is for, when to use it, and any
important constraints.

Keep comments short. Prefer explaining why the code exists over repeating what
the code already says.

Regular comments are also allowed inside code for implementation details,
non-obvious branches, or temporary local context.

Good regular comments:

```dart
// Preview must stay read-only; uploads happen only during apply.
```

```dart
// Public bucket RLS protects writes, not reads.
```

Avoid long comments that become second documentation files inside the code.

## Practical Review Checklist

Before adding a new file or function, ask:

- Is this UI state? Use a controller.
- Is this workflow/domain behavior? Use a service.
- Is this persistence mapping/querying? Use a DB file.
- Is this reusable stateless logic? Use a helper.
- Is this data? Use a model.
- Is this only needed by one feature? Keep it feature-local.
- Is this generic, repeatedly useful, or not owned by one feature? Use core.
- Does the name read like what it does?
- Does the function name include a useful verb?
- Does this file know too many unrelated concepts?
- Can a small callback contract avoid over-constraining a generic type?
