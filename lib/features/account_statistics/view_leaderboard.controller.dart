// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/leaderboard_controller.dart
// PURPOSE: UI state for leaderboard rankings with optional language filter
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show Controller, LeaderboardEntry, AppException, RemoteDB;

class ViewLeaderboardController extends Controller {
  List<LeaderboardEntry> _entries = [];
  String? _filteredLanguage;

  List<LeaderboardEntry> get entries => List.unmodifiable(_entries);
  String? get filteredLanguage => _filteredLanguage;

  Future<void> fetchLeaderboard() async {
    setLoading(true);
    setError(null);
    notifyListeners();

    try {
      _entries = await RemoteDB.leaderboard.fetchLeaderboard();
    } on AppException catch (e) {
      setError(e);
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  void setLanguageFilter(String? language) {
    _filteredLanguage = language;
    fetchLeaderboard();
  }
}
