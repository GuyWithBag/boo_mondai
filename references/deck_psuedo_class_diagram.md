# DeckCard — Pseudo Class Diagram
> Last updated: 2026-03-28
> Reflects the actual Dart models in `lib/models/`.

---

## Overview

A `DeckCard` is a shell that stores only **type metadata** (`cardType` +
`questionType`). All presentable content lives in **content nodes** — child
objects fetched alongside the card from Supabase and cached in Hive.

The combination of `cardType` and `questionType` determines exactly which
content nodes are present and how the quiz UI renders the card.

---

## Class Diagram

```
┌──────────────────────────────────────────────────────────────────────┐
│                           DeckCard                                   │
│  id                   : String                                       │
│  deckId               : String                                       │
│  cardType             : CardType       ← how many Notes are generated│
│  questionType         : QuestionType   ← which content nodes are used│
│  sortOrder            : int                                          │
│  createdAt            : DateTime                                     │
│  sourceCardId         : String?        ← non-null = copied from deck │
│  identificationAnswer : String         ← comma-sep answers (id only) │
│                                                                      │
│  ── content node lists (populated based on questionType) ──────────  │
│  notes    : List<Note>                    (most types)               │
│  options  : List<MultipleChoiceOption>    (multipleChoice only)      │
│  segments : List<FillInTheBlankSegment>   (fillInTheBlanks only)     │
│  pairs    : List<MatchMadnessPair>        (matchMadness only)        │
│                                                                      │
│  ── convenience getters ───────────────────────────────────────────  │
│  primaryNote                  : Note?       first Note where isReverse=false │
│  question                     : String      primaryNote.frontText            │
│  answer                       : String      primaryNote.backText (flashcard) │
│  questionImageUrl             : String?     primaryNote.frontImageUrl        │
│  answerImageUrl               : String?     primaryNote.backImageUrl         │
│  acceptedAnswers              : List<String> answer split on commas          │
│  acceptedIdentificationAnswers: List<String> identificationAnswer split      │
└──────────────────────────────────────────────────────────────────────┘
         │ 0..2          │ 0..*             │ 0..*          │ 0..*
         ▼               ▼                  ▼               ▼
      Note    MultipleChoiceOption  FillInTheBlankSegment  MatchMadnessPair


┌──────────────────┐   ┌──────────────────────────────────┐
│    CardType      │   │           QuestionType            │
│  (enum)          │   │  (enum)                           │
│                  │   │                                   │
│  normal          │   │  flashcard                        │
│  reversed        │   │  identification                   │
│  both            │   │  multipleChoice                   │
└──────────────────┘   │  fillInTheBlanks                  │
                       │  wordScramble                     │
                       │  matchMadness                     │
                       └──────────────────────────────────┘
```

---

## CardType — controls how many Notes are generated

| Value      | Notes generated      | Direction         | Allowed QuestionTypes |
|------------|----------------------|-------------------|-----------------------|
| `normal`   | 1 (`isReverse=false`) | front → back only | all                   |
| `reversed` | 1 (`isReverse=true`)  | back → front only | `flashcard` only      |
| `both`     | 2                    | both directions   | `flashcard` only      |

> **Why two Notes for `both`?** Rather than flipping a single card at runtime,
> `both` materialises two separate Note rows — one with `isReverse=false`
> (front→back) and one with `isReverse=true` (back→front). The quiz queue
> treats them as independent quiz items.

> **`reversed` vs `reversible` (legacy):** The old DB value was `'reversible'`.
> `CardType.fromString` still accepts it as an alias so migrated data works.

---

## QuestionType — determines the quiz interaction style

### `flashcard`
The default type. Shows `frontText`, the learner taps "Show Answer" and self-grades.
**No typing required.** Use `identification` when you want typing.

- **Content nodes used:** `notes` (1 or 2 depending on `cardType`)
- **CardType:** any (`normal` / `reversed` / `both`)
- **Answer checking:** `answer` field (= `primaryNote.backText`) split on
  commas → any token that matches the user's input case-insensitively is accepted.
  Example: `"dog, いぬ, inu"` accepts `"dog"`, `"いぬ"`, or `"inu"`.
  *(Note: answer checking for flashcard is kept for internal use but the quiz UI
  does not show a text input for this type.)*

### `identification`
Shows `frontText` as the prompt. The learner **must type** an answer.
After submitting, the result is revealed and the learner self-grades.

- **Content nodes used:** `notes` (1 note, `frontText` only) + `identificationAnswer`
- **CardType:** must be `normal`
- **Note.backText:** unused — always stored as `""`
- **Answer checking:** `identificationAnswer` (on `DeckCard`, comma-separated string)
  split → any token that matches the user's input case-insensitively is accepted.
- **Self-grade:** appears after the answer is revealed (same Again/Hard/Good/Easy flow).

### `multipleChoice`
Shows a prompt and a set of answer buttons.

- **Content nodes used:** `notes` (1 note, `frontText` = prompt, `backText` = optional hint)
  + `options` (the answer choices)
- **CardType:** must be `normal`
- **Answer checking:** `options` — exactly one `MultipleChoiceOption` has
  `isCorrect=true`; the user's selection is matched by `id` or `optionText`.

### `fillInTheBlanks`
Shows a sentence with one or more words hidden. The learner types each missing word.

- **Content nodes used:** `segments` (1+ entries)
- **CardType:** must be `normal`
- **Notes:** none (no Note rows generated)
- **How the blank works:** `fullText` stores the complete sentence;
  `blankStart`/`blankEnd` are character indices into it. The UI renders
  `displayText` (underscores replacing the blank span).
  Example: `fullText="The dog barked"`, `blankStart=4`, `blankEnd=7` → renders
  `"The ___ barked"`.
- **Answer checking:** `FillInTheBlankSegment.checkAnswer` — case-insensitive
  exact match against `correctAnswer`.
- **Multiple blanks:** add multiple `FillInTheBlankSegment` rows for the same card,
  each with its own sentence + indices. The quiz advances when all blanks are filled.

### `wordScramble`
Shows a set of shuffled word chips. The learner taps chips in the correct order
to reconstruct the original sentence. Visual feedback shows chips "snapping" into
the target area.

- **Content nodes used:** `notes` (1 note, `frontText` = the full sentence)
- **CardType:** must be `normal`
- **Note.backText:** unused — stored as `""`
- **Words:** derived at runtime by splitting `frontText` on spaces; punctuation
  stays attached to its word chip (e.g. `"barked."` is one chip).
- **Answer checking:** reconstructed string compared to `question` (= `frontText`)
  case-insensitively (exact word-order match required for now).

### `matchMadness`
A drag-and-drop game — the learner matches terms on the left to their counterparts on the right.

- **Content nodes used:** `pairs` only — **no Notes are generated**
- **CardType:** must be `normal`
- **Answer checking:** always returns `false` from `DeckCard.checkAnswer`;
  correctness is handled entirely by the game UI.
- **`isAutoPicked`:** when `true`, the pair was automatically sourced from another
  card in the deck (`sourceCardId` points to it). When `false`, manually authored.

---

## Content Node Summary Table

| QuestionType     | notes | options | segments | pairs | identificationAnswer? |
|------------------|-------|---------|----------|-------|-----------------------|
| flashcard        | 1–2   | —       | —        | —     | no                    |
| identification   | 1     | —       | —        | —     | **yes**               |
| multipleChoice   | 1     | 2+      | —        | —     | no                    |
| fillInTheBlanks  | —     | —       | 1+       | —     | no                    |
| wordScramble     | 1     | —       | —        | —     | no                    |
| matchMadness     | —     | —       | —        | 2+    | no                    |

> `notes` count for `flashcard` is 1 when `cardType=normal/reversed`,
> 2 when `cardType=both`.

---

## Constraints

```
cardType = reversed | both         →  questionType MUST be flashcard
questionType = matchMadness        →  notes list is ALWAYS empty
questionType = identification,
               multipleChoice,
               fillInTheBlanks,
               wordScramble,
               matchMadness        →  cardType MUST be normal

identificationAnswer non-empty     →  questionType MUST be identification
identificationAnswer empty/null    →  all other questionTypes
```

---

## Note fields

```
Note
  id             : String
  cardId         : String         FK → DeckCard.id
  frontText      : String         the prompt / term shown to the learner
  backText       : String         the answer / definition (flashcard + MC only)
                                  unused for identification, wordScramble
  frontAudioUrl  : String?        optional audio for the front side
  backAudioUrl   : String?        optional audio for the back side
  frontImageUrl  : String?        optional image for the front side
  backImageUrl   : String?        optional image for the back side
  isReverse      : bool           false = front→back, true = back→front
  createdAt      : DateTime
```

---

## MultipleChoiceOption fields

```
MultipleChoiceOption
  id           : String
  cardId       : String    FK → DeckCard.id
  optionText   : String    the displayed answer text
  isCorrect    : bool      exactly one option per card must be true
  displayOrder : int       controls render order (shuffle in UI if desired)
```

---

## FillInTheBlankSegment fields

```
FillInTheBlankSegment
  id            : String
  cardId        : String    FK → DeckCard.id
  fullText      : String    the complete sentence including the hidden word
  blankStart    : int       start index (inclusive) of the hidden span
  blankEnd      : int       end index (exclusive) of the hidden span
                            constraint: blankStart < blankEnd
  correctAnswer : String    expected text for this blank (case-insensitive)

  displayText   → fullText with [blankStart, blankEnd) replaced by underscores
  checkAnswer() → userAnswer.trim().toLowerCase() == correctAnswer (trimmed, lower)
```

---

## MatchMadnessPair fields

```
MatchMadnessPair
  id           : String
  cardId       : String     FK → DeckCard.id (the matchMadness card)
  sourceCardId : String?    FK → DeckCard.id of the card this pair was pulled from
                            null when manually created by the deck author
  term         : String     left-side item the learner sees
  match        : String     right-side item that pairs with term
  isAutoPicked : bool       true = auto-sourced from another card in the deck
  displayOrder : int        controls initial layout order
```

---

## DB column → Dart field mapping (DeckCard)

| DB column              | Dart field              | Notes                                    |
|------------------------|-------------------------|------------------------------------------|
| `id`                   | `id`                    |                                          |
| `deck_id`              | `deckId`                |                                          |
| `card_type`            | `cardType`              | `'reversible'` accepted as legacy alias  |
| `question_type`        | `questionType`          | `'read_and_select'` → `flashcard` (legacy) |
| `sort_order`           | `sortOrder`             |                                          |
| `created_at`           | `createdAt`             |                                          |
| `source_card_id`       | `sourceCardId`          | nullable; set on copied cards            |
| `identification_answer`| `identificationAnswer`  | NULL in DB → `''` in Dart; only set for identification |
| *(joined)*             | `notes`                 | key `'notes'` in Supabase join / cache JSON |
| *(joined)*             | `options`               | key `'mc_options'`                       |
| *(joined)*             | `segments`              | key `'fitb_segments'`                    |
| *(joined)*             | `pairs`                 | key `'mm_pairs'`                         |

---

## Removed / renamed since v1

| What was removed          | Replaced by                                                       |
|---------------------------|-------------------------------------------------------------------|
| `TypeAnswerMode` enum      | Replaced by `QuestionType.identification` (a dedicated type)     |
| `type_answer` DB column    | Deleted — no backwards compat needed (pre-production)            |
| `QuestionType.readAndComplete` | Merged into `fillInTheBlanks` (now supports 1+ blanks)       |
| `QuestionType.read_and_select` (DB) | Still accepted as legacy alias → maps to `flashcard`   |
