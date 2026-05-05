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

  Profile? _userProfile;
  bool _isLoading = false;
  String? _error;

  bool _hasPendingGuestMerge = false;
  String? _pendingGuestId;

  // ── Getters ─────────────────────────────────────────────

  Profile? get userProfile => _userProfile;
  bool get isAuthenticated => _userProfile != null;
  bool get isGuest => !isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get role => _userProfile?.role;
  bool get hasPendingGuestMerge => _hasPendingGuestMerge;

  String get localUserId =>
      _authService.currentUser?.id ?? LocalDB.profile.getOrCreate().userId;

  // ── Actions ─────────────────────────────────────────────

  Future<void> restoreSession() async {
    _setLoading(true);
    try {
      _userProfile = await _authService.restoreSession();
    } catch (_) {
      // Network error on restore → stay in guest mode silently
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      final result = await _authService.signIn(email, password);
      _userProfile = result.profile;

      // If a merge is needed, surface it to the UI
      if (result.needsMerge) {
        _hasPendingGuestMerge = true;
        _pendingGuestId = result.guestUserId;
      }
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> confirmMerge(bool merge) async {
    final guestId = _pendingGuestId;
    if (guestId == null || _userProfile == null) return;

    _setLoading(true);
    try {
      await _authService.executeMergeDecision(merge, guestId, _userProfile!);
    } finally {
      _pendingGuestId = null;
      _hasPendingGuestMerge = false;
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    _setLoading(true);
    try {
      _userProfile = await _authService.signUp(email, password, username);
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _userProfile = null;
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
