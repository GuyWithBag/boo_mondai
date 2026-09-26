import 'dart:developer' as developer;

import 'package:boo_mondai/lib.barrel.dart' show HiveException;
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

abstract class HiveLocalGuard {
  static Future<U> guard<U>(
    Future<U> Function() fn, {
    required String action,
    required String boxName,
  }) async {
    _debugLog('Starts: $action', boxName: boxName);
    try {
      final result = await fn();
      _logResult(result, action, boxName: boxName);
      return result;
    } on HiveError catch (e) {
      _debugLog('HiveError: ${e.message}', error: e, boxName: boxName);
      throw HiveException(e.message, code: 'HIVE_ERROR', originalError: e);
    } catch (e, stack) {
      _debugLog(
        'Unknown Exception: $e',
        error: e,
        stackTrace: stack,
        boxName: boxName,
      );
      rethrow;
    }
  }

  /// Wraps synchronous Hive calls to handle exceptions and log results locally.
  static U guardSync<U>(
    U Function() fn, {
    required String action,
    required String boxName,
  }) {
    _debugLog('Starts: $action', boxName: boxName);
    try {
      final result = fn();
      _logResult(result, action, boxName: boxName);
      return result;
    } on HiveError catch (e) {
      _debugLog('HiveError: ${e.message}', error: e, boxName: boxName);
      throw HiveException(e.message, code: 'HIVE_ERROR', originalError: e);
    } catch (e, stack) {
      _debugLog(
        'Unknown Exception: $e',
        error: e,
        stackTrace: stack,
        boxName: boxName,
      );
      rethrow;
    }
  }

  static void _debugLog(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    required String boxName,
  }) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: 'HiveLocalDB[$boxName]',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void _logResult<U>(
    U result,
    String action, {
    required String boxName,
  }) {
    if (result == null) {
      _debugLog('Result is NULL: $action', boxName: boxName);
    } else if (result is List && result.isEmpty) {
      _debugLog('Result is an EMPTY LIST: $action', boxName: boxName);
    } else {
      final countStr = result is List
          ? ' (Returned ${result.length} items)'
          : '';
      _debugLog('Success: $action$countStr', boxName: boxName);
    }
  }
}
