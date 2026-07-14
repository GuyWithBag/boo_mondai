import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardType,
        DecksService,
        DeckSyncSession,
        FlashcardTemplate,
        LocalDB,
        SyncDeletionService,
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
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.studyCards,
    );
    return SyncDeletionService.withoutDeletedItems(
      session.studyCards.selectManyByDeckIds(deckIds),
      deletedIds,
      (card) => card.id,
    );
  }

  static Future<List<StudyCard>> loadRemoteStudyCardsForSyncSession(
    DeckSyncSession session,
  ) async {
    final deckIds = await DecksService.loadDeckIdsForSyncSession(session);
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.studyCards,
    );
    final cards = await session.remoteStudyCards.selectManyByDeckIds(deckIds);
    return SyncDeletionService.withoutDeletedItems(
      cards,
      deletedIds,
      (card) => card.id,
    );
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
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.studyCards,
    );
    return SyncDeletionService.withoutDeletedIndexEntries(
      session.studyCards.selectSyncIndexByDeckIds(deckIds),
      deletedIds,
    );
  }

  static Future<List<SyncIndexEntry>>
  loadRemoteStudyCardSyncIndexForSyncSession(DeckSyncSession session) async {
    final deckIds = await DecksService.loadDeckIdsForSyncSession(session);
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.studyCards,
    );
    final entries = await session.remoteStudyCards.selectSyncIndexByDeckIds(
      deckIds,
    );
    return SyncDeletionService.withoutDeletedIndexEntries(entries, deletedIds);
  }

  static Future<List<StudyCard>> loadLocalStudyCardsByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.studyCards,
    );
    return SyncDeletionService.withoutDeletedItems(
      session.studyCards.selectManyByIds(ids),
      deletedIds,
      (card) => card.id,
    );
  }

  static Future<List<StudyCard>> loadRemoteStudyCardsByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.studyCards,
    );
    final cards = await session.remoteStudyCards.selectManyByIds(ids);
    return SyncDeletionService.withoutDeletedItems(
      cards,
      deletedIds,
      (card) => card.id,
    );
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
