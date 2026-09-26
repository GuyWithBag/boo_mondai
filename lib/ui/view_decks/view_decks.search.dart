import 'package:boo_mondai/lib.barrel.dart'
    show Deck, DeckWithListingContent, SearchTokenShape, SearchTokens;

enum ViewDecksSearchScope { decks, listings }

extension ViewDecksSearchScopeLabel on ViewDecksSearchScope {
  String get label => switch (this) {
    ViewDecksSearchScope.decks => 'Decks',
    ViewDecksSearchScope.listings => 'Listings',
  };
}

final class ViewDecksScopeOption {
  const ViewDecksScopeOption({required this.value, required this.label});

  final ViewDecksSearchScope value;
  final String label;
}

abstract final class ViewDecksSearch {
  static const tag = SearchTokenShape(name: 'tag', aliases: ['tags']);
  static const sort = SearchTokenShape(name: 'sort', aliases: ['sort_by']);
  static const direction = SearchTokenShape(
    name: 'direction',
    aliases: ['dir', 'order'],
  );
  static const fuzzy = SearchTokenShape(name: 'fuzzy', aliases: ['cutoff']);

  static const tokenShapes = [tag, sort, direction, fuzzy];

  static String deckSearchTextLabel(Deck deck) => [
    deck.title,
    deck.shortDescription,
    deck.longDescription,
    for (final tag in deck.tags) tag.name,
  ].join(' ');

  static String listingSearchTextLabel(DeckWithListingContent entry) => [
    deckSearchTextLabel(entry.deck),
    entry.profile.displayName,
    entry.profile.username,
    entry.sourceProfile?.displayName,
    entry.sourceProfile?.username,
  ].whereType<String>().join(' ');

  static bool deckItemFilter(Deck deck, SearchTokens tokens) {
    final selectedTags = tokens
        .getAll(tag)
        .map((value) => value.trim().toLowerCase())
        .where((value) => value.isNotEmpty)
        .toSet();
    if (selectedTags.isEmpty) return true;

    final deckTags = deck.tags
        .map((tag) => tag.name.trim().toLowerCase())
        .toSet();
    return selectedTags.every(deckTags.contains);
  }

  static bool listingItemFilter(
    DeckWithListingContent entry,
    SearchTokens tokens,
  ) {
    return deckItemFilter(entry.deck, tokens);
  }

  static List<Deck> deckSorter(List<Deck> decks, SearchTokens tokens) {
    final sorted = [...decks];
    final sortValue = tokens.getLast(sort)?.trim().toLowerCase();
    final isAscending = _isAscending(tokens);

    sorted.sort((a, b) {
      final comparison = switch (sortValue) {
        'letters' ||
        'title' ||
        'name' => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        'created_at' || 'created' => a.createdAt.compareTo(b.createdAt),
        _ => a.updatedAt.compareTo(b.updatedAt),
      };
      return isAscending ? comparison : -comparison;
    });
    return sorted;
  }

  static List<DeckWithListingContent> listingSorter(
    List<DeckWithListingContent> entries,
    SearchTokens tokens,
  ) {
    final sorted = [...entries];
    final sortValue = tokens.getLast(sort)?.trim().toLowerCase();
    final isAscending = _isAscending(tokens);

    sorted.sort((a, b) {
      final comparison = switch (sortValue) {
        'letters' || 'title' || 'name' => a.deck.title.toLowerCase().compareTo(
          b.deck.title.toLowerCase(),
        ),
        'created_at' ||
        'created' => a.deck.createdAt.compareTo(b.deck.createdAt),
        'downloads' => a.deckListing.downloadsCount.compareTo(
          b.deckListing.downloadsCount,
        ),
        'favorites' => a.deckListing.favoritesCount.compareTo(
          b.deckListing.favoritesCount,
        ),
        'upvotes' => a.deckListing.upvotesCount.compareTo(
          b.deckListing.upvotesCount,
        ),
        'comments' => a.deckListing.commentsCount.compareTo(
          b.deckListing.commentsCount,
        ),
        'reviews' => a.deckListing.reviewsCount.compareTo(
          b.deckListing.reviewsCount,
        ),
        _ => a.deck.updatedAt.compareTo(b.deck.updatedAt),
      };
      return isAscending ? comparison : -comparison;
    });
    return sorted;
  }

  static bool _isAscending(SearchTokens tokens) {
    final value = tokens.getLast(direction)?.trim().toLowerCase();
    return value == 'ascending' || value == 'asc';
  }
}
