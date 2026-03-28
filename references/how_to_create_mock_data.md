# How to Generate Seed SQL for BooMondai

This document tells an AI (with zero codebase context) exactly how to generate a valid `supabase/seed.sql` file for the BooMondai Supabase PostgreSQL database. Read every section before writing a single row.

---

## What you are generating

A single PostgreSQL SQL file that:
- Seeds test users, decks, cards, quiz history, FSRS state, streaks, and research data
- Can be pasted into the Supabase SQL Editor and run in one shot
- Uses hard-coded UUIDs (not `gen_random_uuid()`) so the data is predictable and re-runnable
- Starts with `TRUNCATE ... CASCADE` to wipe existing seed data first

---

## Step 1 — Understand the Supabase auth layer

Supabase stores authenticated users in `auth.users`. The `profiles` table has a FK `id REFERENCES auth.users(id)`. You **must** insert into `auth.users` before inserting into `profiles`.

Use this minimal insert (Supabase only requires `id`, `email`, `encrypted_password`, `email_confirmed_at`):

```sql
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'researcher@test.com', '$2a$10$abcdefghijklmnopqrstuuVGBMnYnm8A3RKhXXVQjkNXBpQJJQywy', now(), now(), now()),
  ('00000000-0000-0000-0000-000000000002', 'alice@test.com',      '$2a$10$abcdefghijklmnopqrstuuVGBMnYnm8A3RKhXXVQjkNXBpQJJQywy', now(), now(), now()),
  ...
```

The `encrypted_password` value above is a valid bcrypt hash of `password123` — use it for all seed users.

---

## Step 2 — User roles

The `profiles.role` column has three valid values:

| Role | Purpose |
|---|---|
| `researcher` | Admin — can manage research codes, view all research data |
| `group_a_participant` | Study participant with gamified experience (quizzes, FSRS, leaderboard) |
| `group_b_participant` | Control group — only sees code entry and surveys, no gamification |

Seed at minimum: 1 researcher, 2+ group_a participants, 1+ group_b participant.

---

## Step 3 — Insert order (respect foreign keys)

Always insert in this exact order:

1. `auth.users`
2. `profiles`
3. `decks`
4. `deck_cards`
5. `notes`
6. `mc_options`
7. `fitb_segments`
8. `mm_pairs`
9. `quiz_sessions`
10. `quiz_answers`
11. `fsrs_cards`
12. `review_logs`
13. `streaks`
14. `research_users`
15. `research_codes`
16. Research survey/test tables (any order among themselves)

---

## Step 4 — Deck rules

```sql
INSERT INTO decks (id, creator_id, title, short_description, long_description,
                   target_language, tags, is_premade, is_public, is_uneditable,
                   hidden_in_browser, card_count, version, build_number,
                   is_published, created_at, updated_at)
```

Key constraints:
- `is_premade = true` → deck created by the researcher for the study
- `is_uneditable = true` → participants cannot edit or delete cards (used on premade decks)
- `hidden_in_browser = true` → deck does NOT appear in the public online browser
- `is_public = true` → deck is readable by any logged-in user (needed for participants to access premade decks)
- `is_published = true` → deck has been synced to be visible in the online browser
- `card_count` must equal the actual number of `deck_cards` rows you insert for that deck
- `tags` is a PostgreSQL text array: `'{jlpt-n5, animals}'::text[]` or `'{}'::text[]`
- `source_deck_id` — only set when this deck is a copy of another; otherwise omit or set NULL

---

## Step 5 — deck_cards: question types and their child records

Each `deck_cards` row has a `question_type`. The valid values and their required child rows are:

### `flashcard`
- 1 row in `notes` with `is_reverse = false`
- `front_text` = the term/prompt shown to the learner
- `back_text` = the answer revealed after the learner flips the card
- No rows in `mc_options`, `fitb_segments`, or `mm_pairs`
- Leave `identification_answer` NULL

```sql
-- deck_cards row
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, created_at)
VALUES ('card-uuid', 'deck-uuid', 'normal', 'flashcard', 0, now());

-- notes row
INSERT INTO notes (id, card_id, front_text, back_text, is_reverse, created_at)
VALUES ('note-uuid', 'card-uuid', '犬', 'dog', false, now());
```

If `card_type = 'both'`, add a second notes row with `is_reverse = true`, `front_text = back_text`, `back_text = front_text`.

### `identification`
- 1 row in `notes` (`front_text` = the prompt shown, `back_text` = '' is fine)
- `identification_answer` on the `deck_cards` row = comma-separated acceptable answers (case-insensitive match)
- No `mc_options`, `fitb_segments`, or `mm_pairs`

```sql
INSERT INTO deck_cards (id, deck_id, card_type, question_type, identification_answer, sort_order, created_at)
VALUES ('card-uuid', 'deck-uuid', 'normal', 'identification', 'dog, いぬ, inu', 0, now());

INSERT INTO notes (id, card_id, front_text, back_text, is_reverse, created_at)
VALUES ('note-uuid', 'card-uuid', '犬 means...?', '', false, now());
```

### `multiple_choice`
- 1 row in `notes` (`front_text` = the question prompt)
- 3–4 rows in `mc_options`: exactly **one** must have `is_correct = true`, the rest `false`
- `display_order` starts at 0
- No `fitb_segments` or `mm_pairs`

```sql
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, created_at)
VALUES ('card-uuid', 'deck-uuid', 'normal', 'multiple_choice', 0, now());

INSERT INTO notes (id, card_id, front_text, back_text, is_reverse, created_at)
VALUES ('note-uuid', 'card-uuid', 'What does 犬 mean?', '', false, now());

INSERT INTO mc_options (id, card_id, option_text, is_correct, display_order) VALUES
  ('opt-1-uuid', 'card-uuid', 'dog',  true,  0),
  ('opt-2-uuid', 'card-uuid', 'cat',  false, 1),
  ('opt-3-uuid', 'card-uuid', 'bird', false, 2),
  ('opt-4-uuid', 'card-uuid', 'fish', false, 3);
```

### `fill_in_the_blanks`
- **No** rows in `notes`
- 1+ rows in `fitb_segments` — one row per blank
- `full_text` = the complete sentence (same for all segments of the same card)
- `blank_start` and `blank_end` = character indices (0-based) into `full_text` for the hidden word
- `correct_answer` = the exact substring of `full_text` that the blank covers
- **Critical**: `blank_start < blank_end` (enforced by a CHECK constraint)
- Multiple blanks in one card = multiple rows all sharing the same `card_id` and `full_text`

Example: sentence "The dog is big", blank = "dog" (starts at index 4, ends at 7)

```sql
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, created_at)
VALUES ('card-uuid', 'deck-uuid', 'normal', 'fill_in_the_blanks', 0, now());

INSERT INTO fitb_segments (id, card_id, full_text, blank_start, blank_end, correct_answer)
VALUES ('seg-uuid', 'card-uuid', 'The dog is big', 4, 7, 'dog');
```

For two blanks ("The dog is big and the cat is small", blanks = "dog" and "cat"):

```sql
INSERT INTO fitb_segments (id, card_id, full_text, blank_start, blank_end, correct_answer) VALUES
  ('seg-1-uuid', 'card-uuid', 'The dog is big and the cat is small', 4,  7,  'dog'),
  ('seg-2-uuid', 'card-uuid', 'The dog is big and the cat is small', 23, 26, 'cat');
```

**How to compute character indices**: count from 0. 'T'=0, 'h'=1, 'e'=2, ' '=3, 'd'=4, 'o'=5, 'g'=6 → blank_start=4, blank_end=7 (end is exclusive — the character AT blank_end is NOT part of the blank).

### `word_scramble`
- 1 row in `notes`: `front_text` = the full sentence the learner must reconstruct by tapping word chips
- No `mc_options`, `fitb_segments`, or `mm_pairs`
- Leave `identification_answer` NULL

```sql
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, created_at)
VALUES ('card-uuid', 'deck-uuid', 'normal', 'word_scramble', 0, now());

INSERT INTO notes (id, card_id, front_text, back_text, is_reverse, created_at)
VALUES ('note-uuid', 'card-uuid', 'The dog runs fast', '', false, now());
```

### `match_madness`
- **No** rows in `notes`
- 4–8 rows in `mm_pairs`: each is a `term ↔ match` pair the learner must connect
- `is_auto_picked = false` for manually authored pairs
- `display_order` starts at 0

```sql
INSERT INTO deck_cards (id, deck_id, card_type, question_type, sort_order, created_at)
VALUES ('card-uuid', 'deck-uuid', 'normal', 'match_madness', 0, now());

INSERT INTO mm_pairs (id, card_id, term, match, is_auto_picked, display_order) VALUES
  ('pair-1', 'card-uuid', '犬', 'dog',  false, 0),
  ('pair-2', 'card-uuid', '猫', 'cat',  false, 1),
  ('pair-3', 'card-uuid', '鳥', 'bird', false, 2),
  ('pair-4', 'card-uuid', '魚', 'fish', false, 3);
```

---

## Step 6 — quiz_sessions and quiz_answers

```sql
INSERT INTO quiz_sessions (id, user_id, deck_id, previewed, total_questions,
                            correct_count, started_at, completed_at)
VALUES (
  'session-uuid',
  'user-uuid',
  'deck-uuid',
  true,           -- previewed: did user preview before quizzing?
  5,              -- total_questions: how many cards were in the queue
  4,              -- correct_count: how many were answered correctly
  '2026-03-20 09:00:00+00',
  '2026-03-20 09:10:00+00'  -- NULL if session was abandoned
);
```

For `quiz_answers`:
- `self_rating` is 1–4 (1=Again, 2=Hard, 3=Good, 4=Easy) — only set when `is_correct = true`
- For incorrect attempts, `self_rating` should be NULL

```sql
INSERT INTO quiz_answers (id, session_id, card_id, user_answer, is_correct, self_rating, answered_at)
VALUES
  ('ans-1', 'session-uuid', 'card-1-uuid', 'dog',  true,  3, '2026-03-20 09:01:00+00'),
  ('ans-2', 'session-uuid', 'card-2-uuid', 'neko', false, NULL, '2026-03-20 09:02:00+00');
```

---

## Step 7 — fsrs_cards

The `fsrs_cards` table tracks spaced-repetition state per user per card. Its `id` is a **text** field in the format `{user_id}_{card_id}` (the two UUIDs joined by an underscore).

```sql
INSERT INTO fsrs_cards (id, user_id, card_id, due, stability, difficulty,
                        elapsed_days, scheduled_days, reps, lapses, state,
                        last_review, updated_at)
VALUES (
  '00000000-0000-0000-0000-000000000002_00000000-0000-0000-0000-000000000020',
  '00000000-0000-0000-0000-000000000002',  -- user_id
  '00000000-0000-0000-0000-000000000020',  -- card_id
  '2026-03-29 09:00:00+00',  -- due: when this card is next due for review
  1.3,                       -- stability
  5.0,                       -- difficulty (1–10, typically starts ~5)
  1,                         -- elapsed_days
  1,                         -- scheduled_days
  1,                         -- reps: total review count
  0,                         -- lapses: how many times rated "Again"
  1,                         -- state: 0=new, 1=learning, 2=review, 3=relearning
  '2026-03-28 09:00:00+00',  -- last_review
  now()
);
```

For a newly enrolled card (after first quiz): `stability ≈ 1.3`, `difficulty ≈ 5.0`, `reps = 1`, `state = 1`.
For a well-reviewed card: `stability ≈ 10–30`, `reps = 5+`, `state = 2`.

---

## Step 8 — review_logs

One row per FSRS review event:

```sql
INSERT INTO review_logs (id, user_id, card_id, rating, scheduled_days,
                          elapsed_days, review, state, created_at)
VALUES (
  'log-uuid',
  'user-uuid',
  'card-uuid',
  3,                        -- rating: 1=Again 2=Hard 3=Good 4=Easy
  1,                        -- scheduled_days: how many days until next review
  0,                        -- elapsed_days: days since last review
  '2026-03-28 09:00:00+00', -- review timestamp
  1,                        -- state at time of review: 0=new 1=learning 2=review 3=relearning
  now()
);
```

---

## Step 9 — streaks

One row per user. `last_activity_date` is a `date` (not timestamp):

```sql
INSERT INTO streaks (id, user_id, current_streak, longest_streak, last_activity_date, updated_at)
VALUES
  ('streak-1-uuid', 'user-1-uuid', 7, 14, '2026-03-28', now()),
  ('streak-2-uuid', 'user-2-uuid', 0,  5, '2026-03-20', now());
```

---

## Step 10 — research tables

### research_users
```sql
INSERT INTO research_users (id, user_id, role, target_language, created_at)
VALUES ('ru-uuid', 'user-uuid', 'group_a_participant', 'japanese', now());
```

### research_codes
```sql
INSERT INTO research_codes (id, code, target_role, unlocks, created_by, used_by, used_at, created_at)
VALUES
  -- unused code
  ('rc-1-uuid', 'VOCAB-A-001', 'group_a_participant', 'vocabulary_test_a',
   'researcher-uuid', NULL, NULL, now()),
  -- already redeemed code
  ('rc-2-uuid', 'SURVEY-001', 'group_a_participant', 'experience_survey_short_term',
   'researcher-uuid', 'alice-uuid', '2026-03-25 10:00:00+00', now());
```

Valid `unlocks` values (the string must match exactly what the app checks):
- `vocabulary_test_a`
- `vocabulary_test_b`
- `experience_survey_short_term`
- `experience_survey_long_term`
- `proficiency_screener`
- `language_interest`
- `preview_usefulness`
- `fsrs_usefulness`
- `ugc_perception`
- `sus`

### research_proficiency_screener
6 items (1–5 each) + proficiency_level:
```sql
INSERT INTO research_proficiency_screener
  (id, user_id, item_1, item_2, item_3, item_4, item_5, item_6, proficiency_level, submitted_at)
VALUES ('rps-uuid', 'alice-uuid', 2, 2, 1, 1, 3, 4, 'beginner', now());
```
`proficiency_level` must be one of: `none`, `beginner`, `elementary`, `intermediate`, `advanced`

### research_language_interest
5 items (1–5 each):
```sql
INSERT INTO research_language_interest
  (id, user_id, item_1, item_2, item_3, item_4, item_5, submitted_at)
VALUES ('rli-uuid', 'alice-uuid', 4, 5, 4, 3, 5, now());
```

### research_vocabulary_test
```sql
INSERT INTO research_vocabulary_test (id, user_id, test_set, score, answers, submitted_at)
VALUES (
  'rvt-uuid', 'alice-uuid', 'A', 22,
  '{"q1":"A","q2":"C","q3":"B"}'::jsonb,
  now()
);
```
`test_set` must be `'A'` or `'B'`. `score` is 0–30.

### research_experience_survey
15 items across enjoyment (5), engagement (5), motivation (5). Has `time_point`:
```sql
INSERT INTO research_experience_survey
  (id, user_id, time_point,
   enjoyment_1, enjoyment_2, enjoyment_3, enjoyment_4, enjoyment_5,
   engagement_1, engagement_2, engagement_3, engagement_4, engagement_5,
   motivation_1, motivation_2, motivation_3, motivation_4, motivation_5,
   submitted_at)
VALUES
  ('res-uuid', 'alice-uuid', 'short_term',
   4, 5, 4, 4, 3,
   3, 4, 4, 5, 3,
   4, 4, 5, 3, 4,
   now());
```
`time_point` must be `'short_term'` or `'long_term'`. UNIQUE on `(user_id, time_point)`.

### research_preview_usefulness / research_fsrs_usefulness
5 items each (1–5):
```sql
INSERT INTO research_preview_usefulness
  (id, user_id, item_1, item_2, item_3, item_4, item_5, submitted_at)
VALUES ('rpu-uuid', 'alice-uuid', 4, 4, 3, 5, 4, now());
```

### research_ugc_perception
6 items (1–5):
```sql
INSERT INTO research_ugc_perception
  (id, user_id, item_1, item_2, item_3, item_4, item_5, item_6, submitted_at)
VALUES ('rug-uuid', 'alice-uuid', 3, 4, 4, 3, 5, 4, now());
```

### research_sus
10 items + computed `sus_score`:
```sql
INSERT INTO research_sus
  (id, user_id, item_1, item_2, item_3, item_4, item_5,
   item_6, item_7, item_8, item_9, item_10, sus_score, submitted_at)
VALUES (
  'rsus-uuid', 'alice-uuid',
  4, 2, 4, 1, 4, 2, 5, 1, 4, 2,
  72.5,  -- formula: ((sum_odd_items - 5) + (25 - sum_even_items)) * 2.5
  now()
);
```
SUS score formula:
- odd items = item_1 + item_3 + item_5 + item_7 + item_9
- even items = item_2 + item_4 + item_6 + item_8 + item_10
- `sus_score = ((odd_sum - 5) + (25 - even_sum)) * 2.5`
- Valid range: 0–100. Score ≥ 68 is considered acceptable usability.

---

## Step 11 — UUID strategy

Use sequential UUIDs with meaningful zeroed segments for readability. Suggested layout:

```
Users:
  00000000-0000-0000-0000-000000000001  → researcher
  00000000-0000-0000-0000-000000000002  → alice (group_a)
  00000000-0000-0000-0000-000000000003  → bob (group_a)
  00000000-0000-0000-0000-000000000004  → carol (group_b)

Decks:
  00000000-0000-0000-0000-000000000010  → premade JLPT N5 deck (researcher-owned)
  00000000-0000-0000-0000-000000000011  → alice's UGC deck
  00000000-0000-0000-0000-000000000012  → bob's UGC deck

Cards: 00000000-0000-0000-0000-0000000002XX  (XX = 00–99 per deck)
Notes: 00000000-0000-0000-0000-0000000003XX
MC options: 00000000-0000-0000-0000-0000000004XX
FITB segments: 00000000-0000-0000-0000-0000000005XX
MM pairs: 00000000-0000-0000-0000-0000000006XX
Quiz sessions: 00000000-0000-0000-0000-0000000007XX
Quiz answers: 00000000-0000-0000-0000-0000000008XX
FSRS cards: text PK format only (see Step 7)
Review logs: 00000000-0000-0000-0000-0000000009XX
Streaks: 00000000-0000-0000-0000-0000000010XX
Research UUIDs: 00000000-0000-0000-0000-000000005XXX
```

---

## Step 12 — File structure

The seed file must follow this structure:

```sql
-- ══════════════════════════════════════════════════════
-- BooMondai — Seed Data
-- Run AFTER schema.sql. Safe to re-run (truncates first).
-- ══════════════════════════════════════════════════════

-- ── Wipe existing seed data ────────────────────────────
-- Order matters: truncate children before parents.
TRUNCATE TABLE
  research_sus, research_ugc_perception, research_fsrs_usefulness,
  research_preview_usefulness, research_experience_survey,
  research_vocabulary_test, research_language_interest,
  research_proficiency_screener, research_codes, research_users,
  review_logs, fsrs_cards, quiz_answers, quiz_sessions,
  streaks, mm_pairs, fitb_segments, mc_options, notes,
  deck_cards, decks, profiles
CASCADE;

-- Note: auth.users cannot be truncated via SQL — manage test users
-- manually in the Supabase Auth dashboard or via the admin API.
-- The INSERT below uses ON CONFLICT DO NOTHING so it is re-run safe.

-- ── auth.users ─────────────────────────────────────────
INSERT INTO auth.users (...) VALUES (...) ON CONFLICT (id) DO NOTHING;

-- ── profiles ───────────────────────────────────────────
INSERT INTO profiles (...) VALUES (...);

-- ── decks ──────────────────────────────────────────────
INSERT INTO decks (...) VALUES (...);

-- ── deck_cards + child tables (grouped by deck) ────────
-- Insert all cards for deck 1, then all their notes/options/segments/pairs.
-- Then cards for deck 2, etc.

-- ── quiz data ──────────────────────────────────────────
INSERT INTO quiz_sessions (...) VALUES (...);
INSERT INTO quiz_answers  (...) VALUES (...);

-- ── FSRS state ─────────────────────────────────────────
INSERT INTO fsrs_cards  (...) VALUES (...);
INSERT INTO review_logs (...) VALUES (...);

-- ── streaks ────────────────────────────────────────────
INSERT INTO streaks (...) VALUES (...);

-- ── research ───────────────────────────────────────────
INSERT INTO research_users (...) VALUES (...);
INSERT INTO research_codes (...) VALUES (...);
-- survey/test inserts ...
```

---

## Step 13 — Minimum viable seed (what to generate by default)

Unless told otherwise, generate:

| Table | Minimum rows |
|---|---|
| Users | 1 researcher + 2 group_a + 1 group_b |
| Decks | 1 premade (is_premade=true, is_uneditable=true, is_public=true) with 20 cards + 1 UGC deck per group_a user |
| Cards in premade deck | 20 cards, mix of question types: ~8 flashcard, 3 identification, 3 multiple_choice, 2 fill_in_the_blanks, 2 word_scramble, 2 match_madness |
| Cards in UGC decks | 5 flashcard cards each |
| Quiz sessions | 2 completed sessions per group_a user |
| FSRS cards | 1 fsrs_cards row per card reviewed (at minimum, all premade deck cards for user alice) |
| Review logs | 1–2 review log entries per FSRS card |
| Streaks | 1 row per group_a user |
| Research codes | 3–4 codes: some unused, 1–2 redeemed |
| Research users | 1 row per group_a + group_b participant |

---

## Step 14 — Common mistakes to avoid

1. **Forgetting `card_count`**: Set it to the exact number of `deck_cards` rows for that deck.
2. **Wrong FITB indices**: Count characters starting at 0. End index is exclusive. The string `full_text[blank_start:blank_end]` must equal `correct_answer` exactly (same case).
3. **MC with no correct option**: Every multiple_choice card must have exactly one `mc_options` row where `is_correct = true`.
4. **fsrs_cards wrong PK format**: The `id` column is `'{user_id}_{card_id}'` — two UUIDs joined by underscore, not a UUID itself.
5. **Inserting profiles before auth.users**: Profiles has `id REFERENCES auth.users(id)`. auth.users must come first.
6. **match_madness with notes**: Don't insert `notes` rows for `match_madness` cards — they have no notes.
7. **fill_in_the_blanks with notes**: Don't insert `notes` rows for `fill_in_the_blanks` cards — they have no notes.
8. **`blank_start >= blank_end`**: The schema enforces `blank_start < blank_end`. Violating this causes an error.
9. **Wrong `tags` syntax**: PostgreSQL array literal must be `'{tag1,tag2}'` or `ARRAY['tag1','tag2']`, not a JSON array.
10. **`sus_score` wrong**: Apply formula `((odd_sum - 5) + (25 - even_sum)) * 2.5` — do not just sum all 10 items.
