import 'dart:io';

import 'package:boo_mondai/lib.barrel.dart'
    show
        CachedProfile,
        Deck,
        DeckListing,
        LocalDB,
        LocalImageCacheKeysHelper,
        Profile;

abstract final class LocalImageResolverHelper {
  static String? resolveProfileAvatar(Profile profile) {
    return _existingLocalPath(
          LocalImageCacheKeysHelper.profileAvatar(profile.id),
        ) ??
        _nonEmpty(profile.avatarUrl);
  }

  static String? resolveCachedProfileAvatar(CachedProfile profile) {
    return _existingLocalPath(
          LocalImageCacheKeysHelper.profileAvatar(profile.id),
        ) ??
        _nonEmpty(profile.avatarUrl);
  }

  static String? resolveDeckCover(Deck deck) {
    return _existingLocalPath(LocalImageCacheKeysHelper.deckCover(deck.id)) ??
        _nonEmpty(deck.coverImageUrl);
  }

  static String? resolveDeckListingFeaturedImage({
    required Deck deck,
    int index = 0,
  }) {
    final listing = deck.listing;
    if (listing == null) return resolveDeckCover(deck);

    return _existingLocalPath(
          LocalImageCacheKeysHelper.deckListingFeaturedImage(deck.id, index),
        ) ??
        _featuredImageAt(listing, index) ??
        resolveDeckCover(deck);
  }

  static List<String> resolveDeckListingCarouselImages(Deck deck) {
    final listingImages = deck.listing?.featuredImages ?? const <String>[];
    final resolved = <String>[];

    for (var index = 0; index < listingImages.length; index++) {
      final image = resolveDeckListingFeaturedImage(deck: deck, index: index);
      if (image != null && !resolved.contains(image)) {
        resolved.add(image);
      }
    }

    final cover = resolveDeckCover(deck);
    if (cover != null && !resolved.contains(cover)) {
      resolved.add(cover);
    }

    return resolved;
  }

  static String? _existingLocalPath(String cacheKey) {
    final entry = LocalDB.localImage.selectByPk({'cache_key': cacheKey});
    final localPath = entry?.localPath;
    if (localPath == null || localPath.trim().isEmpty) return null;
    return File(localPath).existsSync() ? localPath : null;
  }

  static String? _featuredImageAt(DeckListing listing, int index) {
    if (index < 0 || index >= listing.featuredImages.length) return null;
    return _nonEmpty(listing.featuredImages[index]);
  }

  static String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
