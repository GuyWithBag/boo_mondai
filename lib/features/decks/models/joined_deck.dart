import 'package:boo_mondai/lib.barrel.dart'
    show Content, Profile, Deck, DeckListing;

typedef JoinedDeck = ({
  Deck deck,
  DeckListing? deckListing,
  Content? deckListingContent,
  Profile profile,
  Deck? sourceDeck,
  Profile? sourceProfile,
});
