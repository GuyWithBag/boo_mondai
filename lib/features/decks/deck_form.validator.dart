abstract final class DeckFormValidator {
  static String? title(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a deck title';
    }
    return null;
  }

  static String? optionalText(String? value) => null;

  static String? tags(List<String>? tags) {
    if (tags?.any((tag) => tag.trim().isEmpty) ?? false) {
      return 'Tags cannot be empty';
    }
    return null;
  }

  static String? optionalImage(String? value) => null;

  static String? featuredImages(List<String>? images) {
    if (images == null || images.isEmpty) {
      return 'Add at least one featured image';
    }
    if (images.length > 5) {
      return 'Use no more than 5 featured images';
    }
    return null;
  }

  static String? featuredCards(List<Map<String, dynamic>>? cards) {
    if (cards == null || cards.isEmpty) {
      return 'Add at least one featured card';
    }
    if (cards.length > 3) {
      return 'Use no more than 3 featured cards';
    }
    return null;
  }
}
