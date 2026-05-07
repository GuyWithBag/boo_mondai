// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_service.dart
// PURPOSE: Abstract base for all Supabase services — shared client, guard, and generic CRUD
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:developer' as developer;
import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/exceptions/exceptions.barrel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Base class for domain-specific Supabase services.
///
/// Mirrors [HiveLocalDB]: subclasses declare [tableName] and [fromMap] once,
/// and all primary-table CRUD methods use them implicitly — no need to repeat
/// the table name or deserialiser on every call.
abstract class SupabaseRemoteDB<T> {
  SupabaseClient get client => Supabase.instance.client;

  /// The Supabase table this service operates on.
  String get tableName;

  /// Deserialises a raw DB row into [T].
  T Function(Map<String, dynamic>) get fromMap;

  /// Serialises [item] into a DB row map.
  Map<String, dynamic> toMap(T item);

  // ── Error, Logging & Crashlytics Wrapper ───────────────────

  /// Wraps DB calls to handle exceptions, log results locally,
  /// and silently report crashes to Firebase.
  Future<U> guard<U>(Future<U> Function() fn, {required String action}) async {
    developer.log('🚀 Starts: $action', name: 'SupabaseDB[$tableName]');

    try {
      final result = await fn();

      // Local Logging: Check for empty lists or nulls
      if (result == null) {
        developer.log(
          '⚠️ Result is NULL: $action',
          name: 'SupabaseDB[$tableName]',
        );
      } else if (result is List && result.isEmpty) {
        developer.log(
          '⚠️ Result is an EMPTY LIST: $action',
          name: 'SupabaseDB[$tableName]',
        );
      } else {
        final countStr = result is List
            ? ' (Returned ${result.length} items)'
            : '';
        developer.log(
          '✅ Success: $action$countStr',
          name: 'SupabaseDB[$tableName]',
        );
      }

      return result;
    } on AuthException catch (e) {
      developer.log(
        '❌ AuthException: ${e.message}',
        name: 'SupabaseDB[$tableName]',
        error: e,
      );

      // Send to Firebase Crashlytics silently
      // FirebaseCrashlytics.instance.recordError(
      //   e, stack,
      //   reason: 'Supabase Auth Error during $action in $tableName',
      //   fatal: false,
      // );

      throw AppException(e.message, code: e.statusCode);
    } on PostgrestException catch (e) {
      developer.log(
        '❌ PostgrestException: ${e.message}',
        name: 'SupabaseDB[$tableName]',
        error: e,
      );

      // Send to Firebase Crashlytics silently
      // FirebaseCrashlytics.instance.recordError(
      //   e, stack,
      //   reason: 'Supabase Database Error during $action in $tableName',
      //   fatal: false,
      // );

      throw AppException(e.message, code: e.code);
    } catch (e, stack) {
      developer.log(
        '❌ Unknown Exception: $e',
        name: 'SupabaseDB[$tableName]',
        error: e,
        stackTrace: stack,
      );

      // Catch unexpected app crashes (e.g., mapping errors, null pointers)
      // FirebaseCrashlytics.instance.recordError(
      //   e, stack,
      //   reason: 'Unknown Error during $action in $tableName',
      //   fatal: true,
      // );

      rethrow;
    }
  }

  // ── Primary-table CRUD ───────────────────────────────────

  Future<List<T>> selectMany({
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

    final response = await (orderBy != null
        ? query.order(orderBy, ascending: ascending)
        : query);
    return List<Map<String, dynamic>>.from(response).map(fromMap).toList();
  }, action: 'selectMany');

  Future<T?> selectById(String id) => guard(() async {
    final row = await client
        .from(tableName)
        .select()
        .eq('id', id)
        .maybeSingle();
    return row == null ? null : fromMap(row);
  }, action: 'selectById($id)');

  Future<T?> selectByUserId(String userId) => guard(() async {
    final row = await client
        .from(tableName)
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return row == null ? null : fromMap(row);
  }, action: 'selectByUserId($userId)');

  Future<List<T>> selectManyByUserId(String userId) => guard(() async {
    final row = await client.from(tableName).select().eq('user_id', userId);
    return List<Map<String, dynamic>>.from(row).map(fromMap).toList();
  }, action: 'selectManyByUserId($userId)');

  Future<List<T>> selectManyByCurrentUser() => guard(() async {
    final row = await client
        .from(tableName)
        .select()
        .eq('user_id', LocalDB.profile.getOrCreate().userId);
    return List<Map<String, dynamic>>.from(row).map(fromMap).toList();
  }, action: 'selectManyByUserCurrentUser()');

  Future<T> insertOne(T item) => guard(() async {
    final response = await client
        .from(tableName)
        .insert(toMap(item))
        .select()
        .single();
    return fromMap(response);
  }, action: 'insertOne');

  Future<void> updateById(String id, T item) => guard(
    () => client.from(tableName).update(toMap(item)).eq('id', id),
    action: 'updateById($id)',
  );

  Future<void> upsertOne(T item, {String? onConflict}) => guard(
    () => client.from(tableName).upsert(toMap(item), onConflict: onConflict),
    action: 'upsertOne',
  );

  Future<void> deleteById(String id) => guard(
    () => client.from(tableName).delete().eq('id', id),
    action: 'deleteById($id)',
  );
}
