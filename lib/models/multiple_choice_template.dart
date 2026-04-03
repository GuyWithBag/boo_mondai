import 'package:boo_mondai/models/models.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'multiple_choice_template.mapper.dart';

@MappableClass(discriminatorValue: 'multiple_choice')
class MultipleChoiceTemplate extends CardTemplate
    with MultipleChoiceTemplateMappable {
  final String questionPrompt;
  final List<MultipleChoiceOption> options;
  final String? imageUrl;
  final String? audioUrl;

  const MultipleChoiceTemplate({
    required super.id,
    required super.deckId,
    required super.sortOrder,
    required super.createdAt,
    super.sourceTemplateId,
    required this.questionPrompt,
    required this.options,
    this.imageUrl,
    this.audioUrl,
  });

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
