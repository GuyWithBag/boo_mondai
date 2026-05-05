import 'package:boo_mondai/database/database.barrel.dart';

class LocalDB {
  static late final DeckLocalDB deck;
  static late final CardTemplateLocalDB cardTemplate;
  static late final ReviewCardLocalDB reviewCard;
  static late final FsrsCardLocalDB fsrsCard;
  static late final DrillSessionLocalDB drillSession;
  static late final ReviewSessionLocalDB reviewSession;
  static late final DrillAnswerLocalDB drillAnswer;
  static late final ReviewLogLocalDB reviewLog;
  // static late final StreakLocalDB streak;
  static late final StreakLocalDB streak;
  static late final ProfileLocalDB profile;
  static late final CachedProfileLocalDB cachedProfile;

  static Future<void> init() async {
    profile = await ProfileLocalDB().init() as ProfileLocalDB;
    cachedProfile = await CachedProfileLocalDB().init() as CachedProfileLocalDB;
    deck = await DeckLocalDB().init() as DeckLocalDB;
    cardTemplate = await CardTemplateLocalDB().init() as CardTemplateLocalDB;
    reviewCard = await ReviewCardLocalDB().init() as ReviewCardLocalDB;
    fsrsCard = await FsrsCardLocalDB().init() as FsrsCardLocalDB;
    drillSession = await DrillSessionLocalDB().init() as DrillSessionLocalDB;
    reviewSession = await ReviewSessionLocalDB().init() as ReviewSessionLocalDB;
    reviewLog = await ReviewLogLocalDB().init() as ReviewLogLocalDB;
    drillAnswer = await DrillAnswerLocalDB().init() as DrillAnswerLocalDB;
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
