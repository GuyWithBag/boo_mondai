import 'package:boo_mondai/lib.barrel.dart'
    show
        FsrsCard,
        LocalDB,
        RemoteDB,
        SyncIndexEntry,
        SyncTable,
        StudyCardSyncTable;

class FsrsCardSyncTable extends SyncTable<FsrsCard> {
  FsrsCardSyncTable({required String? deckId})
    : super.newestWins(
        name: 'fsrs_cards',
        getLocalIndex: (profileId) =>
            getLocalFsrsCardIndex(profileId: profileId, deckId: deckId),
        getRemoteIndex: (profileId) =>
            getRemoteFsrsCardIndex(profileId: profileId, deckId: deckId),
        getLocalItemsByIds: getLocalFsrsCardsByIds,
        getRemoteItemsByIds: getRemoteFsrsCardsByIds,
        getItemId: (card) => card.id,
        getItemDeletedAt: (card) => card.deletedAt,
        applyPullItem: LocalDB.fsrsCard.upsert,
        applyPushItem: RemoteDB.fsrsSync.upsert,
        deleteRemoteItemById: (id) => RemoteDB.fsrsSync.deleteWhere({'id': id}),
        toMap: RemoteDB.fsrsSync.toMap,
      );

  static Future<List<String>> getFsrsCardIds({
    required String profileId,
    String? deckId,
  }) async {
    final localCards = await getLocalFsrsCardIndex(
      profileId: profileId,
      deckId: deckId,
    );
    final remoteCards = await getRemoteFsrsCardIndex(
      profileId: profileId,
      deckId: deckId,
    );
    return {
      for (final card in localCards) card.id,
      for (final card in remoteCards) card.id,
    }.toList(growable: false);
  }

  static Future<List<SyncIndexEntry>> getLocalFsrsCardIndex({
    required String profileId,
    String? deckId,
  }) async {
    final studyCardIds = (await StudyCardSyncTable.getStudyCardIds(
      profileId: profileId,
      deckId: deckId,
    )).toSet();
    return LocalDB.fsrsCard.selectSyncIndexByProfileIdAndStudyCardIds(
      profileId: profileId,
      studyCardIds: studyCardIds,
    );
  }

  static Future<List<SyncIndexEntry>> getRemoteFsrsCardIndex({
    required String profileId,
    String? deckId,
  }) async {
    final studyCardIds = (await StudyCardSyncTable.getStudyCardIds(
      profileId: profileId,
      deckId: deckId,
    )).toSet();
    return RemoteDB.fsrsSync.selectSyncIndexByProfileIdAndStudyCardIds(
      profileId: profileId,
      studyCardIds: studyCardIds,
    );
  }

  static Future<List<FsrsCard>> getLocalFsrsCardsByIds(
    String profileId,
    List<String> ids,
  ) async {
    return LocalDB.fsrsCard.selectManyByIds(ids);
  }

  static Future<List<FsrsCard>> getRemoteFsrsCardsByIds(
    String profileId,
    List<String> ids,
  ) async {
    return RemoteDB.fsrsSync.selectManyByIds(ids, includeDeleted: true);
  }
}
