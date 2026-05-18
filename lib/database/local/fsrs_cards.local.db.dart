// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/fsrs_card_state_repository.dart
// PURPOSE: Hive CRUD for FsrsCard — persists FSRS scheduling state per card
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';

import 'package:boo_mondai/models/models.barrel.dart';

class FsrsCardsLocalDB extends HiveLocalDB<FsrsCard> {
  @override
  String get boxName => 'fsrs_cards';

  @override
  Map<String, Object?> primaryKeyFromItem(FsrsCard item) => {'id': item.id};

  // ── Domain Queries ──────────────────────────────────────

  /// Renamed to match the new ReviewCard nomenclature
  FsrsCard? getByReviewCardId(String reviewCardId) => guardSync(
    () => box.values.where((s) => s.reviewCardId == reviewCardId).firstOrNull,
    action: 'getByReviewCardId($reviewCardId)',
  );

  /// Gets all cards for a specific user
  List<FsrsCard> getByUserId(String userId) => guardSync(
    () => box.values.where((s) => s.userId == userId).toList(),
    action: 'getByUserId($userId)',
  );

  /// Highly optimized: Returns just a Set of IDs.
  /// Perfect for checking if a card is already enrolled!
  Set<String> getEnrolledReviewCardIds(String userId) => guardSync(
    () => box.values
        .where((s) => s.userId == userId)
        .map((s) => s.reviewCardId)
        .toSet(),
    action: 'getEnrolledReviewCardIds($userId)',
  );

  /// Gets cards that are ready to be reviewed right now
  List<FsrsCard> getDueCards(DateTime now) => guardSync(
    () => box.values
        .where(
          (s) => s.state.due.isBefore(now) || s.state.due.isAtSameMomentAs(now),
        )
        .toList(),
    action: 'getDueCards',
  );
}
