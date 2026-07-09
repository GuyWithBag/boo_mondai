// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/drill_service.dart
// PURPOSE: Cross-repository business logic for drillzes
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show StudyCard, LocalDB;

abstract final class DrillStudySessionHelper {
  /// Returns only StudyCards that have NEVER been enrolled in FSRS for this user.
  static List<StudyCard> getEligibleDrillCards(String deckId, String userId) {
    // 1. Get all base cards for this deck
    final allDeckCards = LocalDB.studyCard.getByDeckId(deckId);

    // 2. Get the Set of all StudyCard IDs that the user already has in FSRS
    // (Using the highly optimized Set query you built earlier!)
    final enrolledCardIds = LocalDB.fsrsCard.getEnrolledStudyCardIds(userId);

    // 3. Filter out the enrolled ones
    return allDeckCards
        .where((card) => !enrolledCardIds.contains(card.id))
        .toList();
  }
}
