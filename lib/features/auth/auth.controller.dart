// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/auth_controller.dart
// PURPOSE: Manages UI state, loading indicators, and migration flows.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';

import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthService,
        AuthServiceResponse,
        LocalDB,
        ProfileService,
        showModal,
        ModalTone,
        ModalAction,
        ButtonColor,
        SyncDeckService;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class AuthController {
  static const _backgroundRestoreTimeout = Duration(seconds: 5);

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Future<void>? _backgroundRestore;

  final currentProfile = ProfileService.currentProfile;
  final currentEmail = signal<String?>(AuthService.currentUser?.email);
  final isAuthenticatedRemote = signal(AuthService.isAuthenticatedRemote);
  final isLoading = signal(false);
  final isRestoringRemoteSession = signal(false);
  final error = signal<Exception?>(null);

  late final isAuthenticatedEither = computed(
    () => isAuthenticatedRemote.value || !currentProfile.value.isAnonymous,
  );

  late final routerRefresh = computed(
    () => (
      profileId: currentProfile.value.id,
      role: currentProfile.value.role,
      isResearcher: currentProfile.value.isResearcher,
      isAnonymous: currentProfile.value.isAnonymous,
      currentEmail: currentEmail.value,
      isAuthenticatedRemote: isAuthenticatedRemote.value,
    ),
  );

  // ── Getters ─────────────────────────────────────────────

  void refresh() {
    currentProfile.value = LocalDB.currentProfile.getOrCreate();
    currentEmail.value = AuthService.currentUser?.email;
    isAuthenticatedRemote.value = AuthService.isAuthenticatedRemote;
  }

  // ── Actions ─────────────────────────────────────────────

  Future<void> restoreSession() async {
    isLoading.value = true;
    error.value = null;
    try {
      await AuthService.restoreSession();
    } on Exception catch (e) {
      error.value = e;
    } finally {
      refresh();
      isLoading.value = false;
    }
  }

  void startRemoteSessionRestoreListener() {
    if (_connectivitySubscription != null) return;

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      if (_hasNetwork(results)) {
        restoreSessionInBackground();
      }
    });

    restoreSessionInBackground();
  }

  Future<void> restoreSessionInBackground() {
    final running = _backgroundRestore;
    if (running != null) return running;

    final restore = _restoreSessionInBackground();
    _backgroundRestore = restore.whenComplete(() {
      if (identical(_backgroundRestore, restore)) {
        _backgroundRestore = null;
      }
    });
    return _backgroundRestore!;
  }

  Future<void> _restoreSessionInBackground() async {
    isRestoringRemoteSession.value = true;
    error.value = null;
    try {
      await AuthService.restoreSession().timeout(_backgroundRestoreTimeout);
    } on Exception catch (e) {
      error.value = e;
    } finally {
      refresh();
      isRestoringRemoteSession.value = false;
    }
  }

  bool _hasNetwork(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  Future<AuthServiceResponse> signIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    error.value = null;
    try {
      final response = await AuthService.signIn(email, password);
      return response;
    } on Exception catch (e) {
      error.value = e;
      if (!context.mounted) {
        return (profile: null, needsMerge: false, guestUserId: null);
      }
      showSnackbar(context, message: e.toString());
    } finally {
      refresh();
      isLoading.value = false;
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

    isLoading.value = true;
    error.value = null;
    try {
      await AuthService.executeMergeDecision(
        authServiceResponse.needsMerge,
        guestId,
        remoteProfile,
      );
    } on Exception catch (e) {
      error.value = e;
      if (!context.mounted) return false;
      showSnackbar(context, message: e.toString());
    } finally {
      refresh();
      isLoading.value = false;
    }
    return true;
  }

  Future<AuthServiceResponse> signInWithGoogle(BuildContext context) async {
    isLoading.value = true;
    error.value = null;
    try {
      final response = await AuthService.signInWithGoogle();
      return response;
    } on Exception catch (e) {
      error.value = e;
      if (!context.mounted) {
        return (profile: null, needsMerge: false, guestUserId: null);
      }
      showSnackbar(context, message: e.toString());
    } finally {
      refresh();
      isLoading.value = false;
    }
    return (profile: null, needsMerge: false, guestUserId: null);
  }

  Future<AuthServiceResponse> signUp(
    BuildContext context, {
    required String email,
    required String password,
    required String username,
  }) async {
    isLoading.value = true;
    error.value = null;
    try {
      final response = await AuthService.signUp(email, password, username);
      return response;
    } on Exception catch (e) {
      error.value = e;
      if (!context.mounted) {
        return (profile: null, needsMerge: false, guestUserId: null);
      }
      showSnackbar(context, message: e.toString());
    } finally {
      refresh();
      isLoading.value = false;
    }
    return (profile: null, needsMerge: false, guestUserId: null);
  }

  Future<bool> hasLocalSyncData() async {
    final profileId = currentProfile.value.id;
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
    isLoading.value = true;
    error.value = null;
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
      isLoading.value = false;
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
    isLoading.value = false;
  }

  Future<void> signOut(
    BuildContext context, {
    bool removeLocalData = false,
  }) async {
    isLoading.value = true;
    error.value = null;

    try {
      await AuthService.signOut();
      await LocalDB.profiles.clear();
      if (removeLocalData) {
        await LocalDB.clearAll();
      }
    } on Exception catch (e) {
      error.value = e;
      if (!context.mounted) return;
      showSnackbar(context, message: e.toString());
    } finally {
      refresh();
      isLoading.value = false;
    }
  }

  Future<void> onRemoveDataPressed(BuildContext context) async {
    await LocalDB.clearAll();
    if (!context.mounted) return;
    await signOut(context);
  }

  Future<void> manualDevSignIn(String url) async {
    isLoading.value = true;
    error.value = null;
    try {
      await AuthService.manualDevLogin(url);
    } catch (e) {
      error.value = e as Exception;
    } finally {
      refresh();
      isLoading.value = false;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    routerRefresh.dispose();
    isAuthenticatedEither.dispose();
    error.dispose();
    isLoading.dispose();
    isRestoringRemoteSession.dispose();
    isAuthenticatedRemote.dispose();
    currentEmail.dispose();
  }
}
