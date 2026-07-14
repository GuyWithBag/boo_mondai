import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckSyncSession,
        DeckSyncPlanPayload,
        DeckSyncAvailabilitySnapshot,
        PreviewedChangePlan,
        ChangedEntity,
        SyncPlanStep,
        SyncException,
        ChangeSource,
        ChangeTrackerStatus,
        ChangeTrackerEntry,
        AuthService;

class DeckSyncService {
  static Future<PreviewedChangePlan<DeckSyncPlanPayload, Object?>> sync({
    required DeckSyncSession session,
  }) async {
    late final PreviewedChangePlan<DeckSyncPlanPayload, Object?> deckSyncPlan;
    final tracker = session.changeTrackerController;
    late final String entryId;
    final entry = tracker.start<Object?>(
      entry: ChangeTrackerEntry<Object?>(
        source: ChangeSource.sync,
        title: 'Sync decks',
        status: ChangeTrackerStatus.planning,
        progress: 0.05,
      ),
      onApply: () async {
        return _applyDeckSyncPlanSteps(
          session: session,
          payload: deckSyncPlan.payload,
          trackerEntryId: entryId,
        );
      },
    );
    entryId = entry.id;

    try {
      _ensureAuthenticated(userId: session.userId);
      tracker.update(
        entry.id,
        status: ChangeTrackerStatus.fetching,
        progress: 0.05,
      );

      final needsSync = await _doesDeckSyncNeedChanges(
        session: session,
        onProgress: (progress) {
          tracker.update(
            entry.id,
            status: ChangeTrackerStatus.fetching,
            progress: progress,
          );
        },
      );

      if (!needsSync) {
        deckSyncPlan = PreviewedChangePlan<DeckSyncPlanPayload, Object?>(
          payload: const DeckSyncPlanPayload(steps: []),
          changes: const [],
        );
        tracker.update(
          entry.id,
          status: ChangeTrackerStatus.alreadyUpToDate,
          progress: 1,
          changes: const [],
        );
        return deckSyncPlan;
      }

      deckSyncPlan = await _prepareDeckSyncPlanForReview(
        session: session,
        onProgress: (progress) {
          tracker.update(
            entry.id,
            status: ChangeTrackerStatus.fetching,
            progress: 0.5 + (progress * 0.25),
          );
        },
      );

      final changes = deckSyncPlan.changes;
      if (changes.isEmpty) {
        tracker.update(
          entry.id,
          status: ChangeTrackerStatus.alreadyUpToDate,
          progress: 1,
          changes: const [],
        );
        return deckSyncPlan;
      }

      tracker.update(
        entry.id,
        status: ChangeTrackerStatus.reviewing,
        progress: 1,
        changes: changes,
      );
      return deckSyncPlan;
    } catch (e) {
      tracker.fail(entry.id, e);
      if (e is SyncException) rethrow;
      throw SyncException(
        'Failed to sync deck data: $e',
        code: 'DECK_SYNC_FAILED',
      );
    }
  }

  static Future<bool> _doesDeckSyncNeedChanges({
    required DeckSyncSession session,
    required void Function(double progress) onProgress,
  }) async {
    final snapshot = await DeckSyncAvailabilitySnapshot.load(
      session: session,
      onProgress: (progress) => onProgress(progress * 0.5),
    );
    return snapshot.hasChanges;
  }

  static Future<PreviewedChangePlan<DeckSyncPlanPayload, Object?>>
  _prepareDeckSyncPlanForReview({
    required DeckSyncSession session,
    required void Function(double progress) onProgress,
  }) async {
    final strategies = session.getStrategies();
    final steps = <SyncPlanStep>[];

    for (var i = 0; i < strategies.length; i++) {
      onProgress((i + 1) / strategies.length);
      steps.add(
        await SyncPlanStep.createFromStrategyPreview(strategies[i], session),
      );
    }

    final changes = steps
        .expand((step) => step.changes)
        .toList(growable: false);

    return PreviewedChangePlan<DeckSyncPlanPayload, Object?>(
      payload: DeckSyncPlanPayload(steps: steps),
      changes: changes,
    );
  }

  static Future<List<ChangedEntity<Object?>>> _applyDeckSyncPlanSteps({
    required DeckSyncSession session,
    required DeckSyncPlanPayload payload,
    required String trackerEntryId,
  }) async {
    final tracker = session.changeTrackerController;
    final applied = <ChangedEntity<Object?>>[];
    final steps = payload.steps;

    for (var i = 0; i < steps.length; i++) {
      tracker.update(
        trackerEntryId,
        status: ChangeTrackerStatus.applying,
        progress: steps.isEmpty ? 1 : i / steps.length,
      );
      applied.addAll(await _applyDeckSyncPlanStep(steps[i], session));
    }

    tracker.update(
      trackerEntryId,
      status: ChangeTrackerStatus.applying,
      progress: 1,
    );
    return applied;
  }

  static Future<List<ChangedEntity<Object?>>> _applyDeckSyncPlanStep(
    SyncPlanStep step,
    DeckSyncSession session,
  ) {
    return step.apply(session);
  }

  static void _ensureAuthenticated({required String userId}) {
    if (!AuthService.isAuthenticatedRemote || userId.trim().isEmpty) {
      throw const SyncException(
        'Sign in to sync your data.',
        code: 'DECK_SYNC_AUTH_REQUIRED',
      );
    }
  }
}
