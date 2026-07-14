import 'package:boo_mondai/lib.barrel.dart'
    show
        SyncStrategy,
        SupabaseRemoteDB,
        HiveLocalDB,
        SyncIndexEntry,
        SyncStrategyPullPushPlan,
        ChangedEntity,
        ChangedEntityHelper,
        ChangedProperty,
        ChangeSource,
        ChangeType,
        DeckSyncSession,
        TimeHelper;

typedef DeckSyncIndexLoader =
    Future<List<SyncIndexEntry>> Function(DeckSyncSession context);
typedef DeckSyncItemsByIdsLoader<T> =
    Future<List<T>> Function(DeckSyncSession context, List<String> ids);
typedef DeckSyncPushItemPreprocessor<T> =
    Future<T> Function(T item, DeckSyncSession context);

class NewestWinsSyncStrategy<T> implements SyncStrategy<T> {
  const NewestWinsSyncStrategy({
    required this.name,
    required this.localIndex,
    required this.remoteIndex,
    required this.localItemsByIds,
    required this.remoteItemsByIds,
    required this.itemId,
    this.localDb,
    this.remoteDb,
    this.applyPullItem,
    this.applyPushItem,
    this.preprocessPushItem,
    this.itemToChangeMap,
    this.ignoredChangeKeys = const {},
  });

  @override
  final String name;
  final HiveLocalDB<T>? localDb;
  final SupabaseRemoteDB<T>? remoteDb;
  final DeckSyncIndexLoader localIndex;
  final DeckSyncIndexLoader remoteIndex;
  final DeckSyncItemsByIdsLoader<T> localItemsByIds;
  final DeckSyncItemsByIdsLoader<T> remoteItemsByIds;
  final String Function(T item) itemId;
  final Future<void> Function(T item)? applyPullItem;
  final Future<void> Function(T item)? applyPushItem;
  final DeckSyncPushItemPreprocessor<T>? preprocessPushItem;
  final Map<String, Object?> Function(T item)? itemToChangeMap;
  final Set<String> ignoredChangeKeys;

  @override
  Future<bool> doesItNeedSync(DeckSyncSession context) async {
    final comparison = await _compareIndexes(context);
    return comparison.hasChanges;
  }

  @override
  Future<SyncStrategyPullPushPlan<T>> getSyncStrategyPullPushPlan(
    DeckSyncSession context,
  ) async {
    final comparison = await _compareIndexes(context);
    final localIndexById = comparison.localIndexById;
    final remoteIndexById = comparison.remoteIndexById;
    final pullAddedIds = comparison.pullAddedIds;
    final pullModifiedIds = comparison.pullModifiedIds;
    final pushAddedIds = comparison.pushAddedIds;
    final pushModifiedIds = comparison.pushModifiedIds;
    final changes = <ChangedEntity<T>>[];

    final pullIds = comparison.pullIds;
    final pushIds = comparison.pushIds;
    final pullItems = await remoteItemsByIds(context, pullIds);
    final pushItems = await localItemsByIds(context, pushIds);
    final localModifiedItems = await localItemsByIds(context, pullModifiedIds);
    final remoteModifiedItems = await remoteItemsByIds(
      context,
      pushModifiedIds,
    );

    final pullItemsById = {for (final item in pullItems) itemId(item): item};
    final pushItemsById = {for (final item in pushItems) itemId(item): item};
    final localModifiedItemsById = {
      for (final item in localModifiedItems) itemId(item): item,
    };
    final remoteModifiedItemsById = {
      for (final item in remoteModifiedItems) itemId(item): item,
    };

    for (final id in pullAddedIds) {
      final remote = pullItemsById[id];
      final remoteIndex = remoteIndexById[id];
      if (remote == null || remoteIndex == null) continue;
      changes.add(
        ChangedEntity<T>(
          source: ChangeSource.sync,
          changeType: ChangeType.added,
          id: '$name:$id',
          afterChange: remote,
          remoteId: id,
          remoteUpdatedAt: remoteIndex.updatedAt,
        ),
      );
    }

    for (final id in pullModifiedIds) {
      final remote = pullItemsById[id];
      final local = localModifiedItemsById[id];
      final remoteIndex = remoteIndexById[id];
      final localIndex = localIndexById[id];
      if (remote == null || remoteIndex == null || localIndex == null) {
        continue;
      }

      changes.add(
        ChangedEntity<T>(
          source: ChangeSource.sync,
          changeType: ChangeType.modified,
          id: '$name:$id',
          beforeChange: local,
          afterChange: remote,
          localId: id,
          remoteId: id,
          localUpdatedAt: localIndex.updatedAt,
          remoteUpdatedAt: remoteIndex.updatedAt,
          changedProperties: local == null
              ? const []
              : _getChangedProperties(before: local, after: remote),
        ),
      );
    }

    for (final id in pushAddedIds) {
      final local = pushItemsById[id];
      final localIndex = localIndexById[id];
      if (local == null || localIndex == null) continue;
      changes.add(
        ChangedEntity<T>(
          source: ChangeSource.sync,
          changeType: ChangeType.added,
          id: '$name:$id',
          afterChange: local,
          localId: id,
          localUpdatedAt: localIndex.updatedAt,
        ),
      );
    }

    for (final id in pushModifiedIds) {
      final local = pushItemsById[id];
      final remote = remoteModifiedItemsById[id];
      final localIndex = localIndexById[id];
      final remoteIndex = remoteIndexById[id];
      if (local == null || localIndex == null || remoteIndex == null) {
        continue;
      }

      changes.add(
        ChangedEntity<T>(
          source: ChangeSource.sync,
          changeType: ChangeType.modified,
          id: '$name:$id',
          beforeChange: remote,
          afterChange: local,
          localId: id,
          remoteId: id,
          localUpdatedAt: localIndex.updatedAt,
          remoteUpdatedAt: remoteIndex.updatedAt,
          changedProperties: remote == null
              ? const []
              : _getChangedProperties(before: remote, after: local),
        ),
      );
    }

    return SyncStrategyPullPushPlan<T>(
      pullItems: pullItems,
      pushItems: pushItems,
      changes: changes,
      skipped: comparison.skipped,
    );
  }

  Future<_NewestWinsIndexComparison> _compareIndexes(
    DeckSyncSession context,
  ) async {
    final localIndexData = await localIndex(context);
    final remoteIndexData = await remoteIndex(context);
    final localIndexById = {
      for (final entry in localIndexData) entry.id: entry,
    };
    final remoteIndexById = {
      for (final entry in remoteIndexData) entry.id: entry,
    };
    final pullAddedIds = <String>[];
    final pullModifiedIds = <String>[];
    final pushAddedIds = <String>[];
    final pushModifiedIds = <String>[];
    var skipped = 0;

    for (final remote in remoteIndexData) {
      final local = localIndexById[remote.id];
      if (local == null) {
        pullAddedIds.add(remote.id);
        continue;
      }

      if (TimeHelper.isStrictlyAfterMs(remote.updatedAt, local.updatedAt)) {
        pullModifiedIds.add(remote.id);
      } else if (!TimeHelper.isStrictlyAfterMs(
        local.updatedAt,
        remote.updatedAt,
      )) {
        skipped++;
      }
    }

    for (final local in localIndexData) {
      final remote = remoteIndexById[local.id];
      if (remote == null) {
        pushAddedIds.add(local.id);
        continue;
      }

      if (TimeHelper.isStrictlyAfterMs(local.updatedAt, remote.updatedAt)) {
        pushModifiedIds.add(local.id);
      }
    }

    return _NewestWinsIndexComparison(
      localIndexById: localIndexById,
      remoteIndexById: remoteIndexById,
      pullAddedIds: pullAddedIds,
      pullModifiedIds: pullModifiedIds,
      pushAddedIds: pushAddedIds,
      pushModifiedIds: pushModifiedIds,
      skipped: skipped,
    );
  }

  @override
  Future<List<ChangedEntity<T>>> applySyncStrategyPullPushPlan(
    SyncStrategyPullPushPlan<T> plan,
    DeckSyncSession context,
  ) async {
    for (final remote in plan.pullItems) {
      final applyPull = applyPullItem ?? localDb?.upsert;
      if (applyPull == null) {
        throw StateError('$name cannot apply pulled items.');
      }
      await applyPull(remote);
    }
    for (final local in plan.pushItems) {
      final pushItem = await _preprocessPushItem(local, context);
      final applyPush = applyPushItem ?? remoteDb?.upsert;
      if (applyPush == null) {
        throw StateError('$name cannot apply pushed items.');
      }
      await applyPush(pushItem);
    }
    return plan.changes;
  }

  Future<T> _preprocessPushItem(T item, DeckSyncSession context) {
    final preprocessor = preprocessPushItem;
    return preprocessor == null
        ? Future.value(item)
        : preprocessor(item, context);
  }

  List<ChangedProperty<Object?>> _getChangedProperties({
    required T before,
    required T after,
  }) {
    final mapper = itemToChangeMap;
    if (mapper == null) return const [];

    return ChangedEntityHelper.getChangedProperties(
      before: mapper(before),
      after: mapper(after),
      ignoredKeys: ignoredChangeKeys,
    );
  }
}

class _NewestWinsIndexComparison {
  const _NewestWinsIndexComparison({
    required this.localIndexById,
    required this.remoteIndexById,
    required this.pullAddedIds,
    required this.pullModifiedIds,
    required this.pushAddedIds,
    required this.pushModifiedIds,
    required this.skipped,
  });

  final Map<String, SyncIndexEntry> localIndexById;
  final Map<String, SyncIndexEntry> remoteIndexById;
  final List<String> pullAddedIds;
  final List<String> pullModifiedIds;
  final List<String> pushAddedIds;
  final List<String> pushModifiedIds;
  final int skipped;

  List<String> get pullIds => [...pullAddedIds, ...pullModifiedIds];
  List<String> get pushIds => [...pushAddedIds, ...pushModifiedIds];

  bool get hasChanges =>
      pullAddedIds.isNotEmpty ||
      pullModifiedIds.isNotEmpty ||
      pushAddedIds.isNotEmpty ||
      pushModifiedIds.isNotEmpty;
}
