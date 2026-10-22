// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/hive_single_data_local_db.dart
// PURPOSE: Abstract Hive base for boxes that hold exactly one item (e.g. profile, settings)
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:convert';
import 'package:boo_mondai/core/exceptions/hive_exception.dart'
    show HiveException;
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

typedef HiveSinglePrimaryKey = Map<String, Object?>;

abstract class HiveSingleDataLocalDB<T> {
  String get boxName;

  late final Box<T> box;

  Future<HiveSingleDataLocalDB<T>> init() async {
    // if (await Hive.boxExists(boxName)) {
    //   await Hive.deleteBoxFromDisk(boxName);
    // }
    box = await Hive.openBox<T>(boxName);
    return this;
  }

  /// Extracts the primary key used for Hive put/get from an item.
  HiveSinglePrimaryKey primaryKeyFromItem(T item);

  String encodePrimaryKey(HiveSinglePrimaryKey primaryKey) {
    final orderedKeys = primaryKey.keys.toList()..sort();
    return jsonEncode({for (final key in orderedKeys) key: primaryKey[key]});
  }

  String keyFromItem(T item) => encodePrimaryKey(primaryKeyFromItem(item));

  T createValue();

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
      name: 'HiveSingleDB[$boxName]',
      error: error,
      stackTrace: stackTrace,
    );
  }

  void _logResult<U>(U result, String action) {
    if (result == null) {
      _debugLog('Result is NULL: $action');
    } else {
      _debugLog('Success: $action');
    }
  }

  // ── Operations ──────────────────────────────────────────

  T? retrieve() => guardSync(() {
    final values = box.values.toList();
    return values.isEmpty ? null : values[0];
  }, action: 'retrieve');

  T getOrCreate() {
    final value = retrieve();
    if (value != null) {
      final key = keyFromItem(value);
      if (!box.containsKey(key)) {
        unawaited(box.put(key, value));
      }
      return value;
    }

    final newValue = createValue();
    unawaited(box.put(keyFromItem(newValue), newValue));
    return newValue;
  }

  Future<void> upsert(T item) => guard(() async {
    await box.clear();
    await box.putAll({keyFromItem(item): item});
  }, action: 'upsert(${primaryKeyFromItem(item)})');

  Future<void> clear() => guard(() => box.clear(), action: 'clear');
}
