import 'package:boo_mondai/database/database.barrel.dart';

class RemoteDB {
  // ── Remote Data Sources ──────────────────────────
  static late final ProfileRemoteDB profile;
  static late final DeckRemoteDB deck;
  static late final CardTemplateRemoteDB card;
  static late final DrillSessionRemoteDB drill;
  static late final FsrsCardRemoteDB fsrsSync;
  static late final LeaderboardEntryRemoteDB leaderboard;
  static late final ResearchRemoteDB research;
  static late final StorageRemoteDB storage;
  static late final StreakRemoteDB streak;

  static Future<void> init() async {
    profile = ProfileRemoteDB();
    deck = DeckRemoteDB();
    card = CardTemplateRemoteDB();
    drill = DrillSessionRemoteDB();
    fsrsSync = FsrsCardRemoteDB();
    leaderboard = LeaderboardEntryRemoteDB();
    research = ResearchRemoteDB();
    storage = StorageRemoteDB();
    streak = StreakRemoteDB();
  }
}
