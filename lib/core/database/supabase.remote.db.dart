// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/supabase.remote.db.dart
// PURPOSE: Abstract Supabase table repository — shared client, guard, and generic CRUD
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:developer' as developer;
import 'package:boo_mondai/core/exceptions/app_exception.dart'
    show AppException;
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

  /// Default select used by read methods. Override this to include joins.
  String get defaultSelect => '*';

  /// Map keys that are populated by joined selects and must not be written.
  Set<String> get joinedFields => const {};

  /// Deserializes a DB map that may include joined relation data.
  T fromJoinedMap(Map<String, dynamic> map) => fromMap(map);

  /// Serializes [item] for insert/update/upsert, excluding joined data.
  Map<String, dynamic> toWriteMap(T item) {
    final map = Map<String, dynamic>.from(toMap(item));
    return withoutJoinedFields(map);
  }

  Map<String, dynamic> withoutJoinedFields(Map<String, dynamic> map) {
    final values = Map<String, dynamic>.from(map);
    for (final field in joinedFields) {
      values.remove(field);
    }
    return values;
  }

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

  dynamic applyFilters(dynamic query, Map<String, Object?> filters) {
    for (final entry in filters.entries) {
      query = entry.value == null
          ? query.isFilter(entry.key, null)
          : query.eq(entry.key, entry.value);
    }
    return query;
  }

  Map<String, dynamic> _updatesWithoutPrimaryKey(T item) {
    final updates = toWriteMap(item);
    for (final key in primaryKeyFromItem(item).keys) {
      updates.remove(key);
    }
    return updates;
  }

  // ── Primary-table CRUD ───────────────────────────────────

  Future<List<T>> selectMany({
    String? select,
    Map<String, Object?> filters = const {},
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) => guard(() async {
    dynamic query = client.from(tableName).select(select ?? defaultSelect);

    if (filters.isNotEmpty) {
      query = applyFilters(query, filters);
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
    return List<Map<String, dynamic>>.from(
      response,
    ).map(fromJoinedMap).toList();
  }, action: 'selectMany');

  Future<T?> selectOne({
    String? select,
    required Map<String, Object?> filters,
  }) => guard(() async {
    final row = await applyFilters(
      client.from(tableName).select(select ?? defaultSelect),
      filters,
    ).maybeSingle();
    return row == null ? null : fromJoinedMap(row);
  }, action: 'selectOne($filters)');

  Future<T> insert(T item, {String select = '*'}) => guard(() async {
    final response = await client
        .from(tableName)
        .insert(toWriteMap(item))
        .select(select)
        .single();
    return fromJoinedMap(response);
  }, action: 'insert');

  Future<void> update(T item) => updateWhere(
    filters: primaryKeyFromItem(item),
    values: _updatesWithoutPrimaryKey(item),
  );

  Future<void> updateWhere({
    required Map<String, Object?> filters,
    required Map<String, dynamic> values,
  }) => guard(() async {
    await applyFilters(
      client.from(tableName).update(withoutJoinedFields(values)),
      filters,
    );
  }, action: 'updateWhere($filters)');

  Future<void> upsert(T item, {String? onConflict}) => guard(() async {
    await client
        .from(tableName)
        .upsert(
          toWriteMap(item),
          onConflict: onConflict ?? upsertConflictTarget,
        );
  }, action: 'upsert(${primaryKeyFromItem(item)})');

  Future<void> upsertMany(List<T> items, {String? onConflict}) =>
      guard(() async {
        if (items.isEmpty) return;
        await client
            .from(tableName)
            .upsert(
              items.map(toWriteMap).toList(),
              onConflict: onConflict ?? upsertConflictTarget,
            );
      }, action: 'upsertMany(${items.length} items)');

  Future<void> delete(T item) => deleteWhere(primaryKeyFromItem(item));

  Future<void> deleteWhere(Map<String, Object?> filters) => guard(() async {
    await applyFilters(client.from(tableName).delete(), filters);
  }, action: 'deleteWhere($filters)');
}
