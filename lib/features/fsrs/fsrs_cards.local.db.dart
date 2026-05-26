// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/fsrs_card_state_repository.dart
// PURPOSE: Hive CRUD for FsrsCard — persists FSRS scheduling state per card
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show HiveLocalDB, FsrsCard;

class FsrsCardsLocalDB extends HiveLocalDB<FsrsCard> {
  @override
  String get boxName => 'fsrs_cards';

  @override
  Map<String, Object?> primaryKeyFromItem(FsrsCard item) => {'id': item.id};

  // ── Domain Queries ──────────────────────────────────────

  /// Renamed to match the new StudyCard nomenclature
  FsrsCard? getByStudyCardId(String studyCardId) => guardSync(
    () => box.values.where((s) => s.studyCardId == studyCardId).firstOrNull,
    action: 'getByStudyCardId($studyCardId)',
  );

  /// Gets all cards for a specific user
  List<FsrsCard> getByUserId(String userId) => guardSync(
    () => box.values.where((s) => s.userId == userId).toList(),
    action: 'getByUserId($userId)',
  );

  /// Highly optimized: Returns just a Set of IDs.
  /// Perfect for checking if a card is already enrolled!
  Set<String> getEnrolledStudyCardIds(String userId) => guardSync(
    () => box.values
        .where((s) => s.userId == userId)
        .map((s) => s.studyCardId)
        .toSet(),
    action: 'getEnrolledStudyCardIds($userId)',
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
