// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/app_exception.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class AppException implements Exception {
  final String message;
  final String? code;
  final Object?
  originalError; // <-- NEW: Holds the raw exception (e.g., Supabase error)
  final StackTrace? stackTrace; // <-- NEW: Holds the exact line where it failed

  const AppException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    var output =
        'AppException: $message${code != null ? ' (code: $code)' : ''}';
    if (originalError != null) {
      output += '\nCaused by: $originalError';
    }
    return output;
  }
}
