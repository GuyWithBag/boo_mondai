// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/deck_card.dart
// PURPOSE: A single question/answer card within a deck
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class DeckCard {
  final String id;
  final String deckId;
  final String question;
  final String answer;
  final String? questionImageUrl;
  final String? answerImageUrl;
  final int sortOrder;
  final DateTime createdAt;

  const DeckCard({
    required this.id,
    required this.deckId,
    required this.question,
    required this.answer,
    this.questionImageUrl,
    this.answerImageUrl,
    required this.sortOrder,
    required this.createdAt,
  });

  /// Returns the list of accepted answers, split by comma and trimmed.
  List<String> get acceptedAnswers =>
      answer.split(',').map((a) => a.trim().toLowerCase()).toList();

  /// Checks if [userAnswer] matches any of the accepted answers (case-insensitive).
  bool checkAnswer(String userAnswer) =>
      acceptedAnswers.contains(userAnswer.trim().toLowerCase());

  factory DeckCard.fromJson(Map<String, dynamic> json) => DeckCard(
        id: json['id'] as String,
        deckId: json['deck_id'] as String,
        question: json['question'] as String,
        answer: json['answer'] as String,
        questionImageUrl: json['question_image_url'] as String?,
        answerImageUrl: json['answer_image_url'] as String?,
        sortOrder: json['sort_order'] as int? ?? 0,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'deck_id': deckId,
        'question': question,
        'answer': answer,
        'question_image_url': questionImageUrl,
        'answer_image_url': answerImageUrl,
        'sort_order': sortOrder,
        'created_at': createdAt.toIso8601String(),
      };

  DeckCard copyWith({
    String? id,
    String? deckId,
    String? question,
    String? answer,
    String? questionImageUrl,
    String? answerImageUrl,
    int? sortOrder,
    DateTime? createdAt,
  }) =>
      DeckCard(
        id: id ?? this.id,
        deckId: deckId ?? this.deckId,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        questionImageUrl: questionImageUrl ?? this.questionImageUrl,
        answerImageUrl: answerImageUrl ?? this.answerImageUrl,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckCard && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'DeckCard(id: $id, question: $question, answer: $answer)';
}
