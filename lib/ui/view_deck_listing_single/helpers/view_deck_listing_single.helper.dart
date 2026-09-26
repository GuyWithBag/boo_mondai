import 'package:boo_mondai/lib.barrel.dart'
    show StringHelper, Deck, DeckListing, LocalDB;

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

  String profileName(Deck deck) {
    final profile = LocalDB.profiles.selectByPk({'id': deck.profileId});
    return StringHelper.toTrimmedOrFallback(
      profile?.username,
      'Unknown author',
    );
  }

  String visibilityLabel(Deck deck) {
    return switch (deck.visibilityState.name) {
      'public' => 'Public',
      'unlisted' => 'Unlisted',
      _ => 'Private',
    };
  }

  int downloadsCount(DeckListing? listing) {
    return listing?.downloadsCount ?? 0;
  }

  int forksCount(DeckListing? listing) {
    return listing?.forksCount ?? 0;
  }

  Deck? deckById(List<Deck> decks, String deckId) {
    for (final deck in decks) {
      if (deck.id == deckId) return deck;
    }
    return null;
  }
}
