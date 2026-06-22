import 'package:boo_mondai/features/cards/models/card_media_attachment.dto.dart';
import 'package:boo_mondai/features/cards/models/card_template.dto.dart';
import 'package:boo_mondai/features/cards/models/multiple_choice_option.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';

part 'multiple_choice_template.dto.mapper.dart';

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
    required super.updatedAt,
    super.sourceTemplateId,
    super.tags,
    super.attachments,
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
