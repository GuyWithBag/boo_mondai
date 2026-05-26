import 'package:boo_mondai/features/cards/models/card_template.dto.dart';
import 'package:boo_mondai/features/cards/models/match_madness_pair.dto.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'match_madness_template.dto.mapper.dart';

@MappableClass(discriminatorValue: 'match_madness')
class MatchMadnessTemplate extends CardTemplate
    with MatchMadnessTemplateMappable {
  final List<MatchMadnessPair> pairs;

  const MatchMadnessTemplate({
    required super.id,
    required super.deckId,
    required super.sortOrder,
    required super.createdAt,
    required super.updatedAt,
    super.sourceTemplateId,
    super.tags,
    required this.pairs,
  });

  @override
  bool checkAnswer(String userAnswer, {bool isReversed = false}) {
    return false; // Validated visually by the UI drag-and-drop
  }
}
