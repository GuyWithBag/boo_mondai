import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardTemplateMediaSyncPreprocessor,
        LocalDB,
        RemoteDB,
        SyncIndexEntry,
        SyncTable,
        DeckSyncTable;

class CardTemplateSyncTable extends SyncTable<CardTemplate> {
  CardTemplateSyncTable({required String? deckId})
    : super.newestWins(
        name: 'card_templates',
        getLocalIndex: (userId) =>
            getLocalCardTemplateIndex(userId: userId, deckId: deckId),
        getRemoteIndex: (userId) =>
            getRemoteCardTemplateIndex(userId: userId, deckId: deckId),
        getLocalItemsByIds: getLocalCardTemplatesByIds,
        getRemoteItemsByIds: getRemoteCardTemplatesByIds,
        getItemId: (template) => template.id,
        getItemDeletedAt: (template) => template.deletedAt,
        applyPullItem: LocalDB.cardTemplate.upsert,
        applyPushItem: RemoteDB.card.upsert,
        deleteRemoteItemById: (id) => RemoteDB.card.deleteWhere({'id': id}),
        preprocessPushItem: (template, userId) =>
            CardTemplateMediaSyncPreprocessor.preprocessPushItem(
              template: template,
              userId: userId,
            ),
        toMap: RemoteDB.card.toMap,
      );

  static Future<List<SyncIndexEntry>> getLocalCardTemplateIndex({
    required String userId,
    String? deckId,
  }) async {
    final deckIds = (await DeckSyncTable.getDeckIds(
      userId: userId,
      deckId: deckId,
    )).toSet();
    return LocalDB.cardTemplate.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<SyncIndexEntry>> getRemoteCardTemplateIndex({
    required String userId,
    String? deckId,
  }) async {
    final deckIds = await DeckSyncTable.getDeckIds(
      userId: userId,
      deckId: deckId,
    );
    return RemoteDB.card.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<CardTemplate>> getLocalCardTemplatesByIds(
    String userId,
    List<String> ids,
  ) async {
    return LocalDB.cardTemplate.selectManyByIds(ids);
  }

  static Future<List<CardTemplate>> getRemoteCardTemplatesByIds(
    String userId,
    List<String> ids,
  ) async {
    return RemoteDB.card.selectManyByIds(ids, includeDeleted: true);
  }
}
