import 'package:boo_mondai/lib.barrel.dart'
    show Deck, DeckListing, ImageHelper, LocalDB, Tag;
import 'package:file_picker/file_picker.dart' show PlatformFile;

abstract final class DecksService {
  static Future<Deck> createListingDraft(Deck deck) async {
    final now = DateTime.now();
    final listing = DeckListing(
      deckId: deck.id,
      createdAt: now,
      updatedAt: now,
    );
    final updatedDeck = deck.copyWith(listing: listing, updatedAt: now);

    await LocalDB.deck.upsert(updatedDeck);
    await LocalDB.deckListing.upsert(listing);

    return updatedDeck;
  }

  static Future<Deck?> update({
    required Deck deck,
    String? title,
    String? shortDescription,
    String? longDescription,
    bool? isPublished,
  }) async {
    final updatesEditableField =
        title != null || shortDescription != null || longDescription != null;
    if (updatesEditableField && !deck.isEditable) {
      return null;
    }

    var updatedDeck = deck;
    var changed = false;

    if (title != null) {
      final trimmedTitle = title.trim();
      if (trimmedTitle.isEmpty) {
        return null;
      }
      if (trimmedTitle != deck.title) {
        updatedDeck = updatedDeck.copyWith(title: trimmedTitle);
        changed = true;
      }
    }

    if (shortDescription != null) {
      final trimmedShortDescription = shortDescription.trim();
      if (trimmedShortDescription != deck.shortDescription) {
        updatedDeck = updatedDeck.copyWith(
          shortDescription: trimmedShortDescription,
        );
        changed = true;
      }
    }

    if (longDescription != null) {
      final trimmedLongDescription = longDescription.trim();
      if (trimmedLongDescription != deck.longDescription) {
        updatedDeck = updatedDeck.copyWith(
          longDescription: trimmedLongDescription,
        );
        changed = true;
      }
    }

    if (isPublished != null && isPublished != deck.isPublished) {
      updatedDeck = updatedDeck.copyWith(isPublished: isPublished);
      changed = true;
    }

    if (!changed) {
      return null;
    }

    updatedDeck = updatedDeck.copyWith(updatedAt: DateTime.now());

    await LocalDB.deck.upsert(updatedDeck);
    return updatedDeck;
  }

  static Future<Deck?> updateTags({
    required Deck deck,
    required List<String> tagNames,
  }) async {
    if (!deck.isEditable) {
      return null;
    }

    final normalizedTagNames = tagNames
        .map((tagName) => tagName.trim())
        .where((tagName) => tagName.isNotEmpty)
        .toList();
    final currentTagNames = deck.tags.map((tag) => tag.name).toList();

    if (_sameTagNames(normalizedTagNames, currentTagNames)) {
      return null;
    }

    final existingTagsByName = {
      for (final tag in deck.tags) tag.name.toLowerCase(): tag,
    };
    final updatedTags = [
      for (final tagName in normalizedTagNames)
        existingTagsByName[tagName.toLowerCase()] ??
            Tag.createNow(name: tagName, userId: deck.userId),
    ];
    final updatedDeck = deck.copyWith(
      tags: updatedTags,
      updatedAt: DateTime.now(),
    );

    await LocalDB.deck.upsert(updatedDeck);
    return updatedDeck;
  }

  static Future<Deck?> updateCoverImage({
    required Deck deck,
    required PlatformFile file,
  }) async {
    if (!deck.isEditable) {
      return null;
    }

    final imageSource = ImageHelper.getImageSourceFromPickedFile(file);
    if (imageSource == null || imageSource == deck.coverImageUrl) {
      return null;
    }

    final updatedDeck = deck.copyWith(
      coverImageUrl: imageSource,
      updatedAt: DateTime.now(),
    );

    await LocalDB.deck.upsert(updatedDeck);
    return updatedDeck;
  }

  static bool _sameTagNames(List<String> left, List<String> right) {
    if (left.length != right.length) {
      return false;
    }

    for (var i = 0; i < left.length; i++) {
      if (left[i] != right[i]) {
        return false;
      }
    }

    return true;
  }
}
