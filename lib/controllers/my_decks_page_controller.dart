// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/my_decks_page_controller.dart
// PURPOSE: Loads and manages the list of user-created decks for My Decks page
// PROVIDERS: MyDecksPageController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

/// Drives the My Decks page — loads all decks sorted by [updatedAt] descending
/// and exposes delete operations.
class MyDecksPageController extends Controller {
  final DeckLocalDB _deckDB = LocalDB.deck;
  // Inside your Controller
  void init() {
    // Listen to Hive changes directly
    _deckDB.box.listenable().addListener(() {
      load(); // Automatically refresh whenever the box changes
    });
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
      // ToDo: Unchecked change.
      final all = _deckDB.selectMany();
      all.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      _decks = all;
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
      notifyListeners();
    }
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
      SyncService.sync(
        localDb: LocalDB.deck,
        remoteDb: RemoteDB.deck,
        userId: LocalDB.profile.getOrCreate().userId,
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
