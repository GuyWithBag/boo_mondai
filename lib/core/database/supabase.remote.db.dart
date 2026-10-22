// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/supabase.remote.db.dart
// PURPOSE: Abstract Supabase table repository — shared client, SupabaseRemoteGuard.guard, and generic CRUD
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'package:boo_mondai/lib.barrel.dart'
    show SyncIndexEntry, SupabaseRemoteGuard;
import 'package:supabase_flutter/supabase_flutter.dart';

typedef DbPrimaryKey = Map<String, Object?>;

/// Base class for Supabase table repositories.
/// Subclasses own table identity, row mapping, and primary-key extraction.
abstract class SupabaseRemoteDB<T> {
  SupabaseClient get client => Supabase.instance.client;

  /// Supabase table or view name.
  String get tableName;

  Future<U> guard<U>(Future<U> Function() fn, {required String action}) {
    return SupabaseRemoteGuard.guard(fn, action: action, tableName: tableName);
  }

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

  /// Override for tables with a nullable deleted_at soft-delete column.
  bool get supportsSoftDelete => false;

  String get deletedAtColumn => 'deleted_at';

  SupabaseQueryBuilder get query => client.from(tableName);

  dynamic applySoftDeleteFilter(dynamic query, {required bool includeDeleted}) {
    if (!supportsSoftDelete || includeDeleted) return query;
    return query.isFilter(deletedAtColumn, null);
  }

  // ── Primary-table CRUD ───────────────────────────────────

  Future<List<T>> selectMany({
    String? select,
    Map<String, Object?> filters = const {},
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
    bool includeDeleted = false,
  }) => guard(() async {
    dynamic query = client.from(tableName).select(select ?? defaultSelect);
    query = applySoftDeleteFilter(query, includeDeleted: includeDeleted);

    if (filters.isNotEmpty) {
      for (final entry in filters.entries) {
        query = entry.value == null
            ? query.isFilter(entry.key, null)
            : query.eq(entry.key, entry.value);
      }
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

  Future<List<SyncIndexEntry>> selectSyncIndex({
    String idColumn = 'id',
    String updatedAtColumn = 'updated_at',
    dynamic Function(dynamic query)? applyQuery,
    required String action,
    bool includeDeleted = true,
  }) => guard(() async {
    dynamic query = client
        .from(tableName)
        .select('$idColumn, $updatedAtColumn');
    query = applySoftDeleteFilter(query, includeDeleted: includeDeleted);
    if (applyQuery != null) {
      query = applyQuery(query);
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response)
        .map(
          (row) => SyncIndexEntry(
            id: row[idColumn] as String,
            updatedAt: _dateTimeFromRow(row, updatedAtColumn),
          ),
        )
        .toList(growable: false);
  }, action: action);

  DateTime _dateTimeFromRow(Map<String, dynamic> row, String key) {
    final value = row[key];
    if (value is DateTime) return value;
    return DateTime.parse(value as String);
  }

  Future<List<T>> selectManyPaged({
    String? select,
    Map<String, Object?> filters = const {},
    String? orderBy,
    bool ascending = true,
    required int offset,
    required int pageSize,
    bool includeDeleted = false,
  }) => selectMany(
    select: select,
    filters: filters,
    orderBy: orderBy,
    ascending: ascending,
    limit: pageSize,
    offset: offset,
    includeDeleted: includeDeleted,
  );

  Future<int> count({
    Map<String, Object?> filters = const {},
    bool includeDeleted = false,
  }) => guard(() async {
    dynamic query = client.from(tableName).count(CountOption.exact);
    query = applySoftDeleteFilter(query, includeDeleted: includeDeleted);
    if (filters.isNotEmpty) {
      for (final entry in filters.entries) {
        query = entry.value == null
            ? query.isFilter(entry.key, null)
            : query.eq(entry.key, entry.value);
      }
    }
    return await query;
  }, action: 'count');

  Future<T?> selectOne({
    String? select,
    required Map<String, Object?> filters,
    bool includeDeleted = false,
  }) => guard(() async {
    dynamic query = client.from(tableName).select(select ?? defaultSelect);
    query = applySoftDeleteFilter(query, includeDeleted: includeDeleted);
    for (final entry in filters.entries) {
      query = entry.value == null
          ? query.isFilter(entry.key, null)
          : query.eq(entry.key, entry.value);
    }
    final row = await query.maybeSingle();
    return row == null ? null : fromMap(row);
  }, action: 'selectOne($filters)');

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

  Future<void> delete(Map<String, Object?> filters) => guard(() async {
    dynamic query = client.from(tableName).delete();
    for (final entry in filters.entries) {
      query = entry.value == null
          ? query.isFilter(entry.key, null)
          : query.eq(entry.key, entry.value);
    }
    await query;
  }, action: 'delete($filters)');
}
