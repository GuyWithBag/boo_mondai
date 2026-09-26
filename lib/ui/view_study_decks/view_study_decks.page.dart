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
        ViewStudyDecksController,
        StudyDeckEntry,
        FilteredSearchBar,
        FilteredSearchBarController,
        Scaffold,
        AppTokens;
import 'package:boo_mondai/ui/view_study_decks/view_study_decks.search.dart';
import 'package:flutter/material.dart' hide Scaffold, AppBar;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewStudyDecksPage extends SignalHookWidget {
  const ViewStudyDecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(() => ViewStudyDecksController());
    final tokens = context.themeTokens<AppTokens>();
    final deckEntries = controller.deckEntries.value;
    final searchController = useMemoized(
      () => FilteredSearchBarController<StudyDeckEntry>(
        tokenShapes: ViewStudyDecksSearch.tokenShapes,
        searchTextLabel: ViewStudyDecksSearch.searchTextLabel,
        sorter: ViewStudyDecksSearch.sorter,
        items: deckEntries,
      ),
      const [],
    );

    useEffect(() {
      Future.microtask(() => controller.load());
      return () {
        searchController.dispose();
        controller.dispose();
      };
    }, [controller, searchController]);

    useEffect(() {
      searchController.setItems(deckEntries);
      return null;
    }, [deckEntries, searchController]);

    final searchBar = FilteredSearchBar<StudyDeckEntry>(
      controller: searchController,
      placeholder: 'Filter review decks',
      showFilterButton: true,
      resultLabelBuilder: (entry) => entry.deck.title,
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
        isLoading: controller.isLoading.value,
        items: searchController.results.value,
        onRetry: () => controller.load(),
        useParentScroll: true,
        skeletonTile: StudyDeckTile(),
        separatorHeight: tokens.spaceLayoutGapMd,
        leadingItem: StudyAllDecks(dueCount: controller.totalDue.value),
        itemBuilder: (_, _, StudyDeckEntry entry) {
          return StudyDeckTile(deck: entry.deck, stats: entry.stats);
        },
      ),
    );
  }
}
