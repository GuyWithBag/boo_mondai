// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/fill_in_the_blank_segment.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/services/uuid.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'fill_in_the_blank_segment.dto.mapper.dart';

@MappableClass()
class FillInTheBlankSegment with FillInTheBlankSegmentMappable {
  final String id;
  final String cardId;
  final String fullText;
  final int blankStart;
  final int blankEnd;
  final String correctAnswer;

  const FillInTheBlankSegment({
    required this.id,
    required this.cardId,
    required this.fullText,
    required this.blankStart,
    required this.blankEnd,
    required this.correctAnswer,
  });

  factory FillInTheBlankSegment.createDummy({String? id, String cardId = ''}) {
    return FillInTheBlankSegment(
      id: id ?? uuid.v7(),
      cardId: cardId,
      fullText: '',
      blankStart: 0,
      blankEnd: 0,
      correctAnswer: '',
    );
  }

  // ── NEW HELPERS (Move these below the constructor) ─────

  /// The text appearing before the blank
  String get prefix => fullText.substring(0, blankStart);

  /// The text appearing after the blank
  String get suffix => fullText.substring(blankEnd);

  /// Helper for the UI logic
  bool get isBlank => true;

  /// The visible text with the blank replaced by underscores.
  String get displayText =>
      '${fullText.substring(0, blankStart)}'
      '${'_' * (blankEnd - blankStart)}'
      '${fullText.substring(blankEnd)}';

  /// Case-insensitive answer check.
  bool checkAnswer(String userAnswer) =>
      userAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();
}
