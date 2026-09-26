import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        ErrorText,
        FilteredSearchBar,
        FilteredSearchBarController,
        LoadingIndicator,
        Pages,
        ResearcherDashboardController,
        ResearcherSurveySummary,
        ResearcherSurveyTile,
        Scaffold;
import 'package:boo_mondai/features/researcher_dashboard/researcher_dashboard.search.dart';
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ResearcherDashboardPage extends SignalHookWidget {
  const ResearcherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(ResearcherDashboardController.new);
    final tokens = context.themeTokens<AppTokens>();
    final summaries = controller.summaries;
    final searchController = useMemoized(
      () => FilteredSearchBarController<ResearcherSurveySummary>(
        tokenShapes: ResearcherSurveySummarySearch.tokenShapes,
        searchTextLabel: ResearcherSurveySummarySearch.searchTextLabel,
        sorter: ResearcherSurveySummarySearch.sorter,
        items: summaries,
      ),
      const [],
    );

    useListenable(controller);

    useEffect(() {
      controller.load();
      return () {
        searchController.dispose();
        controller.dispose();
      };
    }, [controller, searchController]);

    useEffect(() {
      searchController.setItems(summaries);
      return null;
    }, [summaries, searchController]);

    if (controller.isLoading && controller.surveys.isEmpty) {
      return const Scaffold(
        appBar: AppBar(title: 'Researcher Dashboard'),
        body: Center(child: LoadingIndicator()),
      );
    }

    final visibleSummaries = searchController.hasText.value
        ? searchController.results.value
        : summaries;

    return Scaffold(
      appBar: const AppBar(title: 'Researcher Dashboard'),
      body: Column(
        spacing: tokens.spaceLayoutGapMd,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilteredSearchBar<ResearcherSurveySummary>(
            controller: searchController,
            placeholder: 'Search surveys',
            showFilterButton: false,
            resultLabelBuilder: (summary) => summary.title,
            onResultSelected: (summary) =>
                context.push(Pages.researcherSurveyUrl(summary.id)),
          ),
          if (controller.error != null) ErrorText.exception(controller.error!),
          for (final summary in visibleSummaries)
            ResearcherSurveyTile(
              summary: summary,
              onPressed: () =>
                  context.push(Pages.researcherSurveyUrl(summary.id)),
            ),
        ],
      ),
    );
  }
}
