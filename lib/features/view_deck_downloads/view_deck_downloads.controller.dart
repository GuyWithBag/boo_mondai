// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/view_deck_downloads.controller.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        ChangeTrackerController,
        ChangeTrackerEntry,
        ChangeTrackerStatus,
        ChangeSource,
        DeckDownloadsService,
        DownloadCheckpointLocalDB,
        LocalDB,
        Services,
        Deck;

class ViewDeckDownloadsController extends Controller {
  ViewDeckDownloadsController({
    required this.changeTrackerController,
    DeckDownloadsService? downloadsService,
    DownloadCheckpointLocalDB? checkpointDB,
  }) : _downloadsService = downloadsService ?? Services.deckDownloads,
       _checkpointDB = checkpointDB ?? LocalDB.downloadCheckpoint {
    changeTrackerController.addListener(_onReviewChanged);
    _autoResumeInterruptedDownloads();
  }

  final ChangeTrackerController changeTrackerController;
  final DeckDownloadsService _downloadsService;
  final DownloadCheckpointLocalDB _checkpointDB;

  List<ChangeTrackerEntry> _activeEntries = [];
  List<ChangeTrackerEntry> _completedPlans = [];

  List<ChangeTrackerEntry> get activeEntries => _activeEntries;
  List<ChangeTrackerEntry> get completedPlans => _completedPlans;
  bool get isEmpty => _activeEntries.isEmpty && _completedPlans.isEmpty;

  // ── Auto-resume ───────────────────────────────────────────────────────────

  /// On init, finds any checkpoints that were mid-download when the app was
  /// killed and resumes them automatically.
  void _autoResumeInterruptedDownloads() {
    final interrupted = [
      ..._checkpointDB.getDownloading(),
      ..._checkpointDB.getPaused(),
    ];

    for (final checkpoint in interrupted) {
      // Find the local deck so we can pass it as sourceDeck
      final localDeck = LocalDB.deck
          .selectMany(
            where: (d) => d.sourceDeckId == checkpoint.deckId,
            limit: 1,
          )
          .firstOrNull;

      if (localDeck == null) continue;

      // Create a fresh plan for this resumed download
      final plan = changeTrackerController.start(
        entry: ChangeTrackerEntry(
          source: ChangeSource.deckDownload,
          title: checkpoint.deckTitle,
          status: ChangeTrackerStatus.applying,
          progress: checkpoint.progress,
        ),
      );

      _downloadsService.downloadDeck(localDeck, resumeEntryId: plan.id);
    }
  }

  // ── Plan list ─────────────────────────────────────────────────────────────

  void _onReviewChanged() {
    final all = changeTrackerController.entries
        .where((p) => p.source == ChangeSource.deckDownload)
        .toList();

    _activeEntries = all.where((p) => _isActive(p.status)).toList();
    _completedPlans = all
        .where((p) => p.status == ChangeTrackerStatus.completed)
        .toList();
    notifyListeners();
  }

  static bool _isActive(ChangeTrackerStatus status) =>
      status == ChangeTrackerStatus.planning ||
      status == ChangeTrackerStatus.fetching ||
      status == ChangeTrackerStatus.applying ||
      status == ChangeTrackerStatus.paused ||
      status == ChangeTrackerStatus.reviewing;

  // ── Actions ───────────────────────────────────────────────────────────────

  void pauseDownload(String entryId) {
    _downloadsService.pauseDownload(entryId);
    changeTrackerController.pause(entryId);
  }

  void resumeDownload(String entryId) {
    final plan = changeTrackerController.entryById(entryId);
    if (plan == null) return;

    // Find the source deck via checkpoint
    final checkpoint = _checkpointDB
        .getPaused()
        .where((c) => true) // all paused ones are candidates
        .firstOrNull;
    if (checkpoint == null) return;

    final localDeck = LocalDB.deck
        .selectMany(where: (d) => d.sourceDeckId == checkpoint.deckId, limit: 1)
        .firstOrNull;
    if (localDeck == null) return;

    changeTrackerController.resume(entryId);
    _downloadsService.resumeDownload(localDeck, entryId);
  }

  void cancelDownload(String entryId) {
    _downloadsService.pauseDownload(entryId); // stop the loop first
    changeTrackerController.cancel(entryId);
    changeTrackerController.remove(entryId);

    // Clean up checkpoint
    final checkpoint =
        _checkpointDB.getPaused().firstOrNull ??
        _checkpointDB.getDownloading().firstOrNull;
    if (checkpoint != null) {
      _checkpointDB.deleteByPk({'deck_id': checkpoint.deckId});
    }
  }

  void dismissCompleted(String entryId) {
    changeTrackerController.remove(entryId);
  }

  /// Returns the local deck for a completed plan, found via sourceDeckId.
  Deck? localDeckForPlan(ChangeTrackerEntry entry) {
    final deckChange = entry.changes
        .where((c) => c.entityType == 'deck')
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
        .where((c) => c.entityType == 'deck')
        .firstOrNull;
    final remoteId = deckChange?.remoteId;
    if (remoteId == null) return 0;
    return _checkpointDB.getByDeckId(remoteId)?.progress ?? 0;
  }

  @override
  void dispose() {
    changeTrackerController.removeListener(_onReviewChanged);
    super.dispose();
  }
}
