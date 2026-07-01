import 'package:boo_mondai/features/cards/models/card_template.dto.dart';
import 'package:boo_mondai/features/cards/models/fill_in_the_blank_segment.dto.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:boo_mondai/features/card_attachments/models/card_media_attachment.dto.dart';

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
    super.sourceTemplateId,
    super.tags,
    super.attachments,
    required this.segments,
  });

  @override
  bool checkAnswer(String userAnswer, {bool isReversed = false}) {
    // Note: In your current UI, FitbInteraction handles the exact array matching
    // and just submits true/false, but this satisfies the class contract.
    return segments.any((s) => s.checkAnswer(userAnswer));
  }
}
