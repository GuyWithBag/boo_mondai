// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/templates/card_template.dart
// PURPOSE: Sealed base class and all subclasses for card blueprints
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'card_template.dto.mapper.dart';

// ── 1. THE BASE CONTRACT ──────────────────────────────────────────────

@MappableClass(
  discriminatorKey: 'type',
  includeSubClasses: [
    FillInTheBlanksTemplate,
    IdentificationTemplate,
    MatchMadnessTemplate,
    FlashcardTemplate,
    MultipleChoiceTemplate,
  ],
)
abstract class CardTemplate with CardTemplateMappable implements DTO {
  @override
  final String id;
  final String deckId;
  final int sortOrder;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final String? sourceTemplateId;

  const CardTemplate({
    required this.id,
    required this.deckId,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.sourceTemplateId,
  });

  /// Every template MUST know how to grade a user's answer based on its own data.
  bool checkAnswer(String userAnswer, {bool isReversed = false});
}
