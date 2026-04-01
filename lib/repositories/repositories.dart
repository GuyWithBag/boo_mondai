import 'package:boo_mondai/repositories/repositories.barrel.dart';

class Repositories {
  static late final DeckRepository deck;
  static late final DeckCardRepository deckCard;
  static late final FsrsCardRepository fsrsCard;
  static late final QuizSessionRepository quizSession;
  static late final ReviewLogRepository reviewLog;
  // static late final StreakRepository streak;
  static late final ProfileRepository userProfile;

  static void init() {
    deck = DeckRepository();
    deckCard = DeckCardRepository();
    fsrsCard = FsrsCardRepository();
    quizSession = QuizSessionRepository();
    reviewLog = ReviewLogRepository();
    // streak = StreakRepository();
    userProfile = ProfileRepository();
  }
}
