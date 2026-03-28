// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/fill_in_the_blank_segment.dart
// PURPOSE: Defines one blank within a FILL_IN_THE_BLANKS or READ_AND_COMPLETE card
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// One segment of a [QuestionType.fillInTheBlanks] card.
///
/// [fullText] is the complete sentence. [blankStart] and [blankEnd] are
/// character indices into [fullText] that mark the hidden word(s).
/// [correctAnswer] is the expected text for that blank (case-insensitive match).
class FillInTheBlankSegment {
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

  /// The visible text with the blank replaced by underscores.
  String get displayText =>
      '${fullText.substring(0, blankStart)}'
      '${'_' * (blankEnd - blankStart)}'
      '${fullText.substring(blankEnd)}';

  /// Case-insensitive answer check.
  bool checkAnswer(String userAnswer) =>
      userAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();

  factory FillInTheBlankSegment.fromJson(Map<String, dynamic> json) =>
      FillInTheBlankSegment(
        id: json['id'] as String,
        cardId: json['card_id'] as String,
        fullText: json['full_text'] as String,
        blankStart: json['blank_start'] as int,
        blankEnd: json['blank_end'] as int,
        correctAnswer: json['correct_answer'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'card_id': cardId,
        'full_text': fullText,
        'blank_start': blankStart,
        'blank_end': blankEnd,
        'correct_answer': correctAnswer,
      };

  FillInTheBlankSegment copyWith({
    String? id,
    String? cardId,
    String? fullText,
    int? blankStart,
    int? blankEnd,
    String? correctAnswer,
  }) =>
      FillInTheBlankSegment(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        fullText: fullText ?? this.fullText,
        blankStart: blankStart ?? this.blankStart,
        blankEnd: blankEnd ?? this.blankEnd,
        correctAnswer: correctAnswer ?? this.correctAnswer,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FillInTheBlankSegment &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'FillInTheBlankSegment(cardId: $cardId, answer: $correctAnswer)';
}
