// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// // PATH: lib/providers/dashboard_page_controller.dart
// // PURPOSE: Loads streak, due-card count, and recent sessions for the Dashboard page
// // PROVIDERS: DashboardPageController
// // HOOKS: none
// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// import 'package:flutter/foundation.dart';
// import '../models/streak.dart';
// import '../models/drill_session.dart';
// import '../repositories/streak_repository.dart';
// import '../repositories/drill_session_repository.dart';

// /// Drives the Dashboard page — exposes streak, due-card count, and recent
// /// drill sessions to the UI via [ChangeNotifier].
// class DashboardPageController extends ChangeNotifier {
//   DashboardPageController({
//     required StreakLocalDB streakRepository,
//     required FsrsCardLocalDB fsrsRepository,
//     required DrillSessionLocalDB drillSessionRepository,
//   }) : _streakRepository = streakRepository,
//        _fsrsRepository = fsrsRepository,
//        _drillSessionRepository = drillSessionRepository;

//   final StreakLocalDB _streakRepository;
//   final FsrsCardLocalDB _fsrsRepository;
//   final DrillSessionLocalDB _drillSessionRepository;

//   // ── private state ────────────────────────────────────────

//   Streak? _streak;
//   int _dueCardCount = 0;
//   List<DrillSession> _recentSessions = [];
//   bool setLoading(false);
//   String? _error;

//   // ── public getters ───────────────────────────────────────

//   Streak? get streak => _streak;
//   int get dueCardCount => _dueCardCount;
//   List<DrillSession> get recentSessions => List.unmodifiable(_recentSessions);
//   bool get isLoading => _isLoading;
//   String? get error => _error;

//   // ── methods ──────────────────────────────────────────────

//   /// Loads all dashboard data from the local repositories.
//   Future<void> load() async {
//     setLoading(true);
//     setError(null);;
//     notifyListeners();

//     try {
//       _streak = _streakRepository.get();
//       _dueCardCount = _fsrsRepository.getDueCards(DateTime.now()).length;
//       _recentSessions = _drillSessionRepository.getRecent(5);
//     } on Exception catch (e) {
//       setError(e);
//     } finally {
//       setLoading(false);
//       notifyListeners();
//     }
//   }

//   /// Clears any active error message and notifies listeners.
//   void clearError() {
//     setError(null);;
//     notifyListeners();
//   }
// }
