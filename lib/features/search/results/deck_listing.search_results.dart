import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckListingSearchFilter,
        DeckListing,
        SearchResults,
        DeckListingSearchSortField,
        SearchSortDirection;
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

final class DeckListingSearchResults
    implements SearchResults<DeckListing, DeckListingSearchFilter> {
  const DeckListingSearchResults();

  @override
  List<DeckListing> resolve({
    required Iterable<DeckListing> items,
    required DeckListingSearchFilter filter,
  }) {
    final normalizedFreeText = filter.freeText.trim();

    var filtered = items.where((listing) {
      if (filter.deckIds.isNotEmpty &&
          !filter.deckIds.contains(listing.deckId)) {
        return false;
      }

      return true;
    }).toList();

    if (normalizedFreeText.isNotEmpty) {
      filtered = extractAllSorted<DeckListing>(
        query: normalizedFreeText,
        choices: filtered,
        cutoff: filter.fuzzyCutoff,
        getter: _deckListingSearchText,
      ).map((result) => result.choice).toList();
    }

    return sortDeckListings(
      filtered,
      field: filter.sortField,
      direction: filter.sortDirection,
    );
  }

  List<DeckListing> sortDeckListings(
    Iterable<DeckListing> listings, {
    DeckListingSearchSortField field = DeckListingSearchSortField.updatedAt,
    SearchSortDirection direction = SearchSortDirection.descending,
  }) {
    final sorted = listings.toList();
    sorted.sort((a, b) {
      final comparison = switch (field) {
        DeckListingSearchSortField.createdAt => a.createdAt.compareTo(
          b.createdAt,
        ),
        DeckListingSearchSortField.updatedAt => a.updatedAt.compareTo(
          b.updatedAt,
        ),
        DeckListingSearchSortField.downloads => a.downloadsCount.compareTo(
          b.downloadsCount,
        ),
        DeckListingSearchSortField.favorites => a.favoritesCount.compareTo(
          b.favoritesCount,
        ),
        DeckListingSearchSortField.upvotes => a.upvotesCount.compareTo(
          b.upvotesCount,
        ),
        DeckListingSearchSortField.comments => a.commentsCount.compareTo(
          b.commentsCount,
        ),
        DeckListingSearchSortField.reviews => a.reviewsCount.compareTo(
          b.reviewsCount,
        ),
      };

      return direction == SearchSortDirection.ascending
          ? comparison
          : -comparison;
    });
    return sorted;
  }

  String _deckListingSearchText(DeckListing listing) {
    return [
      listing.deckId,
      ...listing.featuredImages,
      ...listing.featuredCards.map((card) => card.values.join(' ')),
    ].join(' ');
  }
}
