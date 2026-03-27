# BooMondai — App Guide

## What is BooMondai?

BooMondai (問題) is a gamified Japanese vocabulary learning app. It also doubles as a **capstone research instrument** — the app is used in a controlled study comparing two groups of learners.

---

## The Research Study (Why This App Is More Complex Than a Normal App)

This app is built for an academic study with a **quasi-experimental design**. That means:

- **Group A** uses the full app — quizzes, FSRS spaced repetition, deck creation. They experience the "treatment."
- **Group B** is the control group. They only take surveys and vocabulary tests. They never touch the quiz or deck features.

The researcher needs to measure both groups at specific points in time (e.g., before, during, and after the study period). The measurement tools are surveys and vocabulary tests built into the app.

---

## User Roles

| Role | What they see |
|---|---|
| `group_a_participant` | Full app — Home, Decks, Review, Leaderboard, Account tabs. Can enter research codes to unlock surveys/tests when the researcher tells them to. |
| `group_b_participant` | Only a code entry screen. No quiz, no decks. They only interact with the app when the researcher hands them a code. |
| `researcher` | Everything Group A sees, plus a **Research Dashboard** button on the Home screen. |

When a user signs up normally, they become `group_a_participant` by default. To make someone a researcher:

```sql
UPDATE profiles SET role = 'researcher' WHERE email = 'researcher@test.com';
```

---

## What is a Researcher Code?

A **researcher code** is a short token like `VOCAB-A-001` that the researcher gives to a participant (verbally or by email) to unlock one specific survey or test **at the right moment in the study**.

### Why codes instead of just opening the survey directly?

Because the researcher needs to control **timing**. For example:

- Week 0 → give `PROF-001` (proficiency screener) to everyone
- Week 2 → give `EXP-SHORT-001` only to Group A
- Week 4 → give `VOCAB-A-001` to Group A, `VOCAB-B-001` to Group B
- Week 8 → give `SUS-001` only to Group A

Without codes, participants could open any survey at any time and mess up the data.

### How the code flow works

1. **Researcher** opens the Research Dashboard → Codes tab → fills in the form → clicks Generate. A unique code string is created in the database.
2. **Researcher** copies that code and sends it to the participant (verbally, email, etc.).
3. **Participant** opens the app → Account tab → "Enter Research Code" (or the home screen if Group B) → types the code → taps Redeem.
4. The app validates the code, marks it as used, then immediately navigates the participant to the unlocked survey or test. The code cannot be reused.

### What a code can unlock

| `unlocks` value | What it opens |
|---|---|
| `proficiency_screener` | 6-question language proficiency survey |
| `language_interest` | 5-question language interest survey |
| `vocabulary_test_a` | 30-item multiple-choice vocabulary test (Set A) |
| `vocabulary_test_b` | 30-item multiple-choice vocabulary test (Set B) |
| `experience_survey_short_term` | 15-item enjoyment/engagement/motivation survey (short-term) |
| `experience_survey_long_term` | Same survey at a later time point |
| `preview_usefulness` | 5-item survey about vocabulary preview usefulness (Group A only) |
| `fsrs_usefulness` | 5-item survey about spaced repetition usefulness (Group A only) |
| `ugc_perception` | 6-item survey about user-generated content (both groups) |
| `sus` | 10-item System Usability Scale (Group A only) |

---

## Researcher Dashboard — The Three Tabs

Access: Home screen → "Research Dashboard" button (only visible when your role is `researcher`).

### Codes tab

This is where you **generate codes**. One code = one participant can unlock one survey/test once.

- **Target Role** — which group this code is for (`group_a_participant` or `group_b_participant`). The app checks this matches the participant's role when they redeem.
- **Unlocks** — which survey/test to open (see table above).
- Click **Generate** → a unique code string is created and appears in the list below.
- Codes show "Available" until redeemed, then "Used".

### Participants tab

Shows everyone in the `research_users` table — the people formally enrolled in the study. Displays their **display name** (from their profile) and a shortened user ID, plus their group role and target language.

### Results tab

Shows graphs and statistics across all collected instruments:

| Section | What it shows |
|---|---|
| **Completion Overview** | How many participants have submitted each instrument (horizontal bar per row) |
| **Vocab Test Set A / Set B** | Average score bar + score distribution histogram (buckets 0–9, 10–19, 20–24, 25–29, 30) |
| **Experience Survey ST / LT** | Subscale averages for Enjoyment, Engagement, and Motivation (1–5 scale) |
| **SUS** | Average System Usability Score with colour-coded rating (Poor / OK / Good / Excellent) |
| **Preview / FSRS / UGC surveys** | Per-item Likert averages (Item 1 … n) |

All sections render their structure even when there are no submissions yet, so you can see what data will appear.

---

## Navigation

### Bottom nav (mobile)

| Tab | Route | Auth required |
|---|---|---|
| Home | `/` | No |
| Decks | `/decks` | Yes (grayed out when signed out) |
| Review | `/review` | Yes |
| Leaderboard | `/leaderboard` | Yes |
| Account | `/account` | No |

### How to get to pages with a back button

- Tapping a deck card → opens Deck Detail (back returns to Decks tab)
- Deck Detail → Edit / Add Card / Preview / Quiz → back returns to Deck Detail
- Account → Sign In / Create Account → back returns to Account
- Home → Research Dashboard → back returns to Home
- Account → Enter Research Code → back returns to Account

### Group B experience

Group B participants see only a code entry screen instead of the normal Home page. They have no Decks, Review, or Leaderboard tabs — only Account.

### Desktop / Web

A NavigationRail is shown on the left instead of the bottom bar.

---

## Step-by-Step Flows

### As a new Group A participant

1. Open app → Account tab → **Create Account**
2. Sign up with email and password
3. Go to **Decks** tab → tap a deck
4. Choose **Preview** (see cards first) or **Start Quiz** directly
5. During the quiz, type your answer. After a correct answer, self-rate: Again / Hard / Good / Easy
6. After the quiz, cards are scheduled with FSRS spaced repetition
7. Come back daily to the **Review** tab to do your due reviews
8. When the researcher gives you a code → Account tab → **Enter Research Code** → type it in

### As a Group B participant

1. Open app → Account tab → **Create Account**
2. You only see a code entry screen
3. Wait for the researcher to give you a code
4. Type the code in → you'll be taken directly to the survey or test
5. Complete it → done until the researcher gives you another code

### As a researcher

1. Sign up, then get your role changed to `researcher` in Supabase (see above)
2. You see the normal app plus a **Research Dashboard** button on the Home screen
3. Tap it → go to the **Codes** tab
4. Fill in Target Role + Unlocks → Generate → copy the code string
5. Send the code to your participant
6. Check the **Results** tab later to see submitted test scores

---

## Supabase Setup

### First-time setup

1. Run `supabase/schema.sql` in the SQL Editor
2. Create test users via **Authentication → Users → Add user** (use `researcher@test.com`, `alice@test.com`, `bob@test.com`, `carol@test.com` with password `password123`)
3. Copy the UUIDs Supabase assigns and fill them into `supabase/seed.sql`
4. Run `supabase/seed.sql` to populate profiles, decks, cards, streaks, and sample codes

### Useful queries

```sql
-- See all users and their roles
SELECT id, email, display_name, role FROM profiles;

-- See all research codes and their status
SELECT code, target_role, unlocks, used_by, used_at FROM research_codes;

-- Promote a user to researcher
UPDATE profiles SET role = 'researcher' WHERE email = 'your@email.com';

-- Reset a code so it can be reused (dev only)
UPDATE research_codes SET used_by = NULL, used_at = NULL WHERE code = 'VOCAB-A-001';

-- See all vocabulary test results
SELECT user_id, test_set, score, submitted_at FROM research_vocabulary_test;

-- See all quiz sessions
SELECT qs.id, p.email, d.title, qs.correct_count, qs.total_questions, qs.completed_at
FROM quiz_sessions qs
JOIN profiles p ON p.id = qs.user_id
JOIN decks d ON d.id = qs.deck_id;
```
