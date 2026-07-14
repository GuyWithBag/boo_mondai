import 'package:boo_mondai/core/models/folder_path.dart';

abstract final class FolderPaths {
  static FolderPath deckMedia(String deckTitle) {
    return FolderPath('$deckTitle/media');
  }

  static FolderPath deckCoverImage(String deckTitle) {
    return FolderPath('$deckTitle/media/coverImage');
  }

  static FolderPath deckListingFeaturedImage(String deckTitle, int index) {
    return FolderPath('$deckTitle/media/featuredImages/image$index');
  }
}
