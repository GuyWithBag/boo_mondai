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

  List<Deck> getByCurrentUser() => guardSync(
    () => selectMany()
        .where((d) => d.userId == LocalDB.profile.getOrCreate().userId)
        .toList(),
    action: 'getByCurrentUser',
  );

  List<Deck> getByUserId(String userId) => guardSync(
    () => box.values.where((d) => d.userId == userId).toList(),
    action: 'getByUserId($userId)',
  );
}
