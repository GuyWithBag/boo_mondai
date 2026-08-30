// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/auth_service.dart
// PURPOSE: Pure business logic for Supabase auth and DB sync.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:boo_mondai/lib.barrel.dart'
    show Profile, LocalDB, AppException, RemoteDB, GuestMigrationService;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef AuthServiceResponse = ({
  Profile? profile,
  bool needsMerge,
  String? guestUserId,
});

class AuthService {
  static SupabaseClient get _client => Supabase.instance.client;

  static Session? get currentSession => _client.auth.currentSession;
  static User? get currentUser => _client.auth.currentUser;
  static bool get isAuthenticatedRemote => _client.auth.currentUser != null;
  static bool get isAuthenticatedLocal =>
      LocalDB.profile.getOrCreate().isAnonymous == false;
  static bool get isAuthenticatedEither =>
      isAuthenticatedRemote || isAuthenticatedLocal;
  static bool get isAuthenticatedBoth =>
      isAuthenticatedRemote && isAuthenticatedLocal;

  // ── Auth Guard ─────────────────────────────────────────────

  /// Internal helper to catch Auth errors and log them.
  static Future<T> _guard<T>(
    Future<T> Function() fn, {
    required String action,
  }) async {
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
    } on SocketException catch (e, stack) {
      developer.log(
        'Network Error during $action: $e',
        name: 'AuthService',
        error: e,
        stackTrace: stack,
      );
      throw AppException(
        'Unable to reach the server. Check your network connection and try again.',
        code: 'NETWORK_ERROR',
        originalError: e,
        stackTrace: stack,
      );
    } on TimeoutException catch (e, stack) {
      developer.log(
        'Timeout Error during $action: $e',
        name: 'AuthService',
        error: e,
        stackTrace: stack,
      );
      throw AppException(
        'The request timed out. Please try again.',
        code: 'TIMEOUT',
        originalError: e,
        stackTrace: stack,
      );
    } catch (e, stack) {
      if (_isNetworkTransportError(e)) {
        developer.log(
          'Network Error during $action: $e',
          name: 'AuthService',
          error: e,
          stackTrace: stack,
        );
        throw AppException(
          'Unable to reach the server. Check your network connection and try again.',
          code: 'NETWORK_ERROR',
          originalError: e,
          stackTrace: stack,
        );
      }

      developer.log(
        'Unexpected Error during $action: $e',
        name: 'AuthService',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  static bool _isNetworkTransportError(Object e) {
    final typeName = e.runtimeType.toString();
    final message = e.toString();
    return typeName == 'ClientException' ||
        message.contains('ClientException') ||
        message.contains('Failed host lookup') ||
        message.contains('SocketException');
  }

  // ── Logic ──────────────────────────────────────────────────

  static Future<Profile?> restoreSession() async {
    // This uses RemoteDB, which is already guarded, so no extra try-catch needed here.
    final user = currentUser;
    if (user == null) return null;

    Profile? profileData = await RemoteDB.profile.selectByUserId(user.id);

    if (profileData == null) {
      final fallbackUsername = _createFallbackUsername(user);
      profileData = await _upsertNewRemoteProfile(user.id, fallbackUsername);
    }

    await LocalDB.profile.upsert(profileData);
    return profileData;
  }

  static Future<AuthServiceResponse> signIn(
    String email,
    String password,
  ) async {
    final guestProfileId = LocalDB.profile.getOrCreate().id;

    // Wrap the actual auth call in the guard
    await _guard(
      () => _client.auth.signInWithPassword(email: email, password: password),
      action: 'signInWithPassword',
    );

    final user = _client
        .auth
        .currentUser!; // Safe to bang-operator because guard would have caught failure

    var remoteProfileData = await RemoteDB.profile.selectByUserId(user.id);
    final createdProfile = remoteProfileData == null;
    if (remoteProfileData == null) {
      final fallbackUsername = _createFallbackUsername(user);
      remoteProfileData = await _upsertNewRemoteProfile(
        user.id,
        fallbackUsername,
      );
    }

    await LocalDB.profile.upsert(remoteProfileData);

    final hasLocalData = GuestMigrationService.hasLocalData(guestProfileId);
    final needsMerge =
        hasLocalData &&
        (createdProfile || guestProfileId != remoteProfileData.id);

    return (
      profile: remoteProfileData,
      needsMerge: needsMerge,
      guestUserId: needsMerge ? guestProfileId : null,
    );
  }

  static Future<AuthServiceResponse> signInWithGoogle() async {
    final guestProfileId = LocalDB.profile.getOrCreate().id;

    // Check if the app is running natively on mobile (iOS/Android)
    final isMobile = !kIsWeb && (Platform.isIOS || Platform.isAndroid);

    if (isMobile) {
      // ━━━ NATIVE MOBILE FLOW ━━━
      final response = await _guard(
        () => _nativeMobileGoogleSignIn(),
        action: 'signInWithGoogle(Native)',
      );

      final user = response.user!;
      return await _processSuccessfulSignIn(user, guestProfileId);
    } else {
      // ━━━ WEB / DESKTOP OAUTH FLOW ━━━
      final completer = Completer<AuthServiceResponse>();
      StreamSubscription<AuthState>? authSubscription;

      // Set up the listener *before* launching the browser
      authSubscription = _client.auth.onAuthStateChange.listen((data) async {
        final AuthChangeEvent event = data.event;

        if (event == AuthChangeEvent.signedIn) {
          await authSubscription?.cancel();
          try {
            final user = _client.auth.currentUser!;
            final response = await _processSuccessfulSignIn(
              user,
              guestProfileId,
            );
            completer.complete(response);
          } catch (e, stackTrace) {
            completer.completeError(e, stackTrace);
          }
        }
      });

      // Launch the browser
      try {
        await _guard(
          () => _client.auth.signInWithOAuth(
            OAuthProvider.google,
            redirectTo: kDebugMode
                ? 'http://127.0.0.1:3000'
                : 'boomondai://auth',
          ),
          action: 'signInWithOAuth(Google)',
        );
      } catch (e) {
        await authSubscription.cancel();
        rethrow;
      }

      return completer.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () {
          authSubscription?.cancel();
          throw AppException(
            'Google sign-in timed out. Please try again.',
            code: 'TIMEOUT',
          );
        },
      );
    }
  }

  static Future<AuthServiceResponse> signUp(
    String email,
    String password,
    String username,
  ) async {
    final guestProfileId = LocalDB.profile.getOrCreate().id;

    final response = await _guard(
      () => _client.auth.signUp(email: email, password: password),
      action: 'signUp',
    );

    final user = response.user!;

    final profile = await _upsertNewRemoteProfile(user.id, username);

    final needsMerge = GuestMigrationService.hasLocalData(guestProfileId);

    return (
      profile: profile,
      needsMerge: needsMerge,
      guestUserId: needsMerge ? guestProfileId : null,
    );
  }

  /// Clears out the session and local profile.
  static Future<void> signOut() async {
    await _client.auth.signOut();
    await LocalDB.profile.clear();
    LocalDB.profile.getOrCreate();
  }

  /// Executes the migration or deletion of guest data based on user choice.
  static Future<void> executeMergeDecision(
    bool merge,
    String guestUserId,
    Profile remoteProfile,
  ) async {
    if (merge) {
      await GuestMigrationService.migrateLocalData(
        guestUserId,
        remoteProfile.id,
      );
    } else {
      await GuestMigrationService.discardGuestData(guestUserId);
    }
    await LocalDB.profile.upsert(remoteProfile);
  }

  // You can stick this in your AuthService or directly in your UI for testing
  static Future<void> manualDevLogin(String urlFromBrowser) async {
    try {
      final uri = Uri.parse(urlFromBrowser);
      // This forces Supabase to process the URL as if it came from a deep link!
      await Supabase.instance.client.auth.getSessionFromUrl(uri);
      developer.log('✅ Dev Login Successful!');
    } catch (e) {
      developer.log('❌ Dev Login Failed: $e');
    }
  }

  static Future<AuthResponse> _nativeMobileGoogleSignIn() async {
    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '256317141710-6qfk8m7379n1619rduj3dqdkr4a8qevn.apps.googleusercontent.com';

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId = 'my-ios.apps.googleusercontent.com';

    final scopes = ['email', 'profile'];
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      serverClientId: webClientId,
      clientId: iosClientId,
    );
    final googleUser = await googleSignIn.attemptLightweightAuthentication();
    // or await googleSignIn.authenticate(); which will return a GoogleSignInAccount or throw an exception
    if (googleUser == null) {
      throw AuthException('Failed to sign in with Google.');
    }

    /// Authorization is required to obtain the access token with the appropriate scopes for Supabase authentication,
    /// while also granting permission to access user information.
    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
        await googleUser.authorizationClient.authorizeScopes(scopes);
    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw AuthException('No ID Token found.');
    }
    return await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );
  }

  /// Extracted logic to keep DB sync and Guest Merging DRY
  static Future<AuthServiceResponse> _processSuccessfulSignIn(
    User user,
    String guestProfileId,
  ) async {
    Profile? profileData = await RemoteDB.profile.selectByUserId(user.id);
    final createdProfile = profileData == null;

    if (profileData == null) {
      final fallbackUsername = _createFallbackUsername(user);
      profileData = await _upsertNewRemoteProfile(user.id, fallbackUsername);
    }

    await LocalDB.profile.upsert(profileData);

    final hasLocalData = GuestMigrationService.hasLocalData(guestProfileId);
    final needsMerge =
        hasLocalData && (createdProfile || guestProfileId != profileData.id);

    return (
      profile: profileData,
      needsMerge: needsMerge,
      guestUserId: needsMerge ? guestProfileId : null,
    );
  }

  static String _createFallbackUsername(User user) {
    final fallbackUsername =
        user.userMetadata?['full_name'] ??
        user.email?.split('@').first ??
        'User';
    return fallbackUsername;
  }

  /// Will create a new profile with the same local ID but new information based on the sign-up form.
  static Future<Profile> _upsertNewRemoteProfile(
    String newUserId,
    String newUsername,
  ) async {
    final localProfile = LocalDB.profile.getOrCreate();

    final profile = Profile(
      id: localProfile.id,
      userId: newUserId,
      role: null,
      username: newUsername,
      displayName: newUsername,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      isAnonymous: false,
    );

    await RemoteDB.profile.upsert(profile);
    await LocalDB.profile.upsert(profile);
    return profile;
  }
}
