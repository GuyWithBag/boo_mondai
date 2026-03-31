// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/dashboard_page_controller.dart
// PURPOSE: Loads streak, due-card count, and recent sessions for the Dashboard page
// PROVIDERS: DashboardPageController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import '../models/streak.dart';
import '../models/quiz_session.dart';
import '../repositories/streak_repository.dart';
import '../repositories/fsrs_card_state_repository.dart';
import '../repositories/quiz_session_repository.dart';

/// Drives the Dashboard page — exposes streak, due-card count, and recent
/// quiz sessions to the UI via [ChangeNotifier].
class DashboardPageController extends ChangeNotifier {
  DashboardPageController({
    required StreakRepository streakRepository,
    required FsrsCardStateRepository fsrsRepository,
    required QuizSessionRepository quizSessionRepository,
  })  : _streakRepository = streakRepository,
        _fsrsRepository = fsrsRepository,
        _quizSessionRepository = quizSessionRepository;

  final StreakRepository _streakRepository;
  final FsrsCardStateRepository _fsrsRepository;
  final QuizSessionRepository _quizSessionRepository;

  // ── private state ────────────────────────────────────────

  Streak? _streak;
  int _dueCardCount = 0;
  List<QuizSession> _recentSessions = [];
  bool _isLoading = false;
  String? _error;

  // ── public getters ───────────────────────────────────────

  Streak? get streak => _streak;
  int get dueCardCount => _dueCardCount;
  List<QuizSession> get recentSessions => List.unmodifiable(_recentSessions);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ── methods ──────────────────────────────────────────────

  /// Loads all dashboard data from the local repositories.
  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _streak = _streakRepository.get();
      _dueCardCount =
          _fsrsRepository.getDueCards(DateTime.now()).length;
      _recentSessions = _quizSessionRepository.getRecent(5);
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears any active error message and notifies listeners.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
