// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/question_type.dart
// PURPOSE: Enum — determines the drill interaction style for a card
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'question_type.mapper.dart';

/// The drill interaction style presented to the learner.
///
/// - [flashcard]      → show front, learner reveals back and self-grades (no typing)
/// - [identification] → show front, learner must type an accepted answer; self-grade follows
/// - [multipleChoice] → show front, pick from [MultipleChoiceOption]s
/// - [fillInTheBlanks]→ sentence with one or more blanks; type each missing word
/// - [wordScramble]   → tap shuffled word chips to reconstruct the original sentence
/// - [matchMadness]   → drag-and-drop term↔match pairs from [MatchMadnessPair]s
///
/// Constraints:
/// - Only [flashcard] supports [CardType.reversed] / [CardType.both].
///   All other types must use [CardType.normal].
/// - [matchMadness] → Notes are NOT generated; content lives in [MatchMadnessPair]s only.
/// - [wordScramble] → Note.frontText stores the full sentence; words are split at runtime.
/// - [identification] → Note.frontText is the prompt; acceptable answers are stored
///   in [DeckCard.identificationAnswer] (comma-separated), not in Note.backText.
@MappableEnum()
enum QuestionType {
  flashcard,
  identification,
  multipleChoice,
  fillInTheBlanks,
  wordScramble,
  matchMadness;

  /// True when this type supports [CardType.reversed] / [CardType.both].
  /// Currently only [flashcard].
  bool get canBeReversible => this == flashcard;

  /// True when the card uses [MultipleChoiceOption]s.
  bool get usesOptions => this == multipleChoice;

  /// True when the card uses [FillInTheBlankSegment]s.
  bool get usesSegments => this == fillInTheBlanks;

  /// True when the card uses [MatchMadnessPair]s (and no Notes).
  bool get usesPairs => this == matchMadness;

  /// True when accepted answers are stored in [DeckCard.identificationAnswer]
  /// rather than in Note.backText.
  bool get usesIdentificationAnswer => this == identification;
}
