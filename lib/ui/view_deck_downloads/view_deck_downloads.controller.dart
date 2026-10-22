// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/view_deck_downloads.controller.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangeTrackerController,
        ChangeTrackerEntry,
        ChangeTrackerStatus,
        ChangeSource,
        DeckDownloadsService,
        LocalDB,
        ProgressCheckpointLocalDB,
        ProgressCheckpointType,
        Services,
        Deck;
import 'package:signals/signals_flutter.dart';

class ViewDeckDownloadsController {
  ViewDeckDownloadsController({
    required this.changeTrackerController,
    DeckDownloadsService? downloadsService,
    ProgressCheckpointLocalDB? checkpointDB,
  }) : downloadsService = downloadsService ?? Services.deckDownloads,
       checkpointDB = checkpointDB ?? LocalDB.progressCheckpoint {
    activeEntries = computed(
      () => changeTrackerController.entries.value
          .where(
            (entry) =>
                entry.source == ChangeSource.deckDownload && entry.isActive,
          )
          .toList(growable: false),
    );
    completedPlans = computed(
      () => changeTrackerController.entries.value
          .where(
            (entry) =>
                entry.source == ChangeSource.deckDownload &&
                entry.status == ChangeTrackerStatus.completed,
          )
          .toList(growable: false),
    );
    isEmpty = computed(
      () => activeEntries.value.isEmpty && completedPlans.value.isEmpty,
    );
    autoResumeInterruptedDownloads();
  }

  final ChangeTrackerController changeTrackerController;
  final DeckDownloadsService downloadsService;
  final ProgressCheckpointLocalDB checkpointDB;
  late final Computed<List<ChangeTrackerEntry>> activeEntries;
  late final Computed<List<ChangeTrackerEntry>> completedPlans;
  late final Computed<bool> isEmpty;

  // ── Auto-resume ───────────────────────────────────────────────────────────

  /// On init, finds any checkpoints that were mid-download when the app was
  /// killed and resumes them automatically.
  void autoResumeInterruptedDownloads() {
    final interrupted = checkpointDB.getActiveByType(
      ProgressCheckpointType.deckDownloadFetch,
    );

    for (final checkpoint in interrupted) {
      // Find the local deck so we can pass it as sourceDeck
      final localDeck = LocalDB.deck
          .selectMany(
            where: (d) => d.sourceDeckId == checkpoint.targetId,
            limit: 1,
          )
          .firstOrNull;

      if (localDeck == null) continue;

      // Create a fresh plan for this resumed download
      final plan = changeTrackerController.start(
        entry: ChangeTrackerEntry(
          source: ChangeSource.deckDownload,
          title: localDeck.title,
          status: ChangeTrackerStatus.applying,
          progress: checkpoint.progress,
        ),
      );

      downloadsService.downloadDeck(localDeck, resumeEntryId: plan.id);
    }
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void pauseDownload(String entryId) {
    downloadsService.pauseDownload(entryId);
    changeTrackerController.pause(entryId);
  }

  void resumeDownload(String entryId) {
    final plan = changeTrackerController.entryById(entryId);
    if (plan == null) return;

    // Find the source deck via checkpoint
    final checkpoint = checkpointDB
        .getActiveByType(ProgressCheckpointType.deckDownloadFetch)
        .firstOrNull;
    if (checkpoint == null) return;

    final localDeck = LocalDB.deck
        .selectMany(
          where: (d) => d.sourceDeckId == checkpoint.targetId,
          limit: 1,
        )
        .firstOrNull;
    if (localDeck == null) return;

    changeTrackerController.resume(entryId);
    downloadsService.resumeDownload(localDeck, entryId);
  }

  void cancelDownload(String entryId) {
    downloadsService.pauseDownload(entryId); // stop the loop first
    changeTrackerController.cancel(entryId);
    changeTrackerController.remove(entryId);

    // Clean up checkpoint
    final checkpoint = checkpointDB
        .getActiveByType(ProgressCheckpointType.deckDownloadFetch)
        .firstOrNull;
    if (checkpoint != null) {
      checkpointDB.deleteByPk({'id': checkpoint.id});
    }
  }

  void dismissCompleted(String entryId) {
    changeTrackerController.remove(entryId);
  }

  /// Returns the local deck for a completed plan, found via sourceDeckId.
  Deck? localDeckForPlan(ChangeTrackerEntry entry) {
    final deckChange = entry.changes
        .where((c) => c.typeName == 'deck')
        .firstOrNull;
    final remoteId = deckChange?.remoteId;
    if (remoteId == null) return null;
    return LocalDB.deck
        .selectMany(where: (d) => d.sourceDeckId == remoteId, limit: 1)
        .firstOrNull;
  }

  /// Progress for a plan, falling back to checkpoint if plan has none yet.
  double progressForPlan(ChangeTrackerEntry entry) {
    if ((entry.progress ?? 0) > 0) return entry.progress!;
    final deckChange = entry.changes
        .where((c) => c.typeName == 'deck')
        .firstOrNull;
    final remoteId = deckChange?.remoteId;
    if (remoteId == null) return 0;
    return checkpointDB
            .getByTypeAndTargetId(
              ProgressCheckpointType.deckDownloadFetch,
              remoteId,
            )
            ?.progress ??
        0;
  }

  void dispose() {
    isEmpty.dispose();
    completedPlans.dispose();
    activeEntries.dispose();
  }
}
