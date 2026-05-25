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
        .where((d) => d.userId == LocalDB.profile.getOrCreate().userId)
        .toList(),
    action: 'getByCurrentUser',
  );

  List<Deck> getByUserId(String userId) => guardSync(
    () => selectMany(where: (deck) => deck.userId == userId),
    action: 'getByUserId($userId)',
  );

  List<Deck> filterDecks({
    String query = '',
    BrowseSortField sortField = BrowseSortField.updatedAt,
    BrowseSortDirection sortDirection = BrowseSortDirection.descending,
  }) => guardSync(() {
    final normalizedQuery = query.trim().toLowerCase();
    final filtered = selectMany().where((deck) {
      if (normalizedQuery.isEmpty) return true;
      return deck.title.toLowerCase().contains(normalizedQuery) ||
          deck.shortDescription.toLowerCase().contains(normalizedQuery) ||
          deck.longDescription.toLowerCase().contains(normalizedQuery);
    });

    return _sortDecks(filtered, field: sortField, direction: sortDirection);
  }, action: 'filterDecks($query, $sortField, $sortDirection)');

  List<Deck> _sortDecks(
    Iterable<Deck> decks, {
    required BrowseSortField field,
    required BrowseSortDirection direction,
  }) {
    final sorted = decks.toList();
    sorted.sort((a, b) {
      final comparison = switch (field) {
        BrowseSortField.letters => a.title.toLowerCase().compareTo(
          b.title.toLowerCase(),
        ),
        BrowseSortField.createdAt => a.createdAt.compareTo(b.createdAt),
        BrowseSortField.updatedAt => a.updatedAt.compareTo(b.updatedAt),
      };

      return direction == BrowseSortDirection.ascending
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
