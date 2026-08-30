// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/database/bucket_supabase.remote.db.dart
// PURPOSE: Abstract Supabase Storage bucket repository
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:boo_mondai/core/exceptions/app_exception.dart'
    show AppException;
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Base class for Supabase Storage bucket repositories.
///
/// Storage buckets are not Postgres tables, so this intentionally does not
/// extend [SupabaseRemoteDB]. Subclasses own bucket identity and public/private
/// URL behavior.
abstract class BucketSupabaseRemoteDB {
  SupabaseClient get client => Supabase.instance.client;

  /// Supabase Storage bucket name.
  String get name;

  /// Whether files in this bucket are expected to be publicly readable.
  bool get isPublic;

  // ── Error, Logging & Crashlytics Wrapper ───────────────────

  Future<T> guard<T>(Future<T> Function() fn, {required String action}) async {
    _debugLog('Starts: $action');

    try {
      final result = await fn();
      _logResult(result, action);
      return result;
    } on StorageException catch (e) {
      _debugLog('StorageException: ${e.message}', error: e);
      throw AppException(e.message, code: e.statusCode);
    } on AuthException catch (e) {
      _debugLog('AuthException: ${e.message}', error: e);
      throw AppException(e.message, code: e.statusCode);
    } on SocketException catch (e, stack) {
      _debugLog('SocketException: $e', error: e, stackTrace: stack);
      throw AppException(
        'Unable to reach the server. Check your network connection and try again.',
        code: 'NETWORK_ERROR',
        originalError: e,
        stackTrace: stack,
      );
    } on TimeoutException catch (e, stack) {
      _debugLog('TimeoutException: $e', error: e, stackTrace: stack);
      throw AppException(
        'The request timed out. Please try again.',
        code: 'TIMEOUT',
        originalError: e,
        stackTrace: stack,
      );
    } catch (e, stack) {
      if (_isNetworkTransportError(e)) {
        _debugLog('Network transport error: $e', error: e, stackTrace: stack);
        throw AppException(
          'Unable to reach the server. Check your network connection and try again.',
          code: 'NETWORK_ERROR',
          originalError: e,
          stackTrace: stack,
        );
      }

      _debugLog('Unknown Exception: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }

  void _debugLog(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: 'SupabaseBucket[$name]',
      error: error,
      stackTrace: stackTrace,
    );
  }

  void _logResult<T>(T result, String action) {
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

  bool _isNetworkTransportError(Object e) {
    final typeName = e.runtimeType.toString();
    final message = e.toString();
    return typeName == 'ClientException' ||
        message.contains('ClientException') ||
        message.contains('Failed host lookup') ||
        message.contains('SocketException');
  }

  Future<String> uploadBytes(
    String path,
    Uint8List bytes, {
    String? contentType,
    bool upsert = false,
  }) => guard(() async {
    await client.storage
        .from(name)
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: contentType, upsert: upsert),
        );
    return client.storage.from(name).getPublicUrl(path);
  }, action: 'uploadBytes($path, ${bytes.length} bytes)');

  Future<void> deleteFile(String path) => deleteFiles([path]);

  Future<void> deleteFiles(List<String> paths) => guard(() async {
    if (paths.isEmpty) return;
    await client.storage.from(name).remove(paths);
  }, action: 'deleteFiles(${paths.length} files)');
}
