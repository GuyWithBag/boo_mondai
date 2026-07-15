import 'package:boo_mondai/lib.barrel.dart' show StoredMedia;

abstract final class MediaRemotePathHelper {
  /// Returns the public bucket object path for a deck cover image.
  ///
  /// Supabase Storage RLS expects all user-owned objects to start with
  /// `users/{profileId}`.
  static String deckCoverImage({
    required String profileId,
    required String deckId,
  }) {
    return 'users/$profileId/decks/$deckId/cover';
  }

  /// Returns the public bucket object path for a deck-listing featured image.
  ///
  /// Supabase Storage RLS expects all user-owned objects to start with
  /// `users/{profileId}`.
  static String deckListingFeaturedImage({
    required String profileId,
    required String deckId,
    required int index,
  }) {
    return 'users/$profileId/decks/$deckId/featured/image$index';
  }

  /// Returns the public bucket object path for a deck markdown attachment.
  ///
  /// Supabase Storage RLS expects all user-owned objects to start with
  /// `users/{profileId}`.
  static String deckMarkdownAttachment({
    required String profileId,
    required String deckId,
    required String fileName,
  }) {
    return 'users/$profileId/decks/$deckId/markdown/$fileName';
  }

  /// Returns the public bucket object path for a card markdown attachment.
  ///
  /// Supabase Storage RLS expects all user-owned objects to start with
  /// `users/{profileId}`.
  static String cardMarkdownAttachment({
    required String profileId,
    required String deckId,
    required String templateId,
    required String field,
    required String fileName,
  }) {
    return 'users/$profileId/decks/$deckId/cards/$templateId/markdown/$field/$fileName';
  }

  /// Returns the public bucket object path for a profile avatar.
  ///
  /// Supabase Storage RLS expects all user-owned objects to start with
  /// `users/{profileId}`.
  static String profileAvatar({required String profileId}) {
    return 'users/$profileId/profile/avatar';
  }

  static String fileNameFromStoredMedia(StoredMedia storedMedia, int index) {
    final uri = Uri.file(storedMedia.localPath);
    final fileName = uri.pathSegments.isEmpty ? '' : uri.pathSegments.last;
    return fileName.trim().isEmpty ? 'media$index' : fileName;
  }
}
