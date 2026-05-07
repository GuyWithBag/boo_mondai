// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/hive_single_data_local_db.dart
// PURPOSE: Abstract Hive base for boxes that hold exactly one item (e.g. profile, settings)
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:developer' as developer;
import 'package:boo_mondai/exceptions/exceptions.barrel.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

abstract class HiveSingleDataLocalDB<T> {
  String get boxName;

  late final Box<T> box;

  Future<HiveSingleDataLocalDB<T>> init() async {
    // Hive.deleteBoxFromDisk(boxName);
    box = await Hive.openBox<T>(boxName);
    return this;
  }

  /// Extracts the String key used for Hive put/get from an item.
  String getId(T item);

  T createValue();

  // ── Error, Logging & Crashlytics Wrapper ───────────────────

  /// Wraps async Hive calls to handle exceptions and log results locally.
  Future<U> guard<U>(Future<U> Function() fn, {required String action}) async {
    developer.log('🚀 Starts: $action', name: 'HiveSingleDB[$boxName]');
    try {
      final result = await fn();
      _logResult(result, action);
      return result;
    } on HiveError catch (e) {
      developer.log(
        '❌ HiveError: ${e.message}',
        name: 'HiveSingleDB[$boxName]',
        error: e,
      );
      throw HiveException(e.message, code: 'HIVE_ERROR', originalError: e);
    } catch (e, stack) {
      developer.log(
        '❌ Unknown Exception: $e',
        name: 'HiveSingleDB[$boxName]',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Wraps synchronous Hive calls to handle exceptions and log results locally.
  U guardSync<U>(U Function() fn, {required String action}) {
    developer.log('🚀 Starts: $action', name: 'HiveSingleDB[$boxName]');
    try {
      final result = fn();
      _logResult(result, action);
      return result;
    } on HiveError catch (e) {
      developer.log(
        '❌ HiveError: ${e.message}',
        name: 'HiveSingleDB[$boxName]',
        error: e,
      );
      throw HiveException(e.message, code: 'HIVE_ERROR', originalError: e);
    } catch (e, stack) {
      developer.log(
        '❌ Unknown Exception: $e',
        name: 'HiveSingleDB[$boxName]',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  void _logResult<U>(U result, String action) {
    if (result == null) {
      developer.log('⚠️ Result is NULL: $action', name: 'HiveSingleDB[$boxName]');
    } else {
      developer.log('✅ Success: $action', name: 'HiveSingleDB[$boxName]');
    }
  }

  // ── Operations ──────────────────────────────────────────

  T? retrieve() => guardSync(
    () {
      final values = box.values.toList();
      return values.isEmpty ? null : values[0];
    },
    action: 'retrieve',
  );

  T getOrCreate() {
    final value = retrieve();
    if (value == null) {
      final newValue = createValue();
      upsert(newValue);
    }
    return retrieve()!;
  }

  Future<void> upsert(T item) => guard(() async {
    await box.clear();
    await box.putAll({getId(item): item});
  }, action: 'upsert(${getId(item)})');

  Future<void> clear() => guard(() => box.clear(), action: 'clear');
}
