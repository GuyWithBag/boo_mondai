import 'package:boo_mondai/features/cards/models/card_template.dto.dart';
import 'package:boo_mondai/features/cards/models/identification_answer.dto.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';
import 'package:boo_mondai/core/services/uuid.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'identification_template.dto.mapper.dart';

@MappableClass(discriminatorValue: 'identification')
class IdentificationTemplate extends CardTemplate
    with IdentificationTemplateMappable {
  final String promptText;
  @MappableField(key: 'accepted_answers')
  final List<IdentificationAnswer> acceptedAnswers;

  const IdentificationTemplate({
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
    required this.promptText,
    required this.acceptedAnswers,
  });

  factory IdentificationTemplate.createDummy({
    String? id,
    String deckId = '',
    int sortOrder = 0,
  }) {
    final now = DateTime.now();
    final resolvedId = id ?? uuid.v7();
    return IdentificationTemplate(
      id: resolvedId,
      deckId: deckId,
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
      promptText: '',
      acceptedAnswers: [
        IdentificationAnswer.createDummy(templateId: resolvedId),
      ],
    );
  }

  @override
  bool checkAnswer(String userAnswer, {bool isReversed = false}) {
    return acceptedAnswers.any((answer) => answer.accepts(userAnswer));
  }
}
