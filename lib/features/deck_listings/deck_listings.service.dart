import 'package:boo_mondai/lib.barrel.dart'
    show
        DecksService,
        StoredMediaService,
        Deck,
        StringHelper,
        ListHelper,
        StoredMediaPathHelper,
        LocalDB,
        CardTemplate,
        DeckListing,
        VisibilityState,
        AuthService,
        SyncDeletionPolicy,
        ImageHelper;
import 'package:file_picker/file_picker.dart';

abstract final class DeckListingsService {
  static String? getFeaturedImages({required Deck deck, int index = 0}) {
    final listing = deck.listing;
    if (listing == null) return DecksService.getCoverImageUrl(deck);

    final remoteUrl = StringHelper.toTrimmedOrNull(
      ListHelper.getAtOrNull(listing.featuredImages, index),
    );

    return StoredMediaService.getFileByPath(
          StoredMediaPathHelper.deckListingFeaturedImage(
            deckTitle: deck.title,
            index: index,
          ),
        )?.path ??
        (remoteUrl == null
            ? null
            : StoredMediaService.getFileByRemoteUrl(remoteUrl)?.path) ??
        remoteUrl ??
        DecksService.getCoverImageUrl(deck);
  }

  static List<String> getCarouselImages(Deck deck) {
    final listingImages = deck.listing?.featuredImages ?? const <String>[];
    final resolved = <String>[];

    for (var index = 0; index < listingImages.length; index++) {
      final image = getFeaturedImages(deck: deck, index: index);
      if (image != null && !resolved.contains(image)) {
        resolved.add(image);
      }
    }

    final cover = DecksService.getCoverImageUrl(deck);
    if (cover != null && !resolved.contains(cover)) {
      resolved.add(cover);
    }

    return resolved;
  }

  static Future<DeckListing> createListing(Deck deck) async {
    final now = DateTime.now();
    final listing = DeckListing(
      deckId: deck.id,
      createdAt: now,
      updatedAt: now,
    );

    await LocalDB.deckListing.upsert(listing);

    return listing;
  }

  static Future<Deck> saveListing(Deck deck) async {
    await LocalDB.deck.upsert(deck);

    final listing = deck.listing;
    if (listing != null) {
      await LocalDB.deckListing.upsert(listing);
    }

    return deck;
  }

  static Future<Deck?> setPublished({
    required Deck deck,
    required bool isPublished,
  }) async {
    if (deck.isPublished == isPublished) {
      return null;
    }

    final now = DateTime.now();
    final listing = isPublished
        ? (deck.listing ??
                  DeckListing(deckId: deck.id, createdAt: now, updatedAt: now))
              .copyWith(updatedAt: now)
        : deck.listing;
    final updatedDeck = deck.copyWith(
      isPublished: isPublished,
      visibilityState: isPublished
          ? VisibilityState.public
          : VisibilityState.private,
      listing: listing,
      updatedAt: now,
    );

    await saveListing(updatedDeck);
    return updatedDeck;
  }

  static Future<Deck?> deleteListing(Deck deck) async {
    if (!deck.isEditable || deck.listing == null) {
      return null;
    }

    final now = DateTime.now();
    final purgeAfter = SyncDeletionPolicy.current().purgeAfter(now);
    final updatedDeck = deck.copyWith(
      isPublished: false,
      visibilityState: VisibilityState.private,
      listing: null,
      updatedAt: now,
    );

    if (AuthService.isAuthenticatedRemote) {
      await LocalDB.deckListing.upsert(
        deck.listing!.copyWith(
          updatedAt: now,
          deletedAt: now,
          purgeAfter: purgeAfter,
        ),
      );
    } else {
      await LocalDB.deckListing.deleteByPk({'deck_id': deck.id});
    }
    await LocalDB.deck.upsert(updatedDeck);

    return updatedDeck;
  }

  static Future<Deck?> updateListingFeaturedImage({
    required Deck deck,
    required int index,
    required PlatformFile file,
  }) async {
    if (!deck.isEditable || index < 0) {
      return null;
    }

    final now = DateTime.now();
    final listing =
        deck.listing ??
        DeckListing(deckId: deck.id, createdAt: now, updatedAt: now);
    final featuredImages = listing.featuredImages.toList();
    final targetIndex = index <= featuredImages.length
        ? index
        : featuredImages.length;

    final localPath = await StoredMediaService.storeFile(
      path: StoredMediaPathHelper.deckListingFeaturedImage(
        deckTitle: deck.title,
        index: targetIndex,
      ),
      file: file,
    );
    if (localPath == null) {
      return null;
    }

    if (targetIndex < featuredImages.length) {
      featuredImages[targetIndex] =
          ImageHelper.isRemoteUrl(featuredImages[targetIndex])
          ? featuredImages[targetIndex]
          : '';
    } else {
      featuredImages.add('');
    }

    final updatedListing = listing.copyWith(
      featuredImages: featuredImages,
      updatedAt: now,
    );
    final updatedDeck = deck.copyWith(listing: updatedListing, updatedAt: now);

    await LocalDB.deck.upsert(updatedDeck);
    await LocalDB.deckListing.upsert(updatedListing);
    return updatedDeck;
  }

  static Future<Deck?> addListingFeaturedCard({
    required Deck deck,
    required CardTemplate template,
  }) async {
    if (!deck.isEditable) {
      return null;
    }

    final now = DateTime.now();
    final listing =
        deck.listing ??
        DeckListing(deckId: deck.id, createdAt: now, updatedAt: now);
    final featuredCards = listing.featuredCards.toList();
    final hasTemplate = featuredCards.any((card) => card['id'] == template.id);
    if (hasTemplate) {
      return null;
    }

    final updatedListing = listing.copyWith(
      featuredCards: [...featuredCards, template.toMap()],
      updatedAt: now,
    );
    final updatedDeck = deck.copyWith(listing: updatedListing, updatedAt: now);

    await LocalDB.deck.upsert(updatedDeck);
    await LocalDB.deckListing.upsert(updatedListing);
    return updatedDeck;
  }
}
