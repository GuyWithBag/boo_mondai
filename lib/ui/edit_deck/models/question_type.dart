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
/// - [matchMadness]   → drag-and-drop term↔match pairs from [MatchingTypeValue]s
///
/// Constraints:
/// - Only [flashcard] supports [CardTemplateDirection.reversed] / [CardTemplateDirection.both].
///   All other types must use [CardTemplateDirection.normal].
/// - [matchMadness] → Notes are NOT generated; content lives in [MatchingTypeValue]s only.
/// - [wordScramble] → Note.frontText stores the full sentence; words are split at runtime.
/// - [identification] → template prompt stores the prompt; accepted answers are
///   ordered answer objects with per-answer casing rules.
@MappableEnum()
enum CardTemplateType {
  flashcard,
  identification,
  multipleChoice,
  fillInTheBlanks,
  wordScramble,
  matchMadness;

  /// True when this type supports [CardTemplateDirection.reversed] / [CardTemplateDirection.both].
  /// Currently only [flashcard].
  bool get canBeReversible => this == flashcard;

  /// True when the card uses [MultipleChoiceOption]s.
  bool get usesOptions => this == multipleChoice;

  /// True when the card uses fill-in-the-blank answer keys.
  bool get usesSegments => this == fillInTheBlanks;

  /// True when the card uses [MatchingTypeValue]s (and no Notes).
  bool get usesPairs => this == matchMadness;

  /// True when accepted answers are stored as ordered answer objects rather than
  /// in Note.backText.
  bool get usesIdentificationAnswerKey => this == identification;
}
