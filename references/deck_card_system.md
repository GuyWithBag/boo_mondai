# BooMondai — DeckCard Generation Guide
> For AI systems generating card data (Gemini, Claude, GPT, etc.)
> Last updated: 2026-03-28

---

## What you are generating

You are generating **deck cards** for BooMondai, a gamified language learning app.
Each card belongs to a `deck` and has a `question_type` that determines how the
learner interacts with it.

Your output must be a **PostgreSQL seed file** — a sequence of `INSERT` statements
that can be pasted directly into the Supabase SQL editor or run via `psql`.

---

## Output format

Generate one block of SQL per card. Each block inserts into `deck_cards` first,
then into the appropriate child table(s). Use explicit UUID literals for all `id`
values so that parent–child foreign keys are consistent within the same script.

```sql
-- [sort_order]. [question prompt] ([question_type])
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, identification_answer)
VALUES ('<card-uuid>', '<deck_id>', '<card_type>', '<question_type>', <sort_order>, <identification_answer_or_NULL>);

-- child rows (notes / mc_options / fitb_segments / mm_pairs)
INSERT INTO notes (id, card_id, front_text, back_text, is_reverse)
VALUES ('<note-uuid>', '<card-uuid>', '<front>', '<back>', false);
```

**UUID format:** Use lowercase hyphenated UUIDs like `'a1b2c3d4-0000-0000-0000-000000000001'`.
Increment the last segment per card (`…0001`, `…0002`, etc.) so they are easy to read.
Note UUIDs can follow the same pattern offset by a range (e.g. notes start at `…1001`).

**Omit** `created_at` — the database defaults to `now()`.

**`deck_id`** is a placeholder. Replace `DECK_ID_HERE` with the real deck UUID before running.

---

## Question types

| Type              | Child table(s)                                   | CardType allowed         |
|-------------------|--------------------------------------------------|--------------------------|
| `flashcard`       | `notes` (1–2 rows)                               | normal / reversed / both |
| `identification`  | `notes` (1 row) + `identification_answer` column | normal only              |
| `multiple_choice` | `notes` (1 row) + `mc_options` rows              | normal only              |
| `fill_in_the_blanks` | `fitb_segments` rows (no notes)             | normal only              |
| `word_scramble`   | `notes` (1 row, front = full sentence)           | normal only              |
| `match_madness`   | `mm_pairs` rows (no notes)                       | normal only              |

---

## Type 1 — `flashcard`

The learner sees the front, reveals the back, and self-grades.

**Rules:**
- `identification_answer` → `NULL`
- One `notes` row with `is_reverse = false`
- For `card_type = 'both'`: add a second `notes` row with `is_reverse = true`
- `back_text` supports comma-separated answers (`'dog, いぬ, inu'`)

```sql
-- 0. 犬 (flashcard)
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, identification_answer)
VALUES ('a1b2c3d4-0000-0000-0000-000000000001', 'DECK_ID_HERE', 'normal', 'flashcard', 0, NULL);

INSERT INTO notes (id, card_id, front_text, back_text, is_reverse)
VALUES ('a1b2c3d4-0000-0000-0000-000001000001', 'a1b2c3d4-0000-0000-0000-000000000001', '犬', 'dog, いぬ, inu', false);
```

**Bidirectional (`card_type = 'both'`):**
```sql
-- 1. 猫 (flashcard, both directions)
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, identification_answer)
VALUES ('a1b2c3d4-0000-0000-0000-000000000002', 'DECK_ID_HERE', 'both', 'flashcard', 1, NULL);

INSERT INTO notes (id, card_id, front_text, back_text, is_reverse)
VALUES ('a1b2c3d4-0000-0000-0000-000001000002', 'a1b2c3d4-0000-0000-0000-000000000002', '猫', 'cat, ねこ, neko', false),
       ('a1b2c3d4-0000-0000-0000-000001000003', 'a1b2c3d4-0000-0000-0000-000000000002', 'cat', '猫 (ねこ)', true);
```

---

## Type 2 — `identification`

The learner sees the front prompt and must type a correct answer.

**Rules:**
- `card_type` must be `'normal'`
- One `notes` row — only `front_text` is meaningful; `back_text = ''`
- `identification_answer` is a comma-separated string of all accepted answers

```sql
-- 2. 犬 (identification)
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, identification_answer)
VALUES ('a1b2c3d4-0000-0000-0000-000000000003', 'DECK_ID_HERE', 'normal', 'identification', 2, 'dog, いぬ, inu');

INSERT INTO notes (id, card_id, front_text, back_text, is_reverse)
VALUES ('a1b2c3d4-0000-0000-0000-000001000004', 'a1b2c3d4-0000-0000-0000-000000000003', '犬', '', false);
```

---

## Type 3 — `multiple_choice`

The learner taps one of several answer choices.

**Rules:**
- `card_type` must be `'normal'`; `identification_answer` → `NULL`
- One `notes` row for the prompt (`front_text`); `back_text` is optional hint or `''`
- `mc_options`: exactly one row with `is_correct = true`; typically 3–4 options; `display_order` starts at 0

```sql
-- 3. 鳥 (multiple_choice)
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, identification_answer)
VALUES ('a1b2c3d4-0000-0000-0000-000000000004', 'DECK_ID_HERE', 'normal', 'multiple_choice', 3, NULL);

INSERT INTO notes (id, card_id, front_text, back_text, is_reverse)
VALUES ('a1b2c3d4-0000-0000-0000-000001000005', 'a1b2c3d4-0000-0000-0000-000000000004', 'What does 鳥 mean?', '', false);

INSERT INTO mc_options (id, card_id, option_text, is_correct, display_order)
VALUES ('a1b2c3d4-0000-0000-0000-000002000001', 'a1b2c3d4-0000-0000-0000-000000000004', 'bird',  true,  0),
       ('a1b2c3d4-0000-0000-0000-000002000002', 'a1b2c3d4-0000-0000-0000-000000000004', 'fish',  false, 1),
       ('a1b2c3d4-0000-0000-0000-000002000003', 'a1b2c3d4-0000-0000-0000-000000000004', 'horse', false, 2),
       ('a1b2c3d4-0000-0000-0000-000002000004', 'a1b2c3d4-0000-0000-0000-000000000004', 'tree',  false, 3);
```

---

## Type 4 — `fill_in_the_blanks`

The learner fills in one or more missing words in a sentence.

**Rules:**
- `card_type` must be `'normal'`; `identification_answer` → `NULL`
- **No `notes` rows** for this type
- Each `fitb_segments` row = one blank:
  - `full_text` — the complete sentence including the hidden word
  - `blank_start` / `blank_end` — 0-based character indices (exclusive end) of the hidden word
  - `correct_answer` — the text hidden at those indices (matching is case-insensitive, whitespace-trimmed)
- For multiple blanks: multiple rows, all pointing to the same `card_id`

**How to compute indices:**
```
full_text  = "犬 means dog in English"
              0123456789...
The word "dog" starts at index 9, ends at 12 (9 + 3)
blank_start = 9, blank_end = 12
```
Note: each Unicode character (including CJK like 犬) counts as 1 character in Dart strings.

```sql
-- 4. Fill in the blank — single blank
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, identification_answer)
VALUES ('a1b2c3d4-0000-0000-0000-000000000005', 'DECK_ID_HERE', 'normal', 'fill_in_the_blanks', 4, NULL);

INSERT INTO fitb_segments (id, card_id, full_text, blank_start, blank_end, correct_answer)
VALUES ('a1b2c3d4-0000-0000-0000-000003000001', 'a1b2c3d4-0000-0000-0000-000000000005',
        '犬 means dog in English', 9, 12, 'dog');
```

```sql
-- 5. Fill in the blank — two blanks (same sentence)
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, identification_answer)
VALUES ('a1b2c3d4-0000-0000-0000-000000000006', 'DECK_ID_HERE', 'normal', 'fill_in_the_blanks', 5, NULL);

INSERT INTO fitb_segments (id, card_id, full_text, blank_start, blank_end, correct_answer)
VALUES ('a1b2c3d4-0000-0000-0000-000003000002', 'a1b2c3d4-0000-0000-0000-000000000006',
        '犬 means dog and 猫 means cat', 9, 12, 'dog'),
       ('a1b2c3d4-0000-0000-0000-000003000003', 'a1b2c3d4-0000-0000-0000-000000000006',
        '犬 means dog and 猫 means cat', 24, 27, 'cat');
```

---

## Type 5 — `word_scramble`

Shuffled word chips — learner taps them in the correct order.

**Rules:**
- `card_type` must be `'normal'`; `identification_answer` → `NULL`
- One `notes` row — `front_text` = the complete correct sentence; `back_text = ''`
- Words split on spaces at runtime; punctuation stays attached to its word
- Avoid sentences shorter than 3 words or longer than 12 words

```sql
-- 6. Word scramble
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, identification_answer)
VALUES ('a1b2c3d4-0000-0000-0000-000000000007', 'DECK_ID_HERE', 'normal', 'word_scramble', 6, NULL);

INSERT INTO notes (id, card_id, front_text, back_text, is_reverse)
VALUES ('a1b2c3d4-0000-0000-0000-000001000006', 'a1b2c3d4-0000-0000-0000-000000000007',
        'The dog barked at the cat', '', false);
```

---

## Type 6 — `match_madness`

Drag-and-match game — learner connects terms with their pairs.

**Rules:**
- `card_type` must be `'normal'`; `identification_answer` → `NULL`
- **No `notes` rows** for this type
- `mm_pairs`: at least 2 entries (typically 4–6); `is_auto_picked = false`; `display_order` starts at 0
- `source_card_id` → `NULL` for manually authored pairs

```sql
-- 7. Match madness
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, identification_answer)
VALUES ('a1b2c3d4-0000-0000-0000-000000000008', 'DECK_ID_HERE', 'normal', 'match_madness', 7, NULL);

INSERT INTO mm_pairs (id, card_id, source_card_id, term, match, is_auto_picked, display_order)
VALUES ('a1b2c3d4-0000-0000-0000-000004000001', 'a1b2c3d4-0000-0000-0000-000000000008', NULL, '犬', 'dog',    false, 0),
       ('a1b2c3d4-0000-0000-0000-000004000002', 'a1b2c3d4-0000-0000-0000-000000000008', NULL, '猫', 'cat',    false, 1),
       ('a1b2c3d4-0000-0000-0000-000004000003', 'a1b2c3d4-0000-0000-0000-000000000008', NULL, '鳥', 'bird',   false, 2),
       ('a1b2c3d4-0000-0000-0000-000004000004', 'a1b2c3d4-0000-0000-0000-000000000008', NULL, '魚', 'fish',   false, 3),
       ('a1b2c3d4-0000-0000-0000-000004000005', 'a1b2c3d4-0000-0000-0000-000000000008', NULL, '花', 'flower', false, 4);
```

---

## Constraints checklist

Before returning your SQL, verify each card:

- [ ] `question_type` is one of: `flashcard`, `identification`, `multiple_choice`,
      `fill_in_the_blanks`, `word_scramble`, `match_madness`
- [ ] `card_type` is `'both'` or `'reversed'` only for `flashcard`; `'normal'` for all others
- [ ] `identification_answer` is a non-empty quoted string only for `identification`; `NULL` elsewhere
- [ ] No `notes` inserts for `fill_in_the_blanks` or `match_madness`
- [ ] `notes` has exactly one row for `identification`, `multiple_choice`, `word_scramble`
- [ ] `mc_options` has exactly one row with `is_correct = true`
- [ ] `fitb_segments`: `blank_start < blank_end`; the text at those indices in `full_text`
      matches `correct_answer` (case-insensitive)
- [ ] `mm_pairs` has at least 2 rows; `source_card_id = NULL` for manual pairs
- [ ] `sort_order` is unique within the deck and starts at 0
- [ ] Every UUID used as a `card_id` FK exactly matches an `id` inserted into `deck_cards`
- [ ] All UUIDs are unique across the entire output
- [ ] `DECK_ID_HERE` appears in every `deck_cards` insert (not replaced — leave it as a literal placeholder)

---

## Prompt template

Use this template when asking an AI to generate cards:

```
You are generating a PostgreSQL seed file for BooMondai, a language learning app.
Read the generation guide at references/deck_card_system.md before starting.

Deck topic: [describe the topic, e.g. "JLPT N5 animals vocabulary"]
Target language: Japanese
Native language: English
Number of cards: 20
Question types to include: [e.g. "flashcard (10), multiple_choice (4), fill_in_the_blanks (3), match_madness (1 card with 5 pairs), word_scramble (2)"]

Output a PostgreSQL seed file only — no markdown explanation, no JSON.
Use the UUID pattern from the guide (increment last segment per card).
Leave deck_id as the literal placeholder DECK_ID_HERE.
Follow the constraints checklist before returning.
```
