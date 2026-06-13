// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/view_decks.local.controller.dart
// PURPOSE: Loads and manages the list of user-created decks for My Decks page
// PROVIDERS: ViewDecksLocalController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        DecksLocalDB,
        LocalDB,
        Controller,
        ChangeReviewController,
        ChangeSource,
        Deck,
        DeckSearchFilterCodec,
        DeckSearchResults,
        AppException,
        SnackbarTone,
        showViewDeckLocalSheet,
        showSnackbar,
        SyncService,
        RemoteDB,
        SyncPlanPayload,
        ChangePlan;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class ViewDecksLocalController extends Controller {
  static const deckSearchFilterCodec = DeckSearchFilterCodec();
  static const deckSearchResults = DeckSearchResults();

  final DecksLocalDB _deckDB = LocalDB.deck;
  late final Listenable _deckListenable;

  ViewDecksLocalController() {
    _deckListenable = _deckDB.box.listenable();
    _deckListenable.addListener(load);
  }

  @override
  void dispose() {
    _deckListenable.removeListener(load);
    super.dispose();
  }

  // ── private state ────────────────────────────────────────

  List<Deck> _decks = [];
  bool _isSyncing = false;
  String? _syncError;

  // ── public getters ───────────────────────────────────────

  List<Deck> get decks => List.unmodifiable(_decks);
  bool get isSyncing => _isSyncing;
  String? get syncError => _syncError;
  ChangePlan<SyncPlanPayload<Deck>>? changePlan;

  // ── methods ──────────────────────────────────────────────

  void load() {
    setLoading(true);
    setError(null);
    notifyListeners();

    try {
      _decks = _deckDB.filterDecks();
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  void goToDeck(BuildContext context, Deck deck) {
    showViewDeckLocalSheet(context, deck);
  }

  void loadOnNextFrame() {
    SchedulerBinding.instance.addPostFrameCallback((_) => load());
  }

  void showSyncErrorIfPresent(BuildContext context) {
    final err = syncError;
    if (err == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      showSnackbar(
        context: context,
        message: 'Sync failed: $err',
        leading: const Icon(Icons.sync_problem_outlined),
        duration: const Duration(seconds: 3),
        tone: SnackbarTone.error,
      );
      clearSyncError();
    });
  }

  void submitSearch(BuildContext context, List<Deck> visibleDecks) {
    if (visibleDecks.length != 1) return;
    goToDeck(context, visibleDecks.single);
  }

  Future<void> deleteDeck(String id) async {
    setLoading(true);
    setError(null);
    try {
      await _deckDB.deleteByPk({'id': id});
      load();
    } on Exception catch (e) {
      setError(e);
      setLoading(false);
      notifyListeners();
    }
  }

  void clearError() {
    setError(null);
    notifyListeners();
  }

  void clearSyncError() {
    _syncError = null;
    notifyListeners();
  }

  /// Call this when the user taps Apply — the plan completes naturally
  /// via ChangeReviewController, we just need to stop the loading indicator.
  void clearSyncing() {
    _isSyncing = false;
    notifyListeners();
  }

  /// Call this when the user taps Discard/Cancel — cancels and removes
  /// the plan from the controller and resets local sync state.
  void dismissSyncReview(
    ChangeReviewController reviewController,
    String planId,
  ) {
    _isSyncing = false;
    _syncError = null;
    reviewController.cancel(planId);
    reviewController.remove(planId);
    notifyListeners();
  }

  Future<void> sync(ChangeReviewController reviewController) async {
    // Guard: don't start a second sync if one is already active
    final alreadyActive = reviewController.activePlans.any(
      (p) => p.source == ChangeSource.sync,
    );
    if (alreadyActive) return;

    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      final profile = LocalDB.profile.getOrCreate();
      await LocalDB.deck.adoptLegacyOwnerId(
        legacyUserId: profile.userId,
        currentProfileId: profile.id,
      );

      changePlan = await SyncService.sync(
        localDb: LocalDB.deck,
        remoteDb: RemoteDB.deck,
        userId: profile.id,
        reviewController: reviewController,
        localWhere: (deck) => deck.userId == profile.id,
      );

      load();
    } on AppException catch (e) {
      if (_isSyncing) {
        _syncError = e.message;
      }
      _isSyncing = false;
    } finally {
      // Intentionally NOT setting _isSyncing = false here.
      // The plan is still alive in ChangeReviewController and SyncPage
      // is still showing. isSyncing flips only via clearSyncing() or
      // dismissSyncReview() when the user explicitly acts on the plan.
      notifyListeners();
    }
  }
}
