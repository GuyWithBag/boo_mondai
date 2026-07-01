import 'package:boo_mondai/lib.barrel.dart'
    show ResearchService, FsrsService, StreakService;

class Services {
  static late final FsrsService fsrs;
  static late final ResearchService research;
  static late final StreakService streak;

  static void init() {
    fsrs = FsrsService();
    research = ResearchService();
    streak = StreakService();
  }
}
