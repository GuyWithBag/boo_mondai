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
        LocalDB,
        showModal,
        ModalTone,
        ModalAction,
        ButtonColor,
        SyncDeckService;
import 'package:flutter/material.dart';

class AuthController extends Controller {
  /// Holds the result of the latest auth action to drive UI logic (like merges)
  AuthServiceResponse? authServiceResponse;

  // ── Getters ─────────────────────────────────────────────

  Profile get currentProfile => LocalDB.profile.getOrCreate();

  String? get currentEmail => AuthService.currentUser?.email;

  bool get isAuthenticatedEither => AuthService.isAuthenticatedEither;

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

  Future<void> signIn({required String email, required String password}) async {
    setLoading(true);
    try {
      authServiceResponse = await AuthService.signIn(email, password);
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<bool> showPendingGuestMerge({required BuildContext context}) async {
    if (!hasPendingGuestMerge) return false;

    final shouldMerge = await showModal<bool>(
      context: context,
      barrierDismissible: false,
      title: 'You have local data',
      subtitle:
          'Merge your decks and study progress into this account, or discard the local data and load your account data instead.',
      leading: const Icon(Icons.sync_alt),
      actions: const [
        ModalAction<bool>(
          value: false,
          label: 'Discard local data',
          color: ButtonColor.error,
        ),
        ModalAction<bool>(
          value: true,
          label: 'Merge into account',
          color: ButtonColor.error,
        ),
      ],
    );

    if (shouldMerge == null) return false;
    await confirmMerge(shouldMerge);
    return true;
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

  Future<bool> hasLocalSyncData() async {
    final profileId = currentProfile.id;
    final decks = LocalDB.deck.getByCurrentProfile();

    if (decks.isEmpty) return false;

    for (final deck in decks) {
      final tables = SyncDeckService.getTables(deckId: deck.id);

      for (final table in tables) {
        final getLocalIndex = table.getLocalIndex;
        if (getLocalIndex == null) continue;

        final localIndex = await getLocalIndex(profileId);
        if (localIndex.isNotEmpty) return true;
      }
    }

    return false;
  }

  Future<void> onSignOutPressed({required BuildContext context}) async {
    setLoading(true);
    if (!await hasLocalSyncData()) {
      if (!context.mounted) return;
      showModal<void>(
        context: context,
        tone: ModalTone.error,
        leading: const Icon(Icons.logout),
        actionsMainAxisAlignment: MainAxisAlignment.spaceBetween,
        title: 'Sign Out',
        subtitle: 'Are you sure?',
        actions: [
          ModalAction(value: null, label: 'Cancel'),
          ModalAction(value: null, label: 'Continue', onPressed: signOut),
        ],
      );
      setLoading(false);
      return;
    }

    if (!context.mounted) return;

    showModal<void>(
      context: context,
      tone: ModalTone.error,
      leading: const Icon(Icons.logout),
      showCancelButton: true,
      actionsMainAxisAlignment: MainAxisAlignment.spaceBetween,
      title: 'Sign Out',
      subtitle:
          'Keep your local data on this device, or remove it after signing out.',
      actions: [
        ModalAction(value: null, label: 'Keep data', onPressed: signOut),
        ModalAction(
          value: null,
          label: 'Remove data',
          color: ButtonColor.hard,
          onPressed: onRemoveDataPressed,
        ),
      ],
    );
    setLoading(false);
  }

  Future<void> signOut({bool removeLocalData = false}) async {
    setLoading(true);

    try {
      await AuthService.signOut();
      await LocalDB.cachedProfile.clear();
      if (removeLocalData) {
        await LocalDB.clearAll();
      }
      authServiceResponse = null; // Reset auth state on sign out
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> onRemoveDataPressed() async {
    await LocalDB.clearAll();
    await signOut();
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
