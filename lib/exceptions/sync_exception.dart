// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/app_exception.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/exceptions/exceptions.barrel.dart';

class SyncException extends AppException {
  const SyncException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
