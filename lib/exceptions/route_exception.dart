// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/app_exception.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/exceptions/exceptions.barrel.dart';

class RouteException extends AppException {
  const RouteException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
