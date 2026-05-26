// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/templates/card_template.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/models/dto.dart';
import 'package:boo_mondai/features/cards/models/fill_in_the_blanks_template.dto.dart';
import 'package:boo_mondai/features/cards/models/flashcard_template.dto.dart';
import 'package:boo_mondai/features/cards/models/identification_template.dto.dart';
import 'package:boo_mondai/features/cards/models/match_madness_template.dto.dart';
import 'package:boo_mondai/features/cards/models/multiple_choice_template.dto.dart';
import 'package:boo_mondai/features/cards/models/word_scramble_template.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'card_template.dto.mapper.dart';

@MappableClass(
  discriminatorKey: 'type',
  includeSubClasses: [
    FlashcardTemplate,
    IdentificationTemplate,
    MultipleChoiceTemplate,
    FillInTheBlanksTemplate,
    MatchMadnessTemplate,
    WordScrambleTemplate,
  ],
)
abstract class CardTemplate with CardTemplateMappable implements DTO {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  final String deckId;
  final int sortOrder;

  // ── Provenance (For Git-lite Forks) ──
  final String? sourceTemplateId;

  // Joined from card_template_tags
  final List<Tag> tags;

  const CardTemplate({
    required this.id,
    required this.deckId,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.sourceTemplateId,
    this.tags = const [],
  });

  bool checkAnswer(String userAnswer, {bool isReversed = false});
}
