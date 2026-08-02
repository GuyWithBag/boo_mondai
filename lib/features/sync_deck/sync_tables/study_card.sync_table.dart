import 'package:boo_mondai/lib.barrel.dart'
    show LocalDB, RemoteDB, StudyCard, SyncIndexEntry, SyncTable, DeckSyncTable;

class StudyCardSyncTable extends SyncTable<StudyCard> {
  StudyCardSyncTable({required String? deckId})
    : super.newestWins(
        name: 'study_cards',
        getLocalIndex: (profileId) =>
            getLocalStudyCardIndex(profileId: profileId, deckId: deckId),
        getRemoteIndex: (profileId) =>
            getRemoteStudyCardIndex(profileId: profileId, deckId: deckId),
        getLocalItemsByIds: getLocalStudyCardsByIds,
        getRemoteItemsByIds: getRemoteStudyCardsByIds,
        getItemId: (card) => card.id,
        getItemDeletedAt: (card) => card.deletedAt,
        applyPullItem: LocalDB.studyCard.upsert,
        applyPushItem: RemoteDB.studyCard.upsert,
        deleteRemoteItemById: (id) =>
            RemoteDB.studyCard.deleteWhere({'id': id}),
        toMap: RemoteDB.studyCard.toMap,
      );

  static Future<List<String>> getStudyCardIds({
    required String profileId,
    String? deckId,
  }) async {
    final localCards = await getLocalStudyCardIndex(
      profileId: profileId,
      deckId: deckId,
    );
    final remoteCards = await getRemoteStudyCardIndex(
      profileId: profileId,
      deckId: deckId,
    );
    return {
      for (final card in localCards) card.id,
      for (final card in remoteCards) card.id,
    }.toList(growable: false);
  }

  static Future<List<SyncIndexEntry>> getLocalStudyCardIndex({
    required String profileId,
    String? deckId,
  }) async {
    final deckIds = (await DeckSyncTable.getDeckIds(
      profileId: profileId,
      deckId: deckId,
    )).toSet();
    return LocalDB.studyCard.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<SyncIndexEntry>> getRemoteStudyCardIndex({
    required String profileId,
    String? deckId,
  }) async {
    final deckIds = await DeckSyncTable.getDeckIds(
      profileId: profileId,
      deckId: deckId,
    );
    return RemoteDB.studyCard.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<StudyCard>> getLocalStudyCardsByIds(
    String profileId,
    List<String> ids,
  ) async {
    return LocalDB.studyCard.selectManyByIds(ids);
  }

  static Future<List<StudyCard>> getRemoteStudyCardsByIds(
    String profileId,
    List<String> ids,
  ) async {
    return RemoteDB.studyCard.selectManyByIds(ids, includeDeleted: true);
  }
}
