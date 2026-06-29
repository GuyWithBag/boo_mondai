import 'package:boo_mondai/core/database/localdbs.dart';
import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/decks/models/visibility_state.dto.dart';
import 'package:boo_mondai/features/profile/models/cached_profile.dart';
import 'package:boo_mondai/features/profile/models/profile.dto.dart';

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
