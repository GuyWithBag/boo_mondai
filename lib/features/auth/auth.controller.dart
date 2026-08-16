// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/auth_controller.dart
// PURPOSE: Manages UI state, loading indicators, and migration flows.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart';
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
  // ── Getters ─────────────────────────────────────────────

  Profile get currentProfile => LocalDB.profile.getOrCreate();

  String? get currentEmail => AuthService.currentUser?.email;

  bool get isAuthenticatedEither => AuthService.isAuthenticatedEither;

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

  Future<AuthServiceResponse> signIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    setLoading(true);
    try {
      final response = await AuthService.signIn(email, password);
      return response;
    } on Exception catch (e) {
      setError(e);
      if (!context.mounted) {
        return (profile: null, needsMerge: false, guestUserId: null);
      }
      showSnackbar(context, message: e.toString());
    } finally {
      setLoading(false);
    }
    return (profile: null, needsMerge: false, guestUserId: null);
  }

  Future<bool> showPendingGuestMerge(
    BuildContext context, {
    required AuthServiceResponse authServiceResponse,
  }) async {
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

    final guestId = authServiceResponse.guestUserId;
    final remoteProfile = authServiceResponse.profile;

    if (guestId == null || remoteProfile == null) return false;

    setLoading(true);
    try {
      await AuthService.executeMergeDecision(
        authServiceResponse.needsMerge,
        guestId,
        remoteProfile,
      );
    } on Exception catch (e) {
      setError(e);
      if (!context.mounted) return false;
      showSnackbar(context, message: e.toString());
    } finally {
      setLoading(false);
    }
    return true;
  }

  Future<AuthServiceResponse> signInWithGoogle(BuildContext context) async {
    setLoading(true);
    try {
      final response = await AuthService.signInWithGoogle();
      return response;
    } on Exception catch (e) {
      setError(e);
      if (!context.mounted) {
        return (profile: null, needsMerge: false, guestUserId: null);
      }
      showSnackbar(context, message: e.toString());
    } finally {
      setLoading(false);
    }
    return (profile: null, needsMerge: false, guestUserId: null);
  }

  Future<AuthServiceResponse> signUp(
    BuildContext context, {
    required String email,
    required String password,
    required String username,
  }) async {
    setLoading(true);
    try {
      final response = await AuthService.signUp(email, password, username);
      return response;
    } on Exception catch (e) {
      setError(e);
      if (!context.mounted) {
        return (profile: null, needsMerge: false, guestUserId: null);
      }
      showSnackbar(context, message: e.toString());
    } finally {
      setLoading(false);
    }
    return (profile: null, needsMerge: false, guestUserId: null);
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

  Future<void> onSignOutPressed(BuildContext context) async {
    setLoading(true);
    if (!await hasLocalSyncData()) {
      if (!context.mounted) return;
      final proceed =
          await showModal<bool>(
            context: context,
            tone: ModalTone.error,
            leading: const Icon(Icons.logout),
            actionsMainAxisAlignment: MainAxisAlignment.spaceBetween,
            title: 'Sign Out',
            subtitle: 'Are you sure?',
            actions: [
              ModalAction(value: false, label: 'Cancel'),
              ModalAction(value: true, label: 'Continue'),
            ],
          ) ??
          false;
      if (!context.mounted) return;
      if (proceed) await signOut(context);
      setLoading(false);
      return;
    }

    if (!context.mounted) return;

    final proceed =
        await showModal<bool>(
          context: context,
          tone: ModalTone.error,
          leading: const Icon(Icons.logout),
          showCancelButton: true,
          actionsMainAxisAlignment: MainAxisAlignment.spaceBetween,
          title: 'Sign Out',
          subtitle:
              'Keep your local data on this device, or remove it after signing out.',
          actions: [
            ModalAction(value: false, label: 'Keep data'),
            ModalAction(
              value: true,
              label: 'Remove data',
              color: ButtonColor.hard,
            ),
          ],
        ) ??
        false;
    if (!context.mounted) return;
    if (proceed) {
      onRemoveDataPressed(context);
    } else {
      signOut(context);
    }
    setLoading(false);
  }

  Future<void> signOut(
    BuildContext context, {
    bool removeLocalData = false,
  }) async {
    setLoading(true);

    try {
      await AuthService.signOut();
      await LocalDB.cachedProfile.clear();
      if (removeLocalData) {
        await LocalDB.clearAll();
      }
    } on Exception catch (e) {
      setError(e);
      if (!context.mounted) return;
      showSnackbar(context, message: e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> onRemoveDataPressed(BuildContext context) async {
    await LocalDB.clearAll();
    if (!context.mounted) return;
    await signOut(context);
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
