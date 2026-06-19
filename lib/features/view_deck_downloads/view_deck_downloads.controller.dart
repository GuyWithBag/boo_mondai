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
        Deck;

class ViewDeckDownloadsController extends Controller {
  ViewDeckDownloadsController({
    required this.reviewController,
    DeckDownloadsService? downloadsService,
    DownloadCheckpointLocalDB? checkpointDB,
  }) : _downloadsService = downloadsService ?? DeckDownloadsService(),
       _checkpointDB = checkpointDB ?? LocalDB.downloadCheckpoint {
    reviewController.addListener(_onReviewChanged);
    _autoResumeInterruptedDownloads();
  }

  final ChangeTrackerController reviewController;
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
      final plan = reviewController.start(
        source: ChangeSource.deckDownload,
        title: checkpoint.deckTitle,
        status: ChangeTrackerStatus.applying,
        progress: checkpoint.progress,
      );

      _downloadsService.downloadDeck(
        localDeck,
        reviewController,
        resumeEntryId: plan.id,
      );
    }
  }

  // ── Plan list ─────────────────────────────────────────────────────────────

  void _onReviewChanged() {
    final all = reviewController.entries
        .where((p) => p.source == ChangeSource.deckDownload)
        .toList();

    _activeEntries = all.where((p) => _isActive(p.status)).toList();
    _completedPlans = all
        .where((p) => p.status == ChangeTrackerStatus.completed)
        .toList();
    notifyListeners();
  }

  static bool _isActive(ChangeTrackerStatus status) =>
      status == ChangeTrackerStatus.previewing ||
      status == ChangeTrackerStatus.applying ||
      status == ChangeTrackerStatus.paused ||
      status == ChangeTrackerStatus.reviewing;

  // ── Actions ───────────────────────────────────────────────────────────────

  void pauseDownload(String entryId) {
    _downloadsService.pauseDownload(entryId);
    reviewController.pause(entryId);
  }

  void resumeDownload(String entryId) {
    final plan = reviewController.entryById(entryId);
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

    reviewController.resume(entryId);
    _downloadsService.resumeDownload(localDeck, reviewController, entryId);
  }

  void cancelDownload(String entryId) {
    _downloadsService.pauseDownload(entryId); // stop the loop first
    reviewController.cancel(entryId);
    reviewController.remove(entryId);

    // Clean up checkpoint
    final checkpoint =
        _checkpointDB.getPaused().firstOrNull ??
        _checkpointDB.getDownloading().firstOrNull;
    if (checkpoint != null) {
      _checkpointDB.deleteByPk({'deck_id': checkpoint.deckId});
    }
  }

  void dismissCompleted(String entryId) {
    reviewController.remove(entryId);
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
    reviewController.removeListener(_onReviewChanged);
    super.dispose();
  }
}
