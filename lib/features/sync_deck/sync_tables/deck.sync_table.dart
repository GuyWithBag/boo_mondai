import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        DeckMediaSyncPreprocessor,
        LocalDB,
        RemoteDB,
        SyncIndexEntry,
        SyncTable;

class DeckSyncTable extends SyncTable<Deck> {
  DeckSyncTable({required String? deckId})
    : super.newestWins(
        name: 'decks',
        getLocalIndex: (profileId) =>
            getLocalDeckIndex(profileId: profileId, deckId: deckId),
        getRemoteIndex: (profileId) =>
            getRemoteDeckIndex(profileId: profileId, deckId: deckId),
        getLocalItemsByIds: getLocalDecksByIds,
        getRemoteItemsByIds: getRemoteDecksByIds,
        getItemId: (deck) => deck.id,
        getItemDeletedAt: (deck) => deck.deletedAt,
        applyPullItem: LocalDB.deck.upsert,
        applyPushItem: RemoteDB.deck.upsert,
        deleteRemoteItemById: (id) => RemoteDB.deck.deleteWhere({'id': id}),
        preprocessPushItem: (deck, profileId) =>
            DeckMediaSyncPreprocessor.preprocessPushItem(
              deck: deck,
              profileId: profileId,
            ),
        toMap: (deck) =>
            RemoteDB.deck.withoutJoinedFields(RemoteDB.deck.toMap(deck)),
      );

  static Future<List<String>> getDeckIds({
    required String profileId,
    String? deckId,
  }) async {
    if (deckId != null) return [deckId];

    final localDecks = LocalDB.deck.selectSyncIndexByProfileIdAndOptionalDeckId(
      profileId: profileId,
      deckId: deckId,
    );
    final remoteDecks = await RemoteDB.deck
        .selectSyncIndexByProfileIdAndOptionalDeckId(
          profileId: profileId,
          deckId: deckId,
        );

    return {
      for (final deck in localDecks) deck.id,
      for (final deck in remoteDecks) deck.id,
    }.toList(growable: false);
  }

  static Future<List<SyncIndexEntry>> getLocalDeckIndex({
    required String profileId,
    String? deckId,
  }) async {
    return LocalDB.deck.selectSyncIndexByProfileIdAndOptionalDeckId(
      profileId: profileId,
      deckId: deckId,
    );
  }

  static Future<List<SyncIndexEntry>> getRemoteDeckIndex({
    required String profileId,
    String? deckId,
  }) async {
    return RemoteDB.deck.selectSyncIndexByProfileIdAndOptionalDeckId(
      profileId: profileId,
      deckId: deckId,
    );
  }

  static Future<List<Deck>> getLocalDecksByIds(
    String profileId,
    List<String> ids,
  ) async {
    return LocalDB.deck.selectManyByIds(ids);
  }

  static Future<List<Deck>> getRemoteDecksByIds(
    String profileId,
    List<String> ids,
  ) async {
    return RemoteDB.deck.selectManyByIds(ids, includeDeleted: true);
  }
}
