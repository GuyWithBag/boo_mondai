import 'package:boo_mondai/lib.barrel.dart'
    show DeckDownloadsService, ResearchService, FsrsService, StreakService;

class Services {
  static late final FsrsService fsrs;
  static late final ResearchService research;
  static late final StreakService streak;
  static late final DeckDownloadsService deckDownloads;

  static void init() {
    fsrs = FsrsService();
    research = ResearchService();
    streak = StreakService();
    deckDownloads = DeckDownloadsService();
  }
}
