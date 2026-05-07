// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/hive_localdb.dart
// PURPOSE: Abstract Hive CRUD base — shared getAll, getById, put, putAll, delete, deleteAll, clear
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:developer' as developer;
import 'package:boo_mondai/exceptions/exceptions.barrel.dart';
import 'package:hive_ce/hive.dart';

/// Base repository for Hive boxes keyed by a String id.
///
/// Subclasses provide [boxName] and [getId] to get shared CRUD for free.
/// Domain-specific queries (e.g. getByDeckId) belong in the subclass.
abstract class HiveLocalDB<T> {
  String get boxName;

  late final Box<T> box;

  Future<HiveLocalDB<T>> init() async {
    // Hive.deleteBoxFromDisk(boxName);
    box = await Hive.openBox<T>(boxName);
    return this;
  }

  /// Extracts the String key used for Hive put/get from an item.
  String getId(T item);

  // ── Error, Logging & Crashlytics Wrapper ───────────────────

  /// Wraps async Hive calls to handle exceptions and log results locally.
  Future<U> guard<U>(Future<U> Function() fn, {required String action}) async {
    developer.log('🚀 Starts: $action', name: 'HiveLocalDB[$boxName]');
    try {
      final result = await fn();
      _logResult(result, action);
      return result;
    } on HiveError catch (e) {
      developer.log(
        '❌ HiveError: ${e.message}',
        name: 'HiveLocalDB[$boxName]',
        error: e,
      );
      throw HiveException(e.message, code: 'HIVE_ERROR', originalError: e);
    } catch (e, stack) {
      developer.log(
        '❌ Unknown Exception: $e',
        name: 'HiveLocalDB[$boxName]',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Wraps synchronous Hive calls to handle exceptions and log results locally.
  U guardSync<U>(U Function() fn, {required String action}) {
    developer.log('🚀 Starts: $action', name: 'HiveLocalDB[$boxName]');
    try {
      final result = fn();
      _logResult(result, action);
      return result;
    } on HiveError catch (e) {
      developer.log(
        '❌ HiveError: ${e.message}',
        name: 'HiveLocalDB[$boxName]',
        error: e,
      );
      throw HiveException(e.message, code: 'HIVE_ERROR', originalError: e);
    } catch (e, stack) {
      developer.log(
        '❌ Unknown Exception: $e',
        name: 'HiveLocalDB[$boxName]',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  void _logResult<U>(U result, String action) {
    if (result == null) {
      developer.log('⚠️ Result is NULL: $action', name: 'HiveLocalDB[$boxName]');
    } else if (result is List && result.isEmpty) {
      developer.log('⚠️ Result is an EMPTY LIST: $action', name: 'HiveLocalDB[$boxName]');
    } else {
      final countStr = result is List ? ' (Returned ${result.length} items)' : '';
      developer.log('✅ Success: $action$countStr', name: 'HiveLocalDB[$boxName]');
    }
  }

  // ── CRUD ────────────────────────────────────────────────

  List<T> getAll() => guardSync(() => box.values.toList(), action: 'getAll');

  T? getById(String id) => guardSync(() => box.get(id), action: 'getById($id)');

  List<T> getAllById(String id) => guardSync(
    () => box.values.where((T item) => getId(item) == id).toList(),
    action: 'getAllById($id)',
  );

  Future<void> put(T item) => guard(
    () => box.put(getId(item), item),
    action: 'put(${getId(item)})',
  );

  Future<void> putAll(List<T> items) => guard(() async {
    final map = {for (final item in items) getId(item): item};
    await box.putAll(map);
  }, action: 'putAll(${items.length} items)');

  Future<void> delete(String id) => guard(
    () => box.delete(id),
    action: 'delete($id)',
  );

  Future<void> deleteAll(List<String> ids) => guard(
    () => box.deleteAll(ids),
    action: 'deleteAll(${ids.length} ids)',
  );

  Future<void> clear() => guard(() => box.clear(), action: 'clear');
}
