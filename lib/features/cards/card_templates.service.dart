import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        DecksService,
        DeckSyncSession,
        SyncDeletionService,
        SyncIndexEntry;

abstract final class CardTemplatesService {
  static Future<List<CardTemplate>> loadLocalCardTemplatesForSyncSession(
    DeckSyncSession session,
  ) async {
    final deckIds = (await DecksService.loadDeckIdsForSyncSession(
      session,
    )).toSet();
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.cardTemplates,
    );
    return SyncDeletionService.withoutDeletedItems(
      session.cardTemplates.selectManyByDeckIds(deckIds),
      deletedIds,
      (template) => template.id,
    );
  }

  static Future<List<CardTemplate>> loadRemoteCardTemplatesForSyncSession(
    DeckSyncSession session,
  ) async {
    final deckIds = await DecksService.loadDeckIdsForSyncSession(session);
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.cardTemplates,
    );
    final templates = await session.remoteCardTemplates.selectManyByDeckIds(
      deckIds,
    );
    return SyncDeletionService.withoutDeletedItems(
      templates,
      deletedIds,
      (template) => template.id,
    );
  }

  static Future<List<SyncIndexEntry>>
  loadLocalCardTemplateSyncIndexForSyncSession(DeckSyncSession session) async {
    final deckIds = (await DecksService.loadDeckIdsForSyncSession(
      session,
    )).toSet();
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.cardTemplates,
    );
    return SyncDeletionService.withoutDeletedIndexEntries(
      session.cardTemplates.selectSyncIndexByDeckIds(deckIds),
      deletedIds,
    );
  }

  static Future<List<SyncIndexEntry>>
  loadRemoteCardTemplateSyncIndexForSyncSession(DeckSyncSession session) async {
    final deckIds = await DecksService.loadDeckIdsForSyncSession(session);
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.cardTemplates,
    );
    final entries = await session.remoteCardTemplates.selectSyncIndexByDeckIds(
      deckIds,
    );
    return SyncDeletionService.withoutDeletedIndexEntries(entries, deletedIds);
  }

  static Future<List<CardTemplate>> loadLocalCardTemplatesByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.cardTemplates,
    );
    return SyncDeletionService.withoutDeletedItems(
      session.cardTemplates.selectManyByIds(ids),
      deletedIds,
      (template) => template.id,
    );
  }

  static Future<List<CardTemplate>> loadRemoteCardTemplatesByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.cardTemplates,
    );
    final templates = await session.remoteCardTemplates.selectManyByIds(ids);
    return SyncDeletionService.withoutDeletedItems(
      templates,
      deletedIds,
      (template) => template.id,
    );
  }
}
