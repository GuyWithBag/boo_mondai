import 'dart:convert';

import 'package:boo_mondai/features/cards/models/card.template.dto.dart';
import 'package:boo_mondai/features/cards/models/fill_in_the_blank.answer_key.dto.dart';
import 'package:boo_mondai/core/services/uuid.dart';
import 'package:boo_mondai/features/study_session/models/study_session.answer.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'fill_in_the_blanks.template.dto.mapper.dart';

@MappableClass(discriminatorValue: 'fill_in_the_blanks')
class FillInTheBlanksTemplate extends CardTemplate
    with FillInTheBlanksTemplateMappable {
  final String promptText;
  final List<FillInTheBlankAnswerKey> answerKeys;

  const FillInTheBlanksTemplate({
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
    required this.answerKeys,
  });

  factory FillInTheBlanksTemplate.createDummy({
    String? id,
    String deckId = '',
    int sortOrder = 0,
  }) {
    final now = DateTime.now();
    return FillInTheBlanksTemplate(
      id: id ?? uuid.v7(),
      deckId: deckId,
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
      promptText: '',
      answerKeys: const [],
    );
  }

  @override
  bool checkAnswer(StudySessionAnswer answer, {bool isReversed = false}) {
    final dynamic decoded;
    try {
      decoded = jsonDecode(answer.value);
    } on FormatException {
      return false;
    }
    if (decoded is! List || decoded.length != answerKeys.length) return false;

    final keys = [...answerKeys]..sort((a, b) => a.order.compareTo(b.order));
    for (var index = 0; index < keys.length; index++) {
      final value = decoded[index];
      if (value is! String || !keys[index].accepts(value)) return false;
    }
    return true;
  }
}
