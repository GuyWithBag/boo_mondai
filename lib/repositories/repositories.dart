import 'package:boo_mondai/repositories/repositories.barrel.dart';

class Repositories {
  static late final DeckRepository deck;
  static late final CardTemplateRepository cardTemplate;
  static late final ReviewCardRepository reviewCard;
  static late final FsrsCardRepository fsrsCard;
  static late final DrillSessionRepository quizSession;
  static late final DrillAnswerRepository quizAnswer;
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
    quizSession =
        await DrillSessionRepository().init() as DrillSessionRepository;
    reviewLog = await ReviewLogRepository().init() as ReviewLogRepository;
    quizAnswer = await DrillAnswerRepository().init() as DrillAnswerRepository;
    // streak = StreakRepository();
    // Repositories.clearAll();
  }

  static void clearAll() {
    deck.clear();
    cardTemplate.clear();
    fsrsCard.clear();
    quizSession.clear();
    reviewLog.clear();
    userProfile.clear();
    cachedProfile.clear();
  }
}
