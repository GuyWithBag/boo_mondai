// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/fsrs_card_state_repository.dart
// PURPOSE: Hive CRUD for FsrsCard — persists FSRS scheduling state per card
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';

import 'hive_repository.dart';

class FsrsCardRepository extends HiveRepository<FsrsCard> {
  @override
  String get boxName => 'fsrs_card_box';

  @override
  String getId(FsrsCard item) => item.id.toString();

  FsrsCard? getByDeckCardId(String cardId) =>
      box.values.where((s) => s.deckCardId == cardId).firstOrNull;

  List<FsrsCard> getDueCards(DateTime now) => box.values
      .where(
        (s) => s.state.due.isBefore(now) || s.state.due.isAtSameMomentAs(now),
      )
      .toList();
}
