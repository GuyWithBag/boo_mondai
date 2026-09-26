import 'package:boo_mondai/lib.barrel.dart'
    show Profile, Content, Deck, DeckListing;

typedef DeckWithListingContent = ({
  Deck deck,
  DeckListing deckListing,
  Content deckListingContent,
  Profile profile,
  Profile? sourceProfile,
});
