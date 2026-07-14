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

  @override
  List<Deck> selectMany({
    bool Function(Deck item)? where,
    int? limit,
    int offset = 0,
  }) => super
      .selectMany(where: where, limit: limit, offset: offset)
      .map(_withLocalProfile)
      .toList();

  @override
  Deck? selectByPk(HivePrimaryKey primaryKey) {
    final deck = super.selectByPk(primaryKey);
    return deck == null ? null : _withLocalProfile(deck);
  }

  List<Deck> getByCurrentUser() => guardSync(
    () => selectMany()
        .where((d) => d.userId == LocalDB.profile.getOrCreate().id)
        .toList(),
    action: 'getByCurrentUser',
  );

  List<Deck> getByUserId(String userId) => guardSync(
    () => selectMany(where: (deck) => deck.userId == userId),
    action: 'getByUserId($userId)',
  );

  List<Deck> selectManyByUserIdAndOptionalDeckId({
    required String userId,
    String? deckId,
  }) => guardSync(
    () => selectMany(
      where: (deck) {
        if (deck.userId != userId) return false;
        return deckId == null || deck.id == deckId;
      },
    ),
    action: 'selectManyByUserIdAndOptionalDeckId($userId, $deckId)',
  );

  List<SyncIndexEntry> selectSyncIndexByUserIdAndOptionalDeckId({
    required String userId,
    String? deckId,
  }) => guardSync(
    () => selectManyByUserIdAndOptionalDeckId(userId: userId, deckId: deckId)
        .map((deck) => SyncIndexEntry(id: deck.id, updatedAt: deck.updatedAt))
        .toList(growable: false),
    action: 'selectSyncIndexByUserIdAndOptionalDeckId($userId, $deckId)',
  );

  List<Deck> selectManyByIds(List<String> ids) => guardSync(
    () => [
      for (final id in ids) ?selectByPk({'id': id}),
    ],
    action: 'selectManyByIds(${ids.length} ids)',
  );

  List<Deck> filterDecks({
    String query = '',
    DeckSortField sortField = DeckSortField.updatedAt,
    SearchSortDirection sortDirection = SearchSortDirection.descending,
  }) => guardSync(() {
    final normalizedQuery = query.trim().toLowerCase();
    final currentProfileId = LocalDB.profile.getOrCreate().id;
    final filtered = selectMany().where((deck) {
      if (deck.userId != currentProfileId) return false;
      if (normalizedQuery.isEmpty) return true;
      return deck.title.toLowerCase().contains(normalizedQuery) ||
          deck.shortDescription.toLowerCase().contains(normalizedQuery) ||
          deck.longDescription.toLowerCase().contains(normalizedQuery);
    });

    return _sortDecks(filtered, field: sortField, direction: sortDirection);
  }, action: 'filterDecks($query, $sortField, $sortDirection)');

  Future<void> adoptLegacyOwnerId({
    required String legacyUserId,
    required String currentProfileId,
  }) => guard(() async {
    if (legacyUserId == currentProfileId) return;

    final legacyDecks = box.values
        .where((deck) => deck.userId == legacyUserId)
        .toList();
    for (final deck in legacyDecks) {
      await upsert(
        deck.copyWith(userId: currentProfileId, updatedAt: DateTime.now()),
      );
    }
  }, action: 'adoptLegacyOwnerId($legacyUserId, $currentProfileId)');

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

  Deck _withLocalProfile(Deck deck) {
    if (deck.userProfile != null) return deck;

    final profile = LocalDB.profile.getOrCreate();
    if (deck.userId != profile.id) return deck;

    return deck.copyWith(
      userProfile: CachedProfile(
        id: profile.id,
        username: profile.username,
        avatarUrl: profile.avatarUrl,
        createdAt: profile.createdAt,
      ),
    );
  }
}
