// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review_dashboard_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/search/widgets/filtered_search_bar.dart';
import 'package:boo_mondai/features/search/widgets/filtered_search_bar.hook.dart';
import 'package:boo_mondai/features/search/filters/review_deck.search_filter.dart';
import 'package:boo_mondai/features/view_reviews/models/review_deck_entry.dart';
import 'package:boo_mondai/features/view_reviews/view_reviews.controller.dart'
    show ViewReviewsController;
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppSpacing,
        EmptyState,
        ListingStatesWrapper,
        ReviewAllCard,
        ReviewDeckTile;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class ViewReviewsPage extends HookWidget {
  const ViewReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ViewReviewsController>();
    final searchController =
        useFilteredSearchBarController<ReviewDeckEntry, ReviewDeckSearchFilter>(
          filterCodec: ViewReviewsController.reviewSearchFilterCodec,
          searchResults: ViewReviewsController.reviewSearchResults,
          items: ctrl.deckEntries,
          initialFilter: ctrl.reviewFilter,
        );

    useEffect(() {
      // Load stats when page opens
      Future.microtask(() => ctrl.load());
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text('FSRS Reviews')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              0,
            ),
            child: FilteredSearchBar<ReviewDeckEntry, ReviewDeckSearchFilter>(
              controller: searchController,
              filterCodec: ViewReviewsController.reviewSearchFilterCodec,
              searchResults: ViewReviewsController.reviewSearchResults,
              items: ctrl.deckEntries,
              placeholder: 'Filter review decks',
              showFilterButton: true,
              onFilterChanged: ctrl.setReviewFilter,
            ),
          ),
          Expanded(
            child: ListingStatesWrapper.list(
              emptyState: EmptyState(
                // Placeholder icon
                icon: Icons.abc,
                title: 'No Enrolled Cards Yet',
                message: 'Go take a drill!',
              ),
              isLoading: ctrl.isLoading,
              items: searchController.results,
              onRetry: ctrl.load,
              skeletonTile: ReviewDeckTile(),
              leadingItem: ReviewAllCard(dueCount: ctrl.totalDue),
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.md,
                bottom: 100,
              ),
              itemBuilder: (_, _, ReviewDeckEntry entry) {
                return ReviewDeckTile(deck: entry.deck, stats: entry.stats);
              },
            ),
          ),
        ],
      ),
    );
  }
}
