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
        Deck,
        DeckSearchFilterCodec,
        DeckSearchResults,
        AppException,
        SnackbarTone,
        showViewDeckLocalSheet,
        showSnackbar,
        SyncService,
        RemoteDB;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

/// Drives the My Decks page — loads all decks sorted by [updatedAt] descending
/// and exposes delete operations.
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

  // ── methods ──────────────────────────────────────────────

  /// Loads all decks from the repository, sorted by [updatedAt] descending.
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

  /// Deletes the deck with the given [id] from the repository, then reloads.
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

  /// Clears any active error message and notifies listeners.
  void clearError() {
    setError(null);
    notifyListeners();
  }

  void clearSyncError() {
    _syncError = null;
    notifyListeners();
  }

  /// Pull remote decks (newer [updatedAt] wins), then push all local decks.
  ///
  Future<void> sync() async {
    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      final profile = LocalDB.profile.getOrCreate();
      await LocalDB.deck.adoptLegacyOwnerId(
        legacyUserId: profile.userId,
        currentProfileId: profile.id,
      );

      await SyncService.sync(
        localDb: LocalDB.deck,
        remoteDb: RemoteDB.deck,
        userId: profile.id,
        localWhere: (deck) => deck.userId == profile.id,
      );

      // ── 3. Reload ────────────────────────────────────────
      load();
    } on AppException catch (e) {
      _syncError = e.message;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
}
