Research System — Current State

### What's already built and functional

**Backend/Data layer** — fully wired:
- `SupabaseResearchService` — all Supabase operations (code redeem, code insert, survey insert, vocab test insert, full data fetch)
- `ResearchProvider` — all business logic (generate codes, redeem codes, submit surveys, submit vocab tests, fetch dashboard data)
- Models: `ResearchCode`, `ResearchUser`, `SurveyResponse`, `VocabularyTestResult`

**Pages** — all exist and routed:
| Page | Route | Status |
|---|---|---|
| `ResearcherDashboardPage` | `/research` | ✅ Works |
| `ResearchCodeEntryPage` | `/research/code` | ✅ Works |
| `SurveyPage` | `/research/survey/:type?timePoint=` | ✅ Works (with 1 bug) |
| `VocabularyTestPage` | `/research/test/:set` | ✅ Works (placeholder data) |

**Group B guard** — implemented in `routes.dart`, redirects group_b_participant to `/research/code` for all non-allowed routes.

**Survey questions** — all 7 survey types fully written out in `survey_questions.dart` (proficiency screener, language interest, experience survey, preview usefulness, fsrs usefulness, ugc perception, SUS).

---

### What's broken or missing

**1. Bug: `proficiency_level` never submitted**
In `survey_page.dart:50-51`, there's this comment:
```dart
if (isProficiency && proficiencyLevel.value != null) {
  // proficiency_level goes through a separate key
}
```
The `ProficiencyLevelSelector` shows in the UI and collects a value, but it's never included in the `data` map sent to Supabase. The DB column `proficiency_level` will never be set.

**2. Vocabulary test items are all placeholder data**
`test_items.dart` generates 30 fake questions with "What is the meaning of word A-1?" — no actual Japanese vocabulary content. These need to be the real test questions for your study.

**3. No automatic navigation after code redemption**
After a participant redeems a code in `ResearchCodeEntryPage`, it shows "Unlocked: vocabulary_test_a" as text — but doesn't navigate them to `/research/survey/proficiency_screener` or `/research/test/A`. The user is stuck.

**4. Onboarding code flow not handled**
The Day 1 study flow requires an "onboarding code" that:
- Assigns the participant to Group A or B
- Sets their `target_language`
- Inserts a row into `research_users`
- Then triggers proficiency screener + language interest

Currently `redeemCode()` just marks the code as used. There's no handling of enrollment into `research_users`. The `addResearchUser()` method exists but is never called from code redemption.

**5. `ResearchCodeEntryPage` missing navigation after special unlock values**
After redeeming any code, nothing happens UI-side except showing the unlocked value as text.

---

### What needs to be done (priority order)

1. **Fix proficiency_level submission bug** — small fix in `survey_page.dart`
2. **Add post-redemption navigation** — router logic after `redeemCode()` returns (navigate to the correct survey/test based on `unlocks` value)
3. **Handle onboarding codes** — special code type that calls `addResearchUser()` and navigates to Day 1 flow
4. **Add real vocabulary test content** — populate `test_items.dart` with actual test questions
5. **`online_deck_browser_page.dart`** — currently commented out; likely not needed for the research system priority, can be left as-is

Want me to start with the fixes (items 1–3), or do you want to discuss the vocabulary test content first?
