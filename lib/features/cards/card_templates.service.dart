import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplate, DecksService, DeckSyncSession, SyncIndexEntry;

abstract final class CardTemplatesService {
  static Future<List<CardTemplate>> loadLocalCardTemplatesForSyncSession(
    DeckSyncSession session,
  ) async {
    final deckIds = (await DecksService.loadDeckIdsForSyncSession(
      session,
    )).toSet();
    return session.cardTemplates.selectManyByDeckIds(deckIds);
  }

  static Future<List<CardTemplate>> loadRemoteCardTemplatesForSyncSession(
    DeckSyncSession session,
  ) async {
    final deckIds = await DecksService.loadDeckIdsForSyncSession(session);
    return session.remoteCardTemplates.selectManyByDeckIds(deckIds);
  }

  static Future<List<SyncIndexEntry>>
  loadLocalCardTemplateSyncIndexForSyncSession(DeckSyncSession session) async {
    final deckIds = (await DecksService.loadDeckIdsForSyncSession(
      session,
    )).toSet();
    return session.cardTemplates.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<SyncIndexEntry>>
  loadRemoteCardTemplateSyncIndexForSyncSession(DeckSyncSession session) async {
    final deckIds = await DecksService.loadDeckIdsForSyncSession(session);
    return session.remoteCardTemplates.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<CardTemplate>> loadLocalCardTemplatesByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    return session.cardTemplates.selectManyByIds(ids);
  }

  static Future<List<CardTemplate>> loadRemoteCardTemplatesByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    return session.remoteCardTemplates.selectManyByIds(ids);
  }
}
