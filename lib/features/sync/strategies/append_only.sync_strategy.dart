import 'package:boo_mondai/lib.barrel.dart'
    show
        SyncStrategy,
        HiveLocalDB,
        SupabaseRemoteDB,
        SyncIndexLoader,
        SyncItemsByIdsLoader,
        SyncStrategyPullPushPlan,
        ChangedEntity,
        ChangeSource,
        ChangeType;

class AppendOnlySyncStrategy<T, TContext> implements SyncStrategy<T, TContext> {
  const AppendOnlySyncStrategy({
    required this.name,
    required this.localDb,
    required this.remoteDb,
    required this.localIndex,
    required this.remoteIndex,
    required this.localItemsByIds,
    required this.remoteItemsByIds,
    required this.itemId,
    this.changeType = ChangeType.added,
  });

  @override
  final String name;
  final HiveLocalDB<T> localDb;
  final SupabaseRemoteDB<T> remoteDb;
  final SyncIndexLoader<TContext> localIndex;
  final SyncIndexLoader<TContext> remoteIndex;
  final SyncItemsByIdsLoader<T, TContext> localItemsByIds;
  final SyncItemsByIdsLoader<T, TContext> remoteItemsByIds;
  final String Function(T item) itemId;
  final ChangeType changeType;

  @override
  Future<bool> doesItNeedSync(TContext context) async {
    final comparison = await _compareIndexes(context);
    return comparison.hasChanges;
  }

  @override
  Future<SyncStrategyPullPushPlan<T>> getSyncStrategyPullPushPlan(
    TContext context,
  ) async {
    final comparison = await _compareIndexes(context);
    final pullItems = await remoteItemsByIds(context, comparison.pullIds);
    final pushItems = await localItemsByIds(context, comparison.pushIds);
    final changes = <ChangedEntity<T>>[];

    for (final remote in pullItems) {
      final id = itemId(remote);
      changes.add(
        ChangedEntity<T>(
          source: ChangeSource.sync,
          changeType: changeType,
          id: '$name:$id',
          afterChange: remote,
          remoteId: id,
        ),
      );
    }

    for (final local in pushItems) {
      final id = itemId(local);
      changes.add(
        ChangedEntity<T>(
          source: ChangeSource.sync,
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

  Future<_AppendOnlyIndexComparison> _compareIndexes(TContext context) async {
    final localIndexData = await localIndex(context);
    final remoteIndexData = await remoteIndex(context);
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

  @override
  Future<List<ChangedEntity<T>>> applySyncStrategyPullPushPlan(
    SyncStrategyPullPushPlan<T> plan,
    TContext context,
  ) async {
    for (final remote in plan.pullItems) {
      await localDb.upsert(remote);
    }
    for (final local in plan.pushItems) {
      await remoteDb.upsert(local);
    }
    return plan.changes;
  }
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

  bool get hasChanges => pullIds.isNotEmpty || pushIds.isNotEmpty;
}
