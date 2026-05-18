import 'package:boo_mondai/database/database.barrel.dart';

class LocalDB {
  static late final DecksLocalDB deck;
  static late final CardTemplatesLocalDB cardTemplate;
  static late final ReviewCardsLocalDB reviewCard;
  static late final FsrsCardsLocalDB fsrsCard;
  static late final DrillSessionsLocalDB drillSession;
  static late final ReviewSessionsLocalDB reviewSession;
  static late final DrillAnswersLocalDB drillAnswer;
  static late final ReviewLogsLocalDB reviewLog;
  // static late final StreakLocalDB streak;
  static late final StreakLocalDB streak;
  static late final ProfileLocalDB profile;
  static late final CachedProfileLocalDB cachedProfile;

  static Future<void> init() async {
    profile = await ProfileLocalDB().init() as ProfileLocalDB;
    cachedProfile = await CachedProfileLocalDB().init() as CachedProfileLocalDB;
    deck = await DecksLocalDB().init() as DecksLocalDB;
    cardTemplate = await CardTemplatesLocalDB().init() as CardTemplatesLocalDB;
    reviewCard = await ReviewCardsLocalDB().init() as ReviewCardsLocalDB;
    fsrsCard = await FsrsCardsLocalDB().init() as FsrsCardsLocalDB;
    drillSession = await DrillSessionsLocalDB().init() as DrillSessionsLocalDB;
    reviewSession = await ReviewSessionsLocalDB().init() as ReviewSessionsLocalDB;
    reviewLog = await ReviewLogsLocalDB().init() as ReviewLogsLocalDB;
    drillAnswer = await DrillAnswersLocalDB().init() as DrillAnswersLocalDB;
    streak = await StreakLocalDB().init() as StreakLocalDB;
  }

  static void clearAll() {
    deck.clear();
    cardTemplate.clear();
    fsrsCard.clear();
    drillSession.clear();
    reviewLog.clear();
    profile.clear();
    cachedProfile.clear();
  }
}
