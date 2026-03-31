// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// // PATH: lib/providers/account_page_controller.dart
// // PURPOSE: Manages local user profile editing and theme mode preference
// // PROVIDERS: AccountPageController
// // HOOKS: none
// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// import 'package:flutter/material.dart';

// import '../models/user_profile.dart';
// import '../repositories/user_profile_repository.dart';

// /// Manages the local UserProfile with dirty-tracking and theme mode toggling.
// class AccountPageController extends ChangeNotifier {
//   AccountPageController({required UserProfileRepository repository})
//       : _repository = repository;

//   final UserProfileRepository _repository;

//   UserProfile? _profile;
//   bool _isDirty = false;
//   bool _isLoading = false;
//   String? _error;
//   ThemeMode _themeMode = ThemeMode.system;

//   UserProfile? get profile => _profile;
//   bool get isDirty => _isDirty;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   ThemeMode get themeMode => _themeMode;

//   Future<void> load() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//     try {
//       _profile = _repository.get();
//       _themeMode = _themeModeFromString(_profile?.themeMode ?? 'system');
//       _isDirty = false;
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void update(UserProfile updated) {
//     _profile = updated;
//     _isDirty = true;
//     notifyListeners();
//   }

//   void setThemeMode(ThemeMode mode) {
//     _themeMode = mode;
//     _profile = _profile?.copyWith(themeMode: _themeModeToString(mode)) ??
//         UserProfile(
//           id: 'local',
//           email: '',
//           displayName: '',
//           createdAt: DateTime.now(),
//           themeMode: _themeModeToString(mode),
//         );
//     _isDirty = true;
//     notifyListeners();
//   }

//   Future<void> save() async {
//     final profile = _profile;
//     if (profile == null) return;
//     _isLoading = true;
//     notifyListeners();
//     try {
//       await _repository.save(profile);
//       _isDirty = false;
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> discard() async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       _profile = _repository.get();
//       _themeMode = _themeModeFromString(_profile?.themeMode ?? 'system');
//       _isDirty = false;
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }

//   // ── helpers ───────────────────────────────────────────────

//   ThemeMode _themeModeFromString(String value) => switch (value) {
//         'light' => ThemeMode.light,
//         'dark' => ThemeMode.dark,
//         _ => ThemeMode.system,
//       };

//   String _themeModeToString(ThemeMode mode) => switch (mode) {
//         ThemeMode.light => 'light',
//         ThemeMode.dark => 'dark',
//         ThemeMode.system => 'system',
//       };
// }
