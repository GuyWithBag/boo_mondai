import 'dart:io';

import 'package:boo_mondai/core/database/supabase.remote.db.dart';
import 'package:boo_mondai/core/exceptions/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestRemoteDb extends SupabaseRemoteDB<Object> {
  @override
  String get tableName => 'test_table';

  @override
  Object Function(Map<String, dynamic>) get fromMap =>
      (_) => Object();

  @override
  Map<String, dynamic> toMap(Object item) => const {};

  @override
  Map<String, Object?> primaryKeyFromItem(Object item) => const {};
}

class _FakeClientException {
  @override
  String toString() =>
      'ClientException with SocketException: Failed host lookup';
}

void main() {
  group('SupabaseRemoteDB.guard', () {
    test('maps socket failures to AppException', () async {
      final db = _TestRemoteDb();

      final future = db.guard(
        () => throw const SocketException('Failed host lookup'),
        action: 'selectMany',
      );

      await expectLater(
        future,
        throwsA(
          isA<AppException>()
              .having((e) => e.code, 'code', 'NETWORK_ERROR')
              .having(
                (e) => e.message,
                'message',
                'Unable to reach the server. Check your network connection and try again.',
              ),
        ),
      );
    });

    test('maps HTTP client failures to AppException', () async {
      final db = _TestRemoteDb();

      final future = db.guard(
        () => throw _FakeClientException(),
        action: 'selectMany',
      );

      await expectLater(
        future,
        throwsA(
          isA<AppException>().having((e) => e.code, 'code', 'NETWORK_ERROR'),
        ),
      );
    });
  });
}
