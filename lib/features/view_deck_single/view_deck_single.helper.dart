import 'package:boo_mondai/core/database/localdbs.dart';
import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/decks/models/visibility_state.dto.dart';
import 'package:boo_mondai/features/profile/models/cached_profile.dart';
import 'package:boo_mondai/features/profile/models/profile.dto.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';

abstract final class ViewDeckSingleHelper {
  static String title(Deck deck) {
    return deck.title.isEmpty ? 'Untitled deck' : deck.title;
  }

  static String shortDescription(Deck deck) {
    return deck.shortDescription.isEmpty
        ? 'No short description yet.'
        : deck.shortDescription;
  }

  static String longDescription(Deck deck) {
    return deck.longDescription.isEmpty
        ? 'No long description yet.'
        : deck.longDescription;
  }

  static String profileName(Deck deck) {
    return switch (_profile(deck)) {
      CachedProfile(:final username) => username,
      Profile(:final displayName) => displayName,
      _ => 'Unknown user',
    };
  }

  static String? profileAvatarUrl(Deck deck) {
    return switch (_profile(deck)) {
      CachedProfile(:final avatarUrl) => avatarUrl,
      Profile(:final avatarUrl) => avatarUrl,
      _ => null,
    };
  }

  static String? sourceProfileName(Deck deck) {
    return _sourceProfile(deck)?.username;
  }

  static String? sourceProfileAvatarUrl(Deck deck) {
    return _sourceProfile(deck)?.avatarUrl;
  }

  static String visibilityLabel(Deck deck) {
    return switch (deck.visibilityState) {
      VisibilityState.private => 'Private',
      VisibilityState.public => 'Public',
      VisibilityState.unlisted => 'Unlisted',
    };
  }

  static Future<bool> updatePublishedState({
    required Deck deck,
    required bool isPublished,
  }) async {
    await LocalDB.deck.upsert(
      deck.copyWith(isPublished: isPublished, updatedAt: DateTime.now()),
    );
    return true;
  }

  static Future<bool> updateTags({
    required Deck deck,
    required List<String> tagNames,
  }) async {
    if (!deck.isEditable) {
      return false;
    }

    final normalizedTagNames = tagNames
        .map((tagName) => tagName.trim())
        .where((tagName) => tagName.isNotEmpty)
        .toList();
    final currentTagNames = deck.tags.map((tag) => tag.name).toList();

    if (_sameTagNames(normalizedTagNames, currentTagNames)) {
      return false;
    }

    final existingTagsByName = {
      for (final tag in deck.tags) tag.name.toLowerCase(): tag,
    };
    final updatedTags = [
      for (final tagName in normalizedTagNames)
        existingTagsByName[tagName.toLowerCase()] ??
            Tag.createNow(name: tagName, userId: deck.userId),
    ];

    await LocalDB.deck.upsert(
      deck.copyWith(tags: updatedTags, updatedAt: DateTime.now()),
    );
    return true;
  }

  static Future<bool> updateTextField({
    required Deck deck,
    required String value,
    required bool allowEmpty,
    required String Function(Deck deck) selectCurrentValue,
    required Deck Function(Deck deck, String value) copyWithValue,
  }) async {
    if (!deck.isEditable) {
      return false;
    }

    final trimmedValue = value.trim();
    if (!allowEmpty && trimmedValue.isEmpty) {
      return false;
    }
    if (trimmedValue == selectCurrentValue(deck)) {
      return false;
    }

    final updatedDeck = copyWithValue(
      deck,
      trimmedValue,
    ).copyWith(updatedAt: DateTime.now());

    await LocalDB.deck.upsert(updatedDeck);
    return true;
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

  static Object? _profile(Deck deck) {
    return LocalDB.cachedProfile.selectByPk({'id': deck.userId}) ??
        LocalDB.profile.getOrCreate();
  }

  static CachedProfile? _sourceProfile(Deck deck) {
    final sourceDeck = deck.sourceDeckId == null
        ? null
        : LocalDB.deck.selectByPk({'id': deck.sourceDeckId});

    if (sourceDeck == null) {
      return null;
    }

    return LocalDB.cachedProfile.selectByPk({'id': sourceDeck.userId});
  }
}
