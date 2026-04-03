import 'package:boo_mondai/models/models.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'fill_in_the_blanks_template.mapper.dart';

@MappableClass(discriminatorValue: 'fill_in_the_blanks')
class FillInTheBlanksTemplate extends CardTemplate
    with FillInTheBlanksTemplateMappable {
  final List<FillInTheBlankSegment> segments;

  const FillInTheBlanksTemplate({
    required super.id,
    required super.deckId,
    required super.sortOrder,
    required super.createdAt,
    super.sourceTemplateId,
    required this.segments,
  });

  @override
  bool checkAnswer(String userAnswer, {bool isReversed = false}) {
    // Note: In your current UI, FitbInteraction handles the exact array matching
    // and just submits true/false, but this satisfies the class contract.
    return segments.any((s) => s.checkAnswer(userAnswer));
  }
}
