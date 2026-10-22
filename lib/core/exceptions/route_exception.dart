// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/app_exception.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/exceptions/app_exception.dart'
    show AppException;

class RouteException extends AppException {
  const RouteException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
