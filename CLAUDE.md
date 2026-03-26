# ZED FLUTTER PROJECT CONTEXT
# ══════════════════════════════════════════════════════
# Paste this entire file into Zed as your project context.
# Claude in Zed will use this as the source of truth for
# all code generation in this project.
# ══════════════════════════════════════════════════════

## IDENTITY & RULES

You are an elite Flutter engineer working on BooMondai.
You write cross-platform Flutter code for Mobile, Web, and Desktop.
You use Provider (ChangeNotifier) for shared state and Flutter Hooks for
local UI state exclusively. You never use StatefulWidget.
You never write a single widget over 100 lines — extract aggressively.
You use native Flutter APIs before reaching for packages.
You follow the spec in this file as the single source of truth.
When something is ambiguous, you ask before assuming.

## NATIVE FIRST POLICY

Before using any package, check if Flutter provides this natively:
- Animations → AnimationController, Tween, CurvedAnimation, Hero
- Custom UI → CustomPainter, ClipPath, ShaderMask
- Forms → Form, TextFormField, GlobalKey<FormState>
- Layout → LayoutBuilder, MediaQuery, Sliver widgets
- Gestures → GestureDetector, Draggable, Dismissible
- Focus → FocusNode, FocusScope, Shortcuts + Actions

Default packages (always available — use these, do not reinvent them):
- Navigation → go_router 17.0.1 (declarative, deep link, web URL support)
- Local storage → hive_ce 2.19.3 + hive_ce_flutter 2.3.4 (via HiveService; use @GenerateAdapters + AdapterSpec, never @HiveType/@HiveField)
- Loading skeletons → skeletonizer 2.1.3 (wrap existing widgets, no hand-written skeletons)
- Pickers → flutter_picker_plus 1.5.6 (dates, lists, multi-column wheel pickers)
- Color picking → flutter_colorpicker 1.1.0
- File picking → file_picker 10.3.10
- Notifications → flutter_local_notifications ^21.0.0
- External links → url_launcher ^6.3.2
- Responsive sizing → flutter_screenutil ^5.9.3 (use .sp, .w, .h, .r — never hardcode px)
- Backend/auth/db → supabase_flutter ^2.12.2 (Supabase.instance.client — wrap in SupabaseService)
- Barrel exports → barrel_annotation 1.0.0 + barrel_generator ^1.0.4
- Testing mocks → mockito ^5.4.4 (use @GenerateMocks + build_runner)
- FSRS → fsrs ^1.1.0 (spaced repetition algorithm — wrap in FsrsService)
- UUIDs → uuid ^4.5.1 (generate client-side UUIDs for offline-first)

## CODE STYLE

- const constructors everywhere possible
- All providers documented with /// dartdoc
- All models implement copyWith(), ==, hashCode, toString()
- Every async provider method has _isLoading and _error state
- Every screen handles: loading state, error state, empty state
- Never use dynamic — always fully typed
- Widgets stay under 100 lines — extract into named widgets
- No business logic inside build() — it belongs in providers

WIDGET DECOMPOSITION RULES — READ CAREFULLY:
- NEVER use _buildSomething() private methods to split up a widget
- NEVER use _buildHeader(), _buildBody(), _buildFooter(), or any variant
- Instead, ALWAYS extract into a separate named class:
    ✗ Widget _buildUserCard() => Card(...)
    ✓ class UserCard extends StatelessWidget { ... }
- Every extracted widget lives in its own file if it is reusable,
  or at the bottom of the same file if it is screen-local
- This rule is absolute — no exceptions, no matter how small the widget

UNIT TEST RULES:
- Every ChangeNotifier class has a corresponding _test.dart file
- Every service class has a corresponding _test.dart file
- Every screen and reusable widget has a widget test
- Tests live in test/ mirroring the lib/ structure
- Use fake/mock dependencies — never real I/O, network, or Hive in tests
- Each test is fully isolated — no shared state between tests
- When generating a class, always generate its test file too
- Test names follow: '[method] [scenario] [expected outcome]'

## FILE HEADER FORMAT

Every file you generate must start with:
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/[path/to/file.dart]
// PURPOSE: [one sentence]
// PROVIDERS: [comma-separated list or 'none']
// HOOKS: [comma-separated list or 'none']
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## PLATFORM RULES

Desktop:
- NavigationRail with extended labels or custom sidebar
- Tooltip on every interactive element
- Right-click context menus via ContextMenuRegion where useful
- Keyboard shortcuts via Shortcuts + Actions widgets
- Multi-panel layouts using Row + VerticalDivider + Expanded

Web:
- SelectableText for any text the user may want to copy
- MouseRegion for hover effects on interactive elements
- URL-reflective navigation
- Max content width container centered on wide screens
- Keyboard shortcut support

Mobile:
- NavigationBar (Material 3) or CupertinoTabBar
- BottomSheet for contextual actions
- SafeArea on all screens
- Pull-to-refresh with RefreshIndicator
- Swipe-to-dismiss on list items where appropriate

Responsive breakpoints (from lib/shared/breakpoints.dart):
- mobile < 600
- tablet 600–1024
- desktop > 1024
Always use LayoutBuilder — never raw MediaQuery.size comparisons inline.

## PROJECT SPEC

### SECTION 1 — PROJECT OVERVIEW

- App name: BooMondai (問題)
- Purpose: Gamified language learning platform with FSRS spaced repetition, user-generated quizzes, and built-in research instrumentation for a quasi-experimental capstone study.
- Target platforms: Mobile (iOS + Android), Web, Desktop (Windows/macOS/Linux)

Core user stories:
- As a Group A participant, I want to take a gamified quiz on a premade vocabulary deck so that I learn new words effectively.
- As a Group A participant, I want to preview vocabulary before quizzing so that I can prime my memory.
- As a learner, I want my quiz results to seed an FSRS review schedule so that I retain words long-term via spaced repetition.
- As a learner, I want to create my own decks and share them so that I can study additional vocabulary.
- As a participant (A or B), I want to enter a researcher code so that I can unlock and complete required surveys and vocabulary tests.
- As a researcher, I want to generate codes, add users to the study, and view all collected data so that I can run the experiment.
- As a learner, I want to see leaderboards and my streak so that I stay motivated.

v1.0 scope — explicitly OUT:
- Multiplayer / real-time WebSocket quiz sessions
- Audio/pronunciation features
- Chat or social features
- Push notifications to external devices (local notifications only)
- Anki import/export
- AI-generated content
- Payment / premium tiers

### SECTION 2 — FOLDER STRUCTURE

```
lib/
├── providers/
│   ├── auth_provider.dart
│   ├── deck_provider.dart
│   ├── card_provider.dart
│   ├── quiz_provider.dart
│   ├── fsrs_provider.dart
│   ├── leaderboard_provider.dart
│   ├── streak_provider.dart
│   └── research_provider.dart
├── controllers/
│   └── quiz_queue_controller.dart
├── services/
│   ├── supabase_service.dart
│   ├── hive_service.dart
│   ├── fsrs_service.dart
│   └── notification_service.dart
├── models/
│   ├── user_profile.dart
│   ├── deck.dart
│   ├── deck_card.dart
│   ├── quiz_session.dart
│   ├── quiz_answer.dart
│   ├── fsrs_card_state.dart
│   ├── review_log_entry.dart
│   ├── leaderboard_entry.dart
│   ├── streak.dart
│   ├── research_code.dart
│   ├── research_user.dart
│   ├── survey_response.dart
│   ├── vocabulary_test_result.dart
│   └── adapters.dart
├── painters/
│   └── streak_flame_painter.dart
├── widgets/
│   ├── responsive_scaffold.dart
│   ├── deck_card_widget.dart
│   ├── quiz_question_card.dart
│   ├── self_rating_bottom_sheet.dart
│   ├── likert_scale_widget.dart
│   ├── streak_badge.dart
│   ├── leaderboard_tile.dart
│   └── empty_state_widget.dart
├── pages/
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── home_page.dart
│   ├── deck_list_page.dart
│   ├── deck_detail_page.dart
│   ├── deck_creator_page.dart
│   ├── card_editor_page.dart
│   ├── quiz_preview_page.dart
│   ├── quiz_session_page.dart
│   ├── quiz_result_page.dart
│   ├── review_page.dart
│   ├── leaderboard_page.dart
│   ├── account_page.dart
│   ├── researcher_dashboard_page.dart
│   ├── research_code_entry_page.dart
│   ├── survey_page.dart
│   └── vocabulary_test_page.dart
├── shared/
│   ├── theme_constants.dart
│   ├── main_theme.dart
│   ├── env.dart
│   ├── breakpoints.dart
│   ├── app_spacing.dart
│   └── app_typography.dart
├── app.dart
├── routes.dart
└── main.dart

test/
├── providers/
│   ├── auth_provider_test.dart
│   ├── deck_provider_test.dart
│   ├── card_provider_test.dart
│   ├── quiz_provider_test.dart
│   ├── fsrs_provider_test.dart
│   ├── leaderboard_provider_test.dart
│   ├── streak_provider_test.dart
│   └── research_provider_test.dart
├── controllers/
│   └── quiz_queue_controller_test.dart
├── services/
│   ├── supabase_service_test.dart
│   ├── hive_service_test.dart
│   ├── fsrs_service_test.dart
│   └── notification_service_test.dart
├── widgets/
│   ├── responsive_scaffold_test.dart
│   ├── deck_card_widget_test.dart
│   ├── quiz_question_card_test.dart
│   ├── self_rating_bottom_sheet_test.dart
│   ├── likert_scale_widget_test.dart
│   ├── streak_badge_test.dart
│   ├── leaderboard_tile_test.dart
│   └── empty_state_widget_test.dart
├── pages/
│   ├── login_page_test.dart
│   ├── home_page_test.dart
│   ├── deck_list_page_test.dart
│   ├── quiz_session_page_test.dart
│   ├── review_page_test.dart
│   ├── researcher_dashboard_page_test.dart
│   ├── survey_page_test.dart
│   └── vocabulary_test_page_test.dart
└── helpers/
    ├── fake_deck.dart
    ├── fake_deck_card.dart
    ├── fake_user_profile.dart
    ├── fake_quiz_session.dart
    ├── fake_fsrs_card_state.dart
    ├── mock_supabase_service.dart
    ├── mock_hive_service.dart
    ├── mock_fsrs_service.dart
    └── pump_app.dart
```

### SECTION 3 — DATA LAYER MAP

```
Model: UserProfile
Fields:
  - id (String, non-null) — Supabase auth.users UUID
  - email (String, non-null)
  - displayName (String, non-null)
  - role (String, non-null) — 'group_a_participant' | 'group_b_participant' | 'researcher'
  - avatarUrl (String?, nullable)
  - targetLanguage (String?, nullable)
  - createdAt (DateTime, non-null)
Source: Supabase profiles table + local Hive cache
Serialization: fromJson/toJson + hive_ce @GenerateAdapters
Relationships: has many Deck, has many QuizSession, has one Streak
```

```
Model: Deck
Fields:
  - id (String, non-null) — UUID
  - creatorId (String, non-null) — FK to profiles
  - title (String, non-null)
  - description (String, non-null, default '')
  - targetLanguage (String, non-null)
  - isPremade (bool, non-null, default false)
  - isPublic (bool, non-null, default true)
  - cardCount (int, non-null, default 0)
  - createdAt (DateTime, non-null)
  - updatedAt (DateTime, non-null)
Source: Supabase decks table + local Hive cache
Serialization: fromJson/toJson + hive_ce @GenerateAdapters
Relationships: belongs to UserProfile, has many DeckCard
```

```
Model: DeckCard
Fields:
  - id (String, non-null) — UUID
  - deckId (String, non-null) — FK to decks
  - question (String, non-null) — the term / prompt
  - answer (String, non-null) — comma-separated accepted answers (any match = correct, case-insensitive)
  - questionImageUrl (String?, nullable)
  - answerImageUrl (String?, nullable)
  - sortOrder (int, non-null)
  - createdAt (DateTime, non-null)
Source: Supabase deck_cards table + local Hive cache
Serialization: fromJson/toJson + hive_ce @GenerateAdapters
Relationships: belongs to Deck
Notes: Multiple accepted answers stored as comma-separated string. Matching logic: split on comma, trim whitespace, compare case-insensitive. Example: "dog, いぬ, inu" accepts any of the three.
```

```
Model: QuizSession
Fields:
  - id (String, non-null) — UUID
  - userId (String, non-null)
  - deckId (String, non-null)
  - previewed (bool, non-null) — whether user chose to preview first
  - totalQuestions (int, non-null)
  - correctCount (int, non-null)
  - startedAt (DateTime, non-null)
  - completedAt (DateTime?, nullable)
Source: Supabase quiz_sessions table + local Hive cache
Serialization: fromJson/toJson + hive_ce @GenerateAdapters
Relationships: belongs to UserProfile, belongs to Deck, has many QuizAnswer
```

```
Model: QuizAnswer
Fields:
  - id (String, non-null) — UUID
  - sessionId (String, non-null)
  - cardId (String, non-null)
  - userAnswer (String, non-null)
  - isCorrect (bool, non-null)
  - selfRating (int?, nullable) — 1=Again, 2=Hard, 3=Good, 4=Easy; null if incorrect final attempt
  - answeredAt (DateTime, non-null)
Source: Supabase quiz_answers table + local Hive cache
Serialization: fromJson/toJson + hive_ce @GenerateAdapters
Relationships: belongs to QuizSession, belongs to DeckCard
```

```
Model: FsrsCardState
Fields:
  - id (String, non-null) — composite key: "{userId}_{cardId}"
  - userId (String, non-null)
  - cardId (String, non-null)
  - due (DateTime, non-null)
  - stability (double, non-null)
  - difficulty (double, non-null)
  - elapsedDays (int, non-null)
  - scheduledDays (int, non-null)
  - reps (int, non-null)
  - lapses (int, non-null)
  - state (int, non-null) — 0=new, 1=learning, 2=review, 3=relearning
  - lastReview (DateTime?, nullable)
Source: Local Hive (primary) + Supabase fsrs_cards (sync)
Serialization: hive_ce @GenerateAdapters + fromJson/toJson for sync
Relationships: belongs to UserProfile, belongs to DeckCard
Notes: FSRS computation is local via the fsrs dart package. State syncs to Supabase automatically when online for research data collection.
```

```
Model: ReviewLogEntry
Fields:
  - id (String, non-null) — UUID
  - userId (String, non-null)
  - cardId (String, non-null)
  - rating (int, non-null) — 1–4
  - scheduledDays (int, non-null)
  - elapsedDays (int, non-null)
  - review (DateTime, non-null)
  - state (int, non-null)
Source: Local Hive + Supabase review_logs (sync)
Serialization: hive_ce @GenerateAdapters + fromJson/toJson
Relationships: belongs to UserProfile, belongs to DeckCard
```

```
Model: LeaderboardEntry
Fields:
  - userId (String, non-null)
  - displayName (String, non-null)
  - targetLanguage (String?, nullable)
  - quizScore (int, non-null) — total correct across all sessions
  - reviewCount (int, non-null) — total FSRS reviews completed
  - currentStreak (int, non-null)
Source: Supabase leaderboard view (computed)
Serialization: fromJson
Relationships: belongs to UserProfile
Notes: Global leaderboard with optional filter by targetLanguage
```

```
Model: Streak
Fields:
  - id (String, non-null) — UUID
  - userId (String, non-null)
  - currentStreak (int, non-null, default 0)
  - longestStreak (int, non-null, default 0)
  - lastActivityDate (DateTime?, nullable)
Source: Supabase streaks table + local Hive cache
Serialization: fromJson/toJson + hive_ce @GenerateAdapters
Relationships: belongs to UserProfile
Notes: Activity = completing at least one FSRS review per day
```

```
Model: ResearchCode
Fields:
  - id (String, non-null) — UUID
  - code (String, non-null) — unique alphanumeric
  - targetRole (String, non-null)
  - unlocks (String, non-null) — e.g. 'vocabulary_test_a', 'experience_survey_short_term'
  - createdBy (String, non-null) — researcher user_id
  - usedBy (String?, nullable)
  - usedAt (DateTime?, nullable)
  - createdAt (DateTime, non-null)
Source: Supabase research_codes table
Serialization: fromJson/toJson
```

```
Model: ResearchUser
Fields:
  - id (String, non-null) — UUID
  - userId (String, non-null) — FK to profiles
  - role (String, non-null) — 'group_a_participant' | 'group_b_participant'
  - targetLanguage (String, non-null)
  - createdAt (DateTime, non-null)
Source: Supabase research_users table
Serialization: fromJson/toJson
```

```
Model: SurveyResponse
Fields:
  - id (String, non-null) — UUID
  - userId (String, non-null)
  - surveyType (String, non-null) — 'proficiency_screener' | 'language_interest' | 'experience_survey' | 'preview_usefulness' | 'fsrs_usefulness' | 'ugc_perception' | 'sus'
  - timePoint (String?, nullable) — 'short_term' | 'long_term' (for experience_survey only)
  - responses (Map<String, dynamic>, non-null) — JSON map of item_key → rating
  - computedScore (double?, nullable) — SUS score only
  - submittedAt (DateTime, non-null)
Source: Supabase research_* tables (routed by surveyType)
Serialization: fromJson/toJson
```

```
Model: VocabularyTestResult
Fields:
  - id (String, non-null) — UUID
  - userId (String, non-null)
  - testSet (String, non-null) — 'A' | 'B'
  - score (int, non-null) — out of 30
  - answers (Map<String, dynamic>, non-null) — full answer JSON {question_id: selected_option}
  - submittedAt (DateTime, non-null)
Source: Supabase research_vocabulary_test table
Serialization: fromJson/toJson
Notes: Multiple choice (A/B/C/D) format. 30 items per test set. Set A and Set B have zero overlapping items.
```

### SECTION 4 — PROVIDER ARCHITECTURE

```
Provider: AuthProvider
File: lib/providers/auth_provider.dart
Responsibility: Manages Supabase authentication state and current user profile

Dependencies (injected via constructor):
  - SupabaseService
  - HiveService

Private state fields:
  - _userProfile (UserProfile?)
  - _isLoading (bool)
  - _error (String?)

Public getters:
  - userProfile → UserProfile?
  - isAuthenticated → bool
  - isLoading → bool
  - error → String?
  - role → String?

Public methods:
  - signIn(email, password) → Future<void>
    Does: calls SupabaseService.signIn, fetches profile, caches in Hive
    Notifies: yes, after profile loaded
    Error handling: sets _error

  - signUp(email, password, displayName) → Future<void>
    Does: calls SupabaseService.signUp, creates profile row, caches in Hive
    Notifies: yes
    Error handling: sets _error

  - signOut() → Future<void>
    Does: calls SupabaseService.signOut, clears Hive user cache
    Notifies: yes
    Error handling: sets _error

  - restoreSession() → Future<void>
    Does: checks Supabase session, loads profile from Hive if offline
    Notifies: yes
    Error handling: sets _error

  - clearError() → void
    Does: sets _error to null
    Notifies: yes

Loading state: bool _isLoading with getter
Error state: String? _error with getter
```

```
Provider: DeckProvider
File: lib/providers/deck_provider.dart
Responsibility: CRUD operations for decks, fetches all public decks and user's own decks

Dependencies (injected via constructor):
  - SupabaseService
  - HiveService

Private state fields:
  - _decks (List<Deck>)
  - _userDecks (List<Deck>)
  - _isLoading (bool)
  - _error (String?)

Public getters:
  - decks → List<Deck>
  - userDecks → List<Deck>
  - premadeDecks → List<Deck>
  - isLoading → bool
  - error → String?

Public methods:
  - fetchDecks() → Future<void>
    Does: loads all public decks from Supabase, caches in Hive
    Notifies: yes
    Error handling: sets _error

  - fetchUserDecks(userId) → Future<void>
    Does: loads decks created by userId
    Notifies: yes
    Error handling: sets _error

  - createDeck(title, description, targetLanguage) → Future<Deck>
    Does: inserts deck in Supabase, adds to _userDecks, caches
    Notifies: yes
    Error handling: sets _error

  - updateDeck(deck) → Future<void>
    Does: updates deck in Supabase, updates local state
    Notifies: yes
    Error handling: sets _error

  - deleteDeck(deckId) → Future<void>
    Does: deletes deck in Supabase, removes from local state
    Notifies: yes
    Error handling: sets _error

Loading state: bool _isLoading with getter
Error state: String? _error with getter
```

```
Provider: CardProvider
File: lib/providers/card_provider.dart
Responsibility: CRUD operations for cards within a specific deck

Dependencies (injected via constructor):
  - SupabaseService
  - HiveService

Private state fields:
  - _cards (List<DeckCard>)
  - _currentDeckId (String?)
  - _isLoading (bool)
  - _error (String?)

Public getters:
  - cards → List<DeckCard>
  - currentDeckId → String?
  - isLoading → bool
  - error → String?

Public methods:
  - fetchCards(deckId) → Future<void>
    Does: loads all cards for deckId from Supabase, caches in Hive
    Notifies: yes
    Error handling: sets _error

  - addCard(deckId, question, answer, {questionImageUrl, answerImageUrl}) → Future<DeckCard>
    Does: inserts card in Supabase, appends to _cards
    Notifies: yes
    Error handling: sets _error

  - updateCard(card) → Future<void>
    Does: updates card in Supabase, updates in _cards
    Notifies: yes
    Error handling: sets _error

  - deleteCard(cardId) → Future<void>
    Does: deletes from Supabase, removes from _cards
    Notifies: yes
    Error handling: sets _error

  - reorderCards(List<DeckCard> reordered) → Future<void>
    Does: updates sortOrder for all cards in Supabase
    Notifies: yes
    Error handling: sets _error

Loading state: bool _isLoading with getter
Error state: String? _error with getter
```

```
Provider: QuizProvider
File: lib/providers/quiz_provider.dart
Responsibility: Manages quiz session state — preview choice, question queue, answer tracking, session completion

Dependencies (injected via constructor):
  - SupabaseService
  - HiveService
  - FsrsService
  - QuizQueueController

Private state fields:
  - _session (QuizSession?)
  - _currentCard (DeckCard?)
  - _answers (List<QuizAnswer>)
  - _queueLength (int)
  - _isLoading (bool)
  - _error (String?)
  - _isComplete (bool)

Public getters:
  - session → QuizSession?
  - currentCard → DeckCard?
  - answers → List<QuizAnswer>
  - queueLength → int
  - progress → double
  - isLoading → bool
  - isComplete → bool
  - error → String?

Public methods:
  - startSession(deckId, userId, cards, previewed) → Future<void>
    Does: creates QuizSession, initializes QuizQueueController with cards, saves to Supabase
    Notifies: yes
    Error handling: sets _error

  - submitAnswer(userAnswer) → void
    Does: checks answer against card's comma-separated accepted answers (case-insensitive, trimmed). If incorrect, requeues card. If correct, waits for self-rating.
    Notifies: yes

  - submitSelfRating(rating) → Future<void>
    Does: if Again(1), requeues; if Hard(2)/Good(3)/Easy(4), saves QuizAnswer, advances queue. When queue empty, completes session and enrolls cards in FSRS.
    Notifies: yes
    Error handling: sets _error

  - completeSession() → Future<void>
    Does: sets completedAt, syncs to Supabase, triggers FSRS enrollment for all rated cards
    Notifies: yes
    Error handling: sets _error

Loading state: bool _isLoading with getter
Error state: String? _error with getter
```

```
Provider: FsrsProvider
File: lib/providers/fsrs_provider.dart
Responsibility: Manages FSRS card states and review sessions — due cards, review flow

Dependencies (injected via constructor):
  - FsrsService
  - HiveService
  - SupabaseService

Private state fields:
  - _dueCards (List<FsrsCardState>)
  - _currentReviewCard (FsrsCardState?)
  - _currentDeckCard (DeckCard?)
  - _dueCount (int)
  - _isLoading (bool)
  - _error (String?)

Public getters:
  - dueCards → List<FsrsCardState>
  - currentReviewCard → FsrsCardState?
  - currentDeckCard → DeckCard?
  - dueCount → int
  - isLoading → bool
  - error → String?

Public methods:
  - fetchDueCards(userId) → Future<void>
    Does: queries Hive for all FsrsCardState where due <= now, loads associated DeckCards
    Notifies: yes
    Error handling: sets _error

  - startReview() → void
    Does: sets _currentReviewCard to first due card
    Notifies: yes

  - submitReview(rating) → Future<void>
    Does: calls FsrsService.reviewCard, updates FsrsCardState in Hive, logs ReviewLogEntry, syncs to Supabase, advances to next due card
    Notifies: yes
    Error handling: sets _error

  - enrollCardsFromQuiz(List<QuizAnswer> answers, List<DeckCard> cards) → Future<void>
    Does: for each card with a self-rating, calls FsrsService.createNewCard + scheduleCard, saves FsrsCardState to Hive and Supabase
    Notifies: yes
    Error handling: sets _error

Loading state: bool _isLoading with getter
Error state: String? _error with getter
```

```
Provider: LeaderboardProvider
File: lib/providers/leaderboard_provider.dart
Responsibility: Fetches and exposes leaderboard rankings with optional language filter

Dependencies (injected via constructor):
  - SupabaseService

Private state fields:
  - _entries (List<LeaderboardEntry>)
  - _filteredLanguage (String?) — null = global, otherwise filter by targetLanguage
  - _isLoading (bool)
  - _error (String?)

Public getters:
  - entries → List<LeaderboardEntry>
  - filteredLanguage → String?
  - isLoading → bool
  - error → String?

Public methods:
  - fetchLeaderboard({String? targetLanguage}) → Future<void>
    Does: queries Supabase leaderboard view, optionally filtered by targetLanguage, sorts by quizScore descending
    Notifies: yes
    Error handling: sets _error

  - setLanguageFilter(String? language) → void
    Does: sets _filteredLanguage and re-fetches
    Notifies: yes

Loading state: bool _isLoading with getter
Error state: String? _error with getter
```

```
Provider: StreakProvider
File: lib/providers/streak_provider.dart
Responsibility: Tracks and updates user's daily FSRS review streak

Dependencies (injected via constructor):
  - SupabaseService
  - HiveService

Private state fields:
  - _streak (Streak?)
  - _isLoading (bool)
  - _error (String?)

Public getters:
  - streak → Streak?
  - currentStreak → int
  - longestStreak → int
  - isLoading → bool
  - error → String?

Public methods:
  - fetchStreak(userId) → Future<void>
    Does: loads streak from Hive (fast), then syncs from Supabase
    Notifies: yes
    Error handling: sets _error

  - recordActivity(userId) → Future<void>
    Does: checks lastActivityDate — if today, no-op; if yesterday, increments; otherwise resets to 1. Updates longestStreak if needed. Saves to Hive + Supabase.
    Notifies: yes
    Error handling: sets _error

Loading state: bool _isLoading with getter
Error state: String? _error with getter
Notes: Activity = completing at least one FSRS review per day. Called from FsrsProvider.submitReview.
```

```
Provider: ResearchProvider
File: lib/providers/research_provider.dart
Responsibility: Manages research codes, surveys, vocabulary tests, and researcher dashboard data

Dependencies (injected via constructor):
  - SupabaseService

Private state fields:
  - _researchUser (ResearchUser?)
  - _codes (List<ResearchCode>)
  - _unlockedFlows (List<String>)
  - _surveyResponses (List<SurveyResponse>)
  - _testResults (List<VocabularyTestResult>)
  - _isLoading (bool)
  - _error (String?)

Public getters:
  - researchUser → ResearchUser?
  - codes → List<ResearchCode>
  - unlockedFlows → List<String>
  - surveyResponses → List<SurveyResponse>
  - testResults → List<VocabularyTestResult>
  - isLoading → bool
  - error → String?

Public methods:
  - redeemCode(userId, code) → Future<String>
    Does: validates code in Supabase, marks as used, returns the unlocked flow name
    Notifies: yes
    Error handling: sets _error

  - generateCode(targetRole, unlocks) → Future<ResearchCode>
    Does: (researcher only) creates a new code in Supabase
    Notifies: yes
    Error handling: sets _error

  - submitSurvey(userId, surveyType, timePoint, responses) → Future<void>
    Does: inserts response into the correct research_* table. For SUS, computes sus_score client-side: ((sum of odd items - 5) + (25 - sum of even items)) * 2.5
    Notifies: yes
    Error handling: sets _error

  - submitVocabularyTest(userId, testSet, score, answers) → Future<void>
    Does: inserts into research_vocabulary_test
    Notifies: yes
    Error handling: sets _error

  - fetchAllResearchData() → Future<void>
    Does: (researcher only) loads all survey responses, test results, codes, research_users
    Notifies: yes
    Error handling: sets _error

  - addResearchUser(userId, role, targetLanguage) → Future<void>
    Does: (researcher only) inserts into research_users
    Notifies: yes
    Error handling: sets _error

Loading state: bool _isLoading with getter
Error state: String? _error with getter
```

### SECTION 5 — HOOK STRATEGY

```
Screen: LoginPage
Hooks:
  - useTextEditingController → email, password fields
  - useFocusNode → email field (auto-focus on mount)

Screen: RegisterPage
Hooks:
  - useTextEditingController → email, password, displayName fields
  - useFocusNode → email field

Screen: HomePage
Hooks:
  - useEffect → fetch due card count and streak on mount, dependency: [userId]

Screen: DeckListPage
Hooks:
  - useEffect → fetch decks on mount
  - useTextEditingController → search/filter input

Screen: DeckDetailPage
Hooks:
  - useEffect → fetch cards for this deck on mount, dependency: [deckId]
  - useScrollController → card list scroll

Screen: DeckCreatorPage
Hooks:
  - useTextEditingController → title, description fields

Screen: CardEditorPage
Hooks:
  - useTextEditingController → question, answer fields
  - useFocusNode → question field (auto-focus)

Screen: QuizPreviewPage
Hooks:
  - useScrollController → scrollable card list

Screen: QuizSessionPage
Hooks:
  - useTextEditingController → answer input field
  - useAnimationController → card transition animation (300ms, easeInOut)
  - useAnimationController → incorrect answer shake animation (400ms)
  - useEffect → auto-focus answer field when new card appears

Screen: QuizResultPage
Hooks:
  - useAnimationController → score reveal spring animation (600ms)

Screen: ReviewPage
Hooks:
  - useAnimationController → card flip Y-axis animation (400ms, easeInOutCubic)
  - useEffect → fetch due cards on mount, dependency: [userId]

Screen: LeaderboardPage
Hooks:
  - useEffect → fetch leaderboard on mount
  - useScrollController → leaderboard list scroll

Screen: AccountPage
Hooks:
  - useTextEditingController → displayName edit field

Screen: ResearcherDashboardPage
Hooks:
  - useEffect → fetch all research data on mount
  - useTextEditingController → code generation form fields

Screen: ResearchCodeEntryPage
Hooks:
  - useTextEditingController → code input field
  - useFocusNode → code input (auto-focus)

Screen: SurveyPage
Hooks:
  - useScrollController → survey question list
  - useMemoized → builds survey question list from surveyType (cached)

Screen: VocabularyTestPage
Hooks:
  - useScrollController → test question list
  - useMemoized → builds test items from testSet

Custom hooks to extract:
  - useDebounce → debounce search input (shared: DeckListPage, ResearcherDashboardPage)
```

### SECTION 6 — NAVIGATION PLAN

```
Router strategy: go_router — required for web URL reflection, deep linking, declarative route guards

Routes:
  /login → LoginPage (auth: no)
  /register → RegisterPage (auth: no)
  / → HomePage (auth: yes)
  /decks → DeckListPage (auth: yes, params: ?language)
  /decks/:deckId → DeckDetailPage (auth: yes)
  /decks/create → DeckCreatorPage (auth: yes)
  /decks/:deckId/edit → DeckCreatorPage edit mode (auth: yes)
  /decks/:deckId/cards/add → CardEditorPage (auth: yes)
  /decks/:deckId/cards/:cardId/edit → CardEditorPage edit mode (auth: yes)
  /quiz/:deckId/preview → QuizPreviewPage (auth: yes)
  /quiz/:deckId/session → QuizSessionPage (auth: yes, URL not restorable mid-quiz)
  /quiz/:sessionId/result → QuizResultPage (auth: yes)
  /review → ReviewPage (auth: yes)
  /leaderboard → LeaderboardPage (auth: yes)
  /account → AccountPage (auth: yes)
  /research → ResearcherDashboardPage (auth: yes, role: researcher)
  /research/code → ResearchCodeEntryPage (auth: yes)
  /research/survey/:surveyType → SurveyPage (auth: yes, params: ?timePoint)
  /research/test/:testSet → VocabularyTestPage (auth: yes)

Guard logic:
  - Auth guard: redirects unauthenticated users to /login
  - Role guard: /research (dashboard) requires role == 'researcher'
  - Research flow guard: survey/test routes check that user has unlocked the specific flow via code
  - Group B guard: group_b_participant can only access /, /research/code, /research/survey/*, /research/test/*, /account

Platform nav differences:
  - Mobile: NavigationBar (Material 3) with tabs — Home, Decks, Review, Account
  - Web: Top AppBar with navigation links
  - Desktop: NavigationRail with extended labels

Group B experience:
  - Group B participants see only a code entry screen as their home page
  - They can access surveys and tests via codes, and their account page
  - All other routes redirect to /research/code for Group B
```

### SECTION 7 — PLATFORM ADAPTATION MAP

```
Screen: HomePage
  Mobile: single column — streak card, due reviews card, recent activity. Pull to refresh. SafeArea.
  Web: centered max-width (800px), same stack. MouseRegion on cards. SelectableText on counts.
  Desktop: same as web. Tooltips on streak badge and review button.

Screen: DeckListPage
  Mobile: single column list, FAB for create. Pull to refresh.
  Web: responsive grid (2–3 columns), search bar. MouseRegion hover elevation. Ctrl+N create shortcut.
  Desktop: same grid. Tooltips on deck cards.

Screen: QuizSessionPage
  Mobile: full screen — question card centered, answer input bottom. SafeArea. No swipe gestures.
  Web: centered max-width (600px). Enter to submit, 1/2/3/4 for self-rating shortcuts.
  Desktop: same as web. Same keyboard shortcuts.

Screen: ReviewPage
  Mobile: full screen — single card, rating buttons bottom. Tap to reveal.
  Web: centered card. Space to flip, 1/2/3/4 for rating.
  Desktop: same as web. Tooltips on rating buttons.

Screen: ResearcherDashboardPage
  Mobile: single column tabs (Codes | Participants | Results). Swipe between tabs.
  Web: sidebar nav + main content. SelectableText on data. Ctrl+G generate code.
  Desktop: multi-panel sidebar + data table. Right-click on data rows. Tooltips on headers.

Screen: SurveyPage / VocabularyTestPage
  Mobile: single column scrollable, submit at bottom. SafeArea.
  Web: centered max-width (700px). SelectableText on questions.
  Desktop: same as web. Tab between questions.

Responsive breakpoints (lib/shared/breakpoints.dart):
  mobile: < 600px
  tablet: 600–1024px
  desktop: > 1024px
```

### SECTION 8 — NATIVE CAPABILITIES USED

```
API: AnimationController + CurvedAnimation (easeInOutCubic)
Used in: ReviewPage (card flip 400ms), QuizSessionPage (card transitions 300ms), QuizResultPage (score reveal 600ms spring)
Purpose: smooth card flip and transition animations
Why native: simple tween animations don't need a package

API: AnimatedSwitcher
Used in: QuizSessionPage (switching between question cards)
Purpose: cross-fade between cards
Why native: built-in widget

API: Hero
Used in: DeckListPage → DeckDetailPage (deck card hero transition)
Purpose: shared element transition
Why native: native Hero widget

API: CustomPainter
Used in: StreakFlamePainter (draws flame icon based on streak count)
Purpose: visual streak indicator
Why native: simple canvas drawing

API: Form + TextFormField + GlobalKey<FormState>
Used in: LoginPage, RegisterPage, DeckCreatorPage, CardEditorPage
Purpose: form validation
Why native: built-in form validation

API: GestureDetector
Used in: ReviewPage (tap to reveal), QuizSessionPage (answer interactions)
Purpose: tap detection
Why native: no gesture library needed

API: RefreshIndicator
Used in: HomePage, DeckListPage, LeaderboardPage
Purpose: pull-to-refresh on mobile
Why native: Material pull-to-refresh

API: LayoutBuilder
Used in: ResponsiveScaffold — switches between mobile/tablet/desktop layouts
Purpose: responsive layout decisions
Why native: preferred over raw MediaQuery

API: Shortcuts + Actions + Intent
Used in: QuizSessionPage (1/2/3/4 rating, Enter submit), ReviewPage (Space flip)
Purpose: keyboard shortcut support for web and desktop
Why native: native keyboard handling

API: FocusNode + FocusScope
Used in: LoginPage, CardEditorPage, ResearchCodeEntryPage
Purpose: auto-focus and tab-order management
Why native: built-in focus system

API: Semantics
Used in: all interactive widgets
Purpose: accessibility labels
Why native: built-in accessibility

API: SafeArea
Used in: all pages on mobile
Purpose: avoid system UI overlap
Why native: standard Flutter widget

API: SliverAppBar + CustomScrollView
Used in: DeckDetailPage (collapsing app bar with deck info)
Purpose: scroll-aware app bar
Why native: built-in sliver system

API: Transform (Y-axis rotation)
Used in: ReviewPage (3D card flip)
Purpose: Y-axis card flip animation
Why native: Transform.rotateY with perspective matrix
```

### SECTION 9 — SERVICES LAYER

```
Service: SupabaseService
File: lib/services/supabase_service.dart
Responsibility: Single access point for all Supabase operations (auth, database, storage)

Methods:
  Auth:
  - signIn(email, password) → Future<AuthResponse>
  - signUp(email, password) → Future<AuthResponse>
  - signOut() → Future<void>

  Profiles:
  - getProfile(userId) → Future<Map<String, dynamic>?>
  - upsertProfile(data) → Future<void>

  Decks:
  - fetchDecks({bool publicOnly}) → Future<List<Map<String, dynamic>>>
  - insertDeck(data) → Future<Map<String, dynamic>>
  - updateDeck(id, data) → Future<void>
  - deleteDeck(id) → Future<void>

  Cards:
  - fetchCards(deckId) → Future<List<Map<String, dynamic>>>
  - insertCard(data) → Future<Map<String, dynamic>>
  - updateCard(id, data) → Future<void>
  - deleteCard(id) → Future<void>

  Quiz:
  - insertQuizSession(data) → Future<Map<String, dynamic>>
  - updateQuizSession(id, data) → Future<void>
  - insertQuizAnswer(data) → Future<void>

  FSRS:
  - upsertFsrsCard(data) → Future<void>
  - insertReviewLog(data) → Future<void>

  Leaderboard:
  - fetchLeaderboard({String? targetLanguage}) → Future<List<Map<String, dynamic>>>

  Streaks:
  - upsertStreak(data) → Future<void>
  - fetchStreak(userId) → Future<Map<String, dynamic>?>

  Research:
  - fetchResearchCodes({createdBy}) → Future<List<Map<String, dynamic>>>
  - insertResearchCode(data) → Future<Map<String, dynamic>>
  - redeemResearchCode(code, userId) → Future<Map<String, dynamic>>
  - insertSurveyResponse(table, data) → Future<void>
  - insertVocabularyTest(data) → Future<void>
  - fetchAllResearchData() → Future<Map<String, List<Map<String, dynamic>>>>
  - insertResearchUser(data) → Future<void>

  Storage:
  - uploadImage(bucket, path, bytes) → Future<String> — returns public URL
  - deleteImage(bucket, path) → Future<void>

All methods throw AppException on failure.
Platform differences: none
Initialization: Supabase.initialize called in main.dart; service created after
```

```
Service: HiveService
File: lib/services/hive_service.dart
Responsibility: Manages all local Hive box operations for offline caching and FSRS state

Box constants:
  - profileBox = 'profile'
  - decksBox = 'decks'
  - cardsBox = 'cards'
  - fsrsCardsBox = 'fsrs_cards'
  - reviewLogsBox = 'review_logs'
  - streaksBox = 'streaks'
  - settingsBox = 'settings'

Methods:
  - init() → Future<void> — opens all boxes
  - saveProfile(UserProfile) → Future<void>
  - getProfile() → UserProfile?
  - saveDecks(List<Deck>) → Future<void>
  - getDecks() → List<Deck>
  - saveCards(deckId, List<DeckCard>) → Future<void>
  - getCards(deckId) → List<DeckCard>
  - saveFsrsCard(FsrsCardState) → Future<void>
  - getFsrsCard(compositeKey) → FsrsCardState?
  - getDueCards(userId, DateTime now) → List<FsrsCardState>
  - getAllFsrsCards(userId) → List<FsrsCardState>
  - saveReviewLog(ReviewLogEntry) → Future<void>
  - saveStreak(Streak) → Future<void>
  - getStreak(userId) → Streak?
  - getNotificationHour() → int — defaults to 9 (9 AM)
  - setNotificationHour(int hour) → Future<void>
  - clearAll() → Future<void>

Platform differences: none
Initialization: called in main.dart after Hive.initFlutter
```

```
Service: FsrsService
File: lib/services/fsrs_service.dart
Responsibility: Wraps the fsrs dart package — computes scheduling, new card creation, review processing

Methods:
  - createNewCard() → Card (from fsrs package)
  - scheduleCard(Card card, Rating rating) → SchedulingInfo
  - reviewCard(FsrsCardState state, int rating) → FsrsCardState
  - getDueDate(FsrsCardState state) → DateTime

Platform differences: none
Initialization: lazy — plain object, no async init
```

```
Service: NotificationService
File: lib/services/notification_service.dart
Responsibility: Schedules local notifications for FSRS review reminders

Methods:
  - init() → Future<void> — initializes flutter_local_notifications plugin
  - scheduleReviewReminder(DateTime scheduledDate, int dueCount) → Future<void>
  - cancelAll() → Future<void>

Platform differences: Android notification channel setup, iOS permission request
Initialization: called in main.dart
Notes: Notification time is user-configurable via HiveService.getNotificationHour/setNotificationHour. Notifications fire at the user's chosen hour on the exact day the card is due.
```

### SECTION 10 — SUPABASE & POSTGRESQL SPEC

```sql
CREATE EXTENSION IF NOT EXISTS moddatetime SCHEMA extensions;
```

```sql
-- ── profiles ──────────────────────────────────────────
CREATE TABLE profiles (
  id            uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email         text NOT NULL,
  display_name  text NOT NULL,
  role          text NOT NULL DEFAULT 'group_a_participant'
                CHECK (role IN ('group_a_participant', 'group_b_participant', 'researcher')),
  avatar_url    text,
  target_language text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "profiles: users read all" ON profiles FOR SELECT USING (true);
CREATE POLICY "profiles: users update own" ON profiles FOR UPDATE USING (auth.uid() = id) WITH CHECK (auth.uid() = id);
CREATE POLICY "profiles: users insert own" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);
```

```sql
-- ── decks ──────────────────────────────────────────
CREATE TABLE decks (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  creator_id      uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title           text NOT NULL,
  description     text NOT NULL DEFAULT '',
  target_language text NOT NULL,
  is_premade      bool NOT NULL DEFAULT false,
  is_public       bool NOT NULL DEFAULT true,
  card_count      int NOT NULL DEFAULT 0,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE decks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "decks: anyone reads public" ON decks FOR SELECT USING (is_public = true OR auth.uid() = creator_id);
CREATE POLICY "decks: users manage own" ON decks FOR ALL USING (auth.uid() = creator_id) WITH CHECK (auth.uid() = creator_id);
CREATE INDEX ON decks (creator_id);
CREATE INDEX ON decks (target_language);
CREATE INDEX ON decks (is_public);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON decks FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);
```

```sql
-- ── deck_cards ──────────────────────────────────────────
CREATE TABLE deck_cards (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  deck_id            uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  question           text NOT NULL,
  answer             text NOT NULL,
  question_image_url text,
  answer_image_url   text,
  sort_order         int NOT NULL DEFAULT 0,
  created_at         timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE deck_cards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "deck_cards: readable if deck is accessible" ON deck_cards FOR SELECT
  USING (EXISTS (SELECT 1 FROM decks WHERE decks.id = deck_cards.deck_id AND (decks.is_public = true OR decks.creator_id = auth.uid())));
CREATE POLICY "deck_cards: creator manages" ON deck_cards FOR ALL
  USING (EXISTS (SELECT 1 FROM decks WHERE decks.id = deck_cards.deck_id AND decks.creator_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM decks WHERE decks.id = deck_cards.deck_id AND decks.creator_id = auth.uid()));
CREATE INDEX ON deck_cards (deck_id);
```

```sql
-- ── quiz_sessions ──────────────────────────────────────────
CREATE TABLE quiz_sessions (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  deck_id         uuid NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
  previewed       bool NOT NULL DEFAULT false,
  total_questions int NOT NULL,
  correct_count   int NOT NULL DEFAULT 0,
  started_at      timestamptz NOT NULL DEFAULT now(),
  completed_at    timestamptz
);
ALTER TABLE quiz_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "quiz_sessions: users manage own" ON quiz_sessions FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE INDEX ON quiz_sessions (user_id);
CREATE INDEX ON quiz_sessions (deck_id);
```

```sql
-- ── quiz_answers ──────────────────────────────────────────
CREATE TABLE quiz_answers (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id  uuid NOT NULL REFERENCES quiz_sessions(id) ON DELETE CASCADE,
  card_id     uuid NOT NULL REFERENCES deck_cards(id) ON DELETE CASCADE,
  user_answer text NOT NULL,
  is_correct  bool NOT NULL,
  self_rating int CHECK (self_rating BETWEEN 1 AND 4),
  answered_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE quiz_answers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "quiz_answers: users manage own" ON quiz_answers FOR ALL
  USING (EXISTS (SELECT 1 FROM quiz_sessions WHERE quiz_sessions.id = quiz_answers.session_id AND quiz_sessions.user_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM quiz_sessions WHERE quiz_sessions.id = quiz_answers.session_id AND quiz_sessions.user_id = auth.uid()));
CREATE INDEX ON quiz_answers (session_id);
CREATE INDEX ON quiz_answers (card_id);
```

```sql
-- ── fsrs_cards ──────────────────────────────────────────
CREATE TABLE fsrs_cards (
  id              text PRIMARY KEY,
  user_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  card_id         uuid NOT NULL REFERENCES deck_cards(id) ON DELETE CASCADE,
  due             timestamptz NOT NULL,
  stability       double precision NOT NULL,
  difficulty      double precision NOT NULL,
  elapsed_days    int NOT NULL DEFAULT 0,
  scheduled_days  int NOT NULL DEFAULT 0,
  reps            int NOT NULL DEFAULT 0,
  lapses          int NOT NULL DEFAULT 0,
  state           int NOT NULL DEFAULT 0,
  last_review     timestamptz,
  updated_at      timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE fsrs_cards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "fsrs_cards: users manage own" ON fsrs_cards FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE INDEX ON fsrs_cards (user_id);
CREATE INDEX ON fsrs_cards (user_id, due);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON fsrs_cards FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);
```

```sql
-- ── review_logs ──────────────────────────────────────────
CREATE TABLE review_logs (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  card_id         uuid NOT NULL REFERENCES deck_cards(id) ON DELETE CASCADE,
  rating          int NOT NULL CHECK (rating BETWEEN 1 AND 4),
  scheduled_days  int NOT NULL,
  elapsed_days    int NOT NULL,
  review          timestamptz NOT NULL,
  state           int NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE review_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "review_logs: users manage own" ON review_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE INDEX ON review_logs (user_id);
CREATE INDEX ON review_logs (card_id);
```

```sql
-- ── streaks ──────────────────────────────────────────
CREATE TABLE streaks (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  current_streak      int NOT NULL DEFAULT 0,
  longest_streak      int NOT NULL DEFAULT 0,
  last_activity_date  date,
  updated_at          timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "streaks: users manage own" ON streaks FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE INDEX ON streaks (user_id);
CREATE TRIGGER set_updated_at BEFORE UPDATE ON streaks FOR EACH ROW EXECUTE FUNCTION moddatetime(updated_at);
```

```sql
-- ── leaderboard (view) ──────────────────────────
CREATE OR REPLACE VIEW leaderboard AS
SELECT
  p.id AS user_id,
  p.display_name,
  p.target_language,
  COALESCE(SUM(qs.correct_count), 0)::int AS quiz_score,
  COALESCE(rc.review_count, 0)::int AS review_count,
  COALESCE(s.current_streak, 0) AS current_streak
FROM profiles p
LEFT JOIN quiz_sessions qs ON qs.user_id = p.id AND qs.completed_at IS NOT NULL
LEFT JOIN (SELECT user_id, COUNT(*)::int AS review_count FROM review_logs GROUP BY user_id) rc ON rc.user_id = p.id
LEFT JOIN streaks s ON s.user_id = p.id
WHERE p.role = 'group_a_participant'
GROUP BY p.id, p.display_name, p.target_language, rc.review_count, s.current_streak
ORDER BY quiz_score DESC;
```

```sql
-- ══════════════════════════════════════════════════════
-- RESEARCH TABLES
-- ══════════════════════════════════════════════════════

-- ── research_users ──────────────────────────────────────
CREATE TABLE research_users (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  role            text NOT NULL CHECK (role IN ('group_a_participant', 'group_b_participant')),
  target_language text NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_users: researchers manage" ON research_users FOR ALL
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE POLICY "research_users: users read own" ON research_users FOR SELECT USING (auth.uid() = user_id);
CREATE INDEX ON research_users (user_id);

-- ── research_codes ──────────────────────────────────────
CREATE TABLE research_codes (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code        text NOT NULL UNIQUE,
  target_role text NOT NULL,
  unlocks     text NOT NULL,
  created_by  uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  used_by     uuid REFERENCES profiles(id),
  used_at     timestamptz,
  created_at  timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_codes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_codes: researchers manage" ON research_codes FOR ALL
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE POLICY "research_codes: participants redeem" ON research_codes FOR UPDATE
  USING (used_by IS NULL) WITH CHECK (auth.uid() = used_by);
CREATE POLICY "research_codes: participants read own" ON research_codes FOR SELECT
  USING (auth.uid() = used_by OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_codes (code);
CREATE INDEX ON research_codes (created_by);

-- ── research_proficiency_screener ────────────────────────
CREATE TABLE research_proficiency_screener (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  item_1            int NOT NULL CHECK (item_1 BETWEEN 1 AND 5),
  item_2            int NOT NULL CHECK (item_2 BETWEEN 1 AND 5),
  item_3            int NOT NULL CHECK (item_3 BETWEEN 1 AND 5),
  item_4            int NOT NULL CHECK (item_4 BETWEEN 1 AND 5),
  item_5            int NOT NULL CHECK (item_5 BETWEEN 1 AND 5),
  item_6            int NOT NULL CHECK (item_6 BETWEEN 1 AND 5),
  proficiency_level text NOT NULL CHECK (proficiency_level IN ('none', 'beginner', 'elementary', 'intermediate', 'advanced')),
  submitted_at      timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_proficiency_screener ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_proficiency_screener: users insert own" ON research_proficiency_screener FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_proficiency_screener: read" ON research_proficiency_screener FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_proficiency_screener (user_id);

-- ── research_language_interest ────────────────────────
CREATE TABLE research_language_interest (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  item_1       int NOT NULL CHECK (item_1 BETWEEN 1 AND 5),
  item_2       int NOT NULL CHECK (item_2 BETWEEN 1 AND 5),
  item_3       int NOT NULL CHECK (item_3 BETWEEN 1 AND 5),
  item_4       int NOT NULL CHECK (item_4 BETWEEN 1 AND 5),
  item_5       int NOT NULL CHECK (item_5 BETWEEN 1 AND 5),
  submitted_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_language_interest ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_language_interest: users insert own" ON research_language_interest FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_language_interest: read" ON research_language_interest FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_language_interest (user_id);

-- ── research_vocabulary_test ────────────────────────
CREATE TABLE research_vocabulary_test (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  test_set     text NOT NULL CHECK (test_set IN ('A', 'B')),
  score        int NOT NULL CHECK (score BETWEEN 0 AND 30),
  answers      jsonb NOT NULL,
  submitted_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, test_set)
);
ALTER TABLE research_vocabulary_test ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_vocabulary_test: users insert own" ON research_vocabulary_test FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_vocabulary_test: read" ON research_vocabulary_test FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_vocabulary_test (user_id);

-- ── research_experience_survey ────────────────────────
CREATE TABLE research_experience_survey (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  time_point   text NOT NULL CHECK (time_point IN ('short_term', 'long_term')),
  enjoyment_1  int NOT NULL CHECK (enjoyment_1 BETWEEN 1 AND 5),
  enjoyment_2  int NOT NULL CHECK (enjoyment_2 BETWEEN 1 AND 5),
  enjoyment_3  int NOT NULL CHECK (enjoyment_3 BETWEEN 1 AND 5),
  enjoyment_4  int NOT NULL CHECK (enjoyment_4 BETWEEN 1 AND 5),
  enjoyment_5  int NOT NULL CHECK (enjoyment_5 BETWEEN 1 AND 5),
  engagement_1 int NOT NULL CHECK (engagement_1 BETWEEN 1 AND 5),
  engagement_2 int NOT NULL CHECK (engagement_2 BETWEEN 1 AND 5),
  engagement_3 int NOT NULL CHECK (engagement_3 BETWEEN 1 AND 5),
  engagement_4 int NOT NULL CHECK (engagement_4 BETWEEN 1 AND 5),
  engagement_5 int NOT NULL CHECK (engagement_5 BETWEEN 1 AND 5),
  motivation_1 int NOT NULL CHECK (motivation_1 BETWEEN 1 AND 5),
  motivation_2 int NOT NULL CHECK (motivation_2 BETWEEN 1 AND 5),
  motivation_3 int NOT NULL CHECK (motivation_3 BETWEEN 1 AND 5),
  motivation_4 int NOT NULL CHECK (motivation_4 BETWEEN 1 AND 5),
  motivation_5 int NOT NULL CHECK (motivation_5 BETWEEN 1 AND 5),
  submitted_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, time_point)
);
ALTER TABLE research_experience_survey ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_experience_survey: users insert own" ON research_experience_survey FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_experience_survey: read" ON research_experience_survey FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_experience_survey (user_id);

-- ── research_preview_usefulness (Group A only) ────────────
CREATE TABLE research_preview_usefulness (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  item_1       int NOT NULL CHECK (item_1 BETWEEN 1 AND 5),
  item_2       int NOT NULL CHECK (item_2 BETWEEN 1 AND 5),
  item_3       int NOT NULL CHECK (item_3 BETWEEN 1 AND 5),
  item_4       int NOT NULL CHECK (item_4 BETWEEN 1 AND 5),
  item_5       int NOT NULL CHECK (item_5 BETWEEN 1 AND 5),
  submitted_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_preview_usefulness ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_preview_usefulness: group_a insert own" ON research_preview_usefulness FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_preview_usefulness: read" ON research_preview_usefulness FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_preview_usefulness (user_id);

-- ── research_fsrs_usefulness (Group A only) ────────────
CREATE TABLE research_fsrs_usefulness (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  item_1       int NOT NULL CHECK (item_1 BETWEEN 1 AND 5),
  item_2       int NOT NULL CHECK (item_2 BETWEEN 1 AND 5),
  item_3       int NOT NULL CHECK (item_3 BETWEEN 1 AND 5),
  item_4       int NOT NULL CHECK (item_4 BETWEEN 1 AND 5),
  item_5       int NOT NULL CHECK (item_5 BETWEEN 1 AND 5),
  submitted_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_fsrs_usefulness ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_fsrs_usefulness: group_a insert own" ON research_fsrs_usefulness FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_fsrs_usefulness: read" ON research_fsrs_usefulness FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_fsrs_usefulness (user_id);

-- ── research_ugc_perception (both groups) ────────────
CREATE TABLE research_ugc_perception (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  item_1       int NOT NULL CHECK (item_1 BETWEEN 1 AND 5),
  item_2       int NOT NULL CHECK (item_2 BETWEEN 1 AND 5),
  item_3       int NOT NULL CHECK (item_3 BETWEEN 1 AND 5),
  item_4       int NOT NULL CHECK (item_4 BETWEEN 1 AND 5),
  item_5       int NOT NULL CHECK (item_5 BETWEEN 1 AND 5),
  item_6       int NOT NULL CHECK (item_6 BETWEEN 1 AND 5),
  submitted_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_ugc_perception ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_ugc_perception: users insert own" ON research_ugc_perception FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_ugc_perception: read" ON research_ugc_perception FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_ugc_perception (user_id);

-- ── research_sus (Group A only) ────────────
CREATE TABLE research_sus (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  item_1       int NOT NULL CHECK (item_1 BETWEEN 1 AND 5),
  item_2       int NOT NULL CHECK (item_2 BETWEEN 1 AND 5),
  item_3       int NOT NULL CHECK (item_3 BETWEEN 1 AND 5),
  item_4       int NOT NULL CHECK (item_4 BETWEEN 1 AND 5),
  item_5       int NOT NULL CHECK (item_5 BETWEEN 1 AND 5),
  item_6       int NOT NULL CHECK (item_6 BETWEEN 1 AND 5),
  item_7       int NOT NULL CHECK (item_7 BETWEEN 1 AND 5),
  item_8       int NOT NULL CHECK (item_8 BETWEEN 1 AND 5),
  item_9       int NOT NULL CHECK (item_9 BETWEEN 1 AND 5),
  item_10      int NOT NULL CHECK (item_10 BETWEEN 1 AND 5),
  sus_score    double precision NOT NULL,
  submitted_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_sus ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_sus: group_a insert own" ON research_sus FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "research_sus: read" ON research_sus FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'researcher'));
CREATE INDEX ON research_sus (user_id);
```

MOCK DATA:
```sql
-- ── MOCK DATA ───────────────────────────────
INSERT INTO auth.users (id, email) VALUES
  ('00000000-0000-0000-0000-000000000001', 'researcher@test.com'),
  ('00000000-0000-0000-0000-000000000002', 'alice@test.com'),
  ('00000000-0000-0000-0000-000000000003', 'bob@test.com'),
  ('00000000-0000-0000-0000-000000000004', 'carol@test.com');

INSERT INTO profiles (id, email, display_name, role, target_language) VALUES
  ('00000000-0000-0000-0000-000000000001', 'researcher@test.com', 'Dr. Test', 'researcher', NULL),
  ('00000000-0000-0000-0000-000000000002', 'alice@test.com', 'Alice', 'group_a_participant', 'japanese'),
  ('00000000-0000-0000-0000-000000000003', 'bob@test.com', 'Bob', 'group_a_participant', 'japanese'),
  ('00000000-0000-0000-0000-000000000004', 'carol@test.com', 'Carol', 'group_b_participant', 'japanese');

INSERT INTO decks (id, creator_id, title, description, target_language, is_premade, card_count) VALUES
  ('00000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000001', 'JLPT N5 Vocabulary', 'Premade deck for the study', 'japanese', true, 5),
  ('00000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000002', 'My Extra Vocab', 'Alice UGC deck', 'japanese', false, 2);

INSERT INTO deck_cards (id, deck_id, question, answer, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000010', '犬', 'dog, いぬ, inu', 0),
  ('00000000-0000-0000-0000-000000000021', '00000000-0000-0000-0000-000000000010', '猫', 'cat, ねこ, neko', 1),
  ('00000000-0000-0000-0000-000000000022', '00000000-0000-0000-0000-000000000010', '鳥', 'bird, とり, tori', 2),
  ('00000000-0000-0000-0000-000000000023', '00000000-0000-0000-0000-000000000010', '魚', 'fish, さかな, sakana', 3),
  ('00000000-0000-0000-0000-000000000024', '00000000-0000-0000-0000-000000000010', '花', 'flower, はな, hana', 4),
  ('00000000-0000-0000-0000-000000000025', '00000000-0000-0000-0000-000000000011', '空', 'sky, そら, sora', 0),
  ('00000000-0000-0000-0000-000000000026', '00000000-0000-0000-0000-000000000011', '海', 'sea, うみ, umi', 1);

INSERT INTO streaks (id, user_id, current_streak, longest_streak, last_activity_date) VALUES
  ('00000000-0000-0000-0000-000000000030', '00000000-0000-0000-0000-000000000002', 5, 12, '2026-03-25'),
  ('00000000-0000-0000-0000-000000000031', '00000000-0000-0000-0000-000000000003', 0, 3, '2026-03-20');

INSERT INTO research_users (id, user_id, role, target_language) VALUES
  ('00000000-0000-0000-0000-000000000050', '00000000-0000-0000-0000-000000000002', 'group_a_participant', 'japanese'),
  ('00000000-0000-0000-0000-000000000051', '00000000-0000-0000-0000-000000000003', 'group_a_participant', 'japanese'),
  ('00000000-0000-0000-0000-000000000052', '00000000-0000-0000-0000-000000000004', 'group_b_participant', 'japanese');

INSERT INTO research_codes (id, code, target_role, unlocks, created_by) VALUES
  ('00000000-0000-0000-0000-000000000060', 'VOCAB-A-001', 'group_a_participant', 'vocabulary_test_a', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000061', 'VOCAB-A-002', 'group_b_participant', 'vocabulary_test_a', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000062', 'EXP-SHORT-001', 'group_a_participant', 'experience_survey_short_term', '00000000-0000-0000-0000-000000000001');
```

DART MOCK HELPERS:
```dart
// test/helpers/fake_user_profile.dart
UserProfile fakeUserProfile({String? id, String? role}) => UserProfile(
  id: id ?? '00000000-0000-0000-0000-000000000002',
  email: 'alice@test.com',
  displayName: 'Alice',
  role: role ?? 'group_a_participant',
  avatarUrl: null,
  targetLanguage: 'japanese',
  createdAt: DateTime(2026, 1, 1),
);

// test/helpers/fake_deck.dart
Deck fakeDeck({String? id, bool? isPremade}) => Deck(
  id: id ?? '00000000-0000-0000-0000-000000000010',
  creatorId: '00000000-0000-0000-0000-000000000002',
  title: 'Test Deck',
  description: 'A test deck',
  targetLanguage: 'japanese',
  isPremade: isPremade ?? false,
  isPublic: true,
  cardCount: 3,
  createdAt: DateTime(2026, 1, 1),
  updatedAt: DateTime(2026, 1, 1),
);
List<Deck> fakeDeckList({int count = 3}) =>
  List.generate(count, (i) => fakeDeck(id: '00000000-0000-0000-0000-00000000001$i'));

// test/helpers/fake_deck_card.dart
DeckCard fakeDeckCard({String? id, String? question, String? answer}) => DeckCard(
  id: id ?? '00000000-0000-0000-0000-000000000020',
  deckId: '00000000-0000-0000-0000-000000000010',
  question: question ?? '犬',
  answer: answer ?? 'dog, いぬ, inu',
  questionImageUrl: null,
  answerImageUrl: null,
  sortOrder: 0,
  createdAt: DateTime(2026, 1, 1),
);
List<DeckCard> fakeDeckCardList({int count = 3}) =>
  List.generate(count, (i) => fakeDeckCard(id: '00000000-0000-0000-0000-00000000002$i'));

// test/helpers/fake_quiz_session.dart
QuizSession fakeQuizSession({String? id, bool? completed}) => QuizSession(
  id: id ?? '00000000-0000-0000-0000-000000000040',
  userId: '00000000-0000-0000-0000-000000000002',
  deckId: '00000000-0000-0000-0000-000000000010',
  previewed: true,
  totalQuestions: 3,
  correctCount: 2,
  startedAt: DateTime(2026, 1, 1),
  completedAt: completed == true ? DateTime(2026, 1, 1, 0, 10) : null,
);

// test/helpers/fake_fsrs_card_state.dart
FsrsCardState fakeFsrsCardState({String? cardId, DateTime? due}) => FsrsCardState(
  id: '00000000-0000-0000-0000-000000000002_${cardId ?? '00000000-0000-0000-0000-000000000020'}',
  userId: '00000000-0000-0000-0000-000000000002',
  cardId: cardId ?? '00000000-0000-0000-0000-000000000020',
  due: due ?? DateTime.now(),
  stability: 1.0,
  difficulty: 5.0,
  elapsedDays: 0,
  scheduledDays: 1,
  reps: 1,
  lapses: 0,
  state: 1,
  lastReview: DateTime.now(),
);
```

### SECTION 11 — ERROR HANDLING STRATEGY

```
Global error model:
  class AppException implements Exception {
    final String message;
    final String? code;
    const AppException(this.message, {this.code});
    @override String toString() => 'AppException: $message (code: $code)';
  }

Provider error pattern:
  String? _error with getter
  clearError() sets _error = null and notifies
  Every async method wraps in try/catch, sets _error on failure, resets _isLoading

UI error pattern:
  SnackBar for transient errors (network, save failures)
  Inline form error for validation (TextFormField validator)
  Full-screen error widget with retry button for critical load failures

Network error handling:
  SupabaseService catches PostgrestException and AuthException, wraps in AppException
  No automatic retry for v1 — user-initiated retry via pull-to-refresh or retry button
  Offline detection: check Supabase connectivity; fall back to Hive cache
  Automatic sync: when connectivity returns, sync queued Hive writes to Supabase

Crash reporting: none for v1
```

### SECTION 12 — ARCHITECTURE DIAGRAM

```
┌─────────────────────────────────────────────────────────────────────┐
│                            UI LAYER                                  │
│                                                                      │
│  LoginPage/RegisterPage ──watch──> AuthProvider                      │
│      └── hooks: useTextEditingController, useFocusNode               │
│                                                                      │
│  HomePage ──watch──> FsrsProvider, StreakProvider                     │
│      └── hooks: useEffect                                            │
│                                                                      │
│  DeckListPage ──watch──> DeckProvider                                │
│      └── hooks: useEffect, useTextEditingController                  │
│                                                                      │
│  DeckDetailPage ──watch──> CardProvider                              │
│      └── hooks: useEffect, useScrollController                       │
│                                                                      │
│  DeckCreatorPage/CardEditorPage ──watch──> DeckProvider, CardProvider│
│      └── hooks: useTextEditingController, useFocusNode               │
│                                                                      │
│  QuizSessionPage ──watch──> QuizProvider                             │
│      └── hooks: useTextEditingController, useAnimationController x2  │
│                                                                      │
│  ReviewPage ──watch──> FsrsProvider                                  │
│      └── hooks: useAnimationController (flip 400ms), useEffect       │
│                                                                      │
│  LeaderboardPage ──watch──> LeaderboardProvider                      │
│      └── hooks: useEffect, useScrollController                       │
│                                                                      │
│  ResearcherDashboardPage ──watch──> ResearchProvider                 │
│      └── hooks: useEffect, useTextEditingController                  │
│                                                                      │
│  ResearchCodeEntryPage ──watch──> ResearchProvider                   │
│      └── hooks: useTextEditingController, useFocusNode               │
│                                                                      │
│  SurveyPage/VocabularyTestPage ──watch──> ResearchProvider           │
│      └── hooks: useScrollController, useMemoized                     │
│                                                                      │
│  AccountPage ──watch──> AuthProvider, StreakProvider                  │
│      └── hooks: useTextEditingController                             │
└──────────────┬────────────────┬────────────────┬────────────────────┘
               │ calls          │ calls          │ calls
┌──────────────▼────────────────▼────────────────▼────────────────────┐
│                          SERVICE LAYER                               │
│                                                                      │
│  SupabaseService          HiveService                                │
│  FsrsService              NotificationService                        │
│                                                                      │
│  ┌──────────────────────────────────────────────────────┐           │
│  │ QuizQueueController (non-ChangeNotifier)             │           │
│  │ Manages quiz question queue: enqueue, dequeue,       │           │
│  │ reinsert, isEmpty, length                            │           │
│  └──────────────────────────────────────────────────────┘           │
└──────────────┬────────────────┬──────────────────────────────────────┘
               │                │
┌──────────────▼──┐  ┌─────────▼──────────┐
│   Supabase DB    │  │   Local Hive Boxes  │
│   (PostgreSQL)   │  │   (FSRS state,      │
│   19 tables      │  │    deck cache,      │
│   + 1 view       │  │    profile cache,   │
│                  │  │    settings)        │
└─────────────────┘  └────────────────────┘
```

### SECTION 13 — PUBSPEC.YAML DEPENDENCIES

```yaml
dependencies:
  flutter:
    sdk: flutter

  # ── State & UI ──────────────────────────────────────────
  provider: ^6.1.2             # shared state via ChangeNotifier
  flutter_hooks: ^0.20.5       # local UI state (useEffect, useAnimationController, etc.)

  # ── Code generation ─────────────────────────────────────
  barrel_annotation: 1.0.0     # marks files for barrel export generation

  # ── Local persistence ────────────────────────────────────
  hive_ce: 2.19.3              # fast local NoSQL box storage
  hive_ce_flutter: 2.3.4       # Flutter adapter for hive_ce (Hive.initFlutter)

  # ── Input & pickers ─────────────────────────────────────
  flutter_picker_plus: 1.5.6   # wheel-style picker for dates, lists, multi-column
  flutter_colorpicker: 1.1.0   # color picker widget for settings/customization
  file_picker: 10.3.10         # native file system picker (images, docs, any file)

  # ── Notifications ────────────────────────────────────────
  flutter_local_notifications: ^21.0.0  # scheduled & immediate local notifications

  # ── Loading states ───────────────────────────────────────
  skeletonizer: 2.1.3          # wraps any widget to render as animated skeleton

  # ── Utilities ────────────────────────────────────────────
  url_launcher: ^6.3.2         # open URLs, emails, phone links
  flutter_screenutil: ^5.9.3   # responsive sizing (.sp, .w, .h, .r)

  # ── Backend ──────────────────────────────────────────────
  supabase_flutter: ^2.12.2    # Supabase client (auth, database, storage, realtime)

  # ── Navigation ───────────────────────────────────────────
  go_router: 17.0.1            # declarative routing with deep link + web URL support

  # ── Project-specific additions ───────────────────────────
  fsrs: ^1.1.0                 # FSRS spaced repetition algorithm
  uuid: ^4.5.1                 # client-side UUID generation for offline-first IDs

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  mockito: ^5.4.4
  build_runner: ^2.4.13
  barrel_generator: ^1.0.4
  hive_ce_generator: ^1.0.0
  flutter_launcher_icons: "^0.14.4"
```

### SECTION 14 — UNIT TEST PLAN

PROVIDER TESTS:
```
auth_provider_test.dart — MockSupabaseService, MockHiveService
  - initial state: not authenticated
  - signIn success: profile set
  - signIn failure: error set
  - signUp success: profile created
  - signOut: profile cleared
  - restoreSession with cache: loads from Hive

deck_provider_test.dart — MockSupabaseService, MockHiveService
  - initial state: empty
  - fetchDecks success: populated + cached
  - createDeck: added to userDecks
  - updateDeck: updated in list
  - deleteDeck: removed
  - premadeDecks getter: filters correctly

card_provider_test.dart — MockSupabaseService, MockHiveService
  - fetchCards success: populated
  - addCard: appended
  - updateCard: updated
  - deleteCard: removed
  - reorderCards: sortOrder updated

quiz_provider_test.dart — MockSupabaseService, MockHiveService, MockFsrsService, QuizQueueController
  - startSession: session created, currentCard set
  - submitAnswer incorrect: card requeued
  - submitAnswer correct: awaits rating
  - submitSelfRating Again: card requeued
  - submitSelfRating Good: card removed, queue advances
  - completeSession: isComplete true, FSRS enrollment triggered
  - answer matching: case-insensitive, comma-separated, trimmed

fsrs_provider_test.dart — MockFsrsService, MockHiveService, MockSupabaseService
  - fetchDueCards with due: populated
  - fetchDueCards none due: empty
  - submitReview: card updated, advances
  - enrollCardsFromQuiz: FsrsCardState created per rated card

leaderboard_provider_test.dart — MockSupabaseService
  - fetchLeaderboard: sorted by quizScore
  - fetchLeaderboard with language filter: filtered correctly

streak_provider_test.dart — MockSupabaseService, MockHiveService
  - recordActivity same day: no change
  - recordActivity consecutive: incremented
  - recordActivity gap: reset to 1
  - longestStreak updated when exceeded

research_provider_test.dart — MockSupabaseService
  - redeemCode valid: returns unlocked flow
  - redeemCode invalid: error set
  - generateCode: code created
  - submitSurvey: response saved
  - submitSurvey duplicate: error (UNIQUE)
  - submitVocabularyTest: result saved
  - SUS score computed correctly
```

CONTROLLER TESTS:
```
quiz_queue_controller_test.dart — pure logic
  - initialize: queue populated
  - dequeue: returns next, length decreases
  - requeue: card goes to end
  - isEmpty: true when done
  - multiple requeues: card reappears
```

SERVICE TESTS:
```
supabase_service_test.dart — mock Supabase client
  - signIn success / wrong credentials
  - fetchDecks / insertDeck
  - redeemResearchCode valid / already used

hive_service_test.dart — Hive with temp directory
  - save/get profile round-trip
  - save/get decks round-trip
  - getDueCards filters by date
  - clearAll empties all boxes
  - notification hour get/set

fsrs_service_test.dart — no mocks
  - createNewCard: state=new
  - scheduleCard Good: future due
  - scheduleCard Again: soon due
  - reviewCard: state updated

notification_service_test.dart — mock plugin
  - scheduleReviewReminder: correct params
  - cancelAll: calls cancelAll
```

WIDGET TESTS:
```
login_page_test.dart — renders fields, validates, calls signIn, navigates
home_page_test.dart — renders streak, due count, loading skeleton, empty
deck_list_page_test.dart — renders grid, empty state, tap navigates, FAB
quiz_session_page_test.dart — renders question, submits answer, shows rating, completes
review_page_test.dart — renders card, tap reveals, rating buttons, empty state
researcher_dashboard_page_test.dart — renders tabs, code list, generates code
survey_page_test.dart — renders Likert items, submit disabled until complete, submits
vocabulary_test_page_test.dart — renders 30 MC questions, tracks score, submits
```

TEST HELPERS:
```
fake_deck.dart — fakeDeck(), fakeDeckList()
fake_deck_card.dart — fakeDeckCard(), fakeDeckCardList()
fake_user_profile.dart — fakeUserProfile()
fake_quiz_session.dart — fakeQuizSession()
fake_fsrs_card_state.dart — fakeFsrsCardState()
mock_supabase_service.dart — @GenerateMocks([SupabaseService])
mock_hive_service.dart — @GenerateMocks([HiveService])
mock_fsrs_service.dart — @GenerateMocks([FsrsService])
pump_app.dart — pumpApp() wraps with all providers + MaterialApp + router
```

### SECTION 15 — OPEN QUESTIONS (RESOLVED)

All 10 open questions have been resolved:
1. Quiz accepts multiple comma-separated answers, case-insensitive match
2. Vocabulary test is multiple choice A/B/C/D, 30 items per set
3. All survey question text provided — see references/survey_questions.md
4. Premade deck uploaded via UI; mock data seeded for dev
5. Leaderboard is global with optional target language filter
6. Streak = at least one FSRS review per day
7. Card images supported in v1
8. Notification fires on the exact day card is due, at user-configurable hour (default 9 AM)
9. Group B sees only code entry screen
10. Offline sync is automatic when connectivity returns

### SURVEY QUESTION REFERENCE

All survey items are defined in references/survey_questions.md. Key details:

Proficiency Screener (6 Likert + 1 categorical):
1. I can recognize basic vocabulary in my target language
2. I can read simple sentences in my target language
3. I can understand basic written instructions in my target language
4. I have formally studied this language before
5. I interact with this language regularly
6. I have used a language learning app before
+ Proficiency level: none / beginner / elementary / intermediate / advanced

Language Interest (5 Likert):
1. I am genuinely interested in learning my target language
2. I am motivated to improve my proficiency
3. Learning this language is important to my goals
4. I enjoy consuming content in this language
5. I plan to continue studying after this study

Experience Survey — Enjoyment (5), Engagement (5), Motivation (5) = 15 items total
Collected at short_term and long_term time points.

Preview Usefulness (5 Likert) — Group A only
FSRS Usefulness (5 Likert) — Group A only
UGC Perception (6 Likert) — both groups
SUS (10 standard items) — Group A only, score formula: ((sum odd - 5) + (25 - sum even)) * 2.5

Scoring: Mean ≥ 3.50 acceptable. SUS ≥ 68 acceptable.

## DESIGN REFERENCE

Design system from references/gemini_design_system.md. Concept art from references/gemini_design_system.html.

Color palette:
  Primary: #5C6BC0 (light) / #7986CB (dark)
  Secondary: #FF7043 / #FF8A65
  Tertiary: #26A69A / #4DB6AC
  Background: #F8F9FA / #121212
  Surface: #FFFFFF / #1E1E1E
  Surface Variant: #F0F2F5 / #2C2C2C
  Error: #E53935 / #EF5350
  Text Primary: #212121 / #E0E0E0
  Text Secondary: #757575 / #9E9E9E

Semantic colors:
  Correct/Good: #4CAF50 / #81C784
  Incorrect/Again: #F44336 / #E57373
  Hard: #FF9800 / #FFB74D
  Easy: #2196F3 / #64B5F6
  Streak Fire: #FFC107 / #FFD54F

Typography: Noto Sans (Google Fonts, CJK support)
  displayLarge: 48px/Bold, headlineMedium: 28px/Bold, titleLarge: 22px/SemiBold
  titleMedium: 16px/SemiBold, bodyLarge: 16px/Regular, bodyMedium: 14px/Regular
  labelLarge: 14px/Medium, labelSmall: 11px/Medium

Component styles:
  Cards: border-radius 16px, 1px border surface variant, shadow Y:2 blur:8 5% opacity
  Buttons: border-radius 12px, primary filled #5C6BC0, rating buttons 15% opacity bg
  Input fields: border-radius 12px, surface variant bg, 2px primary border on focus
  Bottom nav: surface color, 1px top border, active icon primary + scale 1.1x
  Badges: pill shape (100px radius), semantic color at 15% opacity
  Bottom sheets: top-left/right 24px radius, drag handle 4x32px

Animation durations:
  Card flip: 400ms easeInOutCubic (Y-axis rotation)
  Page transitions: 300ms fade-through or slide-up
  Score reveal: 600ms spring with count-up + scale bounce 1.2→1.0
  Button press: 100ms scale 0.95, 100ms back to 1.0
  Incorrect shake: 400ms, 3 horizontal shakes ±4px + error color border flash

## THEMEDATA IMPLEMENTATION

Implement in lib/shared/main_theme.dart using:
- Custom ColorScheme matching the palette above for both light and dark
- TextTheme with Noto Sans at the specified sizes and weights
- CardTheme: shape RoundedRectangleBorder(16), side BorderSide(surfaceVariant, 1)
- FilledButtonTheme: shape RoundedRectangleBorder(12), backgroundColor primary
- OutlinedButtonTheme: shape RoundedRectangleBorder(12), side BorderSide(surfaceVariant, 2)
- InputDecorationTheme: border radius 12, filled true, fillColor surfaceVariant
- NavigationBarTheme: surfaceTintColor transparent, indicatorColor primary
- BottomSheetTheme: shape top-left/right 24px radius
- Both light and dark ThemeData

Constants split across lib/shared/:
  - theme_constants.dart — all color hex values, shadow definitions, border radii
  - app_typography.dart — TextStyle constants + TextTheme builder
  - app_spacing.dart — xs(4), sm(8), md(16), lg(24), xl(32), xxl(48)
  - breakpoints.dart — mobile(<600), tablet(600-1024), desktop(>1024)
  - env.dart — Supabase URL, anon key, storage bucket names

## HOW TO REQUEST CODE

When you ask me to build something, I will:
1. State which files I am creating
2. State which providers and hooks are involved
3. Output each file in full with the header format above
4. Output the corresponding test file(s) immediately after each class
5. Tell you where to register any new providers in main.dart
6. Tell you if any new packages need to be added to pubspec.yaml

Every class I generate ships with its test. This is non-negotiable.
I will never output a provider, service, or widget without its test file.

To ask me to build something, say:
  BUILD: [feature or screen name]
  REFACTOR: [file path] [what to change]
  ADD: [specific thing to add to existing file]
  EXPLAIN: [any part of the spec or code]
  TEST: [file path] — generate or fix tests for a specific file
