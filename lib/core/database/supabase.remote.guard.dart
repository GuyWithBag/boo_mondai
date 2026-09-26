import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:boo_mondai/lib.barrel.dart' show AppException;
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseRemoteGuard {
  // ── Error, Logging & Crashlytics Wrapper ───────────────────

  /// Wraps DB calls to handle exceptions, log results locally,
  /// and silently report crashes to Firebase.
  static Future<U> guard<U>(
    Future<U> Function() fn, {
    required String action,
    required String tableName,
  }) async {
    _debugLog('Starts: $action', tableName: tableName);

    try {
      final result = await fn();
      _logResult(result, action, tableName: tableName);
      return result;
    } on AuthException catch (e) {
      _debugLog('AuthException: ${e.message}', error: e, tableName: tableName);

      // Send to Firebase Crashlytics silently
      // FirebaseCrashlytics.instance.recordError(
      //   e, stack,
      //   reason: 'Supabase Auth Error during $action in $tableName',
      //   fatal: false,
      // );

      throw AppException(e.message, code: e.statusCode);
    } on PostgrestException catch (e) {
      _debugLog(
        'PostgrestException: ${e.message}',
        error: e,
        tableName: tableName,
      );

      // Send to Firebase Crashlytics silently
      // FirebaseCrashlytics.instance.recordError(
      //   e, stack,
      //   reason: 'Supabase Database Error during $action in $tableName',
      //   fatal: false,
      // );

      throw AppException(e.message, code: e.code);
    } on SocketException catch (e, stack) {
      _debugLog(
        'SocketException: $e',
        error: e,
        stackTrace: stack,
        tableName: tableName,
      );
      throw AppException(
        'Unable to reach the server. Check your network connection and try again.',
        code: 'NETWORK_ERROR',
        originalError: e,
        stackTrace: stack,
      );
    } on TimeoutException catch (e, stack) {
      _debugLog(
        'TimeoutException: $e',
        error: e,
        stackTrace: stack,
        tableName: tableName,
      );
      throw AppException(
        'The request timed out. Please try again.',
        code: 'TIMEOUT',
        originalError: e,
        stackTrace: stack,
      );
    } catch (e, stack) {
      if (_isNetworkTransportError(e)) {
        _debugLog(
          'Network transport error: $e',
          error: e,
          stackTrace: stack,
          tableName: tableName,
        );
        throw AppException(
          'Unable to reach the server. Check your network connection and try again.',
          code: 'NETWORK_ERROR',
          originalError: e,
          stackTrace: stack,
        );
      }

      _debugLog(
        'Unknown Exception: $e',
        error: e,
        stackTrace: stack,
        tableName: tableName,
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

  static bool _isNetworkTransportError(Object e) {
    final typeName = e.runtimeType.toString();
    final message = e.toString();
    return typeName == 'ClientException' ||
        message.contains('ClientException') ||
        message.contains('Failed host lookup') ||
        message.contains('SocketException');
  }

  static void _debugLog(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    required String tableName,
  }) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: 'SupabaseDB[$tableName]',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void _logResult<U>(
    U result,
    String action, {
    required String tableName,
  }) {
    if (result == null) {
      _debugLog('Result is NULL: $action', tableName: tableName);
    } else if (result is List && result.isEmpty) {
      _debugLog('Result is an EMPTY LIST: $action', tableName: tableName);
    } else {
      final countStr = result is List
          ? ' (Returned ${result.length} items)'
          : '';
      _debugLog('Success: $action$countStr', tableName: tableName);
    }
  }
}
