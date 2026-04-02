import 'package:boo_mondai/repositories/repositories.barrel.dart';

class Repositories {
  static late final DeckRepository deck;
  static late final DeckCardRepository deckCard;
  static late final FsrsCardRepository fsrsCard;
  static late final QuizSessionRepository quizSession;
  static late final ReviewLogRepository reviewLog;
  // static late final StreakRepository streak;
  static late final ProfileRepository userProfile;
  static late final CachedProfileRepository cachedProfile;

  static Future<void> init() async {
    userProfile = await ProfileRepository().init() as ProfileRepository;
    cachedProfile =
        await CachedProfileRepository().init() as CachedProfileRepository;
    deck = await DeckRepository().init() as DeckRepository;
    deckCard = await DeckCardRepository().init() as DeckCardRepository;
    fsrsCard = await FsrsCardRepository().init() as FsrsCardRepository;
    quizSession = await QuizSessionRepository().init() as QuizSessionRepository;
    reviewLog = await ReviewLogRepository().init() as ReviewLogRepository;
    // streak = StreakRepository();
    // Repositories.clearAll();
  }

  static void clearAll() {
    deck.clear();
    deckCard.clear();
    fsrsCard.clear();
    quizSession.clear();
    reviewLog.clear();
    userProfile.clear();
    cachedProfile.clear();
  }
}
