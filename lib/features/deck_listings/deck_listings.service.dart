import 'dart:io' hide ContentType;

import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        DecksDirectoryPaths,
        LocalDB,
        CardTemplate,
        DeckListing,
        VisibilityState,
        AuthService,
        SyncDeletionPolicy,
        RemoteDB,
        FileSystemHandler,
        Content,
        uuid,
        ContentType;
import 'package:file_picker/file_picker.dart';

abstract final class DeckListingsService {
  static String getFeaturedImage({
    required Deck deck,
    required DeckListing listing,
    int index = 0,
  }) {
    return DecksDirectoryPaths.listingFeaturedImage(
      deckTitle: deck.title,
      index: index,
    );
  }

  static List<String> getFeaturedImages({
    required Deck deck,
    required DeckListing listing,
  }) {
    var images = <String>[];

    // ToDo: Add error handling for null listing
    for (var index = 0; index < listing.featuredImages.length; index++) {
      final image = getFeaturedImage(
        deck: deck,
        index: index,
        listing: listing,
      );
      images = [...images, image];
    }

    return images;
  }

  static Future<DeckListing> createListing(Deck deck) async {
    final now = DateTime.now();
    final content = Content(
      createdAt: now,
      updatedAt: now,
      id: uuid.v7(),
      profileId: LocalDB.currentProfile.getOrCreate().id,
      type: ContentType.deckListing,
    );
    final listing = DeckListing(contentId: content.id, deckId: deck.id);

    await LocalDB.deckListing.upsert(listing);

    return listing;
  }

  static Future<void> upsertListing({
    required Deck deck,
    required DeckListing listing,
    required Content content,
  }) async {
    await LocalDB.deck.upsert(deck);

    await LocalDB.deckListing.upsert(listing);
  }

  static Future<Deck?> deleteListing({
    required Deck deck,
    required DeckListing listing,
    required Content content,
  }) async {
    if (!deck.isEditable) {
      return null;
    }

    final now = DateTime.now();
    final purgeAfter = SyncDeletionPolicy.current().purgeAfter(now);
    final updatedDeck = deck.copyWith(
      isPublished: false,
      visibilityState: VisibilityState.private,
      updatedAt: now,
    );

    if (AuthService.isAuthenticatedRemote) {
      await LocalDB.deckListing.upsert(
        // ToDo: Move deletedAt to Content
        listing.copyWith(deletedAt: now, purgeAfter: purgeAfter),
      );
    } else {
      await LocalDB.deckListing.deleteByPk({'deck_id': deck.id});
    }
    await LocalDB.deck.upsert(updatedDeck);

    return updatedDeck;
  }

  static Future<void> setFeaturedImageByFile({
    required Deck deck,
    required DeckListing listing,
    required Content content,
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

    final absolutePath = await FileSystemHandler.getAbsolutePathOfRelativePath(
      path,
    );
    final file = File(absolutePath);
    final bytes = await file.readAsBytes();
    file.writeAsBytes(bytes);

    final remoteUrl = await RemoteDB.publicBucket.uploadBytes(path, bytes);

    final feauturedImages = listing.featuredImages.toList();
    feauturedImages[index] = remoteUrl;

    final updatedDeckListing = listing.copyWith(
      featuredImages: feauturedImages,
    );

    final updatedContent = content.copyWith(updatedAt: DateTime.now());

    await LocalDB.contents.upsert(updatedContent);
    await LocalDB.deckListing.upsert(updatedDeckListing);
  }

  static Future<void> setFeaturedImagesByFile({
    required Deck deck,
    required DeckListing listing,
    required Content content,
    required List<PlatformFile> files,
  }) async {
    if (!deck.isEditable) {
      return;
    }

    final paths = DecksDirectoryPaths.listingFeaturedImages(
      deckTitle: deck.title,
    );

    // ToDo: Add error handling
    for (int i = 0; i < listing.featuredImages.length; i++) {
      final path = paths[i];

      final absolutePath =
          await FileSystemHandler.getAbsolutePathOfRelativePath(path);
      final file = File(absolutePath);
      final bytes = await file.readAsBytes();
      file.writeAsBytes(bytes);

      final remoteUrl = await RemoteDB.publicBucket.uploadBytes(path, bytes);

      final updatedDeckListing = listing.copyWith(
        featuredImages: [...listing.featuredImages, remoteUrl],
      );

      final updatedContent = content.copyWith(updatedAt: DateTime.now());

      await LocalDB.contents.upsert(updatedContent);
      await LocalDB.deckListing.upsert(updatedDeckListing);
    }
  }

  static Future<Deck?> addListingFeaturedCard({
    required Deck deck,
    required DeckListing listing,
    required Content content,
    required CardTemplate template,
  }) async {
    if (!deck.isEditable) {
      return null;
    }

    final now = DateTime.now();

    final featuredCards = listing.featuredCards.toList();
    final hasTemplate = featuredCards.any((card) => card['id'] == template.id);
    if (hasTemplate) {
      return null;
    }

    final updatedListing = listing.copyWith(
      featuredCards: [...featuredCards, template.toMap()],
    );
    final updatedDeck = deck.copyWith(updatedAt: now);
    final updatedContent = content.copyWith(updatedAt: DateTime.now());

    await LocalDB.contents.upsert(updatedContent);
    await LocalDB.deck.upsert(updatedDeck);
    await LocalDB.deckListing.upsert(updatedListing);
    return updatedDeck;
  }
}
