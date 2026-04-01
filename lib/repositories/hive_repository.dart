// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/hive_repository.dart
// PURPOSE: Abstract Hive CRUD base — shared getAll, getById, save, saveAll, delete, deleteAll, clear
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:hive_ce/hive.dart';

/// Base repository for Hive boxes keyed by a String id.
///
/// Subclasses provide [boxName] and [getId] to get shared CRUD for free.
/// Domain-specific queries (e.g. getByDeckId) belong in the subclass.
abstract class HiveRepository<T> {
  String get boxName;

  Box<T> get box => Hive.box<T>(boxName);

  /// Extracts the String key used for Hive put/get from an item.
  String getId(T item);

  List<T> getAll() => box.values.toList();

  T? getById(String id) => box.get(id);

  Future<void> save(T item) => box.put(getId(item), item);

  Future<void> saveAll(List<T> items) async {
    final map = {for (final item in items) getId(item): item};
    await box.putAll(map);
  }

  Future<void> delete(String id) => box.delete(id);

  Future<void> deleteAll(List<String> ids) => box.deleteAll(ids);

  Future<void> clear() => box.clear();
}
