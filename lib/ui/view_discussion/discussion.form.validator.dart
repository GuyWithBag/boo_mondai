abstract final class DiscussionFormValidator {
  static String? title(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a review title';
    }
    return null;
  }

  static String? body(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a message';
    }
    return null;
  }

  static String? vote(int? value) {
    if (value != 1 && value != -1) {
      return 'Choose a positive or negative vote';
    }
    return null;
  }
}
