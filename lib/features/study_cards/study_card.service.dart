import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplate, CardType, FlashcardTemplate, LocalDB, StudyCard, uuid;

class StudyCardService {
  const StudyCardService._();

  /// Reconciles the personal local StudyCards for [deckId] against the current
  /// template list.
  ///
  /// StudyCards are generated local-only records. Remote StudyCards should not
  /// be downloaded because they belong to another user's personal progress.
  static Future<void> syncDeckStudyCards({
    required String deckId,
    required List<CardTemplate> templates,
  }) async {
    final expectedKeys = <_StudyCardKey>{};
    for (final template in templates) {
      expectedKeys.addAll(_expectedKeysForTemplate(template));
    }

    final existingStudyCards = LocalDB.studyCard.getByDeckId(deckId);
    final existingByKey = {
      for (final studyCard in existingStudyCards)
        _StudyCardKey(
          templateId: studyCard.templateId,
          isReversed: studyCard.isReversed,
        ): studyCard,
    };

    final newStudyCards = <StudyCard>[];
    for (final key in expectedKeys) {
      if (existingByKey.containsKey(key)) continue;
      final now = DateTime.now();

      newStudyCards.add(
        StudyCard(
          id: uuid.v7(),
          createdAt: now,
          updatedAt: now,
          deckId: deckId,
          templateId: key.templateId,
          isReversed: key.isReversed,
        ),
      );
    }

    if (newStudyCards.isNotEmpty) {
      await LocalDB.studyCard.upsertMany(newStudyCards);
    }

    final obsoleteStudyCards = existingStudyCards.where((studyCard) {
      final key = _StudyCardKey(
        templateId: studyCard.templateId,
        isReversed: studyCard.isReversed,
      );
      return !expectedKeys.contains(key);
    }).toList();

    final deletableStudyCards = obsoleteStudyCards.where((studyCard) {
      final hasFsrsState =
          LocalDB.fsrsCard.getByStudyCardId(studyCard.id) != null;
      final hasDrillAnswers = LocalDB.drillAnswer
          .getByStudyCardId(studyCard.id)
          .isNotEmpty;
      return !hasFsrsState && !hasDrillAnswers;
    }).toList();

    if (deletableStudyCards.isNotEmpty) {
      await LocalDB.studyCard.deleteManyByPk([
        for (final studyCard in deletableStudyCards) {'id': studyCard.id},
      ]);
    }
  }

  static Set<_StudyCardKey> _expectedKeysForTemplate(CardTemplate template) {
    if (template is FlashcardTemplate) {
      return {
        if (template.cardType != CardType.reversed)
          _StudyCardKey(templateId: template.id, isReversed: false),
        if (template.cardType != CardType.normal)
          _StudyCardKey(templateId: template.id, isReversed: true),
      };
    }

    return {_StudyCardKey(templateId: template.id, isReversed: false)};
  }
}

class _StudyCardKey {
  const _StudyCardKey({required this.templateId, required this.isReversed});

  final String templateId;
  final bool isReversed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _StudyCardKey &&
          runtimeType == other.runtimeType &&
          templateId == other.templateId &&
          isReversed == other.isReversed;

  @override
  int get hashCode => Object.hash(templateId, isReversed);
}
