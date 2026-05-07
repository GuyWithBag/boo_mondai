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
  String get boxName => 'reivew_card_box';

  @override
  String getId(ReviewCard item) => item.id;

  List<ReviewCard> getByDeckId(String deckId) => guardSync(
    () => box.values.where((c) => c.deckId == deckId).toList(),
    action: 'getByDeckId($deckId)',
  );

  Future<void> deleteByDeckId(String deckId) => guard(() async {
    final keys = box.values
        .where((c) => c.deckId == deckId)
        .map((c) => c.id)
        .toList();
    await box.deleteAll(keys);
  }, action: 'deleteByDeckId($deckId)');
}
