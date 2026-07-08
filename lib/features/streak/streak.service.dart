import 'package:boo_mondai/core/database/localdbs.dart';
import 'package:boo_mondai/core/database/remotedbs.dart';
import 'package:boo_mondai/core/services/service.dart';
import 'package:boo_mondai/core/services/uuid.dart';
import 'package:boo_mondai/features/streak/streak.dto.dart';
import 'package:boo_mondai/features/streak/streak.helper.dart';

class StreakService extends Service {
  @override
  String get name => 'StreakService';

  Future<Streak> refreshFromReviewLogs({bool syncRemote = false}) async {
    final now = DateTime.now();
    final existing = LocalDB.streak.retrieve();
    final profile = LocalDB.profile.getOrCreate();
    final calculation = StreakHelper.calculateFromActivityDates(
      activityDates: LocalDB.reviewLog.activityDates(),
      now: now,
    );

    final streak = Streak(
      id: existing?.id ?? uuid.v7(),
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      userId: profile.id,
      currentStreak: calculation.currentStreak,
      longestStreak: calculation.longestStreak,
      lastActivityDate: calculation.lastActivityDate,
    );

    await LocalDB.streak.upsert(streak);

    if (syncRemote) {
      await RemoteDB.streak.upsert(streak);
    }

    return streak;
  }
}
