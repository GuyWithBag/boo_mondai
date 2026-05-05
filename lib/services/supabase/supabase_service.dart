// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_service.dart
// PURPOSE: Abstract base for all Supabase services — shared client, guard, and generic CRUD
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:boo_mondai/services/app_exception.dart';

/// Base class for domain-specific Supabase services.
///
/// Provides the shared [client] accessor, a [guard] helper that converts
/// Supabase exceptions into [AppException], and a full set of generic CRUD
/// operations parameterised by table name.
///
/// Domain services only need to add methods with bespoke query logic
/// (joins, custom filters, snake↔camel remapping, etc.). Anything that
/// is a plain insert / update / upsert / delete / select can delegate
/// to one of the helpers below.
abstract class SupabaseService {
  SupabaseClient get client => Supabase.instance.client;

  // ── Error wrapper ────────────────────────────────────────

  /// Runs [fn] and converts [PostgrestException] / [AuthException] into
  /// [AppException] so every caller gets a consistent error type.
  Future<T> guard<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on AuthException catch (e) {
      throw AppException(e.message, code: e.statusCode);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  // ── Generic CRUD ─────────────────────────────────────────

  /// Fetches all rows from [table].
  ///
  /// Pass [filters] for simple equality conditions (AND-ed together).
  /// Pass [orderBy] + [ascending] to control ordering.
  Future<List<Map<String, dynamic>>> fetchAll(
    String table, {
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = false,
  }) => guard(() async {
    var query = client.from(table).select();
    if (filters != null) {
      for (final entry in filters.entries) {
        query = query.eq(entry.key, entry.value);
      }
    }
    if (orderBy != null) {
      final response = await query.order(orderBy, ascending: ascending);
      return List<Map<String, dynamic>>.from(response);
    }
    return List<Map<String, dynamic>>.from(await query);
  });

  /// Fetches a single row by its primary key [id], returning null if absent.
  Future<Map<String, dynamic>?> fetchById(String table, String id) =>
      guard(() => client.from(table).select().eq('id', id).maybeSingle());

  /// Inserts one row and returns the persisted record (with server defaults).
  Future<Map<String, dynamic>> insertOne(
    String table,
    Map<String, dynamic> data,
  ) => guard(() => client.from(table).insert(data).select().single());

  /// Inserts one row without returning the record.
  Future<void> insertRow(String table, Map<String, dynamic> data) =>
      guard(() => client.from(table).insert(data));

  /// Batch-inserts multiple rows. No-op when [rows] is empty.
  Future<void> insertMany(String table, List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) return Future.value();
    return guard(() => client.from(table).insert(rows));
  }

  /// Updates the row identified by [id] in [table] with [data].
  Future<void> updateById(String table, String id, Map<String, dynamic> data) =>
      guard(() => client.from(table).update(data).eq('id', id));

  /// Upserts a row. Supply [onConflict] to target a specific conflict column.
  Future<void> upsertRow(
    String table,
    Map<String, dynamic> data, {
    String? onConflict,
  }) => guard(() => client.from(table).upsert(data, onConflict: onConflict));

  /// Deletes the row identified by [id] from [table].
  Future<void> deleteById(String table, String id) =>
      guard(() => client.from(table).delete().eq('id', id));
}
