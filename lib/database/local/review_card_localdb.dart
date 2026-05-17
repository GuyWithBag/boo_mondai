// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/deck_card_repository.dart
// PURPOSE: Hive CRUD for ReviewCard — source of truth for cards belonging to a deck
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

class ReviewCardLocalDB extends HiveLocalDB<ReviewCard> {
  @override
  String get boxName => 'review_cards';

  @override
  Map<String, Object?> primaryKeyFromItem(ReviewCard item) => {'id': item.id};

  List<ReviewCard> getByDeckId(String deckId) => guardSync(
    () => box.values.where((c) => c.deckId == deckId).toList(),
    action: 'getByDeckId($deckId)',
  );

  Future<void> deleteByDeckId(String deckId) => guard(() async {
    final keys = box.values
        .where((c) => c.deckId == deckId)
        .map((c) => primaryKeyFromItem(c))
        .toList();
    await box.deleteAll(keys.map(encodePrimaryKey));
  }, action: 'deleteByDeckId($deckId)');
}
