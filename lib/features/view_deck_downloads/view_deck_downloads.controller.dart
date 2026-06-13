// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/view_deck_downloads.controller.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        ChangeReviewController,
        ChangeReviewPlan,
        ChangeReviewStatus,
        ChangeSource,
        DeckDownloadsService,
        DownloadCheckpointLocalDB,
        DownloadCheckpointStatus,
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

  final ChangeReviewController reviewController;
  final DeckDownloadsService _downloadsService;
  final DownloadCheckpointLocalDB _checkpointDB;

  List<ChangeReviewPlan> _activePlans = [];
  List<ChangeReviewPlan> _completedPlans = [];

  List<ChangeReviewPlan> get activePlans => _activePlans;
  List<ChangeReviewPlan> get completedPlans => _completedPlans;
  bool get isEmpty => _activePlans.isEmpty && _completedPlans.isEmpty;

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
        status: ChangeReviewStatus.applying,
        progress: checkpoint.progress,
      );

      _downloadsService.downloadDeck(
        localDeck,
        reviewController,
        resumePlanId: plan.id,
      );
    }
  }

  // ── Plan list ─────────────────────────────────────────────────────────────

  void _onReviewChanged() {
    final all = reviewController.plans
        .where((p) => p.source == ChangeSource.deckDownload)
        .toList();

    _activePlans = all.where((p) => _isActive(p.status)).toList();
    _completedPlans = all
        .where((p) => p.status == ChangeReviewStatus.completed)
        .toList();
    notifyListeners();
  }

  static bool _isActive(ChangeReviewStatus status) =>
      status == ChangeReviewStatus.previewing ||
      status == ChangeReviewStatus.applying ||
      status == ChangeReviewStatus.paused ||
      status == ChangeReviewStatus.reviewing;

  // ── Actions ───────────────────────────────────────────────────────────────

  void pauseDownload(String planId) {
    _downloadsService.pauseDownload(planId);
    reviewController.pause(planId);
  }

  void resumeDownload(String planId) {
    final plan = reviewController.planById(planId);
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

    reviewController.resume(planId);
    _downloadsService.resumeDownload(localDeck, reviewController, planId);
  }

  void cancelDownload(String planId) {
    _downloadsService.pauseDownload(planId); // stop the loop first
    reviewController.cancel(planId);
    reviewController.remove(planId);

    // Clean up checkpoint
    final checkpoint =
        _checkpointDB.getPaused().firstOrNull ??
        _checkpointDB.getDownloading().firstOrNull;
    if (checkpoint != null) {
      _checkpointDB.deleteByPk({'deck_id': checkpoint.deckId});
    }
  }

  void dismissCompleted(String planId) {
    reviewController.remove(planId);
  }

  /// Returns the local deck for a completed plan, found via sourceDeckId.
  Deck? localDeckForPlan(ChangeReviewPlan plan) {
    final deckChange = plan.changes
        .where((c) => c.entityType == 'deck')
        .firstOrNull;
    final remoteId = deckChange?.remoteId;
    if (remoteId == null) return null;
    return LocalDB.deck
        .selectMany(where: (d) => d.sourceDeckId == remoteId, limit: 1)
        .firstOrNull;
  }

  /// Progress for a plan, falling back to checkpoint if plan has none yet.
  double progressForPlan(ChangeReviewPlan plan) {
    if ((plan.progress ?? 0) > 0) return plan.progress!;
    final deckChange = plan.changes
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
