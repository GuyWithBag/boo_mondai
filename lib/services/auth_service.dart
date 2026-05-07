// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/auth_service.dart
// PURPOSE: Pure business logic for Supabase auth and DB sync.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:developer' as developer;

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/exceptions/exceptions.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef AuthServiceResponse = ({
  Profile? profile,
  bool needsMerge,
  String? guestUserId,
});

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Session? get currentSession => _client.auth.currentSession;
  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => _client.auth.currentUser != null;

  // ── Auth Guard ─────────────────────────────────────────────

  /// Internal helper to catch Auth errors and log them.
  Future<T> _guard<T>(Future<T> Function() fn, {required String action}) async {
    try {
      return await fn();
    } on AuthException catch (e) {
      // Log it just like we do in the DB service
      developer.log(
        'Auth Error during $action: ${e.message}',
        name: 'AuthService',
      );

      // Silently report to Crashlytics if you have it
      // FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Auth: $action');

      throw AppException(e.message, code: e.statusCode);
    } catch (e) {
      developer.log('Unexpected Error during $action: $e', name: 'AuthService');
      rethrow;
    }
  }

  // ── Logic ──────────────────────────────────────────────────

  Future<Profile?> restoreSession() async {
    // This uses RemoteDB, which is already guarded, so no extra try-catch needed here.
    final user = currentUser;
    if (user == null) return null;

    Profile? profileData = await RemoteDB.profile.selectByUserId(user.id);

    if (profileData == null) {
      final fallbackUsername = await _createFallbackUsername(user);
      profileData = await _upsertNewRemoteProfile(user.id, fallbackUsername);
    }

    await LocalDB.profile.upsert(profileData);
    return profileData;
  }

  Future<AuthServiceResponse> signIn(String email, String password) async {
    final guestUserId = LocalDB.profile.getOrCreate().userId;

    // Wrap the actual auth call in the guard
    await _guard(
      () => _client.auth.signInWithPassword(email: email, password: password),
      action: 'signInWithPassword',
    );

    final user = _client
        .auth
        .currentUser!; // Safe to bang-operator because guard would have caught failure

    final remoteProfileData = await RemoteDB.profile.selectByUserId(user.id);
    if (remoteProfileData != null) {
      await LocalDB.profile.upsert(remoteProfileData);
    }

    bool needsMerge =
        guestUserId != user.id &&
        GuestMigrationService.hasLocalData(guestUserId);

    return (
      profile: remoteProfileData,
      needsMerge: needsMerge,
      guestUserId: needsMerge ? guestUserId : null,
    );
  }

  Future<AuthServiceResponse> signInWithIdToken({
    required OAuthProvider provider,
    required String idToken,
    required String accessToken,
  }) async {
    final guestUserId = LocalDB.profile.getOrCreate().userId;

    await _guard(
      () => _client.auth.signInWithIdToken(
        provider: provider,
        idToken: idToken,
        accessToken: accessToken,
      ),
      action: 'signInWithIdToken(${provider.name})',
    );

    final user = _client.auth.currentUser!;

    Profile? profileData = await RemoteDB.profile.selectByUserId(user.id);
    if (profileData == null) {
      final fallbackUsername = await _createFallbackUsername(user);
      profileData = await _upsertNewRemoteProfile(user.id, fallbackUsername);
    }

    await LocalDB.profile.upsert(profileData);

    bool needsMerge =
        guestUserId != user.id &&
        GuestMigrationService.hasLocalData(guestUserId);

    return (
      profile: profileData,
      needsMerge: needsMerge,
      guestUserId: needsMerge ? guestUserId : null,
    );
  }

  Future<AuthServiceResponse> signUp(
    String email,
    String password,
    String username,
  ) async {
    final guestUserId = LocalDB.profile.getOrCreate().userId;

    final response = await _guard(
      () => _client.auth.signUp(email: email, password: password),
      action: 'signUp',
    );

    final user = response.user!;

    final profile = await _upsertNewRemoteProfile(user.id, username);
    await LocalDB.profile.upsert(profile);

    bool needsMerge =
        guestUserId != user.id &&
        GuestMigrationService.hasLocalData(guestUserId);

    return (
      profile: profile,
      needsMerge: needsMerge,
      guestUserId: needsMerge ? guestUserId : null,
    );
  }

  /// Clears out the session and local profile.
  Future<void> signOut() async {
    await _client.auth.signOut();
    await LocalDB.profile.clear();
  }

  /// Executes the migration or deletion of guest data based on user choice.
  Future<void> executeMergeDecision(
    bool merge,
    String guestUserId,
    Profile remoteProfile,
  ) async {
    if (merge) {
      await GuestMigrationService.migrateLocalData(
        guestUserId,
        remoteProfile.userId,
      );
    } else {
      await GuestMigrationService.discardGuestData(guestUserId);
    }
    await LocalDB.profile.upsert(remoteProfile);
  }

  Future<String> _createFallbackUsername(User user) {
    final fallbackUsername =
        user.userMetadata?['full_name'] ??
        user.email?.split('@').first ??
        'User';
    return fallbackUsername;
  }

  /// Will create a new profile with the same local ID but new information based on the sign-up form.
  Future<Profile> _upsertNewRemoteProfile(
    String newUserId,
    String newUsername,
  ) async {
    final localProfile = LocalDB.profile.getOrCreate();

    final profile = Profile(
      id: localProfile.id,
      userId: newUserId,
      role: 'user', // Assigned a default role instead of an empty string
      username: newUsername,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      isAnonymous: false,
    );

    await RemoteDB.profile.upsertOne(profile);
    return profile;
  }
}
