import 'dart:io' hide ContentType;

import 'package:boo_mondai/features/decks/models/deck_with_listing_content.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppException,
        AuthService,
        CardTemplate,
        Content,
        ContentType,
        Deck,
        DeckListing,
        DecksDirectoryPaths,
        FileSystemHandler,
        LocalDB,
        SyncDeletionPolicy,
        VisibilityState,
        uuid;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';

abstract final class DeckListingsService {
  static String? getFeaturedImage({
    required Deck deck,
    required DeckListing listing,
    int index = 0,
  }) {
    if (index < 0 || index >= listing.featuredImages.length) return null;

    final source = listing.featuredImages[index].trim();
    return source.isEmpty ? null : source;
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
      if (image == null) continue;
      images = [...images, image];
    }

    return images;
  }

  static Future<List<MemoryImage>> getFeaturedMemoryImages({
    required Deck deck,
    required DeckListing listing,
  }) async {
    final images = <MemoryImage>[];

    for (final source in getFeaturedImages(deck: deck, listing: listing)) {
      final absolutePath =
          await FileSystemHandler.getAbsolutePathOfRelativePath(source);
      final file = File(absolutePath);
      if (!await file.exists()) continue;

      images.add(MemoryImage(await file.readAsBytes()));
    }

    return images;
  }

  static Future<DeckWithListingContent> createListing(Deck deck) async {
    final now = DateTime.now();
    final profile = LocalDB.currentProfile.getOrCreate();
    final content = Content(
      createdAt: now,
      updatedAt: now,
      id: uuid.v7(),
      profileId: profile.id,
      type: ContentType.deckListing,
    );
    final listing = DeckListing(contentId: content.id, deckId: deck.id);

    await LocalDB.contents.upsert(content);
    await LocalDB.deckListing.upsert(listing);

    return (
      deck: deck,
      deckListing: listing,
      deckListingContent: content,
      profile: profile,
      sourceProfile: null,
    );
  }

  static List<CardTemplate> getFeaturedCardTemplates({
    required Deck deck,
    required List<CardTemplate> featuredCards,
  }) {
    final featuredCardIds = {for (final card in featuredCards) card.id};

    return LocalDB.cardTemplate
        .getByDeckId(deck.id)
        .where((template) => !featuredCardIds.contains(template.id))
        .toList(growable: false);
  }

  static Future<void> upsertListing({
    required Deck deck,
    required DeckListing listing,
    required Content content,
  }) async {
    await LocalDB.deck.upsert(deck);
    await LocalDB.contents.upsert(content);
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

  static Future<({DeckListing listing, Content content})>
  upsertFeaturedImagesFromImages({
    required Deck deck,
    required DeckListing listing,
    required Content content,
    required List<MemoryImage> images,
  }) async {
    // ToDo: Add proper error handling
    if (!deck.isEditable) {
      throw AppException('Deck is not editable');
    }

    // ToDo: Add error handling

    // var remoteUrls = <String>[];
    var localUrls = <String>[];

    for (int i = 0; i < images.length; i++) {
      final path = DecksDirectoryPaths.listingFeaturedImage(
        deckTitle: deck.title,
        index: i,
      );

      final image = images[i];

      final webpBytes = await FlutterImageCompress.compressWithList(
        image.bytes,
        format: CompressFormat.webp,
        quality: 90,
      );

      final absolutePath =
          await FileSystemHandler.getAbsolutePathOfRelativePath(path);

      final file = File(absolutePath);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(webpBytes, flush: true);

      // final remoteUrl = await RemoteDB.publicBucket.uploadBytes(
      //   path,
      //   webpBytes,
      // );
      // remoteUrls.add(remoteUrl);
      // ToDo: so isPublished = false, it stores the local url. then
      // publishing then syncing will replace these with the remote url.
      // Now when it is synced from remote, it should download the bytes then write it, then replace the urls to local.
      localUrls.add(path);
    }

    // final updatedDeckListing = listing.copyWith(featuredImages: remoteUrls);
    final updatedDeckListing = listing.copyWith(featuredImages: localUrls);

    final updatedContent = content.copyWith(updatedAt: DateTime.now());

    await LocalDB.contents.upsert(updatedContent);
    await LocalDB.deckListing.upsert(updatedDeckListing);
    return (listing: updatedDeckListing, content: updatedContent);
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

    final updatedListing = listing.copyWith(
      featuredCards: [...featuredCards, template],
    );

    final updatedDeck = deck.copyWith(updatedAt: now);
    final updatedContent = content.copyWith(updatedAt: DateTime.now());

    await LocalDB.contents.upsert(updatedContent);
    await LocalDB.deck.upsert(updatedDeck);
    await LocalDB.deckListing.upsert(updatedListing);
    return updatedDeck;
  }
}
