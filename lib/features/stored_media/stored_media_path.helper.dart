import 'package:boo_mondai/lib.barrel.dart' show FileHelper, StoredMediaPath;

abstract final class StoredMediaPathHelper {
  /// Returns the local stored-media path for a deck cover image.
  static StoredMediaPath deckCoverImage({required String deckTitle}) {
    return StoredMediaPath.folder(
      folderPath: '$deckTitle/media',
      name: 'coverImage',
    );
  }

  /// Returns the local stored-media path for a listing featured image.
  static StoredMediaPath deckListingFeaturedImage({
    required String deckTitle,
    required int index,
  }) {
    return StoredMediaPath.folder(
      folderPath: '$deckTitle/media/featuredImages',
      name: 'image$index',
    );
  }

  /// Returns the local stored-media path for a markdown attachment.
  static StoredMediaPath deckAttachment({
    required String deckTitle,
    required String fileName,
  }) {
    return StoredMediaPath.folder(
      folderPath: '$deckTitle/media',
      name: FileHelper.fileNameWithoutExtension(fileName),
    );
  }

  /// Returns the singleton local stored-media path for the current profile avatar.
  static StoredMediaPath profileAvatar() {
    return const StoredMediaPath.app(name: 'profileAvatar');
  }
}
