// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/fsrs_card_state_repository.dart
// PURPOSE: Hive CRUD for FsrsCardState — persists FSRS scheduling state per card
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:hive_ce/hive.dart';
import '../models/fsrs_card_state.dart';

class FsrsCardStateRepository {
  static const String boxName = 'fsrs_card_state_box';

  Box<FsrsCardState> get _box => Hive.box<FsrsCardState>(boxName);

  List<FsrsCardState> getAll() => _box.values.toList();

  FsrsCardState? getById(String id) => _box.get(id);

  FsrsCardState? getByCardId(String cardId) =>
      _box.values.where((s) => s.cardId == cardId).firstOrNull;

  List<FsrsCardState> getDueCards(DateTime now) => _box.values
      .where((s) => s.due.isBefore(now) || s.due.isAtSameMomentAs(now))
      .toList();

  Future<void> save(FsrsCardState state) => _box.put(state.id, state);

  Future<void> saveAll(List<FsrsCardState> states) async {
    final map = {for (final s in states) s.id: s};
    await _box.putAll(map);
  }

  Future<void> delete(String id) => _box.delete(id);

  Future<void> deleteAll(List<String> ids) => _box.deleteAll(ids);

  Future<void> clear() => _box.clear();
}
