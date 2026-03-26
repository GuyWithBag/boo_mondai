# BooMondai — AI Agent Research Summary

## What BooMondai Is
A web-based gamified language learning platform that combines user-generated quizzes, optional vocabulary preview, FSRS-based spaced repetition, leaderboards, streaks, and single-player or optional multiplayer quiz modes.

---

## Study Overview
**Type:** Quasi-experimental  
**Participants:** 40 total, 20 per group, randomly assigned  
**Duration:** 2–4 weeks  
**Location:** Davao City, Philippines  
**Languages:** Japanese, Chinese, or other foreign languages  

---

## Groups

| | Group A | Group B |
|---|---|---|
| Platform | BooMondai (full system) | Anki |
| Premade deck | ✅ Researcher-provided vocabulary set preloaded | ✅ Same vocabulary set in Anki |
| Learning materials | ✅ PDF provided | ✅ Same PDF provided |
| Preview | ✅ Optional pre-quiz deck view | ❌ Not available |
| Quiz | ✅ Gamified quiz session with FSRS self-rating | ❌ Card-by-card only |
| FSRS | ✅ Seeded from quiz self-ratings | ✅ Standard manual ratings |
| Gamification | ✅ Leaderboards, streaks | ❌ None |
| UGC | ✅ Fully enabled for additional decks only | ❌ Not available |
| Surveys & tests | ✅ Inside the app via researcher codes | ✅ Inside the app via researcher codes |

---

## Roles
- `group_a_participant` — uses BooMondai full system
- `group_b_participant` — uses Anki, accesses retention tests and surveys via researcher codes inside the app
- `researcher` — generates codes, manages study flow

---

## Study Flow

### Day 1 — Before anything else
1. Participant enters onboarding code provided by researcher
2. Assigned role (Group A or Group B) recorded in `research_users`
3. Completes **proficiency screener** → saved to `research_proficiency_screener`
4. Completes **language interest survey** → saved to `research_language_interest`
5. Group A begins using BooMondai with premade deck
6. Group B begins using Anki with premade deck

### Immediately after first session
1. Researcher provides code to unlock **vocabulary test Set A**
2. Participant enters code inside app
3. Completes 30-item vocabulary test → saved to `research_vocabulary_test` (test_set: A)
4. Completes **enjoyment, engagement, motivation Likert** (short-term) → saved to `research_experience_survey` (time_point: short_term)

### 2–4 weeks later (adjustable within code) — End of study
1. Researcher provides code to unlock **vocabulary test Set B**
2. Participant completes 30-item vocabulary test → saved to `research_vocabulary_test` (test_set: B)
3. Completes **enjoyment, engagement, motivation Likert** (long-term) → saved to `research_experience_survey` (time_point: long_term)
4. Researcher provides code to unlock **end of study surveys**
5. All participants complete **UGC perception survey** → saved to `research_ugc_perception`
6. Group A only completes:
   - **Preview usefulness** → `research_preview_usefulness`
   - **FSRS usefulness** → `research_fsrs_usefulness`
   - **System Usability Scale (SUS)** → `research_sus`

---

## Data the Agent Must Record

### research_users
- Links platform `user_id` to research study
- Records `role` and `target_language`
- Created by researcher with a Researcher/Admin view

### research_proficiency_screener
- Recorded once per participant on Day 1
- 6 Likert items (1–5) + 1 categorical proficiency level (none / beginner / elementary / intermediate / advanced)

### research_language_interest
- Recorded once per participant on Day 1
- 5 Likert items (1–5)

### research_vocabulary_test
- Recorded twice per participant (Set A and Set B)
- Score out of 30 + full answers as JSON
- Unlocked via researcher code

### research_experience_survey
- Recorded twice per participant (short_term and long_term)
- 15 Likert items total across 3 dimensions:
  - Enjoyment — 5 items
  - Engagement — 5 items
  - Motivation — 5 items

### research_preview_usefulness
- Recorded once — Group A only, end of study
- 5 Likert items (1–5)

### research_fsrs_usefulness
- Recorded once — Group A only, end of study
- 5 Likert items (1–5)

### research_ugc_perception
- Recorded once — both groups, end of study
- 6 Likert items (1–5)

### research_sus
- Recorded once — Group A only, end of study
- 10 Likert items (1–5)
- `sus_score` computed server-side: `((sum of odd items - 5) + (25 - sum of even items)) * 2.5`

### research_codes
- Created by researchers to unlock specific study flows
- Each code has a target role and unlocks one specific step
- Single use — recorded as used once a participant enters it

---

## Important Rules
- Vocabulary test **Set A and Set B have zero overlapping items**
- UGC decks created by Group A participants use **different vocabulary** from the test set — no contamination
- Proficiency screener and language interest are collected **before** participants see any study content
- Preview usefulness, FSRS usefulness, and SUS are **Group A only**
- UGC perception is **both groups**
- All research data is stored in `research_*` tables, separate from platform app data
- Group B participants only access the app for retention tests and surveys via researcher codes — they do not use BooMondai quiz or FSRS features
- `submitted_at` is recorded for every submission
- `UNIQUE` constraints prevent duplicate submissions