import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardType,
        DecksService,
        DeckSyncSession,
        FlashcardTemplate,
        LocalDB,
        SyncIndexEntry,
        StudyCard,
        uuid;

class StudyCardService {
  const StudyCardService._();

  static Future<List<StudyCard>> loadLocalStudyCardsForSyncSession(
    DeckSyncSession session,
  ) async {
    final deckIds = (await DecksService.loadDeckIdsForSyncSession(
      session,
    )).toSet();
    return session.studyCards.selectManyByDeckIds(deckIds);
  }

  static Future<List<StudyCard>> loadRemoteStudyCardsForSyncSession(
    DeckSyncSession session,
  ) async {
    final deckIds = await DecksService.loadDeckIdsForSyncSession(session);
    return session.remoteStudyCards.selectManyByDeckIds(deckIds);
  }

  static Future<List<String>> loadStudyCardIdsForSyncSession(
    DeckSyncSession session,
  ) async {
    final localCards = await loadLocalStudyCardSyncIndexForSyncSession(session);
    final remoteCards = await loadRemoteStudyCardSyncIndexForSyncSession(
      session,
    );
    return {
      for (final card in localCards) card.id,
      for (final card in remoteCards) card.id,
    }.toList(growable: false);
  }

  static Future<List<SyncIndexEntry>> loadLocalStudyCardSyncIndexForSyncSession(
    DeckSyncSession session,
  ) async {
    final deckIds = (await DecksService.loadDeckIdsForSyncSession(
      session,
    )).toSet();
    return session.studyCards.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<SyncIndexEntry>>
  loadRemoteStudyCardSyncIndexForSyncSession(DeckSyncSession session) async {
    final deckIds = await DecksService.loadDeckIdsForSyncSession(session);
    return session.remoteStudyCards.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<StudyCard>> loadLocalStudyCardsByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    return session.studyCards.selectManyByIds(ids);
  }

  static Future<List<StudyCard>> loadRemoteStudyCardsByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    return session.remoteStudyCards.selectManyByIds(ids);
  }

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
