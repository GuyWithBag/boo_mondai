// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/auth_provider.dart
// PURPOSE: Manages Supabase authentication state and current user profile
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/services/services.dart';

/// Handles sign-in, sign-up, sign-out, and session restoration.
class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabaseService;
  final HiveService _hiveService;

  AuthProvider({
    required SupabaseService supabaseService,
    required HiveService hiveService,
  }) : _supabaseService = supabaseService,
       _hiveService = hiveService;

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
      await _supabaseService.signIn(email, password);
      final user = _supabaseService.currentUser;
      if (user != null) {
        final profileData = await _supabaseService.getProfile(user.id);
        if (profileData != null) {
          _userProfile = UserProfile.fromJson(profileData);
          await _hiveService.saveProfile(_userProfile!);
        }
      }
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String displayName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabaseService.signUp(email, password);
      final user = response.user;
      if (user != null) {
        final profile = UserProfile(
          id: user.id,
          email: email,
          displayName: displayName,
          role: 'group_a_participant',
          createdAt: DateTime.now(),
        );
        await _supabaseService.upsertProfile(profile.toJson());
        _userProfile = profile;
        await _hiveService.saveProfile(profile);
      }
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _supabaseService.signOut();
      _userProfile = null;
      await _hiveService.clearAll();
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
      final session = _supabaseService.currentSession;
      if (session != null) {
        final profileData = await _supabaseService.getProfile(session.user.id);
        if (profileData != null) {
          _userProfile = UserProfile.fromJson(profileData);
          await _hiveService.saveProfile(_userProfile!);
        }
      } else {
        _userProfile = _hiveService.getProfile();
      }
    } on AppException {
      _userProfile = _hiveService.getProfile();
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
