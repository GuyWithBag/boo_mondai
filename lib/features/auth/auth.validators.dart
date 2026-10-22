abstract final class AuthValidators {
  static String? displayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a display name';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || !value.trim().contains('@')) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
