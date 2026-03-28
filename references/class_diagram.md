# BooMondai — Class Diagrams
> Last updated: 2026-03-28

---

## 1. Data Models

### 1a. Deck & Card system

A `Deck` contains many `DeckCard`s. Each `DeckCard` stores **only type metadata** —
the presentable content lives in one of four child node types depending on `questionType`:

| questionType | Content nodes |
|---|---|
| `flashcard` | `notes` (1–2, depending on `cardType`) |
| `identification` | `notes` (front prompt only) + `identificationAnswer` string |
| `multipleChoice` | `notes` (front prompt) + `mc_options` |
| `fillInTheBlanks` | `fitb_segments` (1+ blank entries) |
| `wordScramble` | `notes` (front = full sentence to reconstruct) |
| `matchMadness` | `mm_pairs` only — no notes |

`DeckCard.question` and `DeckCard.answer` are **computed getters** (not stored fields)
that delegate to the primary (non-reverse) `Note`. Always use `notes:` in constructors.

```mermaid
classDiagram
    direction TB

    class Deck {
        +String id
        +String creatorId
        +String title
        +String shortDescription
        +String longDescription
        +String targetLanguage
        +List~String~ tags
        +bool isPremade
        +bool isPublic
        +bool isUneditable
        +bool hiddenInBrowser
        +bool isPublished
        +int cardCount
        +String version
        +int buildNumber
        +String? sourceDeckId
        +DateTime createdAt
        +DateTime updatedAt
        +fromJson(Map) Deck
        +toJson() Map
        +copyWith() Deck
    }

    class DeckCard {
        +String id
        +String deckId
        +CardType cardType
        +QuestionType questionType
        +int sortOrder
        +String identificationAnswer
        +String? sourceCardId
        +DateTime createdAt
        +List~Note~ notes
        +List~MultipleChoiceOption~ options
        +List~FillInTheBlankSegment~ segments
        +List~MatchMadnessPair~ pairs
        +String question
        +String answer
        +checkAnswer(userAnswer) bool
        +fromJson(Map) DeckCard
        +toJson() Map
        +toCacheJson() Map
        +copyWith() DeckCard
    }

    class Note {
        +String id
        +String cardId
        +String frontText
        +String backText
        +String? frontImageUrl
        +String? backImageUrl
        +String? frontAudioUrl
        +String? backAudioUrl
        +bool isReverse
        +fromJson(Map) Note
        +toJson() Map
        +copyWith() Note
    }

    class MultipleChoiceOption {
        +String id
        +String cardId
        +String optionText
        +bool isCorrect
        +int displayOrder
        +fromJson(Map) MultipleChoiceOption
        +toJson() Map
        +copyWith() MultipleChoiceOption
    }

    class FillInTheBlankSegment {
        +String id
        +String cardId
        +String fullText
        +int blankStart
        +int blankEnd
        +String correctAnswer
        +checkAnswer(input) bool
        +fromJson(Map) FillInTheBlankSegment
        +toJson() Map
    }

    class MatchMadnessPair {
        +String id
        +String cardId
        +String term
        +String match
        +bool isAutoPicked
        +int displayOrder
        +fromJson(Map) MatchMadnessPair
        +toJson() Map
    }

    class CardType {
        <<enumeration>>
        normal
        reversed
        both
    }

    class QuestionType {
        <<enumeration>>
        flashcard
        identification
        multipleChoice
        fillInTheBlanks
        wordScramble
        matchMadness
    }

    Deck "1" --> "0..*" DeckCard : contains
    DeckCard "1" --> "0..*" Note : notes
    DeckCard "1" --> "0..*" MultipleChoiceOption : options
    DeckCard "1" --> "0..*" FillInTheBlankSegment : segments
    DeckCard "1" --> "0..*" MatchMadnessPair : pairs
    DeckCard --> CardType
    DeckCard --> QuestionType
```

### 1b. Quiz & FSRS system

A `QuizSession` records which deck was attempted. Each card answered produces a
`QuizAnswer` (stored in-memory during the quiz, batch-inserted on complete).
On session complete, correctly-rated cards are enrolled as `FsrsCardState` entries
in Hive. Each subsequent FSRS review adds a `ReviewLogEntry`.

```mermaid
classDiagram
    direction TB

    class UserProfile {
        +String id
        +String email
        +String displayName
        +String role
        +String? avatarUrl
        +String? targetLanguage
        +DateTime createdAt
        +fromJson(Map) UserProfile
        +toJson() Map
        +copyWith() UserProfile
    }

    class QuizSession {
        +String id
        +String userId
        +String deckId
        +bool previewed
        +int totalQuestions
        +int correctCount
        +DateTime startedAt
        +DateTime? completedAt
        +fromJson(Map) QuizSession
        +toJson() Map
    }

    class QuizAnswer {
        +String id
        +String sessionId
        +String cardId
        +String userAnswer
        +bool isCorrect
        +int? selfRating
        +DateTime answeredAt
        +fromJson(Map) QuizAnswer
        +toJson() Map
    }

    class FsrsCardState {
        +String id
        +String userId
        +String cardId
        +DateTime due
        +double stability
        +double difficulty
        +int elapsedDays
        +int scheduledDays
        +int reps
        +int lapses
        +int state
        +DateTime? lastReview
        +fromJson(Map) FsrsCardState
        +toJson() Map
        +copyWith() FsrsCardState
    }

    class ReviewLogEntry {
        +String id
        +String userId
        +String cardId
        +int rating
        +int scheduledDays
        +int elapsedDays
        +DateTime review
        +int state
        +fromJson(Map) ReviewLogEntry
        +toJson() Map
    }

    class Streak {
        +String id
        +String userId
        +int currentStreak
        +int longestStreak
        +DateTime? lastActivityDate
        +fromJson(Map) Streak
        +toJson() Map
        +copyWith() Streak
    }

    class LeaderboardEntry {
        +String userId
        +String displayName
        +String? targetLanguage
        +int quizScore
        +int reviewCount
        +int currentStreak
        +fromJson(Map) LeaderboardEntry
    }

    %% Relationships
    UserProfile "1" --> "0..*" Deck : creates
    UserProfile "1" --> "0..*" QuizSession : takes
    UserProfile "1" --> "1" Streak : has
    UserProfile "1" --> "0..*" FsrsCardState : owns

    QuizSession "1" --> "0..*" QuizAnswer : records

    DeckCard "1" --> "0..*" QuizAnswer : answered as
    DeckCard "1" --> "0..*" FsrsCardState : tracked by
    DeckCard "1" --> "0..*" ReviewLogEntry : reviewed in

    FsrsCardState ..> ReviewLogEntry : logs to
```

---

## 2. Providers & Services

### Local-first data flow

```
UI widgets
  │ watch / read
  ▼
Providers (ChangeNotifier)
  │ all writes → Hive first
  │ Supabase: push on demand (cards) or best-effort (FSRS, quiz)
  ▼
HiveService ──────────────────────► Hive boxes (local)
SupabaseService ──────────────────► Supabase (remote)
```

```mermaid
classDiagram
    direction TB

    class DeckProvider {
        -SupabaseService _supabase
        -HiveService _hive
        -List~Deck~ _decks
        -List~Deck~ _userDecks
        +List~Deck~ decks
        +List~Deck~ userDecks
        +List~Deck~ premadeDecks
        +loadFromCache(userId) int
        +fetchDecks() Future
        +fetchUserDecks(userId) Future
        +createDeck(userId, title, desc, lang) Future~Deck?~
        +updateDeck(deck) Future
        +deleteDeck(deckId) Future
        note: deleteDeck is local-first — Hive immediately,\nSupabase best-effort (errors swallowed)
    }

    class CardProvider {
        -SupabaseService _supabase
        -HiveService _hive
        -List~DeckCard~ _cards
        -Set~String~ _dirtyDeckIds
        -bool _isPushing
        +List~DeckCard~ cards
        +String? currentDeckId
        +bool isPushing
        +isDirty(deckId) bool
        +fetchCards(deckId) Future
        +addCard(deckId, cardType, questionType, ...) Future~DeckCard?~
        +updateCard(card) Future
        +deleteCard(cardId) Future
        +reorderCards(cards) Future
        +pushDeck(deckId) Future
        note: add/update/delete/reorder → Hive only\npushDeck → batch sync to Supabase
    }

    class QuizProvider {
        -SupabaseService _supabase
        -HiveService _hive
        -FsrsService _fsrs
        -QuizQueueController _queue
        -QuizSession? _session
        -DeckCard? _currentCard
        -List~QuizAnswer~ _answers
        -Map~String,int~ _wrongCounts
        +QuizSession? session
        +DeckCard? currentCard
        +double progress
        +bool isComplete
        +List~FsrsCardState~ enrolledCards
        +int reviewableNowCount
        +int reviewLaterCount
        +startSession(deckId, userId, cards, previewed) Future
        +submitAnswer(userAnswer) void
        +submitSelfRating(rating) Future
        +revealAnswer() void
        +submitIdentificationAnswer(answer) void
        +submitFitbAnswers(answers) void
        note: no Supabase calls until completeSession()\nbatch-insert session + answers + FSRS on complete
    }

    class FsrsProvider {
        -FsrsService _fsrs
        -HiveService _hive
        -SupabaseService _supabase
        -List~FsrsCardState~ _dueCards
        -List~FsrsCardState~ _upcomingCards
        -Map~String,DeckCard~ _deckCardCache
        -int _currentIndex
        +List~FsrsCardState~ dueCards
        +List~FsrsCardState~ upcomingCards
        +int dueCount
        +FsrsCardState? currentReviewCard
        +DeckCard? currentDeckCard
        +bool isReviewComplete
        +fetchDueCards(userId) Future
        +startReview() void
        +submitReview(rating) Future
        note: due = cards with due <= now + 1 hour\nupcoming = cards due > now + 1 hour\nFSRS sync to Supabase is offline-tolerant
    }

    class QuizQueueController {
        -Queue~DeckCard~ _queue
        -Map~String,int~ _wrongCounts
        +int length
        +bool isEmpty
        +DeckCard? current
        +initialize(cards) void
        +advance() void
        +requeue(card) void
        +wrongCount(cardId) int
        +incrementWrong(cardId) void
        note: tracks per-card wrong count\nauto-eject at 3 strikes
    }

    class AuthProvider {
        -SupabaseService _supabase
        -HiveService _hive
        -UserProfile? _userProfile
        +UserProfile? userProfile
        +bool isAuthenticated
        +String? role
        +signIn(email, password) Future
        +signUp(email, password, displayName) Future
        +signOut() Future
        +restoreSession() Future
        +clearError() void
    }

    class StreakProvider {
        -SupabaseService _supabase
        -HiveService _hive
        -Streak? _streak
        +int currentStreak
        +int longestStreak
        +fetchStreak(userId) Future
        +recordActivity(userId) Future
    }

    class LeaderboardProvider {
        -SupabaseService _supabase
        -List~LeaderboardEntry~ _entries
        -String? _filteredLanguage
        +List~LeaderboardEntry~ entries
        +fetchLeaderboard(targetLanguage?) Future
        +setLanguageFilter(language?) void
    }

    class ResearchProvider {
        -SupabaseService _supabase
        -List~ResearchCode~ _codes
        -List~ResearchUser~ _researchUsers
        +redeemCode(userId, code) Future~String~
        +generateCode(createdBy, role, unlocks) Future~ResearchCode~
        +submitSurvey(userId, type, timePoint, responses) Future
        +submitVocabularyTest(userId, set, score, answers) Future
        +fetchAllResearchData() Future
        +addResearchUser(userId, role, targetLanguage) Future
    }

    class SupabaseService {
        -SupabaseClient _client
        +signIn(email, password) Future
        +signUp(email, password) Future
        +signOut() Future
        +getProfile(userId) Future
        +upsertProfile(data) Future
        +fetchDecks(publicOnly?) Future
        +insertDeck(data) Future
        +updateDeck(id, data) Future
        +deleteDeck(id) Future
        +fetchUserDecks(userId) Future
        +fetchCards(deckId) Future
        +upsertCardRow(data) Future
        +deleteChildrenByCardId(cardId) Future
        +deleteOrphanCards(deckId, keepIds) Future
        +batchInsertNotes(data) Future
        +batchInsertMCOptions(data) Future
        +batchInsertFITBSegments(data) Future
        +batchInsertMMPairs(data) Future
        +insertQuizSession(data) Future
        +batchInsertQuizAnswers(data) Future
        +upsertFsrsCard(data) Future
        +insertReviewLog(data) Future
        +fetchLeaderboard(lang?) Future
        +upsertStreak(data) Future
        +fetchStreak(userId) Future
        +fetchResearchCodes() Future
        +redeemResearchCode(code, userId) Future
        +insertSurveyResponse(table, data) Future
        +fetchAllResearchData() Future
        +insertResearchUser(data) Future
        +uploadImage(bucket, path, bytes) Future~String~
        note: all methods throw AppException on failure
    }

    class HiveService {
        +init() Future
        +saveProfile(profile) Future
        +getProfile() UserProfile?
        +saveDecks(decks) Future
        +getDecks() List~Deck~
        +saveDeck(deck) Future
        +deleteDeck(deckId) Future
        +getUserDecks(userId) List~Deck~
        +saveCards(deckId, cards) Future
        +getCards(deckId) List~DeckCard~
        +deleteCard(cardId) Future
        +saveFsrsCard(state) Future
        +getFsrsCard(key) FsrsCardState?
        +getAllFsrsCards(userId) List~FsrsCardState~
        +getDueCards(userId, now) List~FsrsCardState~
        +saveReviewLog(entry) Future
        +saveStreak(streak) Future
        +getStreak(userId) Streak?
        +getNotificationHour() int
        +setNotificationHour(hour) Future
        +clearAll() Future
    }

    class FsrsService {
        +createNewCard() Card
        +scheduleCard(card, rating) SchedulingInfo
        +reviewCard(state, ratingValue) FsrsCardState
        +enrollCard(userId, cardId, ratingValue) FsrsCardState
        note: ratingValue is 1-indexed (1=Again, 2=Hard, 3=Good, 4=Easy)\nRating.values uses ratingValue - 1 internally
    }

    %% Provider → Service dependencies
    AuthProvider --> SupabaseService
    AuthProvider --> HiveService
    DeckProvider --> SupabaseService
    DeckProvider --> HiveService
    CardProvider --> SupabaseService
    CardProvider --> HiveService
    QuizProvider --> SupabaseService
    QuizProvider --> HiveService
    QuizProvider --> FsrsService
    QuizProvider --> QuizQueueController
    FsrsProvider --> FsrsService
    FsrsProvider --> HiveService
    FsrsProvider --> SupabaseService
    StreakProvider --> SupabaseService
    StreakProvider --> HiveService
    LeaderboardProvider --> SupabaseService
    ResearchProvider --> SupabaseService
```
