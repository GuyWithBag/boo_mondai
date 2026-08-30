// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/templates/card_template.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        MutableEntity,
        WordScrambleTemplate,
        Tag,
        FlashcardTemplate,
        IdentificationTemplate,
        MultipleChoiceTemplate,
        FillInTheBlanksTemplate,
        MatchMadnessTemplate,
        TagMapper,
        FlashcardTemplateMapper,
        IdentificationTemplateMapper,
        MultipleChoiceTemplateMapper,
        FillInTheBlanksTemplateMapper,
        MatchMadnessTemplateMapper,
        MutableEntityMapper,
        WordScrambleTemplateMapper,
        MutableEntityCopyWith,
        TagCopyWith;
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
abstract class CardTemplate with CardTemplateMappable implements MutableEntity {
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  final DateTime? purgeAfter;

  final String deckId;
  final int sortOrder;

  // ── Provenance (For Git-lite Forks) ──
  final String? sourceTemplateId;

  // Joined from card_template_tags
  final List<Tag> tags;

  final bool verticallyCentered;

  const CardTemplate({
    required this.id,
    required this.deckId,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.purgeAfter,
    this.sourceTemplateId,
    this.tags = const [],
    this.verticallyCentered = true,
  });

  bool checkAnswer(String userAnswer, {bool isReversed = false});
}
