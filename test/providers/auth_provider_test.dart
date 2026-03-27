// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/providers/auth_provider_test.dart
// PURPOSE: Unit tests for AuthProvider — sign-in, sign-up, sign-out, session restore
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../helpers/mock_supabase_service.mocks.dart';
import '../helpers/mock_hive_service.mocks.dart';
import '../helpers/fake_user_profile.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/services/services.dart';

void main() {
  late AuthProvider provider;
  late MockSupabaseService mockSupabase;
  late MockHiveService mockHive;

  setUp(() {
    mockSupabase = MockSupabaseService();
    mockHive = MockHiveService();
    provider = AuthProvider(
      supabaseService: mockSupabase,
      hiveService: mockHive,
    );
  });

  group('initial state', () {
    test('should not be authenticated', () {
      expect(provider.isAuthenticated, false);
      expect(provider.userProfile, isNull);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      expect(provider.role, isNull);
    });
  });

  group('signIn', () {
    test('success sets userProfile and caches in Hive', () async {
      final profile = fakeUserProfile();
      final profileJson = profile.toJson();

      when(mockSupabase.signIn('alice@test.com', 'password'))
          .thenAnswer((_) async => AuthResponse(session: null, user: null));
      when(mockSupabase.currentUser).thenReturn(_FakeUser(profile.id));
      when(mockSupabase.getProfile(profile.id))
          .thenAnswer((_) async => profileJson);
      when(mockHive.saveProfile(any)).thenAnswer((_) async {});

      await provider.signIn('alice@test.com', 'password');

      expect(provider.isAuthenticated, true);
      expect(provider.userProfile!.id, profile.id);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      verify(mockHive.saveProfile(any)).called(1);
    });

    test('failure sets error', () async {
      when(mockSupabase.signIn('bad@test.com', 'wrong'))
          .thenThrow(const AppException('Invalid login credentials'));

      await provider.signIn('bad@test.com', 'wrong');

      expect(provider.isAuthenticated, false);
      expect(provider.error, 'Invalid login credentials');
      expect(provider.isLoading, false);
    });

    test('sets isLoading during operation', () async {
      bool wasLoading = false;
      provider.addListener(() {
        if (provider.isLoading) wasLoading = true;
      });

      when(mockSupabase.signIn(any, any))
          .thenAnswer((_) async => AuthResponse(session: null, user: null));
      when(mockSupabase.currentUser).thenReturn(null);

      await provider.signIn('test@test.com', 'pass');

      expect(wasLoading, true);
      expect(provider.isLoading, false);
    });
  });

  group('signUp', () {
    test('success creates profile and caches', () async {
      final fakeUser = _FakeUser('new-user-id');
      final authResponse = AuthResponse(session: null, user: fakeUser);

      when(mockSupabase.signUp('new@test.com', 'pass123'))
          .thenAnswer((_) async => authResponse);
      when(mockSupabase.upsertProfile(any)).thenAnswer((_) async {});
      when(mockHive.saveProfile(any)).thenAnswer((_) async {});

      await provider.signUp('new@test.com', 'pass123', 'NewUser');

      expect(provider.isAuthenticated, true);
      expect(provider.userProfile!.email, 'new@test.com');
      expect(provider.userProfile!.displayName, 'NewUser');
      expect(provider.userProfile!.role, 'group_a_participant');
      expect(provider.isLoading, false);
      verify(mockSupabase.upsertProfile(any)).called(1);
      verify(mockHive.saveProfile(any)).called(1);
    });

    test('failure sets error', () async {
      when(mockSupabase.signUp('dup@test.com', 'pass'))
          .thenThrow(const AppException('User already registered'));

      await provider.signUp('dup@test.com', 'pass', 'Dup');

      expect(provider.isAuthenticated, false);
      expect(provider.error, 'User already registered');
    });
  });

  group('signOut', () {
    test('clears profile and Hive cache', () async {
      // First sign in
      final profile = fakeUserProfile();
      when(mockSupabase.signIn(any, any))
          .thenAnswer((_) async => AuthResponse(session: null, user: null));
      when(mockSupabase.currentUser)
          .thenReturn(_FakeUser(profile.id));
      when(mockSupabase.getProfile(profile.id))
          .thenAnswer((_) async => profile.toJson());
      when(mockHive.saveProfile(any)).thenAnswer((_) async {});
      await provider.signIn('alice@test.com', 'pass');
      expect(provider.isAuthenticated, true);

      // Now sign out
      when(mockSupabase.signOut()).thenAnswer((_) async {});
      when(mockHive.clearAll()).thenAnswer((_) async {});

      await provider.signOut();

      expect(provider.isAuthenticated, false);
      expect(provider.userProfile, isNull);
      verify(mockSupabase.signOut()).called(1);
      verify(mockHive.clearAll()).called(1);
    });

    test('failure sets error', () async {
      when(mockSupabase.signOut())
          .thenThrow(const AppException('Sign out failed'));
      when(mockHive.clearAll()).thenAnswer((_) async {});

      await provider.signOut();

      expect(provider.error, 'Sign out failed');
    });
  });

  group('restoreSession', () {
    test('with active session fetches profile from Supabase and caches', () async {
      final profile = fakeUserProfile();
      final fakeSession = _FakeSession(_FakeUser(profile.id));

      when(mockSupabase.currentSession).thenReturn(fakeSession);
      when(mockSupabase.getProfile(profile.id))
          .thenAnswer((_) async => profile.toJson());
      when(mockHive.saveProfile(any)).thenAnswer((_) async {});

      await provider.restoreSession();

      expect(provider.isAuthenticated, true);
      expect(provider.userProfile!.id, profile.id);
      verify(mockHive.saveProfile(any)).called(1);
    });

    test('without session loads from Hive cache', () async {
      final profile = fakeUserProfile();

      when(mockSupabase.currentSession).thenReturn(null);
      when(mockHive.getProfile()).thenReturn(profile);

      await provider.restoreSession();

      expect(provider.isAuthenticated, true);
      expect(provider.userProfile!.id, profile.id);
    });

    test('on error falls back to Hive cache', () async {
      final profile = fakeUserProfile();
      final fakeSession = _FakeSession(_FakeUser(profile.id));

      when(mockSupabase.currentSession).thenReturn(fakeSession);
      when(mockSupabase.getProfile(any))
          .thenThrow(const AppException('Network error'));
      when(mockHive.getProfile()).thenReturn(profile);

      await provider.restoreSession();

      expect(provider.isAuthenticated, true);
      expect(provider.userProfile!.id, profile.id);
    });

    test('no session and no cache results in unauthenticated', () async {
      when(mockSupabase.currentSession).thenReturn(null);
      when(mockHive.getProfile()).thenReturn(null);

      await provider.restoreSession();

      expect(provider.isAuthenticated, false);
    });
  });

  group('clearError', () {
    test('sets error to null and notifies', () async {
      when(mockSupabase.signIn(any, any))
          .thenThrow(const AppException('fail'));

      await provider.signIn('a', 'b');
      expect(provider.error, 'fail');

      provider.clearError();
      expect(provider.error, isNull);
    });
  });
}

/// Minimal fake User for tests. Only `id` is accessed by AuthProvider.
class _FakeUser extends Fake implements User {
  @override
  final String id;

  _FakeUser(this.id);
}

/// Minimal fake Session for tests. Only `user` is accessed.
class _FakeSession extends Fake implements Session {
  @override
  final User user;

  _FakeSession(this.user);
}
