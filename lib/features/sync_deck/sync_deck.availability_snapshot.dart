import 'package:boo_mondai/lib.barrel.dart'
    show DeckSyncSession, SyncIndexEntry, TimeHelper;

class DeckSyncAvailabilitySnapshot {
  const DeckSyncAvailabilitySnapshot({
    required this.deckIds,
    required this.studyCardIds,
    required this.fsrsCardIds,
    required this.localDecks,
    required this.remoteDecks,
    required this.localDeckListings,
    required this.remoteDeckListings,
    required this.localCardTemplates,
    required this.remoteCardTemplates,
    required this.localStudyCards,
    required this.remoteStudyCards,
    required this.localFsrsCards,
    required this.remoteFsrsCards,
    required this.localReviewLogs,
    required this.remoteReviewLogs,
  });

  final Set<String> deckIds;
  final Set<String> studyCardIds;
  final Set<String> fsrsCardIds;

  final Map<String, SyncIndexEntry> localDecks;
  final Map<String, SyncIndexEntry> remoteDecks;
  final Map<String, SyncIndexEntry> localDeckListings;
  final Map<String, SyncIndexEntry> remoteDeckListings;
  final Map<String, SyncIndexEntry> localCardTemplates;
  final Map<String, SyncIndexEntry> remoteCardTemplates;
  final Map<String, SyncIndexEntry> localStudyCards;
  final Map<String, SyncIndexEntry> remoteStudyCards;
  final Map<String, SyncIndexEntry> localFsrsCards;
  final Map<String, SyncIndexEntry> remoteFsrsCards;
  final Map<String, SyncIndexEntry> localReviewLogs;
  final Map<String, SyncIndexEntry> remoteReviewLogs;

  bool get hasChanges =>
      _newestWinsHasChanges(localDecks, remoteDecks) ||
      _newestWinsHasChanges(localDeckListings, remoteDeckListings) ||
      _newestWinsHasChanges(localCardTemplates, remoteCardTemplates) ||
      _newestWinsHasChanges(localStudyCards, remoteStudyCards) ||
      _newestWinsHasChanges(localFsrsCards, remoteFsrsCards) ||
      _appendOnlyHasChanges(localReviewLogs, remoteReviewLogs);

  static Future<DeckSyncAvailabilitySnapshot> load({
    required DeckSyncSession session,
    required void Function(double progress) onProgress,
  }) async {
    onProgress(0.08);

    final localDeckIndex = session.decks
        .selectSyncIndexByUserIdAndOptionalDeckId(
          userId: session.userId,
          deckId: session.deckId,
        );
    final remoteDeckIndex = await session.remoteDecks
        .selectSyncIndexByUserIdAndOptionalDeckId(
          userId: session.userId,
          deckId: session.deckId,
        );
    final deckIds = _resolveDeckIds(
      explicitDeckId: session.deckId,
      localDeckIndex: localDeckIndex,
      remoteDeckIndex: remoteDeckIndex,
    );

    onProgress(0.18);

    final localDeckListingIndex = session.deckListings.selectSyncIndexByDeckIds(
      deckIds,
    );
    final localCardTemplateIndex = session.cardTemplates
        .selectSyncIndexByDeckIds(deckIds);
    final localStudyCardIndex = session.studyCards.selectSyncIndexByDeckIds(
      deckIds,
    );
    final remoteDeckListingIndexFuture = session.remoteDeckListings
        .selectSyncIndexByDeckIds(deckIds.toList(growable: false));
    final remoteCardTemplateIndexFuture = session.remoteCardTemplates
        .selectSyncIndexByDeckIds(deckIds.toList(growable: false));
    final remoteStudyCardIndexFuture = session.remoteStudyCards
        .selectSyncIndexByDeckIds(deckIds.toList(growable: false));

    final remoteDeckListingIndex = await remoteDeckListingIndexFuture;
    onProgress(0.28);
    final remoteCardTemplateIndex = await remoteCardTemplateIndexFuture;
    onProgress(0.38);
    final remoteStudyCardIndex = await remoteStudyCardIndexFuture;

    final studyCardIds = _idsFromIndexes(
      localStudyCardIndex,
      remoteStudyCardIndex,
    );

    onProgress(0.48);

    final localFsrsCardIndex = session.fsrsCards
        .selectSyncIndexByUserIdAndStudyCardIds(
          userId: session.userId,
          studyCardIds: studyCardIds,
        );
    final remoteFsrsCardIndex = await session.remoteFsrsCards
        .selectSyncIndexByUserIdAndStudyCardIds(
          userId: session.userId,
          studyCardIds: studyCardIds,
        );
    final fsrsCardIds = _idsFromIndexes(
      localFsrsCardIndex,
      remoteFsrsCardIndex,
    );

    onProgress(0.62);

    final localReviewLogIndex = session.reviewLogs.selectSyncIndexByFsrsCardIds(
      fsrsCardIds,
    );
    final remoteReviewLogIndex = await session.remoteReviewLogs
        .selectSyncIndexByFsrsCardIds(fsrsCardIds.toList(growable: false));

    onProgress(0.76);

    onProgress(1);

    return DeckSyncAvailabilitySnapshot(
      deckIds: deckIds,
      studyCardIds: studyCardIds,
      fsrsCardIds: fsrsCardIds,
      localDecks: _indexById(localDeckIndex),
      remoteDecks: _indexById(remoteDeckIndex),
      localDeckListings: _indexById(localDeckListingIndex),
      remoteDeckListings: _indexById(remoteDeckListingIndex),
      localCardTemplates: _indexById(localCardTemplateIndex),
      remoteCardTemplates: _indexById(remoteCardTemplateIndex),
      localStudyCards: _indexById(localStudyCardIndex),
      remoteStudyCards: _indexById(remoteStudyCardIndex),
      localFsrsCards: _indexById(localFsrsCardIndex),
      remoteFsrsCards: _indexById(remoteFsrsCardIndex),
      localReviewLogs: _indexById(localReviewLogIndex),
      remoteReviewLogs: _indexById(remoteReviewLogIndex),
    );
  }

  static Set<String> _resolveDeckIds({
    required String? explicitDeckId,
    required List<SyncIndexEntry> localDeckIndex,
    required List<SyncIndexEntry> remoteDeckIndex,
  }) {
    if (explicitDeckId != null) return {explicitDeckId};
    return _idsFromIndexes(localDeckIndex, remoteDeckIndex);
  }

  static Set<String> _idsFromIndexes(
    List<SyncIndexEntry> local,
    List<SyncIndexEntry> remote,
  ) {
    return {
      for (final entry in local) entry.id,
      for (final entry in remote) entry.id,
    };
  }

  static Map<String, SyncIndexEntry> _indexById(List<SyncIndexEntry> entries) {
    return {for (final entry in entries) entry.id: entry};
  }

  static bool _newestWinsHasChanges(
    Map<String, SyncIndexEntry> local,
    Map<String, SyncIndexEntry> remote,
  ) {
    for (final remoteEntry in remote.values) {
      final localEntry = local[remoteEntry.id];
      if (localEntry == null) return true;
      if (TimeHelper.isStrictlyAfterMs(
        remoteEntry.updatedAt,
        localEntry.updatedAt,
      )) {
        return true;
      }
    }

    for (final localEntry in local.values) {
      final remoteEntry = remote[localEntry.id];
      if (remoteEntry == null) return true;
      if (TimeHelper.isStrictlyAfterMs(
        localEntry.updatedAt,
        remoteEntry.updatedAt,
      )) {
        return true;
      }
    }

    return false;
  }

  static bool _appendOnlyHasChanges(
    Map<String, SyncIndexEntry> local,
    Map<String, SyncIndexEntry> remote,
  ) {
    if (local.length != remote.length) return true;
    for (final id in local.keys) {
      if (!remote.containsKey(id)) return true;
    }
    return false;
  }
}
