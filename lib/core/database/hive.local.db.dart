// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/hive.local.db.dart
// PURPOSE: Abstract Hive table repository — shared select, insert, upsert, delete, clear
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:convert';
import 'dart:developer' as developer;
import 'package:boo_mondai/lib.barrel.dart' show HiveException, SyncIndexEntry;
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

typedef HivePrimaryKey = Map<String, Object?>;

/// Base repository for Hive boxes keyed by encoded primary-key maps.
/// Subclasses should keep [boxName] identical to the backing Supabase table.
abstract class HiveLocalDB<T> {
  String get boxName;

  late final Box<T> box;

  Future<HiveLocalDB<T>> init() async {
    // Hive.deleteBoxFromDisk(boxName);
    box = await Hive.openBox<T>(boxName);
    return this;
  }

  /// Extracts the real primary key for [item].
  HivePrimaryKey primaryKeyFromItem(T item);

  /// Override for models with soft-delete state.
  DateTime? getDeletedAt(T item) => null;

  bool _isVisible(T item, {required bool includeDeleted}) {
    return includeDeleted || getDeletedAt(item) == null;
  }

  String encodePrimaryKey(HivePrimaryKey primaryKey) {
    final orderedKeys = primaryKey.keys.toList()..sort();
    return jsonEncode({for (final key in orderedKeys) key: primaryKey[key]});
  }

  // ── Error, Logging & Crashlytics Wrapper ───────────────────

  /// Wraps async Hive calls to handle exceptions and log results locally.
  Future<U> guard<U>(Future<U> Function() fn, {required String action}) async {
    _debugLog('Starts: $action');
    try {
      final result = await fn();
      _logResult(result, action);
      return result;
    } on HiveError catch (e) {
      _debugLog('HiveError: ${e.message}', error: e);
      throw HiveException(e.message, code: 'HIVE_ERROR', originalError: e);
    } catch (e, stack) {
      _debugLog('Unknown Exception: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Wraps synchronous Hive calls to handle exceptions and log results locally.
  U guardSync<U>(U Function() fn, {required String action}) {
    _debugLog('Starts: $action');
    try {
      final result = fn();
      _logResult(result, action);
      return result;
    } on HiveError catch (e) {
      _debugLog('HiveError: ${e.message}', error: e);
      throw HiveException(e.message, code: 'HIVE_ERROR', originalError: e);
    } catch (e, stack) {
      _debugLog('Unknown Exception: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  void _debugLog(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: 'HiveLocalDB[$boxName]',
      error: error,
      stackTrace: stackTrace,
    );
  }

  void _logResult<U>(U result, String action) {
    if (result == null) {
      _debugLog('Result is NULL: $action');
    } else if (result is List && result.isEmpty) {
      _debugLog('Result is an EMPTY LIST: $action');
    } else {
      final countStr = result is List
          ? ' (Returned ${result.length} items)'
          : '';
      _debugLog('Success: $action$countStr');
    }
  }

  // ── CRUD ────────────────────────────────────────────────

  List<T> selectMany({
    bool Function(T item)? where,
    int? limit,
    int offset = 0,
    bool includeDeleted = false,
  }) => guardSync(() {
    Iterable<T> values = box.values.where(
      (item) => _isVisible(item, includeDeleted: includeDeleted),
    );
    if (where != null) {
      values = values.where(where);
    }
    if (offset > 0) {
      values = values.skip(offset);
    }
    if (limit != null) {
      values = values.take(limit);
    }
    return values.toList();
  }, action: 'selectMany');

  List<SyncIndexEntry> selectSyncIndexWhere({
    required bool Function(T item) where,
    required String Function(T item) getId,
    required DateTime Function(T item) getUpdatedAt,
    required String action,
    bool includeDeleted = true,
  }) => guardSync(
    () => box.values
        .where((item) => _isVisible(item, includeDeleted: includeDeleted))
        .where(where)
        .map(
          (item) =>
              SyncIndexEntry(id: getId(item), updatedAt: getUpdatedAt(item)),
        )
        .toList(growable: false),
    action: action,
  );

  T? selectByPk(HivePrimaryKey primaryKey, {bool includeDeleted = false}) =>
      guardSync(() {
        final item = box.get(encodePrimaryKey(primaryKey));
        if (item == null || !_isVisible(item, includeDeleted: includeDeleted)) {
          return null;
        }
        return item;
      }, action: 'selectByPk($primaryKey)');

  Future<void> insert(T item) => guard(() async {
    final key = encodePrimaryKey(primaryKeyFromItem(item));
    if (box.containsKey(key)) {
      throw HiveException('Duplicate primary key: $key', code: 'DUPLICATE_KEY');
    }
    await box.put(key, item);
  }, action: 'insert(${primaryKeyFromItem(item)})');

  Future<void> upsert(T item) => guard(
    () => box.put(encodePrimaryKey(primaryKeyFromItem(item)), item),
    action: 'upsert(${primaryKeyFromItem(item)})',
  );

  Future<void> upsertMany(List<T> items) => guard(() async {
    final map = {
      for (final item in items)
        encodePrimaryKey(primaryKeyFromItem(item)): item,
    };
    await box.putAll(map);
  }, action: 'upsertMany(${items.length} items)');

  Future<void> update(T item) => upsert(item);

  Future<void> delete(T item) => deleteByPk(primaryKeyFromItem(item));

  Future<void> deleteByPk(HivePrimaryKey primaryKey) => guard(
    () => box.delete(encodePrimaryKey(primaryKey)),
    action: 'deleteByPk($primaryKey)',
  );

  Future<void> deleteManyByPk(List<HivePrimaryKey> primaryKeys) => guard(
    () => box.deleteAll(primaryKeys.map(encodePrimaryKey)),
    action: 'deleteManyByPk(${primaryKeys.length} keys)',
  );

  Future<void> clear() => guard(() => box.clear(), action: 'clear');

  Stream<BoxEvent> watch({HivePrimaryKey? primaryKey}) {
    return box.watch(
      key: primaryKey == null ? null : encodePrimaryKey(primaryKey),
    );
  }
}
