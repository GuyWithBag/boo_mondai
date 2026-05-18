// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/supabase.remote.db.dart
// PURPOSE: Abstract Supabase table repository — shared client, guard, and generic CRUD
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:developer' as developer;
import 'package:boo_mondai/exceptions/exceptions.barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef DbPrimaryKey = Map<String, Object?>;

/// Base class for Supabase table repositories.
/// Subclasses own table identity, row mapping, and primary-key extraction.
abstract class SupabaseRemoteDB<T> {
  SupabaseClient get client => Supabase.instance.client;

  /// Supabase table or view name.
  String get tableName;

  /// Deserializes a raw DB row into [T].
  T Function(Map<String, dynamic>) get fromMap;

  /// Serializes [item] into a DB row map.
  Map<String, dynamic> toMap(T item);

  /// Extracts the real primary key for [item].
  DbPrimaryKey primaryKeyFromItem(T item);

  /// Supabase/PostgREST upsert conflict target, e.g. `id` or `deck_id,tag_id`.
  String? get upsertConflictTarget => null;

  // ── Error, Logging & Crashlytics Wrapper ───────────────────

  /// Wraps DB calls to handle exceptions, log results locally,
  /// and silently report crashes to Firebase.
  Future<U> guard<U>(Future<U> Function() fn, {required String action}) async {
    _debugLog('Starts: $action');

    try {
      final result = await fn();
      _logResult(result, action);
      return result;
    } on AuthException catch (e) {
      _debugLog('AuthException: ${e.message}', error: e);

      // Send to Firebase Crashlytics silently
      // FirebaseCrashlytics.instance.recordError(
      //   e, stack,
      //   reason: 'Supabase Auth Error during $action in $tableName',
      //   fatal: false,
      // );

      throw AppException(e.message, code: e.statusCode);
    } on PostgrestException catch (e) {
      _debugLog('PostgrestException: ${e.message}', error: e);

      // Send to Firebase Crashlytics silently
      // FirebaseCrashlytics.instance.recordError(
      //   e, stack,
      //   reason: 'Supabase Database Error during $action in $tableName',
      //   fatal: false,
      // );

      throw AppException(e.message, code: e.code);
    } catch (e, stack) {
      _debugLog('Unknown Exception: $e', error: e, stackTrace: stack);

      // Catch unexpected app crashes (e.g., mapping errors, null pointers)
      // FirebaseCrashlytics.instance.recordError(
      //   e, stack,
      //   reason: 'Unknown Error during $action in $tableName',
      //   fatal: true,
      // );

      rethrow;
    }
  }

  void _debugLog(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: 'SupabaseDB[$tableName]',
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

  dynamic _applyFilters(dynamic query, Map<String, Object?> filters) {
    for (final entry in filters.entries) {
      query = entry.value == null
          ? query.isFilter(entry.key, null)
          : query.eq(entry.key, entry.value);
    }
    return query;
  }

  Map<String, dynamic> _updatesWithoutPrimaryKey(T item) {
    final updates = Map<String, dynamic>.from(toMap(item));
    for (final key in primaryKeyFromItem(item).keys) {
      updates.remove(key);
    }
    return updates;
  }

  // ── Primary-table CRUD ───────────────────────────────────

  Future<List<T>> selectMany({
    String select = '*',
    Map<String, Object?> filters = const {},
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) => guard(() async {
    dynamic query = client.from(tableName).select(select);

    if (filters.isNotEmpty) {
      query = _applyFilters(query, filters);
    }
    if (orderBy != null) {
      query = query.order(orderBy, ascending: ascending);
    }
    if (limit != null && offset != null) {
      query = query.range(offset, offset + limit - 1);
    } else if (limit != null) {
      query = query.limit(limit);
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response).map(fromMap).toList();
  }, action: 'selectMany');

  Future<T?> selectOne({
    String select = '*',
    required Map<String, Object?> filters,
  }) => guard(() async {
    final row = await _applyFilters(
      client.from(tableName).select(select),
      filters,
    ).maybeSingle();
    return row == null ? null : fromMap(row);
  }, action: 'selectOne($filters)');

  Future<T> insert(T item, {String select = '*'}) => guard(() async {
    final response = await client
        .from(tableName)
        .insert(toMap(item))
        .select(select)
        .single();
    return fromMap(response);
  }, action: 'insert');

  Future<void> update(T item) => updateWhere(
    filters: primaryKeyFromItem(item),
    values: _updatesWithoutPrimaryKey(item),
  );

  Future<void> updateWhere({
    required Map<String, Object?> filters,
    required Map<String, dynamic> values,
  }) => guard(() async {
    await _applyFilters(client.from(tableName).update(values), filters);
  }, action: 'updateWhere($filters)');

  Future<void> upsert(T item, {String? onConflict}) => guard(() async {
    await client
        .from(tableName)
        .upsert(toMap(item), onConflict: onConflict ?? upsertConflictTarget);
  }, action: 'upsert(${primaryKeyFromItem(item)})');

  Future<void> upsertMany(List<T> items, {String? onConflict}) =>
      guard(() async {
        if (items.isEmpty) return;
        await client
            .from(tableName)
            .upsert(
              items.map(toMap).toList(),
              onConflict: onConflict ?? upsertConflictTarget,
            );
      }, action: 'upsertMany(${items.length} items)');

  Future<void> delete(T item) => deleteWhere(primaryKeyFromItem(item));

  Future<void> deleteWhere(Map<String, Object?> filters) => guard(() async {
    await _applyFilters(client.from(tableName).delete(), filters);
  }, action: 'deleteWhere($filters)');
}
