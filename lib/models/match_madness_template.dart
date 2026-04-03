import 'package:boo_mondai/models/models.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'match_madness_template.mapper.dart';

@MappableClass(discriminatorValue: 'match_madness')
class MatchMadnessTemplate extends CardTemplate
    with MatchMadnessTemplateMappable {
  final List<MatchMadnessPair> pairs;

  const MatchMadnessTemplate({
    required super.id,
    required super.deckId,
    required super.sortOrder,
    required super.createdAt,
    super.sourceTemplateId,
    required this.pairs,
  });

  @override
  bool checkAnswer(String userAnswer, {bool isReversed = false}) {
    return false; // Validated visually by the UI drag-and-drop
  }
}
