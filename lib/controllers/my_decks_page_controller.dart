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
  final DeckLocalDB _deckRepository = LocalDB.deck;
  // Inside your Controller
  void init() {
    // Listen to Hive changes directly
    LocalDB.deck.box.listenable().addListener(() {
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
      final userId = LocalIdentityService.getOrCreate();
      final all = _deckRepository.getByAuthorId(userId);
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
      await _deckRepository.delete(id);
      load();
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
  /// Requires an authenticated Supabase session — call only when
  /// [AuthProvider.isAuthenticated] is true.
  Future<void> sync(String userId) async {
    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      // ── 1. Pull ──────────────────────────────────────────
      // Fetch all remote decks for this user and put any that are newer
      // than the local copy (or missing locally).
      final remoteDecks = await RemoteDB.deck.fetchByUserId(userId);
      for (final decks in remoteDecks) {
        final remote = decks;
        final local = _deckRepository.getById(remote.id);
        if (local == null || remote.updatedAt.isAfter(local.updatedAt)) {
          await _deckRepository.put(remote);
        }
      }

      // ── 2. Push ──────────────────────────────────────────
      // Upsert every local deck that belongs to this user.
      final localDecks = _deckRepository.getByAuthorId(userId);
      for (final deck in localDecks) {
        await RemoteDB.deck.upsertOne(deck);
      }

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
