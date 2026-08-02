import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangedEntity,
        ChangeDirection,
        ChangeSource,
        ChangeType,
        LocalDB,
        RemoteDB,
        SyncDeletion,
        SyncIndexEntry,
        SyncStrategyPullPushPlan,
        SyncTable;

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

  static SyncTable<SyncDeletion> createTable() {
    return SyncTable<SyncDeletion>.custom(
      name: 'sync_deletions',
      getPlan: _getPlan,
      applyPlan: _applyPlan,
    );
  }

  static SyncDeletion create({
    required String entityType,
    required String entityId,
    required String profileId,
    required DateTime deletedAt,
    String? scopeType,
    String? scopeId,
  }) {
    return SyncDeletion.createNow(
      entityType: entityType,
      entityId: entityId,
      profileId: profileId,
      scopeType: scopeType,
      scopeId: scopeId,
      deletedAt: deletedAt,
    );
  }

  static SyncDeletion createDeckScoped({
    required String entityType,
    required String entityId,
    required String deckId,
    required String profileId,
    required DateTime deletedAt,
  }) {
    return create(
      entityType: entityType,
      entityId: entityId,
      profileId: profileId,
      scopeType: 'deck',
      scopeId: deckId,
      deletedAt: deletedAt,
    );
  }

  static String compositeEntityId(Map<String, Object?> values) {
    return SyncDeletion.compositeEntityId(values);
  }

  static Future<Set<String>> getDeletedEntityIds({
    required String profileId,
    required String entityType,
  }) async {
    final local = LocalDB.syncDeletion.selectManyByUserIdAndEntityType(
      profileId: profileId,
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
    String Function(T item) getItemId,
  ) {
    if (deletedIds.isEmpty) return items;
    return items
        .where((item) => !deletedIds.contains(getItemId(item)))
        .toList(growable: false);
  }

  static Future<SyncStrategyPullPushPlan<SyncDeletion>> _getPlan(
    String profileId,
  ) async {
    final deletions = LocalDB.syncDeletion.selectManyByUserId(profileId);
    return SyncStrategyPullPushPlan<SyncDeletion>(
      pullItems: const [],
      pushItems: deletions,
      changes: [
        for (final deletion in deletions)
          ChangedEntity<SyncDeletion>(
            source: ChangeSource.sync,
            direction: ChangeDirection.outbound,
            changeType: ChangeType.removed,
            id: 'sync_deletions:${deletion.id}',
            afterChange: deletion,
            localId: deletion.entityId,
            localUpdatedAt: deletion.deletedAt,
          ),
      ],
    );
  }

  static Future<List<ChangedEntity<SyncDeletion>>> _applyPlan(
    SyncStrategyPullPushPlan<SyncDeletion> plan,
    String profileId,
  ) async {
    for (final deletion in plan.pushItems) {
      await _applyLocal(deletion);
      await _applyRemote(deletion);
      await LocalDB.syncDeletion.deleteByPk({'id': deletion.id});
    }
    return plan.changes;
  }

  static Future<void> _applyLocal(SyncDeletion deletion) async {
    switch (deletion.entityType) {
      case decks:
        await LocalDB.deck.deleteByPk({'id': deletion.entityId});
      case deckListings:
        await LocalDB.deckListing.deleteByPk({'deck_id': deletion.entityId});
      case cardTemplates:
        await LocalDB.cardTemplate.deleteByPk({'id': deletion.entityId});
      case studyCards:
        await LocalDB.studyCard.deleteByPk({'id': deletion.entityId});
      case fsrsCards:
        await LocalDB.fsrsCard.deleteByPk({'id': deletion.entityId});
      case deckTags:
        await LocalDB.deckTag.deleteByPk(_decodeComposite(deletion.entityId));
      case cardTemplateTags:
        await LocalDB.cardTemplateTag.deleteByPk(
          _decodeComposite(deletion.entityId),
        );
      case userStudyCardTags:
        await LocalDB.userStudyCardTag.deleteByPk(
          _decodeComposite(deletion.entityId),
        );
      case tags:
        await LocalDB.tag.deleteByPk({'id': deletion.entityId});
    }
  }

  static Future<void> _applyRemote(SyncDeletion deletion) async {
    switch (deletion.entityType) {
      case decks:
        await RemoteDB.deck.deleteWhere({'id': deletion.entityId});
      case deckListings:
        await RemoteDB.deckListing.deleteWhere({'deck_id': deletion.entityId});
      case cardTemplates:
        await RemoteDB.card.deleteWhere({'id': deletion.entityId});
      case studyCards:
        await RemoteDB.studyCard.deleteWhere({'id': deletion.entityId});
      case fsrsCards:
        await RemoteDB.fsrsSync.deleteWhere({'id': deletion.entityId});
      case deckTags:
        await RemoteDB.deckTag.deleteWhere(_decodeComposite(deletion.entityId));
      case cardTemplateTags:
        await RemoteDB.cardTemplateTag.deleteWhere(
          _decodeComposite(deletion.entityId),
        );
      case userStudyCardTags:
        await RemoteDB.userStudyCardTag.deleteWhere(
          _decodeComposite(deletion.entityId),
        );
      case tags:
        await RemoteDB.tag.deleteWhere({'id': deletion.entityId});
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
