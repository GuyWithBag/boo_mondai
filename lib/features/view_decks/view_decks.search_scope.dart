import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        DeckSearchFilter,
        DeckSearchFilterCodec,
        DeckSearchResults,
        SearchScope;

enum ViewDecksSearchScope { decks, listings }

SearchScope<ViewDecksSearchScope, Deck, DeckSearchFilter>
buildViewDecksDeckScope(Iterable<Deck> items) {
  return SearchScope<ViewDecksSearchScope, Deck, DeckSearchFilter>(
    value: ViewDecksSearchScope.decks,
    label: 'Decks',
    filterCodec: const DeckSearchFilterCodec(),
    searchResults: const DeckSearchResults(),
    items: items,
  );
}

SearchScope<ViewDecksSearchScope, Deck, DeckSearchFilter>
buildViewDecksListingScope(Iterable<Deck> items) {
  return SearchScope<ViewDecksSearchScope, Deck, DeckSearchFilter>(
    value: ViewDecksSearchScope.listings,
    label: 'Listings',
    filterCodec: const DeckSearchFilterCodec(),
    searchResults: const DeckSearchResults(),
    items: items,
  );
}
