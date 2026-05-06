// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/my_decks_page_controller.dart
// PURPOSE: Loads and manages the list of user-created decks for My Decks page
// PROVIDERS: MyDecksPageController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

/// Drives the My Decks page — loads all decks sorted by [updatedAt] descending
/// and exposes delete operations.
class MyDecksPageController extends ChangeNotifier {
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
  bool _isLoading = false;
  String? _error;

  bool _isSyncing = false;
  String? _syncError;

  // ── public getters ───────────────────────────────────────

  List<Deck> get decks => List.unmodifiable(_decks);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSyncing => _isSyncing;
  String? get syncError => _syncError;

  // ── methods ──────────────────────────────────────────────

  /// Loads all decks from the repository, sorted by [updatedAt] descending.
  void load() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // ToDo: Unchecked change.
      final all = _deckDB.getAll();
      all.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      _decks = all;
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Deletes the deck with the given [id] from the repository, then reloads.
  Future<void> deleteDeck(String id) async {
    _isLoading = true;
    _error = null;
    try {
      await _deckDB.delete(id);
      // load();
    } on Exception catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears any active error message and notifies listeners.
  void clearError() {
    _error = null;
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
