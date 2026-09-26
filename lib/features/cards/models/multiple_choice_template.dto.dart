import 'package:boo_mondai/features/cards/models/card_template.dto.dart';
import 'package:boo_mondai/features/cards/models/multiple_choice_option.dto.dart';
import 'package:boo_mondai/features/study_session/models/study_session.answer.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';
import 'package:boo_mondai/core/services/uuid.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'multiple_choice_template.dto.mapper.dart';

@MappableClass(discriminatorValue: 'multiple_choice')
class MultipleChoiceTemplate extends CardTemplate
    with MultipleChoiceTemplateMappable {
  final String questionPrompt;
  final List<MultipleChoiceOption> options;
  final bool multipleAnswers;
  final bool randomizeOptionsOrdering;

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
    this.multipleAnswers = false,
    this.randomizeOptionsOrdering = false,
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
  bool checkAnswer(StudySessionAnswer answer, {bool isReversed = false}) {
    if (multipleAnswers) {
      final selectedOptionIds = (answer.id ?? answer.value)
          .split('|')
          .map(_optionIdForAnswer)
          .whereType<String>()
          .toSet();
      final correctOptionIds = options
          .where((option) => option.isCorrect)
          .map((option) => option.id)
          .toSet();
      return selectedOptionIds.length == correctOptionIds.length &&
          selectedOptionIds.every(correctOptionIds.contains);
    }

    final submitted = answer.id ?? answer.value;
    final trimmed = submitted.trim().toLowerCase();
    return options.any(
      (o) =>
          o.isCorrect &&
          (o.id == submitted.trim() ||
              o.optionText.trim().toLowerCase() == trimmed),
    );
  }

  String? _optionIdForAnswer(String answer) {
    final trimmed = answer.trim();
    final normalized = trimmed.toLowerCase();
    for (final option in options) {
      if (option.id == trimmed ||
          option.optionText.trim().toLowerCase() == normalized) {
        return option.id;
      }
    }
    return null;
  }
}
