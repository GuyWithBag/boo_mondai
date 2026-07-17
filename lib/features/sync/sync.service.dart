import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthService,
        ChangeSource,
        ChangeTrackerController,
        ChangeTrackerEntry,
        ChangeTrackerStatus,
        PreviewedChangePlan,
        StrategySyncPlanPayload,
        SyncException,
        SyncClientService,
        SyncPlanStep,
        SyncPlanStepApplier,
        SyncTable;

class SyncService {
  static void _ensureAuthenticated({required String userId}) {
    if (!AuthService.isAuthenticatedRemote || userId.trim().isEmpty) {
      throw const SyncException(
        'Sign in to sync your data.',
        code: 'SYNC_AUTH_REQUIRED',
      );
    }
  }

  static Future<PreviewedChangePlan<StrategySyncPlanPayload, Object?>> sync({
    required String title,
    required String userId,
    required List<SyncTable<dynamic>> tables,
    required ChangeTrackerController changeTrackerController,
  }) async {
    late final PreviewedChangePlan<StrategySyncPlanPayload, Object?> syncPlan;
    late final String entryId;
    final entry = changeTrackerController.start<Object?>(
      entry: ChangeTrackerEntry<Object?>(
        source: ChangeSource.sync,
        title: title,
        status: ChangeTrackerStatus.planning,
        progress: 0.05,
      ),
      onChangeApply: () async {
        final changes = await SyncPlanStepApplier.applyAll(
          steps: syncPlan.payload.steps,
          userId: userId,
          onProgressChanged: (progress) {
            changeTrackerController.update(
              entryId,
              status: ChangeTrackerStatus.applying,
              progress: progress,
            );
          },
        );
        await SyncClientService.markSynced(userId: userId);
        await SyncClientService.purgeRemoteTombstones();
        await SyncClientService.purgeLocalTombstones();
        return changes;
      },
      onChangeDiscard: () async {
        final changes = await SyncPlanStepApplier.discardAll(
          steps: syncPlan.payload.steps,
          userId: userId,
          onProgressChanged: (progress) {
            changeTrackerController.update(
              entryId,
              status: ChangeTrackerStatus.applying,
              progress: progress,
            );
          },
        );
        await SyncClientService.markSynced(userId: userId);
        await SyncClientService.purgeRemoteTombstones();
        await SyncClientService.purgeLocalTombstones();
        return changes;
      },
    );
    entryId = entry.id;

    try {
      _ensureAuthenticated(userId: userId);
      await SyncClientService.touchSeen(userId: userId);
      changeTrackerController.update(
        entry.id,
        status: ChangeTrackerStatus.fetching,
        progress: 0.05,
      );

      syncPlan = await previewSyncPlan(
        userId: userId,
        tables: tables,
        onProgressChanged: (progress) {
          changeTrackerController.update(
            entry.id,
            status: ChangeTrackerStatus.fetching,
            progress: 0.5 + (progress * 0.25),
          );
        },
      );

      if (syncPlan.changes.isEmpty) {
        changeTrackerController.update(
          entry.id,
          status: ChangeTrackerStatus.alreadyUpToDate,
          progress: 1,
          changes: const [],
        );
        await SyncClientService.markSynced(userId: userId);
        await SyncClientService.purgeRemoteTombstones();
        await SyncClientService.purgeLocalTombstones();
        return syncPlan;
      }

      changeTrackerController.update(
        entry.id,
        status: ChangeTrackerStatus.reviewing,
        progress: 1,
        changes: syncPlan.changes,
      );
      return syncPlan;
    } catch (e) {
      changeTrackerController.fail(entry.id, e);
      if (e is SyncException) rethrow;
      throw SyncException(
        'Unexpected error during sync: $e',
        code: 'SYNC_FAILED',
      );
    }
  }

  static Future<PreviewedChangePlan<StrategySyncPlanPayload, Object?>>
  previewSyncPlan({
    required String userId,
    required List<SyncTable<dynamic>> tables,
    void Function(double progress)? onProgressChanged,
  }) async {
    final steps = <SyncPlanStep>[];

    if (tables.isEmpty) {
      onProgressChanged?.call(1);
      return PreviewedChangePlan<StrategySyncPlanPayload, Object?>(
        payload: StrategySyncPlanPayload(steps: steps),
        changes: const [],
      );
    }

    for (var i = 0; i < tables.length; i++) {
      steps.add(
        await SyncPlanStep.createFromTablePreview(tables[i], userId: userId),
      );
      onProgressChanged?.call((i + 1) / tables.length);
    }

    final changes = steps
        .expand((step) => step.changes)
        .toList(growable: false);

    return PreviewedChangePlan<StrategySyncPlanPayload, Object?>(
      payload: StrategySyncPlanPayload(steps: steps),
      changes: changes,
    );
  }
}
