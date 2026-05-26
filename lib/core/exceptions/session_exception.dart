// Add this new specific exception:

import 'package:boo_mondai/core/exceptions/app_exception.dart'
    show AppException;

class SessionException extends AppException {
  const SessionException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
