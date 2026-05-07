// Add this new specific exception:
import 'package:boo_mondai/exceptions/exceptions.barrel.dart';

class SessionException extends AppException {
  const SessionException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
