import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangedEntity,
        ChangeSource,
        ChangeType,
        DeckSyncSession,
        SyncDeletion,
        SyncIndexEntry,
        SyncStrategyPullPushPlan,
        SyncStrategy;

abstract final class SyncDeletionService {
  static const decks = 'decks';
  static const deckListings = 'deck_listings';
  static const cardTemplates = 'card_templates';
  static const studyCards = 'study_cards';
  static const fsrsCards = 'fsrs_cards';
  static const reviewLogs = 'review_logs';
  static const tags = 'tags';
  static const deckTags = 'deck_tags';
  static const cardTemplateTags = 'card_template_tags';
  static const userStudyCardTags = 'user_study_cards_tags';

  static SyncStrategy<SyncDeletion> createStrategy(DeckSyncSession session) =>
      const _LocalSyncDeletionStrategy();

  static SyncDeletion create({
    required String entityType,
    required String entityId,
    required String userId,
    required DateTime deletedAt,
    String? scopeType,
    String? scopeId,
  }) {
    return SyncDeletion.createNow(
      entityType: entityType,
      entityId: entityId,
      userId: userId,
      scopeType: scopeType,
      scopeId: scopeId,
      deletedAt: deletedAt,
    );
  }

  static SyncDeletion createDeckScoped({
    required String entityType,
    required String entityId,
    required String deckId,
    required String userId,
    required DateTime deletedAt,
  }) {
    return create(
      entityType: entityType,
      entityId: entityId,
      userId: userId,
      scopeType: 'deck',
      scopeId: deckId,
      deletedAt: deletedAt,
    );
  }

  static String compositeEntityId(Map<String, Object?> values) {
    return SyncDeletion.compositeEntityId(values);
  }

  static Future<Set<String>> loadDeletedEntityIds({
    required DeckSyncSession session,
    required String entityType,
  }) async {
    final local = session.syncDeletions.selectManyByUserIdAndEntityType(
      userId: session.userId,
      entityType: entityType,
    );

    return {for (final deletion in local) deletion.entityId};
  }

  static List<SyncIndexEntry> withoutDeletedIndexEntries(
    List<SyncIndexEntry> entries,
    Set<String> deletedIds,
  ) {
    if (deletedIds.isEmpty) return entries;
    return entries
        .where((entry) => !deletedIds.contains(entry.id))
        .toList(growable: false);
  }

  static List<T> withoutDeletedItems<T>(
    List<T> items,
    Set<String> deletedIds,
    String Function(T item) itemId,
  ) {
    if (deletedIds.isEmpty) return items;
    return items
        .where((item) => !deletedIds.contains(itemId(item)))
        .toList(growable: false);
  }

  static Future<void> _applyLocal(
    DeckSyncSession session,
    SyncDeletion deletion,
  ) async {
    switch (deletion.entityType) {
      case decks:
        await session.decks.deleteByPk({'id': deletion.entityId});
      case deckListings:
        await session.deckListings.deleteByPk({'deck_id': deletion.entityId});
      case cardTemplates:
        await session.cardTemplates.deleteByPk({'id': deletion.entityId});
      case studyCards:
        await session.studyCards.deleteByPk({'id': deletion.entityId});
      case fsrsCards:
        await session.fsrsCards.deleteByPk({'id': deletion.entityId});
      case deckTags:
        await session.deckTags.deleteByPk(_decodeComposite(deletion.entityId));
      case cardTemplateTags:
        await session.cardTemplateTags.deleteByPk(
          _decodeComposite(deletion.entityId),
        );
      case userStudyCardTags:
        await session.userStudyCardTags.deleteByPk(
          _decodeComposite(deletion.entityId),
        );
      case tags:
        await session.tags.deleteByPk({'id': deletion.entityId});
    }
  }

  static Future<void> _applyRemote(
    DeckSyncSession session,
    SyncDeletion deletion,
  ) async {
    switch (deletion.entityType) {
      case decks:
        await session.remoteDecks.deleteWhere({'id': deletion.entityId});
      case deckListings:
        await session.remoteDeckListings.deleteWhere({
          'deck_id': deletion.entityId,
        });
      case cardTemplates:
        await session.remoteCardTemplates.deleteWhere({
          'id': deletion.entityId,
        });
      case studyCards:
        await session.remoteStudyCards.deleteWhere({'id': deletion.entityId});
      case fsrsCards:
        await session.remoteFsrsCards.deleteWhere({'id': deletion.entityId});
      case deckTags:
        await session.remoteDeckTags.deleteWhere(
          _decodeComposite(deletion.entityId),
        );
      case cardTemplateTags:
        await session.remoteCardTemplateTags.deleteWhere(
          _decodeComposite(deletion.entityId),
        );
      case userStudyCardTags:
        await session.remoteUserStudyCardTags.deleteWhere(
          _decodeComposite(deletion.entityId),
        );
      case tags:
        await session.remoteTags.deleteWhere({'id': deletion.entityId});
    }
  }

  static Map<String, Object?> _decodeComposite(String entityId) {
    return {
      for (final pair in entityId.split(';'))
        if (pair.contains('='))
          pair.substring(0, pair.indexOf('=')): pair.substring(
            pair.indexOf('=') + 1,
          ),
    };
  }
}

class _LocalSyncDeletionStrategy implements SyncStrategy<SyncDeletion> {
  const _LocalSyncDeletionStrategy();

  @override
  String get name => 'sync_deletions';

  @override
  Future<bool> doesItNeedSync(DeckSyncSession context) async {
    return context.syncDeletions.selectManyByUserId(context.userId).isNotEmpty;
  }

  @override
  Future<SyncStrategyPullPushPlan<SyncDeletion>> getSyncStrategyPullPushPlan(
    DeckSyncSession context,
  ) async {
    final deletions = context.syncDeletions.selectManyByUserId(context.userId);
    return SyncStrategyPullPushPlan<SyncDeletion>(
      pullItems: const [],
      pushItems: deletions,
      changes: [
        for (final deletion in deletions)
          ChangedEntity<SyncDeletion>(
            source: ChangeSource.sync,
            changeType: ChangeType.removed,
            id: '$name:${deletion.id}',
            afterChange: deletion,
            localId: deletion.entityId,
            localUpdatedAt: deletion.deletedAt,
          ),
      ],
    );
  }

  @override
  Future<List<ChangedEntity<SyncDeletion>>> applySyncStrategyPullPushPlan(
    SyncStrategyPullPushPlan<SyncDeletion> plan,
    DeckSyncSession context,
  ) async {
    for (final deletion in plan.pushItems) {
      await SyncDeletionService._applyLocal(context, deletion);
      await SyncDeletionService._applyRemote(context, deletion);
      await context.syncDeletions.deleteByPk({'id': deletion.id});
    }
    return plan.changes;
  }
}
