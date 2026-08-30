import 'package:boo_mondai/features/cards/models/card_template.dto.dart';
import 'package:boo_mondai/features/cards/models/card_type.dto.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';
import 'package:boo_mondai/core/services/uuid.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'flashcard_template.dto.mapper.dart';

@MappableClass(discriminatorValue: 'flashcard')
class FlashcardTemplate extends CardTemplate with FlashcardTemplateMappable {
  final String frontText;
  final String backText;

  /// Controls how many StudyCards are generated for this template.
  /// - [CardType.normal]   → 1 StudyCard (isReversed: false)
  /// - [CardType.reversed] → 1 StudyCard (isReversed: true)
  /// - [CardType.both]     → 2 StudyCards (one each)
  final CardType cardType;

  const FlashcardTemplate({
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
    required this.frontText,
    required this.backText,
    this.cardType = CardType.normal,
  });

  factory FlashcardTemplate.createDummy({
    String? id,
    String deckId = '',
    int sortOrder = 0,
  }) {
    final now = DateTime.now();
    return FlashcardTemplate(
      id: id ?? uuid.v7(),
      deckId: deckId,
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
      frontText: '',
      backText: '',
    );
  }

  String getQuestion({bool isReversed = false}) =>
      isReversed ? backText : frontText;
  String getAnswer({bool isReversed = false}) =>
      isReversed ? frontText : backText;

  @override
  bool checkAnswer(String userAnswer, {bool isReversed = false}) {
    return getAnswer(isReversed: isReversed)
        .split(',')
        .map((a) => a.trim().toLowerCase())
        .where((a) => a.isNotEmpty)
        .contains(userAnswer.trim().toLowerCase());
  }
}
