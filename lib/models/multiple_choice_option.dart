// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/multiple_choice_option.dart
// PURPOSE: One answer choice for a MULTIPLE_CHOICE card
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// A single answer option for a [QuestionType.multipleChoice] card.
///
/// Exactly one option per card must have [isCorrect] = true.
class MultipleChoiceOption {
  final String id;
  final String cardId;
  final String optionText;
  final bool isCorrect;
  final int displayOrder;

  const MultipleChoiceOption({
    required this.id,
    required this.cardId,
    required this.optionText,
    required this.isCorrect,
    required this.displayOrder,
  });

  factory MultipleChoiceOption.fromJson(Map<String, dynamic> json) =>
      MultipleChoiceOption(
        id: json['id'] as String,
        cardId: json['card_id'] as String,
        optionText: json['option_text'] as String,
        isCorrect: json['is_correct'] as bool,
        displayOrder: json['display_order'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'card_id': cardId,
        'option_text': optionText,
        'is_correct': isCorrect,
        'display_order': displayOrder,
      };

  MultipleChoiceOption copyWith({
    String? id,
    String? cardId,
    String? optionText,
    bool? isCorrect,
    int? displayOrder,
  }) =>
      MultipleChoiceOption(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        optionText: optionText ?? this.optionText,
        isCorrect: isCorrect ?? this.isCorrect,
        displayOrder: displayOrder ?? this.displayOrder,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultipleChoiceOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MultipleChoiceOption(text: $optionText, correct: $isCorrect)';
}
