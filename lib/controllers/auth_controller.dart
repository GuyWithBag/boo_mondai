// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/auth_controller.dart
// PURPOSE: Manages UI state, loading indicators, and migration flows.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService;

  AuthController({AuthService? authService})
    : _authService = authService ?? AuthService();

  bool _isLoading = false;
  String? _error;

  /// Holds the result of the latest auth action to drive UI logic (like merges)
  AuthServiceResponse? authServiceResponse;

  // ── Getters ─────────────────────────────────────────────

  Profile get currentProfile => LocalDB.profile.getOrCreate();

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Drives the UI prompt for merging guest data based on the latest auth response.
  bool get hasPendingGuestMerge => authServiceResponse?.needsMerge ?? false;

  // ── Actions ─────────────────────────────────────────────

  Future<void> restoreSession() async {
    _setLoading(true);
    try {
      await _authService.restoreSession();
    } catch (_) {
      // Network error on restore → stay in guest mode silently
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      authServiceResponse = await _authService.signIn(email, password);
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    _setLoading(true);
    try {
      authServiceResponse = await _authService.signUp(
        email,
        password,
        username,
      );
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> confirmMerge(bool merge) async {
    final guestId = authServiceResponse?.guestUserId;
    final remoteProfile = authServiceResponse?.profile;

    if (guestId == null || remoteProfile == null) return;

    _setLoading(true);
    try {
      await _authService.executeMergeDecision(merge, guestId, remoteProfile);
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      authServiceResponse = null; // Clear merge state once decision is executed
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      authServiceResponse = null; // Reset auth state on sign out
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _setLoading(false);
    }
  }

  // ── Helpers ─────────────────────────────────────────────

  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _error = null; // Clear previous errors when starting a new action
    notifyListeners();
  }
}
