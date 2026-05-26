// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/exceptions/hive_exception.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/exceptions/app_exception.dart'
    show AppException;

class HiveException extends AppException {
  const HiveException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
