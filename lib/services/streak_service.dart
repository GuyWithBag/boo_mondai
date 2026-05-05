// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/streak_service.dart
// PURPOSE: Coordinates streak reads and syncs between local Hive and remote Supabase
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

class StreakService {
  /// Loads the streak from Hive first, then pulls the latest from Supabase
  /// and updates Hive if found. Returns the freshest streak available.
  Future<Streak?> fetchStreak(String userId) async {
    // Fast local read
    final local = LocalDB.streak.getByUserId(userId);

    // Remote sync
    final remote = await RemoteDB.streakSync.selectByUserId(userId);
    if (remote != null) {
      await LocalDB.streak.put(remote);
      return remote;
    }

    return local;
  }

  /// Records activity locally, then pushes the updated streak to Supabase.
  Future<Streak> recordAndSync(String userId) async {
    final updated = await LocalDB.streak.recordActivity(
      userId,
      DateTime.now(),
    );

    await RemoteDB.streakSync.upsertOne(updated);
    return updated;
  }
}
