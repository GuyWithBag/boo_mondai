// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/leaderboard_provider.dart
// PURPOSE: Fetches and exposes leaderboard rankings with optional language filter
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.dart';
import 'package:boo_mondai/services/app_exception.dart';

/// Provides ranked leaderboard entries, globally or filtered by language.
class LeaderboardProvider extends ChangeNotifier {
  List<LeaderboardEntry> _entries = [];
  String? _filteredLanguage;
  bool _isLoading = false;
  String? _error;

  List<LeaderboardEntry> get entries => List.unmodifiable(_entries);
  String? get filteredLanguage => _filteredLanguage;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchLeaderboard({String? targetLanguage}) async {
    _isLoading = true;
    _error = null;
    _filteredLanguage = targetLanguage;
    notifyListeners();

    try {
      final data = await Services.leaderboard.fetchLeaderboard(
        targetLanguage: targetLanguage,
      );
      _entries = data.map(LeaderboardEntry.fromJson).toList();
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setLanguageFilter(String? language) {
    _filteredLanguage = language;
    fetchLeaderboard(targetLanguage: language);
  }
}
