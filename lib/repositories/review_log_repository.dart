// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/review_log_repository.dart
// PURPOSE: Hive CRUD for ReviewLogEntry — append-only log of every card review event
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:hive_ce/hive.dart';
import '../models/review_log_entry.dart';

class ReviewLogRepository {
  static const String boxName = 'review_log_box';

  Box<ReviewLogEntry> get _box => Hive.box<ReviewLogEntry>(boxName);

  List<ReviewLogEntry> getAll() => _box.values.toList();

  List<ReviewLogEntry> getByCardId(String cardId) =>
      _box.values.where((e) => e.cardId == cardId).toList();

  Future<void> save(ReviewLogEntry entry) => _box.put(entry.id, entry);

  Future<void> saveAll(List<ReviewLogEntry> entries) async {
    final map = {for (final e in entries) e.id: e};
    await _box.putAll(map);
  }

  Future<void> clear() => _box.clear();
}
