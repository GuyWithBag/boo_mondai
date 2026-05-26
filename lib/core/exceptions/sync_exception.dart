// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/app_exception.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/exceptions/app_exception.dart'
    show AppException;

class SyncException extends AppException {
  const SyncException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
