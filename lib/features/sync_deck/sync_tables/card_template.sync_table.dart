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
        getLocalIndex: (profileId) =>
            getLocalCardTemplateIndex(profileId: profileId, deckId: deckId),
        getRemoteIndex: (profileId) =>
            getRemoteCardTemplateIndex(profileId: profileId, deckId: deckId),
        getLocalItemsByIds: getLocalCardTemplatesByIds,
        getRemoteItemsByIds: getRemoteCardTemplatesByIds,
        getItemId: (template) => template.id,
        getItemDeletedAt: (template) => template.deletedAt,
        applyPullItem: LocalDB.cardTemplate.upsert,
        applyPushItem: RemoteDB.card.upsert,
        deleteRemoteItemById: (id) => RemoteDB.card.deleteWhere({'id': id}),
        preprocessPushItem: (template, profileId) =>
            CardTemplateMediaSyncPreprocessor.preprocessPushItem(
              template: template,
              profileId: profileId,
            ),
        toMap: RemoteDB.card.toMap,
      );

  static Future<List<SyncIndexEntry>> getLocalCardTemplateIndex({
    required String profileId,
    String? deckId,
  }) async {
    final deckIds = (await DeckSyncTable.getDeckIds(
      profileId: profileId,
      deckId: deckId,
    )).toSet();
    return LocalDB.cardTemplate.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<SyncIndexEntry>> getRemoteCardTemplateIndex({
    required String profileId,
    String? deckId,
  }) async {
    final deckIds = await DeckSyncTable.getDeckIds(
      profileId: profileId,
      deckId: deckId,
    );
    return RemoteDB.card.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<CardTemplate>> getLocalCardTemplatesByIds(
    String profileId,
    List<String> ids,
  ) async {
    return LocalDB.cardTemplate.selectManyByIds(ids);
  }

  static Future<List<CardTemplate>> getRemoteCardTemplatesByIds(
    String profileId,
    List<String> ids,
  ) async {
    return RemoteDB.card.selectManyByIds(ids, includeDeleted: true);
  }
}
