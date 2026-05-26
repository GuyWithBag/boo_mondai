// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/auth_controller.dart
// PURPOSE: Manages UI state, loading indicators, and migration flows.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        AuthService,
        AuthServiceResponse,
        Profile,
        Services,
        LocalDB;

class AuthController extends Controller {
  AuthService get service => Services.auth;

  /// Holds the result of the latest auth action to drive UI logic (like merges)
  AuthServiceResponse? authServiceResponse;

  // ── Getters ─────────────────────────────────────────────

  Profile get currentProfile => LocalDB.profile.getOrCreate();

  /// Drives the UI prompt for merging guest data based on the latest auth response.
  bool get hasPendingGuestMerge => authServiceResponse?.needsMerge ?? false;

  // ── Actions ─────────────────────────────────────────────

  Future<void> restoreSession() async {
    setLoading(true);
    try {
      await service.restoreSession();
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> signIn(String email, String password) async {
    setLoading(true);
    try {
      authServiceResponse = await service.signIn(email, password);
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    setLoading(true);
    try {
      authServiceResponse = await service.signInWithGoogle();
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    setLoading(true);
    try {
      authServiceResponse = await service.signUp(email, password, username);
    } on Exception catch (e) {
      setError(e); // Removed the debug junk!
    } finally {
      setLoading(false);
    }
  }

  Future<void> confirmMerge(bool merge) async {
    final guestId = authServiceResponse?.guestUserId;
    final remoteProfile = authServiceResponse?.profile;

    if (guestId == null || remoteProfile == null) return;

    setLoading(true);
    try {
      await service.executeMergeDecision(merge, guestId, remoteProfile);
    } on Exception catch (e) {
      setError(e);
    } finally {
      authServiceResponse = null; // Clear merge state once decision is executed
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    setLoading(true);
    try {
      await service.signOut();
      authServiceResponse = null; // Reset auth state on sign out
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> manualDevSignIn(String url) async {
    setLoading(true);
    try {
      await service.manualDevLogin(url);
    } catch (e) {
      setError(e as Exception);
    } finally {
      setLoading(false);
    }
  }
}
