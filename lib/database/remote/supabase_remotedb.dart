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
/// Mirrors [HiveLocalDB]: subclasses declare [tableName] and [fromMap] once,
/// and all primary-table CRUD methods use them implicitly — no need to repeat
/// the table name or deserialiser on every call.
///
/// For secondary-table operations (e.g. inserting into a child table),
/// use the explicit-table helpers [insertRow] and [insertMany].
abstract class SupabaseRemoteDB<T> {
  SupabaseClient get client => Supabase.instance.client;

  /// The Supabase table this service operates on.
  String get tableName;

  /// Deserialises a raw DB row into [T].
  T Function(Map<String, dynamic>) get fromMap;

  /// Serialises [item] into a DB row map.
  Map<String, dynamic> toMap(T item);

  // ── Error wrapper ────────────────────────────────────────

  Future<U> guard<U>(Future<U> Function() fn) async {
    try {
      return await fn();
    } on AuthException catch (e) {
      throw AppException(e.message, code: e.statusCode);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  // ── Primary-table CRUD ───────────────────────────────────

  Future<List<T>> fetchAll({
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = false,
  }) => guard(() async {
    var query = client.from(tableName).select();
    if (filters != null) {
      for (final entry in filters.entries) {
        query = query.eq(entry.key, entry.value);
      }
    }
    if (orderBy != null) {
      final response = await query.order(orderBy, ascending: ascending);
      return List<Map<String, dynamic>>.from(response).map(fromMap).toList();
    }
    return List<Map<String, dynamic>>.from(await query).map(fromMap).toList();
  });

  Future<T?> fetchById(String id) => guard(() async {
    final row = await client
        .from(tableName)
        .select()
        .eq('id', id)
        .maybeSingle();
    return row == null ? null : fromMap(row);
  });

  Future<T> insertOne(T item) => guard(() async {
    final response = await client
        .from(tableName)
        .insert(toMap(item))
        .select()
        .single();
    return fromMap(response);
  });

  Future<void> updateById(String id, T item) =>
      guard(() => client.from(tableName).update(toMap(item)).eq('id', id));

  Future<void> upsertOne(T item, {String? onConflict}) => guard(
    () => client.from(tableName).upsert(toMap(item), onConflict: onConflict),
  );

  Future<void> deleteById(String id) =>
      guard(() => client.from(tableName).delete().eq('id', id));
}
