abstract final class LocalImageCacheKeysHelper {
  static String profileAvatar(String profileId) => 'profile:$profileId:avatar';

  static String deckCover(String deckId) => 'deck:$deckId:cover';

  static String deckListingFeaturedImage(String deckId, int index) =>
      'deck_listing:$deckId:featured:$index';
}
