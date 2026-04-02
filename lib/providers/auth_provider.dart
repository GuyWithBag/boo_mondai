// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/auth_provider.dart
// PURPOSE: Manages Supabase authentication state and current user profile
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/services/services.barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/repositories/repositories.dart';

/// Handles sign-in, sign-up, sign-out, and session restoration.
class AuthProvider extends ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get userProfile => _userProfile;
  bool get isAuthenticated => _userProfile != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get role => _userProfile?.role;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Services.auth.signIn(email, password);
      final user = Services.auth.currentUser;
      if (user != null) {
        final profileData = await Services.auth.getProfile(user.id);
        if (profileData != null) {
          _userProfile = UserProfileMapper.fromMap(profileData);
          await Repositories.userProfile.save(_userProfile!);
        }
      }
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String userName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final profile = UserProfile(
        id: UuidService.uuid.v4(),
        userName: userName,
        role: 'group_a_participant',
        createdAt: DateTime.now(),
      );
      final response = await Services.auth.signUp(email, password, profile);
      final user = response.user;
      if (user != null) {
        await Services.auth.upsertProfile(profile.toMap());
        _userProfile = profile;
        await Repositories.userProfile.save(profile);
      }
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void mockSignIn() {
    final mockData = UserProfile(
      id: UuidService.uuid.v4(),
      role: 'group_a_participant',
      userName: 'TestUser',
      createdAt: DateTime.now(),
    );
    Repositories.userProfile.save(mockData);
    _userProfile = mockData;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Services.auth.signOut();
      _userProfile = null;
      await Repositories.userProfile.clear();
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> restoreSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final session = Services.auth.currentSession;
      if (session != null) {
        final profileData = await Services.auth.getProfile(session.user.id);
        if (profileData != null) {
          _userProfile = UserProfileMapper.fromMap(profileData);
          await Repositories.userProfile.save(_userProfile!);
        }
      } else {
        _userProfile = Repositories.userProfile.getAll().firstOrNull;
      }
      // } on AppException {
      //   _userProfile = Repositories.userProfile.getAll().firstOrNull;
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
