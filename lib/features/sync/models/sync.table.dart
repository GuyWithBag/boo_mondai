import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangedEntity,
        ChangedEntityHelper,
        ChangedProperty,
        ChangeDirection,
        ChangeSource,
        ChangeType,
        SyncIndexEntry,
        SyncStrategyPullPushPlan,
        TimeHelper;

typedef SyncIndexGetter =
    Future<List<SyncIndexEntry>> Function(String profileId);
typedef SyncItemsByIdsGetter<T> =
    Future<List<T>> Function(String profileId, List<String> ids);
typedef SyncPushItemPreprocessor<T> =
    Future<T> Function(T item, String profileId);
typedef SyncDeletedAtGetter<T> = DateTime? Function(T item);
typedef SyncDeleteRemoteItemById = Future<void> Function(String id);
typedef SyncPlanGetter<T> =
    Future<SyncStrategyPullPushPlan<T>> Function(String profileId);
typedef SyncPlanApplier<T> =
    Future<List<ChangedEntity<T>>> Function(
      SyncStrategyPullPushPlan<T> plan,
      String profileId,
    );

enum SyncTableMode { newestWins, appendOnly, custom }

class SyncTable<T> {
  const SyncTable.newestWins({
    required this.name,
    required this.getLocalIndex,
    required this.getRemoteIndex,
    required this.getLocalItemsByIds,
    required this.getRemoteItemsByIds,
    required this.getItemId,
    this.applyPullItem,
    this.applyPushItem,
    this.deleteRemoteItemById,
    this.preprocessPushItem,
    this.getItemDeletedAt,
    this.toMap,
    this.ignoredChangeKeys = const {},
  }) : mode = SyncTableMode.newestWins,
       getPlan = null,
       applyPlan = null,
       changeType = ChangeType.modified;

  const SyncTable.appendOnly({
    required this.name,
    required this.getLocalIndex,
    required this.getRemoteIndex,
    required this.getLocalItemsByIds,
    required this.getRemoteItemsByIds,
    required this.getItemId,
    required this.applyPullItem,
    required this.applyPushItem,
    this.deleteRemoteItemById,
    this.changeType = ChangeType.added,
  }) : mode = SyncTableMode.appendOnly,
       getPlan = null,
       applyPlan = null,
       preprocessPushItem = null,
       getItemDeletedAt = null,
       toMap = null,
       ignoredChangeKeys = const {};

  const SyncTable.custom({
    required this.name,
    required SyncPlanGetter<T> this.getPlan,
    required SyncPlanApplier<T> this.applyPlan,
  }) : mode = SyncTableMode.custom,
       getLocalIndex = null,
       getRemoteIndex = null,
       getLocalItemsByIds = null,
       getRemoteItemsByIds = null,
       getItemId = null,
       applyPullItem = null,
       applyPushItem = null,
       deleteRemoteItemById = null,
       preprocessPushItem = null,
       getItemDeletedAt = null,
       toMap = null,
       ignoredChangeKeys = const {},
       changeType = ChangeType.modified;

  final String name;
  final SyncTableMode mode;
  final SyncIndexGetter? getLocalIndex;
  final SyncIndexGetter? getRemoteIndex;
  final SyncItemsByIdsGetter<T>? getLocalItemsByIds;
  final SyncItemsByIdsGetter<T>? getRemoteItemsByIds;
  final String Function(T item)? getItemId;
  final Future<void> Function(T item)? applyPullItem;
  final Future<void> Function(T item)? applyPushItem;
  final SyncDeleteRemoteItemById? deleteRemoteItemById;
  final SyncPushItemPreprocessor<T>? preprocessPushItem;
  final SyncDeletedAtGetter<T>? getItemDeletedAt;
  final Map<String, Object?> Function(T item)? toMap;
  final Set<String> ignoredChangeKeys;
  final ChangeType changeType;
  final SyncPlanGetter<T>? getPlan;
  final SyncPlanApplier<T>? applyPlan;

  Future<SyncStrategyPullPushPlan<T>> getSyncPlan({
    required String profileId,
  }) async {
    final customGetter = getPlan;
    if (customGetter != null) return customGetter(profileId);

    return switch (mode) {
      SyncTableMode.newestWins => _getNewestWinsSyncPlan(profileId),
      SyncTableMode.appendOnly => _getAppendOnlySyncPlan(profileId),
      SyncTableMode.custom => throw StateError('$name has no custom plan.'),
    };
  }

  Future<List<ChangedEntity<T>>> applySyncPlan(
    SyncStrategyPullPushPlan<T> plan, {
    required String profileId,
  }) async {
    final customApplier = applyPlan;
    if (customApplier != null) return customApplier(plan, profileId);

    final pullApplier = applyPullItem;
    final pushApplier = applyPushItem;
    if (pullApplier == null || pushApplier == null) {
      throw StateError('$name cannot apply sync plan.');
    }

    for (final remote in plan.pullItems) {
      await pullApplier(remote);
    }
    for (final local in plan.pushItems) {
      final pushItem = await _preprocessPushItem(local, profileId);
      await pushApplier(pushItem);
    }
    return plan.changes;
  }

  Future<List<ChangedEntity<T>>> discardRemoteChanges(
    SyncStrategyPullPushPlan<T> plan, {
    required String profileId,
  }) async {
    final pullApplier = applyPullItem;
    final pushApplier = applyPushItem;
    if (pullApplier == null || pushApplier == null) {
      throw StateError('$name cannot discard remote changes.');
    }

    final applied = <ChangedEntity<T>>[];
    final pushedIds = <String>{};

    for (final local in plan.pushItems) {
      final id = _getItemId(local);
      final mirrored = await _pushLocalAndMirrorSavedRemote(
        local: local,
        profileId: profileId,
        pushApplier: pushApplier,
        pullApplier: pullApplier,
      );
      pushedIds.add(id);
      applied.add(
        ChangedEntity<T>(
          source: ChangeSource.sync,
          direction: ChangeDirection.outbound,
          changeType: _changeTypeFor(mirrored, fallback: ChangeType.modified),
          id: '$name:$id',
          afterChange: mirrored,
          localId: id,
          remoteId: id,
        ),
      );
    }

    for (final change in plan.changes) {
      if (change.direction != ChangeDirection.inbound) continue;
      final local = change.beforeChange;
      if (local == null) {
        final deleteRemote = deleteRemoteItemById;
        final remoteId = change.remoteId ?? _getItemId(change.afterChange);
        if (deleteRemote == null) continue;

        await deleteRemote(remoteId);
        applied.add(
          ChangedEntity<T>(
            source: ChangeSource.sync,
            direction: ChangeDirection.outbound,
            changeType: ChangeType.removed,
            id: '$name:$remoteId',
            beforeChange: change.afterChange,
            afterChange: change.afterChange,
            remoteId: remoteId,
            remoteUpdatedAt: change.remoteUpdatedAt,
          ),
        );
        continue;
      }

      final id = _getItemId(local);
      if (!pushedIds.add(id)) continue;

      final mirrored = await _pushLocalAndMirrorSavedRemote(
        local: local,
        profileId: profileId,
        pushApplier: pushApplier,
        pullApplier: pullApplier,
      );
      applied.add(
        ChangedEntity<T>(
          source: ChangeSource.sync,
          direction: ChangeDirection.outbound,
          changeType: _changeTypeFor(mirrored, fallback: ChangeType.modified),
          id: '$name:$id',
          beforeChange: change.afterChange,
          afterChange: mirrored,
          localId: id,
          remoteId: change.remoteId ?? id,
          localUpdatedAt: change.localUpdatedAt,
          remoteUpdatedAt: change.remoteUpdatedAt,
          changedProperties: change.changedProperties,
        ),
      );
    }

    return applied;
  }

  Future<T> _pushLocalAndMirrorSavedRemote({
    required T local,
    required String profileId,
    required Future<void> Function(T item) pushApplier,
    required Future<void> Function(T item) pullApplier,
  }) async {
    final id = _getItemId(local);
    final pushItem = await _preprocessPushItem(local, profileId);
    await pushApplier(pushItem);

    final savedRemoteItems = await _getRemoteItemsByIds(profileId, [id]);
    final savedRemote = savedRemoteItems.isEmpty
        ? pushItem
        : savedRemoteItems.first;
    await pullApplier(savedRemote);
    return savedRemote;
  }

  Future<SyncStrategyPullPushPlan<T>> _getNewestWinsSyncPlan(
    String profileId,
  ) async {
    final comparison = await _compareNewestWinsIndexes(profileId);
    final localIndexById = comparison.localIndexById;
    final remoteIndexById = comparison.remoteIndexById;
    final pullAddedIds = comparison.pullAddedIds;
    final pullModifiedIds = comparison.pullModifiedIds;
    final pushAddedIds = comparison.pushAddedIds;
    final pushModifiedIds = comparison.pushModifiedIds;
    final changes = <ChangedEntity<T>>[];

    final pullItems = await _getRemoteItemsByIds(profileId, comparison.pullIds);
    final pushItems = await _getLocalItemsByIds(profileId, comparison.pushIds);
    final localModifiedItems = await _getLocalItemsByIds(
      profileId,
      pullModifiedIds,
    );
    final remoteModifiedItems = await _getRemoteItemsByIds(
      profileId,
      pushModifiedIds,
    );

    final pullItemsById = {
      for (final item in pullItems) _getItemId(item): item,
    };
    final pushItemsById = {
      for (final item in pushItems) _getItemId(item): item,
    };
    final localModifiedItemsById = {
      for (final item in localModifiedItems) _getItemId(item): item,
    };
    final remoteModifiedItemsById = {
      for (final item in remoteModifiedItems) _getItemId(item): item,
    };

    for (final id in pullAddedIds) {
      final remote = pullItemsById[id];
      final remoteIndex = remoteIndexById[id];
      if (remote == null || remoteIndex == null) continue;
      changes.add(
        ChangedEntity<T>(
          source: ChangeSource.sync,
          direction: ChangeDirection.inbound,
          changeType: _changeTypeFor(remote, fallback: ChangeType.added),
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
      if (remote == null || remoteIndex == null || localIndex == null) continue;
      changes.add(
        ChangedEntity<T>(
          source: ChangeSource.sync,
          direction: ChangeDirection.inbound,
          changeType: _changeTypeFor(remote, fallback: ChangeType.modified),
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
          direction: ChangeDirection.outbound,
          changeType: _changeTypeFor(local, fallback: ChangeType.added),
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
      if (local == null || localIndex == null || remoteIndex == null) continue;
      changes.add(
        ChangedEntity<T>(
          source: ChangeSource.sync,
          direction: ChangeDirection.outbound,
          changeType: _changeTypeFor(local, fallback: ChangeType.modified),
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

  Future<SyncStrategyPullPushPlan<T>> _getAppendOnlySyncPlan(
    String profileId,
  ) async {
    final comparison = await _compareAppendOnlyIndexes(profileId);
    final pullItems = await _getRemoteItemsByIds(profileId, comparison.pullIds);
    final pushItems = await _getLocalItemsByIds(profileId, comparison.pushIds);
    final changes = <ChangedEntity<T>>[];

    for (final remote in pullItems) {
      final id = _getItemId(remote);
      changes.add(
        ChangedEntity<T>(
          source: ChangeSource.sync,
          direction: ChangeDirection.inbound,
          changeType: changeType,
          id: '$name:$id',
          afterChange: remote,
          remoteId: id,
        ),
      );
    }

    for (final local in pushItems) {
      final id = _getItemId(local);
      changes.add(
        ChangedEntity<T>(
          source: ChangeSource.sync,
          direction: ChangeDirection.outbound,
          changeType: changeType,
          id: '$name:$id',
          afterChange: local,
          localId: id,
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

  Future<_NewestWinsIndexComparison> _compareNewestWinsIndexes(
    String profileId,
  ) async {
    final localIndexData = await _getLocalIndex(profileId);
    final remoteIndexData = await _getRemoteIndex(profileId);
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

  Future<_AppendOnlyIndexComparison> _compareAppendOnlyIndexes(
    String profileId,
  ) async {
    final localIndexData = await _getLocalIndex(profileId);
    final remoteIndexData = await _getRemoteIndex(profileId);
    final localIds = {for (final item in localIndexData) item.id};
    final remoteIds = {for (final item in remoteIndexData) item.id};
    final pullIds = <String>[];
    final pushIds = <String>[];
    var skipped = 0;

    for (final remote in remoteIndexData) {
      if (localIds.contains(remote.id)) {
        skipped++;
        continue;
      }
      pullIds.add(remote.id);
    }

    for (final local in localIndexData) {
      if (remoteIds.contains(local.id)) continue;
      pushIds.add(local.id);
    }

    return _AppendOnlyIndexComparison(
      pullIds: pullIds,
      pushIds: pushIds,
      skipped: skipped,
    );
  }

  Future<T> _preprocessPushItem(T item, String profileId) {
    final preprocessor = preprocessPushItem;
    return preprocessor == null
        ? Future.value(item)
        : preprocessor(item, profileId);
  }

  ChangeType _changeTypeFor(T item, {required ChangeType fallback}) {
    final deletedAt = getItemDeletedAt?.call(item);
    return deletedAt == null ? fallback : ChangeType.removed;
  }

  List<ChangedProperty<Object?>> _getChangedProperties({
    required T before,
    required T after,
  }) {
    final mapper = toMap;
    if (mapper == null) return const [];

    return ChangedEntityHelper.getChangedProperties(
      before: mapper(before),
      after: mapper(after),
      ignoredKeys: ignoredChangeKeys,
    );
  }

  Future<List<SyncIndexEntry>> _getLocalIndex(String profileId) {
    final getter = getLocalIndex;
    if (getter == null) throw StateError('$name has no local index getter.');
    return getter(profileId);
  }

  Future<List<SyncIndexEntry>> _getRemoteIndex(String profileId) {
    final getter = getRemoteIndex;
    if (getter == null) throw StateError('$name has no remote index getter.');
    return getter(profileId);
  }

  Future<List<T>> _getLocalItemsByIds(String profileId, List<String> ids) {
    final getter = getLocalItemsByIds;
    if (getter == null) throw StateError('$name has no local item getter.');
    return getter(profileId, ids);
  }

  Future<List<T>> _getRemoteItemsByIds(String profileId, List<String> ids) {
    final getter = getRemoteItemsByIds;
    if (getter == null) throw StateError('$name has no remote item getter.');
    return getter(profileId, ids);
  }

  String _getItemId(T item) {
    final getter = getItemId;
    if (getter == null) throw StateError('$name has no item id getter.');
    return getter(item);
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
}

class _AppendOnlyIndexComparison {
  const _AppendOnlyIndexComparison({
    required this.pullIds,
    required this.pushIds,
    required this.skipped,
  });

  final List<String> pullIds;
  final List<String> pushIds;
  final int skipped;
}
