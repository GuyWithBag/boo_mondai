// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review_dashboard_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppSpacing,
        EmptyState,
        ListingStatesWrapper,
        ReviewAllCard,
        AppBar,
        ReviewDeckTile,
        ViewStudyCardsController,
        StudyDeckEntry,
        StudyDeckSearchFilter,
        useFilteredSearchBarController,
        FilteredSearchBar,
        Scaffold;
import 'package:flutter/material.dart'
    show BuildContext, Widget, EdgeInsets, Icons;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class ViewStudyCardsPage extends HookWidget {
  const ViewStudyCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ViewStudyCardsController>();
    final searchController =
        useFilteredSearchBarController<StudyDeckEntry, StudyDeckSearchFilter>(
          filterCodec: ViewStudyCardsController.reviewSearchFilterCodec,
          searchResults: ViewStudyCardsController.reviewSearchResults,
          items: ctrl.deckEntries,
          initialFilter: ctrl.reviewFilter,
        );

    useEffect(() {
      // Load stats when page opens
      Future.microtask(() => ctrl.load());
      return null;
    }, const []);

    final searchBar = FilteredSearchBar<StudyDeckEntry, StudyDeckSearchFilter>(
      controller: searchController,
      filterCodec: ViewStudyCardsController.reviewSearchFilterCodec,
      searchResults: ViewStudyCardsController.reviewSearchResults,
      items: ctrl.deckEntries,
      placeholder: 'Filter review decks',
      showFilterButton: true,
      onFilterChanged: ctrl.setReviewFilter,
    );

    return Scaffold(
      appBar: AppBar(title: 'FSRS Reviews', header: searchBar),
      scrollable: false,
      body: ListingStatesWrapper.list(
        emptyState: EmptyState(
          icon: Icons.abc,
          title: 'No Enrolled Cards Yet',
          message: 'Go take a drill!',
        ),
        isLoading: ctrl.isLoading,
        items: searchController.results,
        onRetry: ctrl.load,
        useParentScroll: true,
        skeletonTile: ReviewDeckTile(),
        leadingItem: ReviewAllCard(dueCount: ctrl.totalDue),

        itemBuilder: (_, _, StudyDeckEntry entry) {
          return ReviewDeckTile(deck: entry.deck, stats: entry.stats);
        },
      ),
    );
  }
}
