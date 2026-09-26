import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        ErrorText,
        FilteredSearchBar,
        FilteredSearchBarController,
        ListingStatesWrapper,
        LoadingIndicator,
        Pages,
        ResearcherDashboardController,
        ResearcherExportButton,
        ResearcherSurveyAnalyticsService,
        ResearcherSurveyCharts,
        Scaffold,
        StatusLayoutState,
        SurfaceColor,
        SurfaceShadow,
        SurveyResponse,
        surfaceStyle,
        textStyle,
        TextColor,
        TextSize,
        TextWeight;
import 'package:boo_mondai/features/researcher_dashboard/researcher_dashboard.search.dart';
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ResearcherSurveyDetailPage extends SignalHookWidget {
  const ResearcherSurveyDetailPage({required this.surveyId, super.key});

  final String surveyId;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(ResearcherDashboardController.new);
    final tokens = context.themeTokens<AppTokens>();
    final searchController = useMemoized(
      () => FilteredSearchBarController<SurveyResponse>(
        tokenShapes: ResearcherSurveyResponseSearch.tokenShapes,
        searchTextLabel: ResearcherSurveyResponseSearch.searchTextLabel,
        sorter: ResearcherSurveyResponseSearch.sorter,
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

    final summary = controller.summaryBySurveyId(surveyId);

    if (controller.isLoading && summary == null) {
      return const Scaffold(
        appBar: AppBar(title: 'Survey Data'),
        body: Center(child: LoadingIndicator()),
      );
    }

    if (controller.error != null) {
      return Scaffold(
        appBar: const AppBar(title: 'Survey Data'),
        body: Center(child: ErrorText.exception(controller.error!)),
      );
    }

    if (summary == null) {
      return const Scaffold(
        appBar: AppBar(title: 'Survey Data'),
        body: Center(child: Text('Survey not found.')),
      );
    }

    final responses = summary.responses;
    useEffect(() {
      searchController.setItems(responses);
      return null;
    }, [responses, searchController]);

    final shownResponses = searchController.hasText.value
        ? searchController.results.value
        : responses;
    final aggregates = ResearcherSurveyAnalyticsService.aggregate(
      definition: summary.definition,
      responses: responses,
    );

    return Scaffold(
      appBar: AppBar(
        title: summary.title,
        actions: [
          ResearcherExportButton(
            definition: summary.definition,
            responses: responses,
          ),
        ],
      ),
      body: Column(
        spacing: tokens.spaceLayoutGapLg,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Surface(
            style: surfaceStyle.resolve(tokens, const [
              SurfaceColor.baseline,
              SurfaceShadow.none,
            ]),
            child: Column(
              spacing: tokens.spaceLayoutGapSm,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${responses.length} responses',
                  style: textStyle.resolve(tokens, const [
                    TextSize.header,
                    TextWeight.heavy,
                  ]),
                ),
                if (summary.description.trim().isNotEmpty)
                  Text(
                    summary.description,
                    style: textStyle.resolve(tokens, const [
                      TextSize.label,
                      TextColor.muted,
                    ]),
                  ),
              ],
            ),
          ),
          Text(
            'Analytics',
            style: textStyle.resolve(tokens, const [
              TextSize.header,
              TextWeight.heavy,
            ]),
          ),
          ResearcherSurveyCharts(aggregates: aggregates),
          Text(
            'Responses',
            style: textStyle.resolve(tokens, const [
              TextSize.header,
              TextWeight.heavy,
            ]),
          ),
          FilteredSearchBar<SurveyResponse>(
            controller: searchController,
            placeholder: 'Search responses',
            showFilterButton: false,
            resultLabelBuilder: (response) => response.profileId,
            onResultSelected: (response) => context.push(
              Pages.researcherSurveyResponseUrl(surveyId, response.id),
            ),
          ),
          ListingStatesWrapper<SurveyResponse>.list(
            useParentScroll: true,
            isLoading: controller.isLoading,
            exception: controller.error,
            items: shownResponses,
            emptyState: const StatusLayoutState(
              icon: Icons.assignment_outlined,
              title: 'No responses yet',
              message: 'Submitted survey responses will appear here.',
            ),
            onRetry: controller.load,
            itemBuilder: (context, index, response) {
              return ListTile(
                leading: const Icon(Icons.assignment_turned_in_outlined),
                title: Text('Response ${index + 1}'),
                subtitle: Text(
                  '${response.profileId}\n'
                  '${response.submittedAt.toLocal()}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(
                  Pages.researcherSurveyResponseUrl(surveyId, response.id),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
