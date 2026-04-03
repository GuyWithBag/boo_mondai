// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/fsrs_card_state_repository.dart
// PURPOSE: Hive CRUD for FsrsCard — persists FSRS scheduling state per card
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'hive_repository.dart';

class FsrsCardRepository extends HiveRepository<FsrsCard> {
  @override
  String get boxName => 'fsrs_card_box';

  @override
  String getId(FsrsCard item) => item.id.toString();

  // ── Domain Queries ──────────────────────────────────────

  /// Renamed to match the new ReviewCard nomenclature
  FsrsCard? getByReviewCardId(String reviewCardId) {
    return box.values.where((s) => s.reviewCardId == reviewCardId).firstOrNull;
  }

  /// Gets all cards for a specific user
  List<FsrsCard> getByUserId(String userId) {
    return box.values.where((s) => s.userId == userId).toList();
  }

  /// Highly optimized: Returns just a Set of IDs.
  /// Perfect for checking if a card is already enrolled!
  Set<String> getEnrolledReviewCardIds(String userId) {
    return box.values
        .where((s) => s.userId == userId)
        .map((s) => s.reviewCardId)
        .toSet();
  }

  /// Gets cards that are ready to be reviewed right now
  List<FsrsCard> getDueCards(DateTime now) {
    return box.values.where((s) {
      return s.state.due.isBefore(now) || s.state.due.isAtSameMomentAs(now);
    }).toList();
  }
}
