// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/leaderboard_controller.dart
// PURPOSE: UI state for leaderboard rankings with optional language filter
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/services/app_exception.dart';

class LeaderboardController extends ChangeNotifier {
  List<LeaderboardEntry> _entries = [];
  String? _filteredLanguage;
  bool _isLoading = false;
  String? _error;

  List<LeaderboardEntry> get entries => List.unmodifiable(_entries);
  String? get filteredLanguage => _filteredLanguage;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchLeaderboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _entries = await RemoteDB.leaderboard.fetchLeaderboard();
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setLanguageFilter(String? language) {
    _filteredLanguage = language;
    fetchLeaderboard();
  }

  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
