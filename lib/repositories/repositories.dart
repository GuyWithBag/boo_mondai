import 'package:boo_mondai/repositories/repositories.barrel.dart';

class Repositories {
  static late final DeckRepository deck;
  static late final CardTemplateRepository cardTemplate;
  static late final ReviewCardRepository reviewCard;
  static late final FsrsCardRepository fsrsCard;
  static late final DrillSessionRepository drillSession;
  static late final ReviewSessionRepository reviewSession;
  static late final DrillAnswerRepository drillAnswer;
  static late final ReviewLogRepository reviewLog;
  // static late final StreakRepository streak;
  static late final ProfileRepository userProfile;
  static late final CachedProfileRepository cachedProfile;

  static Future<void> init() async {
    userProfile = await ProfileRepository().init() as ProfileRepository;
    cachedProfile =
        await CachedProfileRepository().init() as CachedProfileRepository;
    deck = await DeckRepository().init() as DeckRepository;
    cardTemplate =
        await CardTemplateRepository().init() as CardTemplateRepository;
    reviewCard = await ReviewCardRepository().init() as ReviewCardRepository;
    fsrsCard = await FsrsCardRepository().init() as FsrsCardRepository;
    drillSession =
        await DrillSessionRepository().init() as DrillSessionRepository;
    reviewSession =
        await ReviewSessionRepository().init() as ReviewSessionRepository;
    reviewLog = await ReviewLogRepository().init() as ReviewLogRepository;
    drillAnswer = await DrillAnswerRepository().init() as DrillAnswerRepository;
    // streak = StreakRepository();
    // Repositories.clearAll();
  }

  static void clearAll() {
    deck.clear();
    cardTemplate.clear();
    fsrsCard.clear();
    drillSession.clear();
    reviewLog.clear();
    userProfile.clear();
    cachedProfile.clear();
  }
}
