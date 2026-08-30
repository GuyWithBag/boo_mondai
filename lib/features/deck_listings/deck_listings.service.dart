import 'dart:io';

import 'package:boo_mondai/lib.barrel.dart'
    show
        DecksService,
        Deck,
        StringHelper,
        ListHelper,
        DecksDirectoryPaths,
        LocalDB,
        CardTemplate,
        DeckListing,
        VisibilityState,
        AuthService,
        SyncDeletionPolicy,
        ImageHelper,
        RemoteDB,
        FileSystemHandler;
import 'package:file_picker/file_picker.dart';

abstract final class DeckListingsService {
  static String getFeaturedImage({required Deck deck, int index = 0}) {
    final listing = deck.listing;
    if (listing == null && index == 0) {
      return DecksDirectoryPaths.coverImage(deckTitle: deck.title);
    }

    return DecksDirectoryPaths.listingFeaturedImage(
      deckTitle: deck.title,
      index: index,
    );
  }

  static List<String> getFeaturedImages(Deck deck) {
    var images = <String>[];

    // ToDo: Add error handling for null listing
    for (var index = 0; index < deck.listing!.featuredImages.length; index++) {
      final image = getFeaturedImage(deck: deck, index: index);
      images = [...images, image];
    }

    return images;
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

  static Future<void> setFeaturedImageByFile({
    required Deck deck,
    required int index,
    required PlatformFile file,
  }) async {
    if (!deck.isEditable) {
      return;
    }
    if (!deck.isEditable) {
      return;
    }

    final path = DecksDirectoryPaths.listingFeaturedImage(
      deckTitle: deck.title,
      index: index,
    );
    final deckListing = deck.listing!;

    final absolutePath = await FileSystemHandler.getAbsolutePath(path);
    final file = File(absolutePath);
    final bytes = await file.readAsBytes();
    file.writeAsBytes(bytes);

    final remoteUrl = await RemoteDB.publicBucket.uploadBytes(path, bytes);

    final feauturedImages = deckListing.featuredImages.toList();
    feauturedImages[index] = remoteUrl;

    final updatedDeckListing = deckListing.copyWith(
      featuredImages: feauturedImages,
      updatedAt: DateTime.now(),
    );

    await LocalDB.deckListing.upsert(updatedDeckListing);
  }

  static Future<void> setFeaturedImagesByFile({
    required Deck deck,
    required List<PlatformFile> files,
  }) async {
    if (!deck.isEditable) {
      return;
    }

    final paths = DecksDirectoryPaths.listingFeaturedImages(
      deckTitle: deck.title,
    );
    final deckListing = deck.listing!;

    // ToDo: Add error handling
    for (int i = 0; i < deck.listing!.featuredImages.length; i++) {
      final path = paths[i];

      final absolutePath = await FileSystemHandler.getAbsolutePath(path);
      final file = File(absolutePath);
      final bytes = await file.readAsBytes();
      file.writeAsBytes(bytes);

      final remoteUrl = await RemoteDB.publicBucket.uploadBytes(path, bytes);

      final updatedDeckListing = deckListing.copyWith(
        featuredImages: [...deckListing.featuredImages, remoteUrl],
        updatedAt: DateTime.now(),
      );

      await LocalDB.deckListing.upsert(updatedDeckListing);
    }
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
