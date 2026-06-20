// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/streak_controller.dart
// PURPOSE: UI state for user's daily FSRS review streak
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show Controller, Streak, LocalDB;

class StreakController extends Controller {
  Streak? get streak => LocalDB.streak.retrieve();

  // void fetchStreak(String userId) {
  //   setLoading(true);
  //   setError(null);;
  //   notifyListeners();

  //   try {} on AppException catch (e) {
  //     setError(e);
  //   } finally {
  //     setLoading(false);
  //     notifyListeners();
  //   }
  // }

  Future<void> recordActivity(DateTime activityDate) async {
    try {
      await LocalDB.streak.recordActivity(activityDate);
      notifyListeners();
    } on Exception catch (e) {
      setError(e);
      notifyListeners();
    }
  }
}
