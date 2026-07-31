import 'package:boo_mondai/lib.barrel.dart'
    show
        StringHelper,
        Deck,
        StoredMediaService,
        StoredMediaPathHelper,
        DeckListingsService;

final class ViewDeckListingSingleHelper {
  const ViewDeckListingSingleHelper();

  String title(Deck deck) {
    return StringHelper.toTrimmedOrFallback(deck.title, 'Untitled deck');
  }

  String shortDescription(Deck deck) {
    return StringHelper.toTrimmedOrFallback(
      deck.shortDescription,
      'No short description yet.',
    );
  }

  String longDescription(Deck deck) {
    return StringHelper.toTrimmedOrFallback(
      deck.longDescription,
      'No long description yet.',
    );
  }

  List<String> carouselImageUrls(Deck deck) {
    return DeckListingsService.getCarouselImages(deck)
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }

  String profileName(Deck deck) {
    return StringHelper.toTrimmedOrFallback(
      deck.userProfile?.username,
      'Unknown author',
    );
  }

  String? profileAvatarUrl(Deck deck) {
    final profile = deck.userProfile;
    if (profile == null) return null;
    return StringHelper.toTrimmedOrNull(
      StoredMediaService.getFileByPath(
            StoredMediaPathHelper.profileAvatar(),
          )?.path ??
          profile.avatarUrl,
    );
  }

  String visibilityLabel(Deck deck) {
    return switch (deck.visibilityState.name) {
      'public' => 'Public',
      'unlisted' => 'Unlisted',
      _ => 'Private',
    };
  }

  int downloadsCount(Deck deck) {
    return deck.listing?.downloadsCount ?? 0;
  }

  int forksCount(Deck deck) {
    return deck.listing?.forksCount ?? 0;
  }

  Deck? deckById(List<Deck> decks, String deckId) {
    for (final deck in decks) {
      if (deck.id == deckId) return deck;
    }
    return null;
  }
}
