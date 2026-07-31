// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/fsrs_card_state_repository.dart
// PURPOSE: Hive CRUD for FsrsCard — persists FSRS scheduling state per card
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show HiveLocalDB, FsrsCard, SyncIndexEntry;

class FsrsCardsLocalDB extends HiveLocalDB<FsrsCard> {
  @override
  String get boxName => 'fsrs_cards';

  @override
  Map<String, Object?> primaryKeyFromItem(FsrsCard item) => {'id': item.id};

  @override
  DateTime? getDeletedAt(FsrsCard item) => item.deletedAt;

  // ── Domain Queries ──────────────────────────────────────

  /// Renamed to match the new StudyCard nomenclature
  FsrsCard? getByStudyCardId(String studyCardId) => guardSync(
    () => selectMany(where: (s) => s.studyCardId == studyCardId).firstOrNull,
    action: 'getByStudyCardId($studyCardId)',
  );

  /// Gets all cards for a specific profile.
  List<FsrsCard> getByProfileId(String profileId) => guardSync(
    () => selectMany(where: (s) => s.profileId == profileId),
    action: 'getByProfileId($profileId)',
  );

  List<FsrsCard> selectManyByProfileIdAndStudyCardIds({
    required String profileId,
    required Set<String> studyCardIds,
  }) => guardSync(
    () => selectMany(
      where: (card) =>
          card.profileId == profileId &&
          studyCardIds.contains(card.studyCardId),
    ),
    action:
        'selectManyByProfileIdAndStudyCardIds($profileId, ${studyCardIds.length} studyCardIds)',
  );

  List<SyncIndexEntry> selectSyncIndexByProfileIdAndStudyCardIds({
    required String profileId,
    required Set<String> studyCardIds,
  }) => selectSyncIndexWhere(
    where: (card) =>
        card.profileId == profileId && studyCardIds.contains(card.studyCardId),
    getId: (card) => card.id,
    getUpdatedAt: (card) => card.updatedAt,
    action:
        'selectSyncIndexByProfileIdAndStudyCardIds($profileId, ${studyCardIds.length} studyCardIds)',
  );

  List<FsrsCard> selectManyByIds(List<String> ids) => guardSync(
    () => [
      for (final id in ids) ?selectByPk({'id': id}, includeDeleted: true),
    ],
    action: 'selectManyByIds(${ids.length} ids)',
  );

  /// Highly optimized: Returns just a Set of IDs.
  /// Perfect for checking if a card is already enrolled!
  Set<String> getEnrolledStudyCardIds(String profileId) => guardSync(
    () => selectMany(
      where: (s) => s.profileId == profileId,
    ).map((s) => s.studyCardId).toSet(),
    action: 'getEnrolledStudyCardIds($profileId)',
  );

  /// Gets cards that are ready to be reviewed right now
  List<FsrsCard> getDueCards(DateTime now) => guardSync(
    () => selectMany(
      where: (s) =>
          s.state.due.isBefore(now) || s.state.due.isAtSameMomentAs(now),
    ),
    action: 'getDueCards',
  );
}
