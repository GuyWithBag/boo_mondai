// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// // PATH: lib/providers/account_page_controller.dart
// // PURPOSE: Manages local user profile editing and theme mode preference
// // PROVIDERS: ViewAccountPageController
// // HOOKS: none
// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// import 'package:flutter/material.dart';

// import '../models/user_profile.dart';
// import '../repositories/user_profile_repository.dart';

// /// Manages the local Profile with dirty-tracking and theme mode toggling.
// class ViewAccountPageController extends ChangeNotifier {
//   ViewAccountPageController({required UserProfileRepository repository})
//       : _repository = repository;

//   final UserProfileRepository _repository;

//   Profile? _profile;
//   bool _isDirty = false;
//   bool setLoading(false);
//   String? _error;
//   ThemeMode _themeMode = ThemeMode.system;

//   Profile? get profile => _profile;
//   bool get isDirty => _isDirty;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   ThemeMode get themeMode => _themeMode;

//   Future<void> load() async {
//     setLoading(true);
//     setError(null);;
//     notifyListeners();
//     try {
//       _profile = _repository.get();
//       _themeMode = _themeModeFromString(_profile?.themeMode ?? 'system');
//       _isDirty = false;
//     } catch (e) {
//       setError(e);
//     } finally {
//       setLoading(false);
//       notifyListeners();
//     }
//   }

//   void update(Profile updated) {
//     _profile = updated;
//     _isDirty = true;
//     notifyListeners();
//   }

//   void setThemeMode(ThemeMode mode) {
//     _themeMode = mode;
//     _profile = _profile?.copyWith(themeMode: _themeModeToString(mode)) ??
//         Profile(
//           id: 'local',
//           email: '',
//           username: '',
//           createdAt: DateTime.now(),
//           themeMode: _themeModeToString(mode),
//         );
//     _isDirty = true;
//     notifyListeners();
//   }

//   Future<void> put() async {
//     final profile = _profile;
//     if (profile == null) return;
//     setLoading(true);
//     notifyListeners();
//     try {
//       await _repository.put(profile);
//       _isDirty = false;
//     } catch (e) {
//       setError(e);
//     } finally {
//       setLoading(false);
//       notifyListeners();
//     }
//   }

//   Future<void> discard() async {
//     setLoading(true);
//     notifyListeners();
//     try {
//       _profile = _repository.get();
//       _themeMode = _themeModeFromString(_profile?.themeMode ?? 'system');
//       _isDirty = false;
//     } catch (e) {
//       setError(e);
//     } finally {
//       setLoading(false);
//       notifyListeners();
//     }
//   }

//   void clearError() {
//     setError(null);;
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
