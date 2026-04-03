// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/in_memory_repository.dart
// PURPOSE: Abstract In-Memory CRUD base — temporary storage for active sessions
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Base repository for temporary, in-memory storage keyed by a String id.
///
/// Subclasses provide [getId] to get shared CRUD for free.
/// Data is cleared when the app restarts or clear() is called.
abstract class InMemoryRepository<T> {
  final Map<String, T> _storage = {};

  /// Extracts the String key used for storage from an item.
  String getId(T item);

  List<T> getAll() => _storage.values.toList();

  T? getById(String id) => _storage[id];

  Future<void> save(T item) async {
    _storage[getId(item)] = item;
  }

  Future<void> saveAll(List<T> items) async {
    for (final item in items) {
      _storage[getId(item)] = item;
    }
  }

  Future<void> delete(String id) async {
    _storage.remove(id);
  }

  Future<void> deleteAll(List<String> ids) async {
    for (final id in ids) {
      _storage.remove(id);
    }
  }

  Future<void> clear() async {
    _storage.clear();
  }
}
