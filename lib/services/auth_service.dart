// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/auth_service.dart
// PURPOSE: Pure business logic for Supabase auth and DB sync.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
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

  /// Restores a session and fetches the user profile if authenticated.
  /// If an OAuth session is restored but no profile exists, it automatically creates one.
  Future<Profile?> restoreSession() async {
    final user = currentUser;
    if (user != null) {
      Profile? profileData = await RemoteDB.profile.selectByUserId(user.id);

      // Handle edge-case: User authenticated via web OAuth deep-link
      // but hasn't had a profile generated in RemoteDB yet.
      if (profileData == null) {
        final fallbackUsername = await _createFallbackUsername(user);
        profileData = await _upsertNewRemoteProfile(user.id, fallbackUsername);
      }

      await LocalDB.profile.upsert(profileData);
      return profileData;
    }
    return null;
  }

  /// Signs in the user via Email/Password.
  /// Returns a record containing the profile and whether a guest data merge prompt is required.
  Future<AuthServiceResponse> signIn(String email, String password) async {
    final guestUserId = LocalDB.profile.getOrCreate().userId;

    await _client.auth.signInWithPassword(email: email, password: password);
    final user = _client.auth.currentUser;
    if (user == null) throw AppException('Sign in failed.');

    final remoteProfileData = await RemoteDB.profile.selectByUserId(user.id);
    if (remoteProfileData != null) {
      await LocalDB.profile.upsert(remoteProfileData);
    }

    bool needsMerge = false;
    if (guestUserId != user.id &&
        GuestMigrationService.hasLocalData(guestUserId)) {
      needsMerge = true;
    }

    return (
      profile: remoteProfileData,
      needsMerge: needsMerge,
      guestUserId: needsMerge ? guestUserId : null,
    );
  }

  /// Third-Party Sign In (e.g., Google/Apple via ID Token).
  /// Acts as both Sign-Up and Sign-In. Automatically creates a profile if one does not exist.
  Future<AuthServiceResponse> signInWithIdToken({
    required OAuthProvider provider,
    required String idToken,
    required String accessToken,
  }) async {
    final guestUserId = LocalDB.profile.getOrCreate().userId;

    await _client.auth.signInWithIdToken(
      provider: provider,
      idToken: idToken,
      accessToken: accessToken,
    );

    final user = _client.auth.currentUser;
    if (user == null) throw AppException('${provider.name} sign in failed.');

    // Check if profile exists. If not, this is a new OAuth sign-up.
    Profile? profileData = await RemoteDB.profile.selectByUserId(user.id);
    if (profileData == null) {
      final fallbackUsername = await _createFallbackUsername(user);
      profileData = await _upsertNewRemoteProfile(user.id, fallbackUsername);
    }

    await LocalDB.profile.upsert(profileData);

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

  Future<String> _createFallbackUsername(User user) {
    final fallbackUsername =
        user.userMetadata?['full_name'] ??
        user.email?.split('@').first ??
        'User';
    return fallbackUsername;
  }

  /// Signs up a new user and creates their profile.
  /// Now correctly returns the merge tuple to trigger a prompt in the UI instead of silently migrating.
  Future<AuthServiceResponse> signUp(
    String email,
    String password,
    String username,
  ) async {
    final guestUserId = LocalDB.profile.getOrCreate().userId;

    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw AppException('Sign up failed.');

    final profile = await _upsertNewRemoteProfile(user.id, username);
    await LocalDB.profile.upsert(profile);

    bool needsMerge = false;
    if (guestUserId != user.id &&
        GuestMigrationService.hasLocalData(guestUserId)) {
      needsMerge = true;
    }

    return (
      profile: profile,
      needsMerge: needsMerge,
      guestUserId: needsMerge ? guestUserId : null,
    );
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
