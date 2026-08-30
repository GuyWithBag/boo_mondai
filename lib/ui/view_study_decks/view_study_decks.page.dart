// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review_dashboard_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        StatusLayoutState,
        ListingStatesWrapper,
        StudyAllDecks,
        AppBar,
        StudyDeckTile,
        ViewStudyCardsController,
        StudyDeckEntry,
        StudyDeckSearchFilter,
        useFilteredSearchBarController,
        FilteredSearchBar,
        Scaffold,
        AppTokens;
import 'package:flutter/material.dart' hide Scaffold, AppBar;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewStudyDecksPage extends HookWidget {
  const ViewStudyDecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ViewStudyCardsController>();
    final tokens = context.themeTokens<AppTokens>();
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
        emptyState: StatusLayoutState(
          icon: Icons.abc,
          title: 'No Enrolled Cards Yet',
          message: 'Go take a drill!',
        ),
        isLoading: ctrl.isLoading,
        items: searchController.results,
        onRetry: ctrl.load,
        useParentScroll: true,
        skeletonTile: StudyDeckTile(),
        separatorHeight: tokens.spaceLayoutGapMd,
        leadingItem: StudyAllDecks(dueCount: ctrl.totalDue),
        itemBuilder: (_, _, StudyDeckEntry entry) {
          return StudyDeckTile(deck: entry.deck, stats: entry.stats);
        },
      ),
    );
  }
}
