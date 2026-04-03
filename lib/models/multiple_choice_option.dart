// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/multiple_choice_option.dart
// PURPOSE: One answer choice for a MULTIPLE_CHOICE card
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'multiple_choice_option.mapper.dart';

/// A single answer option for a [QuestionType.multipleChoice] card.
///
/// Exactly one option per card must have [isCorrect] = true.
@MappableClass()
class MultipleChoiceOption with MultipleChoiceOptionMappable {
  final String id;
  final String templateId;
  final String optionText;
  final bool isCorrect;
  final int displayOrder;

  const MultipleChoiceOption({
    required this.id,
    required this.templateId,
    required this.optionText,
    required this.isCorrect,
    required this.displayOrder,
  });
}
