// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/auth_service.dart
// PURPOSE: Pure business logic for Supabase auth and DB sync.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Session? get currentSession => _client.auth.currentSession;
  User? get currentUser => _client.auth.currentUser;

  /// Restores a session and fetches the user profile if authenticated.
  Future<Profile?> restoreSession() async {
    if (currentSession != null) {
      final profileData = await RemoteDB.profile.selectByUserId(
        currentUser!.id,
      );
      if (profileData != null) {
        await LocalDB.profile.upsert(profileData);
      }
      // await LocalIdentityService.overwrite(session.user.id);
      return profileData;
    }
    return null;
  }

  /// Signs in the user. Returns a record containing the profile and whether
  /// a guest data merge prompt is required.
  Future<({Profile? profile, bool needsMerge, String? guestUserId})> signIn(
    String email,
    String password,
  ) async {
    final guestUserId = LocalDB.profile.getOrCreate().userId;

    await _client.auth.signInWithPassword(email: email, password: password);
    final user = _client.auth.currentUser;
    if (user == null) throw AppException('Sign in failed.');

    final profileData = await RemoteDB.profile.selectByUserId(user.id);
    if (profileData != null) {
      await LocalDB.profile.upsert(profileData);
    }

    bool needsMerge = false;
    if (guestUserId != user.id &&
        GuestMigrationService.hasLocalData(guestUserId)) {
      needsMerge = true;
    }

    return (
      profile: profileData,
      needsMerge: needsMerge,
      guestUserId: needsMerge ? guestUserId : null,
    );
  }

  /// Signs up a new user, creates their profile, and silently migrates guest data.
  Future<Profile> signUp(String email, String password, String username) async {
    final localProfile = LocalDB.profile.getOrCreate();
    final guestUserId = localProfile.userId;

    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) throw AppException('Sign up failed.');

    // Will create a new profile with the same id but new information based on the sign up form.
    final profile = Profile(
      id: localProfile.id,
      userId: user.id,
      role: '',
      username: username,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    await RemoteDB.profile.upsertOne(profile);
    await LocalDB.profile.upsert(profile);

    // Silently migrate guest data since it's a brand new account
    if (guestUserId != user.id &&
        GuestMigrationService.hasLocalData(guestUserId)) {
      await GuestMigrationService.migrateLocalData(guestUserId, user.id);
    }

    return profile;
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

  /// Clears out the session and local profile.
  Future<void> signOut() async {
    await _client.auth.signOut();
    await LocalDB.profile.clear();
  }
}
