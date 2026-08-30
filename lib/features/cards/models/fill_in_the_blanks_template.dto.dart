import 'package:boo_mondai/features/cards/models/card_template.dto.dart';
import 'package:boo_mondai/features/cards/models/fill_in_the_blank_segment.dto.dart';
import 'package:boo_mondai/core/services/uuid.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'fill_in_the_blanks_template.dto.mapper.dart';

@MappableClass(discriminatorValue: 'fill_in_the_blanks')
class FillInTheBlanksTemplate extends CardTemplate
    with FillInTheBlanksTemplateMappable {
  final List<FillInTheBlankSegment> segments;

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
    required this.segments,
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
      segments: const [],
    );
  }

  @override
  bool checkAnswer(String userAnswer, {bool isReversed = false}) {
    final answers = userAnswer.split('|');

    return segments.isNotEmpty &&
        answers.length == segments.length &&
        segments.asMap().entries.every((entry) {
          return entry.value.checkAnswer(answers[entry.key]);
        });
  }
}
