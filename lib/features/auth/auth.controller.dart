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
        ProfileMediaService,
        RemoteDB,
        LocalDB;
import 'package:file_picker/file_picker.dart' show PlatformFile;

class AuthController extends Controller {
  /// Holds the result of the latest auth action to drive UI logic (like merges)
  AuthServiceResponse? authServiceResponse;

  // ── Getters ─────────────────────────────────────────────

  Profile get currentProfile => LocalDB.profile.getOrCreate();

  String? get currentEmail => AuthService.currentUser?.email;

  /// Drives the UI prompt for merging guest data based on the latest auth response.
  bool get hasPendingGuestMerge => authServiceResponse?.needsMerge ?? false;

  // ── Actions ─────────────────────────────────────────────

  Future<void> restoreSession() async {
    setLoading(true);
    try {
      await AuthService.restoreSession();
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> signIn(String email, String password) async {
    setLoading(true);
    try {
      authServiceResponse = await AuthService.signIn(email, password);
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    setLoading(true);
    try {
      authServiceResponse = await AuthService.signInWithGoogle();
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    setLoading(true);
    try {
      authServiceResponse = await AuthService.signUp(email, password, username);
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
      await AuthService.executeMergeDecision(merge, guestId, remoteProfile);
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
      await AuthService.signOut();
      authServiceResponse = null; // Reset auth state on sign out
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) return;

    final profile = currentProfile;
    final updated = profile.copyWith(
      displayName: trimmed,
      updatedAt: DateTime.now(),
    );
    await LocalDB.profile.upsert(updated);
    if (AuthService.isAuthenticatedRemote) {
      await RemoteDB.profile.upsert(
        await ProfileMediaService.uploadAvatarIfNeeded(
          profile: updated,
          bucket: RemoteDB.publicBucket,
        ),
      );
    }
    notifyListeners();
  }

  Future<void> updateAvatarImage(PlatformFile file) async {
    var updated = await ProfileMediaService.saveAvatarImage(
      profile: currentProfile,
      file: file,
    );
    if (updated == null) return;

    if (AuthService.isAuthenticatedRemote) {
      updated = await ProfileMediaService.uploadAvatarIfNeeded(
        profile: updated,
        bucket: RemoteDB.publicBucket,
      );
      await RemoteDB.profile.upsert(updated);
    }
    notifyListeners();
  }

  Future<void> manualDevSignIn(String url) async {
    setLoading(true);
    try {
      await AuthService.manualDevLogin(url);
    } catch (e) {
      setError(e as Exception);
    } finally {
      setLoading(false);
    }
  }
}
