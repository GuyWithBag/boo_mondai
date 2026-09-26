// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/deck_repository.dart
// PURPOSE: Hive CRUD for Deck — source of truth for My Decks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';

class DecksLocalDB extends HiveLocalDB<Deck> {
  @override
  String get boxName => 'decks';

  @override
  Map<String, Object?> primaryKeyFromItem(Deck item) => {'id': item.id};

  List<Deck> getByCurrentProfile() => guardSync(
    () => selectMany()
        .where((d) => d.profileId == LocalDB.currentProfile.getOrCreate().id)
        .toList(),
    action: 'getByCurrentProfile',
  );

  List<Deck> getByProfileId(String profileId) => guardSync(
    () => selectMany(where: (deck) => deck.profileId == profileId),
    action: 'getByProfileId($profileId)',
  );

  JoinedDeck? selectJoinedByDeck(Deck deck, {bool includeDeleted = false}) =>
      guardSync(() {
        final profile = LocalDB.profiles.selectByPk({'id': deck.profileId});
        if (profile == null) return null;

        final deckListing = LocalDB.deckListing.selectByPk({
          'deck_id': deck.id,
        }, includeDeleted: includeDeleted);
        final sourceDeckId = deck.sourceDeckId;
        final sourceDeck = sourceDeckId == null
            ? null
            : selectByPk({'id': sourceDeckId}, includeDeleted: includeDeleted);
        final sourceProfile = sourceDeck == null
            ? null
            : LocalDB.profiles.selectByPk({'id': sourceDeck.profileId});

        return (
          deck: deck,
          deckListing: deckListing,
          deckListingContent: deckListing == null
              ? null
              : LocalDB.deckListing.getContentByListing(
                  deckListing,
                  includeDeleted: includeDeleted,
                ),
          profile: profile,
          sourceDeck: sourceDeck,
          sourceProfile: sourceProfile,
        );
      }, action: 'selectJoinedByDeck(${deck.id})');

  DeckWithListingContent? selectWithListingContentByDeck(
    Deck deck, {
    bool includeDeleted = false,
  }) => guardSync(() {
    final profile = LocalDB.profiles.selectByPk({'id': deck.profileId});
    if (profile == null) return null;

    final deckListing = LocalDB.deckListing.selectByPk({
      'deck_id': deck.id,
    }, includeDeleted: includeDeleted);
    if (deckListing == null) return null;

    final content = LocalDB.deckListing.getContentByListing(
      deckListing,
      includeDeleted: includeDeleted,
    );
    if (content == null) return null;

    return (
      deck: deck,
      deckListing: deckListing,
      deckListingContent: content,
      profile: profile,
      sourceProfile: getSourceProfileByDeck(
        deck,
        includeDeleted: includeDeleted,
      ),
    );
  }, action: 'selectWithListingContentById(${deck.id})');

  Profile? getSourceProfileByDeck(Deck deck, {bool includeDeleted = false}) =>
      guardSync(() {
        final sourceDeckId = deck.sourceDeckId;
        if (sourceDeckId == null) return null;

        final sourceDeck = selectByPk({
          'id': sourceDeckId,
        }, includeDeleted: includeDeleted);
        if (sourceDeck == null) return null;

        return LocalDB.profiles.selectByPk({'id': sourceDeck.profileId});
      }, action: 'getSourceProfileByDeck(${deck.id})');

  List<SyncIndexEntry> selectSyncIndexByProfileIdAndOptionalDeckId({
    required String profileId,
    String? deckId,
  }) => selectSyncIndexWhere(
    where: (deck) {
      if (deck.profileId != profileId) return false;
      return deckId == null || deck.id == deckId;
    },
    getId: (deck) => deck.id,
    getUpdatedAt: (deck) => deck.updatedAt,
    action: 'selectSyncIndexByProfileIdAndOptionalDeckId($profileId, $deckId)',
  );

  List<Deck> selectManyByIds(List<String> ids) => guardSync(
    () => [
      for (final id in ids) ?selectByPk({'id': id}, includeDeleted: true),
    ],
    action: 'selectManyByIds(${ids.length} ids)',
  );

  List<Deck> filterDecks({
    String query = '',
    DeckSortField sortField = DeckSortField.updatedAt,
    SearchSortDirection sortDirection = SearchSortDirection.descending,
  }) => guardSync(() {
    final normalizedQuery = query.trim().toLowerCase();
    final currentProfileId = LocalDB.currentProfile.getOrCreate().id;
    final filtered = selectMany().where((deck) {
      if (deck.profileId != currentProfileId) return false;
      if (normalizedQuery.isEmpty) return true;
      return deck.title.toLowerCase().contains(normalizedQuery) ||
          deck.shortDescription.toLowerCase().contains(normalizedQuery) ||
          deck.longDescription.toLowerCase().contains(normalizedQuery);
    });

    return _sortDecks(filtered, field: sortField, direction: sortDirection);
  }, action: 'filterDecks($query, $sortField, $sortDirection)');

  List<Deck> _sortDecks(
    Iterable<Deck> decks, {
    required DeckSortField field,
    required SearchSortDirection direction,
  }) {
    final sorted = decks.toList();
    sorted.sort((a, b) {
      final comparison = switch (field) {
        DeckSortField.letters => a.title.toLowerCase().compareTo(
          b.title.toLowerCase(),
        ),
        DeckSortField.createdAt => a.createdAt.compareTo(b.createdAt),
        DeckSortField.updatedAt => a.updatedAt.compareTo(b.updatedAt),
      };

      return direction == SearchSortDirection.ascending
          ? comparison
          : -comparison;
    });
    return sorted;
  }
}
