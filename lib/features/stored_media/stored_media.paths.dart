import 'package:boo_mondai/lib.barrel.dart' show FileHelper;

// ToDo: This should soon be deprecated and moved to using manifest.json
abstract final class DecksDirectoryPaths {
  static final imageExtension = '.webp';

  /// Returns the local stored-media folder prefix for a deck.
  static String root({required String deckTitle}) {
    return 'decks/$deckTitle/';
  }

  /// Returns the local stored-media path for a deck cover image.
  static String coverImage({required String deckTitle}) {
    return 'decks/$deckTitle/coverImage$imageExtension';
  }

  /// Returns the local stored-media path for a listing featured image.
  static String listingFeaturedImage({
    required String deckTitle,
    required int index,
  }) {
    return 'decks/$deckTitle/featuredImage$index$imageExtension';
  }

  static List<String> listingFeaturedImages({required String deckTitle}) {
    return [
      listingFeaturedImage(deckTitle: deckTitle, index: 0),
      listingFeaturedImage(deckTitle: deckTitle, index: 1),
      listingFeaturedImage(deckTitle: deckTitle, index: 2),
    ];
  }

  /// Returns the local stored-media path for a markdown attachment.
  static String attachment({
    required String deckTitle,
    required String fileNameWithoutExtension,
  }) {
    final sanitizedFileName = FileHelper.fileNameWithoutExtension(
      fileNameWithoutExtension,
    );
    return 'decks/$deckTitle/attachments/$sanitizedFileName$imageExtension';
  }
}
