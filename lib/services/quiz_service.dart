// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/quiz_service.dart
// PURPOSE: Cross-repository business logic for quizzes
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/repositories/repositories.barrel.dart';

class QuizService {
  /// Returns a list of ReviewCards that the user is eligible to quiz on.
  /// Filters out unsupported templates and cards already enrolled in FSRS.
  static List<ReviewCard> getEligibleQuizCards(String deckId, String userId) {
    // 1. Fetch data from the 3 separate repositories
    final templates = Repositories.cardTemplate.getByDeckId(deckId);
    final reviewCards = Repositories.reviewCard.getByDeckId(deckId);
    final enrolledIds = Repositories.fsrsCard.getEnrolledReviewCardIds(userId);

    // 2. Create a fast lookup map for templates
    final templateMap = {for (final t in templates) t.id: t};

    // 3. Apply the filters
    return reviewCards.where((rc) {
      if (enrolledIds.contains(rc.id)) return false; // Already quizzed!

      final template = templateMap[rc.templateId];
      if (template == null) return false;

      // Filter out game modes that don't work in standard quizzes
      return template is! WordScrambleTemplate &&
          template is! MatchMadnessTemplate;
    }).toList();
  }
}
