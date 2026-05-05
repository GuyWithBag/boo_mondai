// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/auth_provider.dart
// PURPOSE: Auth state — guest mode, Supabase sessions, and account migration
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/services/services.barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/repositories/repositories.dart';

/// Manages sign-in, sign-up, sign-out, session restoration, and the
/// one-time guest-data merge prompt shown when a guest signs into an
/// existing Supabase account.
///
/// Guest mode:     [isAuthenticated] == false, [localUserId] returns the
///                 persistent device UUID from [LocalIdentityService].
/// Authenticated:  [isAuthenticated] == true,  [localUserId] returns the
///                 Supabase UID (also persisted in [LocalIdentityService]).
class AuthProvider extends ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;

  /// Set to true after sign-in when the guest had local data to ask about.
  bool _hasPendingGuestMerge = false;

  /// The guest UUID captured just before sign-in, held until [confirmMerge].
  String? _pendingGuestId;

  // ── Getters ─────────────────────────────────────────────

  UserProfile? get userProfile => _userProfile;

  /// True only when the user has an active Supabase session.
  bool get isAuthenticated => _userProfile != null;

  /// True when the app is running without a Supabase account.
  bool get isGuest => !isAuthenticated;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get role => _userProfile?.role;

  /// True while the merge dialog should be visible on the login screen.
  bool get hasPendingGuestMerge => _hasPendingGuestMerge;

  /// The canonical user ID for ALL local Hive data operations.
  ///
  /// Returns the live Supabase UID when authenticated, otherwise falls back
  /// to the persisted local UUID from [LocalIdentityService].
  /// After any sign-in/sign-up, [LocalIdentityService] is overwritten with
  /// the Supabase UID, so this value is consistent across sessions.
  String get localUserId =>
      Services.auth.currentUser?.id ?? LocalIdentityService.getOrCreate();

  // ── Session Restore ─────────────────────────────────────

  /// Called once at app startup. Restores a Supabase session if one exists;
  /// otherwise the app starts silently in guest mode — no redirect, no error.
  Future<void> restoreSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final session = Services.auth.currentSession;
      if (session != null) {
        final profileData = await Services.auth.getProfile(session.user.id);
        if (profileData != null) {
          _userProfile = UserProfileMapper.fromMap(profileData);
          await LocalDB.userProfile.put(_userProfile!);
        }
        // Keep local identity aligned with the Supabase UID.
        await LocalIdentityService.overwrite(session.user.id);
      }
      // No session → stay as guest. _userProfile remains null.
      // localUserId returns the guest UUID from LocalIdentityService.
    } catch (_) {
      // Network error on restore → stay in guest mode, no crash.
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Sign In ─────────────────────────────────────────────

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Capture the current local identity BEFORE authentication.
      final guestId = LocalIdentityService.getOrCreate();

      // 2. Authenticate with Supabase.
      await Services.auth.signIn(email, password);
      final user = Services.auth.currentUser;
      if (user == null) throw AppException('Sign in failed.');

      // 3. Load the Supabase profile and cache it locally.
      final profileData = await Services.auth.getProfile(user.id);
      if (profileData != null) {
        _userProfile = UserProfileMapper.fromMap(profileData);
        await LocalDB.userProfile.put(_userProfile!);
      }

      // 4. Check whether the guest had any local data worth asking about.
      //    We only prompt if the guest UUID differs from the Supabase UID
      //    (they always do unless the user somehow signed in as themselves).
      if (guestId != user.id && GuestMigrationService.hasLocalData(guestId)) {
        // Park the guest ID — the LoginPage will show the merge dialog.
        _pendingGuestId = guestId;
        _hasPendingGuestMerge = true;
        // Do NOT overwrite LocalIdentityService yet; that happens in
        // confirmMerge once the user makes their choice.
      } else {
        await LocalIdentityService.overwrite(user.id);
      }
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Merge Decision ───────────────────────────────────────

  /// Called by the merge dialog after the user makes their choice.
  ///
  /// [merge] true  → re-key guest Hive data to the Supabase UID.
  /// [merge] false → delete guest Hive data; start fresh from the account.
  Future<void> confirmMerge(bool merge) async {
    final guestId = _pendingGuestId;
    final user = Services.auth.currentUser;
    if (guestId == null || user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (merge) {
        await GuestMigrationService.migrateLocalData(guestId, user.id);
      } else {
        await GuestMigrationService.discardGuestData(guestId);
      }
      await LocalIdentityService.overwrite(user.id);
    } finally {
      _pendingGuestId = null;
      _hasPendingGuestMerge = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Sign Up ─────────────────────────────────────────────

  /// Creates a new Supabase account and silently migrates any guest data
  /// into the new account (no dialog needed — there is no conflict).
  Future<void> signUp(String email, String password, String userName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Capture guest ID before the account exists.
      final guestId = LocalIdentityService.getOrCreate();

      // 2. Register with Supabase.
      final tempProfile = UserProfile(
        id: UuidService.uuid.v4(),
        userName: userName,
        role: 'group_a_participant',
        createdAt: DateTime.now(),
      );
      final response = await Services.auth.signUp(email, password, tempProfile);
      final user = response.user;

      if (user != null) {
        // 3. Build the canonical profile keyed by the Supabase UID.
        final profile = UserProfile(
          id: user.id,
          userId: user.id,
          userName: userName,
          role: 'group_a_participant',
          createdAt: DateTime.now(),
        );
        await Services.auth.upsertProfile(profile.toMap());
        _userProfile = profile;
        await LocalDB.userProfile.put(profile);

        // 4. Silently migrate any existing guest data into the new account.
        if (guestId != user.id && GuestMigrationService.hasLocalData(guestId)) {
          await GuestMigrationService.migrateLocalData(guestId, user.id);
        }

        await LocalIdentityService.overwrite(user.id);
      }
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Sign Out ─────────────────────────────────────────────

  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Services.auth.signOut();
      _userProfile = null;
      await LocalDB.userProfile.clear();
      // LocalIdentityService intentionally retains the last UID so that
      // local data remains accessible in guest mode after sign-out.
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
