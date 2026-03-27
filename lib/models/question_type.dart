// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/question_type.dart
// PURPOSE: Enum — determines the quiz interaction style for a card
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// The quiz interaction style presented to the learner.
///
/// - [readAndSelect]    → see the front, type/match the back (default)
/// - [multipleChoice]   → see the front, pick from [MultipleChoiceOption]s
/// - [fillInTheBlanks]  → sentence with a single blank; answer from [FillInTheBlankSegment]
/// - [readAndComplete]  → sentence with multiple blanks; answers from [FillInTheBlankSegment]s
/// - [listenAndType]    → hear the front audio, type the answer
/// - [matchMadness]     → drag-and-drop term↔match pairs from [MatchMadnessPair]s
///
/// Constraints:
/// - [multipleChoice], [fillInTheBlanks], [readAndComplete], [matchMadness]
///   → CardType must be [CardType.normal] (cannot be reversed)
/// - [listenAndType] → reversible only when both front & back have audio
/// - [matchMadness]  → Notes are NOT generated; content lives in [MatchMadnessPair]s only
enum QuestionType {
  readAndSelect,
  multipleChoice,
  fillInTheBlanks,
  readAndComplete,
  listenAndType,
  matchMadness;

  static const _fromDb = <String, QuestionType>{
    'read_and_select': readAndSelect,
    'multiple_choice': multipleChoice,
    'fill_in_the_blanks': fillInTheBlanks,
    'read_and_complete': readAndComplete,
    'listen_and_type': listenAndType,
    'match_madness': matchMadness,
  };

  static QuestionType fromString(String? s) =>
      _fromDb[s] ?? readAndSelect;

  String toJson() => switch (this) {
        readAndSelect => 'read_and_select',
        multipleChoice => 'multiple_choice',
        fillInTheBlanks => 'fill_in_the_blanks',
        readAndComplete => 'read_and_complete',
        listenAndType => 'listen_and_type',
        matchMadness => 'match_madness',
      };

  /// True when the question type supports [CardType.reversible] / [CardType.both].
  bool get canBeReversible =>
      this == readAndSelect || this == listenAndType;

  /// True when the card uses [MultipleChoiceOption]s instead of free-text.
  bool get usesOptions => this == multipleChoice;

  /// True when the card uses [FillInTheBlankSegment]s.
  bool get usesSegments =>
      this == fillInTheBlanks || this == readAndComplete;

  /// True when the card uses [MatchMadnessPair]s (and no Notes).
  bool get usesPairs => this == matchMadness;
}
