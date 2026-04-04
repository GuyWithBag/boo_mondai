// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/quiz_service.dart
// PURPOSE: Cross-repository business logic for quizzes
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/repositories/repositories.barrel.dart';

class QuizService {
  /// Returns only ReviewCards that have NEVER been enrolled in FSRS for this user.
  static List<ReviewCard> getEligibleQuizCards(String deckId, String userId) {
    // 1. Get all base cards for this deck
    final allDeckCards = Repositories.reviewCard.getByDeckId(deckId);

    // 2. Get the Set of all ReviewCard IDs that the user already has in FSRS
    // (Using the highly optimized Set query you built earlier!)
    final enrolledCardIds = Repositories.fsrsCard.getEnrolledReviewCardIds(
      userId,
    );

    // 3. Filter out the enrolled ones
    return allDeckCards
        .where((card) => !enrolledCardIds.contains(card.id))
        .toList();
  }
}
