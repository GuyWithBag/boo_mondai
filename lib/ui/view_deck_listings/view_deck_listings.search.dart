import 'package:boo_mondai/lib.barrel.dart'
    show DeckWithListingContent, SearchTokenShape, SearchTokens, Tag;

abstract final class ViewDeckListingsSearch {
  static const tag = SearchTokenShape(name: 'tag', aliases: ['tags']);
  static const sort = SearchTokenShape(name: 'sort', aliases: ['sort_by']);
  static const direction = SearchTokenShape(
    name: 'direction',
    aliases: ['dir', 'order'],
  );
  static const fuzzy = SearchTokenShape(name: 'fuzzy', aliases: ['cutoff']);

  static const tokenShapes = [tag, sort, direction, fuzzy];

  static String searchTextLabel(DeckWithListingContent entry) {
    final deck = entry.deck;
    return [
      deck.title,
      deck.shortDescription,
      deck.longDescription,
      entry.profile.displayName,
      entry.profile.username,
      for (final tag in deck.tags) tag.name,
    ].join(' ');
  }

  static bool itemFilter(DeckWithListingContent entry, SearchTokens tokens) {
    final selectedTags = tokens
        .getAll(tag)
        .map((value) => value.trim().toLowerCase())
        .where((value) => value.isNotEmpty)
        .toSet();
    if (selectedTags.isEmpty) return true;

    final deckTags = entry.deck.tags
        .map((tag) => tag.name.trim().toLowerCase())
        .toSet();
    return selectedTags.every(deckTags.contains);
  }

  static List<DeckWithListingContent> sorter(
    List<DeckWithListingContent> entries,
    SearchTokens? tokens,
  ) {
    final sorted = [...entries];
    final sortValue = tokens?.getLast(sort)?.trim().toLowerCase();
    final isAscending =
        tokens?.getLast(direction)?.trim().toLowerCase() == 'ascending' ||
        tokens?.getLast(direction)?.trim().toLowerCase() == 'asc';

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

  static List<Tag> availableTags(Iterable<DeckWithListingContent> entries) {
    final byName = <String, Tag>{};
    for (final entry in entries) {
      for (final tag in entry.deck.tags) {
        byName[tag.name.trim().toLowerCase()] = tag;
      }
    }
    final tags = byName.values.toList();
    tags.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return tags;
  }
}
