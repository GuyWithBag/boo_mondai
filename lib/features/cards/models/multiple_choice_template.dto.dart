import 'package:boo_mondai/features/cards/models/card_template.dto.dart';
import 'package:boo_mondai/features/cards/models/multiple_choice_option.dto.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';
import 'package:boo_mondai/core/services/uuid.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'multiple_choice_template.dto.mapper.dart';

@MappableClass(discriminatorValue: 'multiple_choice')
class MultipleChoiceTemplate extends CardTemplate
    with MultipleChoiceTemplateMappable {
  final String questionPrompt;
  final List<MultipleChoiceOption> options;

  const MultipleChoiceTemplate({
    required super.id,
    required super.deckId,
    required super.sortOrder,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
    super.purgeAfter,
    super.sourceTemplateId,
    super.tags,
    super.verticallyCentered,
    required this.questionPrompt,
    required this.options,
  });

  factory MultipleChoiceTemplate.createDummy({
    String? id,
    String deckId = '',
    int sortOrder = 0,
  }) {
    final now = DateTime.now();
    final resolvedId = id ?? uuid.v7();
    return MultipleChoiceTemplate(
      id: resolvedId,
      deckId: deckId,
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
      questionPrompt: '',
      options: [
        MultipleChoiceOption.createDummy(
          templateId: resolvedId,
          isCorrect: true,
        ),
      ],
    );
  }

  @override
  bool checkAnswer(String userAnswer, {bool isReversed = false}) {
    final trimmed = userAnswer.trim().toLowerCase();
    return options.any(
      (o) =>
          o.isCorrect &&
          (o.id == userAnswer.trim() ||
              o.optionText.trim().toLowerCase() == trimmed),
    );
  }
}
