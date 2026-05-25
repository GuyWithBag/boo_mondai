import 'package:boo_mondai/database/database.barrel.dart';

class RemoteDB {
  // ── Remote Data Sources ──────────────────────────
  static late final ProfilesRemoteDB profile;
  static late final DecksRemoteDB deck;
  static late final DeckInteractionsRemoteDB deckInteractions;
  static late final CardTemplatesRemoteDB card;
  static late final DrillSessionsRemoteDB drill;
  static late final ReviewSessionsRemoteDB reviewSession;
  static late final DrillAnswersRemoteDB drillAnswer;
  static late final FsrsCardsRemoteDB fsrsSync;
  static late final LeaderboardEntriesRemoteDB leaderboard;
  static late final ResearchRemoteDB research;
  static late final StorageRemoteDB storage;
  static late final StreaksRemoteDB streak;

  static Future<void> init() async {
    profile = ProfilesRemoteDB();
    deck = DecksRemoteDB();
    deckInteractions = DeckInteractionsRemoteDB();
    card = CardTemplatesRemoteDB();
    drill = DrillSessionsRemoteDB();
    reviewSession = ReviewSessionsRemoteDB();
    drillAnswer = DrillAnswersRemoteDB();
    fsrsSync = FsrsCardsRemoteDB();
    leaderboard = LeaderboardEntriesRemoteDB();
    research = ResearchRemoteDB();
    storage = StorageRemoteDB();
    streak = StreaksRemoteDB();
  }
}
