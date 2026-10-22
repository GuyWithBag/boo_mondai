import 'package:boo_mondai/features/cards/models/card.template.dto.dart';
import 'package:boo_mondai/features/cards/models/identification.answer_key.dto.dart';
import 'package:boo_mondai/features/study_session/models/study_session.answer.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';
import 'package:boo_mondai/core/services/uuid.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'identification.template.dto.mapper.dart';

@MappableClass(discriminatorValue: 'identification')
class IdentificationTemplate extends CardTemplate
    with IdentificationTemplateMappable {
  final String promptText;
  final List<IdentificationAnswerKey> answers;

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
    required this.answers,
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
      answers: [IdentificationAnswerKey.createDummy(templateId: resolvedId)],
    );
  }

  @override
  bool checkAnswer(StudySessionAnswer answer, {bool isReversed = false}) {
    return answers.any((accepted) => accepted.accepts(answer.value));
  }
}
