Reconciliation** means making stored data match what should exist now.

In this case, `StudyCardService.syncDeckStudyCards(...)` looks at:

- the current `CardTemplate`s in the deck
- the existing local `StudyCard`s for that deck

Then it makes the `StudyCard`s line up with the templates:

- if a needed `StudyCard` is missing, create it
- if an old `StudyCard` is no longer needed, remove it when safe
- if a correct `StudyCard` already exists, leave it alone

Example:

A flashcard template has `CardType.both`.

That means the app needs:

```text
template A, normal direction
template A, reversed direction
```

Later the user changes it to `CardType.normal`.

Now the app only needs:

```text
template A, normal direction
```

The reversed `StudyCard` is now obsolete because the template no longer says it should exist.

**Obsolete Cards With Personal History**

A `StudyCard` can have personal user data attached to it, like:

- FSRS scheduling state
- review progress
- due dates
- drill answers/history

So if the reversed card became obsolete, we ask:

“Has the user already studied this card?”

If no, delete it. It was just an unused generated row.

If yes, keep it for now. Deleting it could leave other records pointing to a missing `StudyCard`, such as an `FsrsCard.studyCardId` or drill answer history. That is what “orphaning progress/history” means: the progress record remains, but the card it belongs to is gone.

So the current behavior is conservative:

```text
obsolete + no history = delete
obsolete + has history = preserve
```

Long term, the cleaner solution may be adding an `isActive` / `archivedAt` field to `StudyCard`, so obsolete cards with history can be hidden from new sessions while still preserving past progress.
