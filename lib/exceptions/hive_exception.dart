// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/exceptions/hive_exception.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/exceptions/exceptions.barrel.dart';

class HiveException extends AppException {
  const HiveException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
