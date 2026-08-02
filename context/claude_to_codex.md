I want to make sure, have u read the [@20260505020000_init_v2.sql](file:///run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/supabase/migrations/20260505020000_init_v2.sql) ?

4. yes that's the purpose. This may be a capstone but I'm planning to release this as a full app.
<context ref="file:///run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/supabase/migrations/20260505020000_init_v2.sql">
# First 1KB of /run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/supabase/migrations/20260505020000_init_v2.sql (file too large to show full content, and no outline available)

-- ══════════════════════════════════════════════════════
-- BooMondai — Schema V2 (Ultimate Edition)
-- Includes: Core Schema, FSRS, Research Tables,
-- Design Tokens, and the "Storefront" (Deck Listings)
-- ══════════════════════════════════════════════════════

-- ── Extensions ────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS moddatetime SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ══════════════════════════════════════════════════════
-- 1. ENUMS
-- ═════════════════════════════════════
</context>2. it should have created_at
3. fuckkkk, really? it should reference the profiles.id
4. yeahhh ill address it later in this prompt
5. fix thtat

so addressing 4.
Ok so I have a problem with the current [@hive_localdb.dart](file:///run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/lib/database/local/hive_localdb.dart) and [@supabase_remotedb.dart](file:///run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/lib/database/remote/supabase_remotedb.dart) 

when I was designing the database, I thought that all tables all had to have a primary key that is the Id, but I didn't know the existence of composite keyes, and maybe there's other designs. For both databases, you should be able to define a primary key, which can also be composite keys

criticize me more and tell me what more I can and should add. Please ask questions
<context ref="file:///run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/lib/database/local/hive_localdb.dart">
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

</context>
<context ref="file:///run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/lib/database/remote/supabase_remotedb.dart">
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
  String get tableName => throw UnimplementedError();

  /// Deserialises a raw DB row into [T].
  T Function(Map<String, dynamic>) get fromMap => throw UnimplementedError();

  /// Serialises [item] into a DB row map.
  Map<String, dynamic> toMap(T item) => throw UnimplementedError();

  String get primaryKey => 'id';

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

  Future<T?> selectByPk(String pk) => guard(() async {
    final row = await client
        .from(tableName)
        .select()
        .eq(primaryKey, pk)
        .maybeSingle();
    return row == null ? null : fromMap(row);
  }, action: 'selectByPk($pk)');

  Future<T?> selectByUserId(String profileId) => guard(() async {
    final row = await client
        .from(tableName)
        .select()
        .eq('profile_id', profileId)
        .maybeSingle();
    return row == null ? null : fromMap(row);
  }, action: 'selectByUserId($profileId)');

  Future<List<T>> selectManyByUserId(String profileId) => guard(() async {
    final row = await client.from(tableName).select().eq('profile_id', profileId);
    return List<Map<String, dynamic>>.from(row).map(fromMap).toList();
  }, action: 'selectManyByUserId($profileId)');

  Future<List<T>> selectManyByCurrentUser() => guard(() async {
    final row = await client
        .from(tableName)
        .select()
        .eq('user_id', LocalDB.profile.getOrCreate().profileId);
    return List<Map<String, dynamic>>.from(row).map(fromMap).toList();
  }, action: 'selectManyByUserCurrentUser()');

  Future<T> insert(T item) => guard(() async {
    final response = await client
        .from(tableName)
        .insert(toMap(item))
        .select()
        .single();
    return fromMap(response);
  }, action: 'insert');

  Future<void> updateByPk(String pk, T item) => guard(
    () => client.from(tableName).update(toMap(item)).eq(primaryKey, pk),
    action: 'updateByPk($pk)',
  );

  Future<void> upsertByPk(String pk, T item, {String? onConflict}) => guard(
    () => client
        .from(tableName)
        .upsert(toMap(item), onConflict: onConflict)
        .eq(primaryKey, pk),
    action: 'upsert',
  );

  Future<void> deleteByPk(String pk) => guard(
    () => client.from(tableName).delete().eq(primaryKey, pk),
    action: 'deleteByPk($pk)',
  );
}

</context>


I want to make sure, have u read the [@20260505020000_init_v2.sql](file:///run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/supabase/migrations/20260505020000_init_v2.sql) ?

4. yes that's the purpose. This may be a capstone but I'm planning to release this as a full app.
<context ref="file:///run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/supabase/migrations/20260505020000_init_v2.sql">
# First 1KB of /run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/supabase/migrations/20260505020000_init_v2.sql (file too large to show full content, and no outline available)

-- ══════════════════════════════════════════════════════
-- BooMondai — Schema V2 (Ultimate Edition)
-- Includes: Core Schema, FSRS, Research Tables,
-- Design Tokens, and the "Storefront" (Deck Listings)
-- ══════════════════════════════════════════════════════

-- ── Extensions ────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS moddatetime SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ══════════════════════════════════════════════════════
-- 1. ENUMS
-- ═════════════════════════════════════
</context>2. it should have created_at
3. fuckkkk, really? it should reference the profiles.id
4. yeahhh ill address it later in this prompt
5. fix thtat

so addressing 4.
Ok so I have a problem with the current [@hive_localdb.dart](file:///run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/lib/database/local/hive_localdb.dart) and [@supabase_remotedb.dart](file:///run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/lib/database/remote/supabase_remotedb.dart) 

when I was designing the database, I thought that all tables all had to have a primary key that is the Id, but I didn't know the existence of composite keyes, and maybe there's other designs. For both databases, you should be able to define a primary key, which can also be composite keys

criticize me more and tell me what more I can and should add. Please ask questions
<context ref="file:///run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/lib/database/local/hive_localdb.dart">
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

</context>
<context ref="file:///run/media/loejee/loejee-500-gb/Transfer-from-old-SSD-08-08-25/Others/github-repositories/boo_mondai/lib/database/remote/supabase_remotedb.dart">
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
  String get tableName => throw UnimplementedError();

  /// Deserialises a raw DB row into [T].
  T Function(Map<String, dynamic>) get fromMap => throw UnimplementedError();

  /// Serialises [item] into a DB row map.
  Map<String, dynamic> toMap(T item) => throw UnimplementedError();

  String get primaryKey => 'id';

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

  Future<T?> selectByPk(String pk) => guard(() async {
    final row = await client
        .from(tableName)
        .select()
        .eq(primaryKey, pk)
        .maybeSingle();
    return row == null ? null : fromMap(row);
  }, action: 'selectByPk($pk)');

  Future<T?> selectByUserId(String profileId) => guard(() async {
    final row = await client
        .from(tableName)
        .select()
        .eq('profile_id', profileId)
        .maybeSingle();
    return row == null ? null : fromMap(row);
  }, action: 'selectByUserId($profileId)');

  Future<List<T>> selectManyByUserId(String profileId) => guard(() async {
    final row = await client.from(tableName).select().eq('profile_id', profileId);
    return List<Map<String, dynamic>>.from(row).map(fromMap).toList();
  }, action: 'selectManyByUserId($profileId)');

  Future<List<T>> selectManyByCurrentUser() => guard(() async {
    final row = await client
        .from(tableName)
        .select()
        .eq('user_id', LocalDB.profile.getOrCreate().profileId);
    return List<Map<String, dynamic>>.from(row).map(fromMap).toList();
  }, action: 'selectManyByUserCurrentUser()');

  Future<T> insert(T item) => guard(() async {
    final response = await client
        .from(tableName)
        .insert(toMap(item))
        .select()
        .single();
    return fromMap(response);
  }, action: 'insert');

  Future<void> updateByPk(String pk, T item) => guard(
    () => client.from(tableName).update(toMap(item)).eq(primaryKey, pk),
    action: 'updateByPk($pk)',
  );

  Future<void> upsertByPk(String pk, T item, {String? onConflict}) => guard(
    () => client
        .from(tableName)
        .upsert(toMap(item), onConflict: onConflict)
        .eq(primaryKey, pk),
    action: 'upsert',
  );

  Future<void> deleteByPk(String pk) => guard(
    () => client.from(tableName).delete().eq(primaryKey, pk),
    action: 'deleteByPk($pk)',
  );
}

</context>

Critique of the base classes

### `SupabaseRemoteDB` — 4 real issues

**1. `upsertByPk` is broken**

```dart
Future<void> upsertByPk(String pk, T item, {String? onConflict}) => guard(
  () => client
      .from(tableName)
      .upsert(toMap(item), onConflict: onConflict)
      .eq(primaryKey, pk),  // ← this does nothing
```

`.upsert()` resolves conflicts via the `onConflict` column list, not via a filter. The `.eq()` after it is a no-op — `upsert` doesn't take a WHERE clause. The row that gets upserted is determined entirely by the conflict target in `onConflict`. Remove the `.eq()`.

**2. `selectManyByCurrentUser` is a layer violation**

```dart
.eq('user_id', LocalDB.profile.getOrCreate().profileId);
```

The remote DB class is reaching into the local DB to get the current user ID. The remote layer shouldn't depend on the local layer at all — that's a circular dependency and it makes unit testing impossible (you'd need a real Hive box just to call a remote method). The user ID should be passed in by the caller, or read from `Supabase.instance.client.auth.currentUser?.id`.

**3. `tableName`, `fromMap`, `toMap` should be `abstract`, not `throw UnimplementedError()`**

Right now a subclass that forgets to implement `fromMap` compiles fine and crashes at runtime. Make them `abstract` — it becomes a compile error:
```dart
abstract String get tableName;
abstract T Function(Map<String, dynamic>) get fromMap;
abstract Map<String, dynamic> toMap(T item);
```

**4. No pagination on `selectMany`**

When the public deck browser has thousands of decks, `.select()` with no limit fetches all of them. You need `range(from, to)` support before this ships.

---

### `HiveLocalDB` — 2 real issues

**1. `getAllById` is misleading and O(n)**

```dart
List<T> getAllById(String id) => guardSync(
  () => box.values.where((T item) => getId(item) == id).toList(),
```

`getId` is also what `put` uses as the Hive key. So a Hive box can never have two items with the same key — this method can return at most 1 result. It's functionally identical to `[getById(id)].whereNotNull()`. What you actually want is a **secondary index lookup** — e.g. "all `DeckTag` rows where `deckId == X`". That requires a different method signature: `getAllWhere(bool Function(T) test)`, and the caller provides the predicate. The O(n) scan is unavoidable in Hive without a secondary index box, but at least name it honestly.

**2. No reactive stream (`watch`)**

This is the biggest missing piece for a local-first app. Hive supports `box.watch(key: key)` which returns a `Stream<BoxEvent>`. Without this, your providers have no way to know when another part of the app writes to Hive — they have to re-fetch manually. Exposing `Stream<BoxEvent> watch([String? key])` from the base class lets providers subscribe to changes and call `notifyListeners()` automatically.

---

## Questions before I touch the composite key redesign

**Q1 — API style for composite PKs on `SupabaseRemoteDB`:**

Option A — unified API, `Map` everywhere:
```dart
// All subclasses, even single-key ones, use Map:
Future<T?> selectByPk(Map<String, dynamic> pk)
// Single-key call site: selectByPk({'id': deckId})
// Composite call site:  selectByPk({'deck_id': deckId, 'tag_id': tagId})
```

Option B — keep `String` for single-key, add `Map` variant for composite only:
```dart
Future<T?> selectByPk(String pk)          // existing, unchanged
Future<T?> selectByPkMap(Map<String, dynamic> pk)  // new, for composites
```

Option A is cleaner long-term. Option B is less breaking. Which do you prefer?

**Q2 — `HiveLocalDB` and composite keys:**

For Hive, composite keys already work today — `DeckTag.compositeId` returns `'${deckId}_${tagId}'` which is the string key. The base class doesn't need to change for writes. The gap is reads: do you ever need to query Hive by one part of a composite key? E.g., "give me all `DeckTag` rows where `deckId == X`". If yes, is O(n) scan acceptable (small data) or do you need a secondary index box?

Q1
Why not just make the primaryKey
List<String> get primaryKey => ['id'];
Or maybe its a bad idea?

Q2
I just want it to be consistent in syntax with the supabase

Q3
yes pagination

## Consistency
also update hive to use the same naming with the supabase db for functions and variables

Also select functions should have an optional argument for the .select arguments
