import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        ErrorText,
        FilteredSearchBar,
        ListingStatesWrapper,
        LoadingIndicator,
        Pages,
        ResearcherDashboardController,
        ResearcherExportButton,
        ResearcherSurveyAnalyticsService,
        ResearcherSurveyCharts,
        ResearcherSurveyResponseFilter,
        ResearcherSurveyResponseFilterCodec,
        ResearcherSurveyResponseSearchResults,
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
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class ResearcherSurveyDetailPage extends HookWidget {
  const ResearcherSurveyDetailPage({required this.surveyId, super.key});

  final String surveyId;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(ResearcherDashboardController.new);
    final visibleResponses = useState<List<SurveyResponse>?>(null);
    final tokens = context.themeTokens<AppTokens>();

    useEffect(() {
      controller.load();
      return controller.dispose;
    }, [controller]);

    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<ResearcherDashboardController>(
        builder: (context, controller, _) {
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
              body: Center(child: ErrorText(controller.error!)),
            );
          }

          if (summary == null) {
            return const Scaffold(
              appBar: AppBar(title: 'Survey Data'),
              body: Center(child: Text('Survey not found.')),
            );
          }

          final responses = summary.responses;
          final shownResponses = visibleResponses.value ?? responses;
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
                FilteredSearchBar<
                  SurveyResponse,
                  ResearcherSurveyResponseFilter
                >(
                  filterCodec: const ResearcherSurveyResponseFilterCodec(),
                  searchResults: const ResearcherSurveyResponseSearchResults(),
                  items: responses,
                  placeholder: 'Search responses',
                  showFilterButton: false,
                  resultLabelBuilder: (response) => response.profileId,
                  onResultSelected: (response) => context.push(
                    Pages.researcherSurveyResponseUrl(surveyId, response.id),
                  ),
                  onResultsChanged: (results) =>
                      visibleResponses.value = results,
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
                        Pages.researcherSurveyResponseUrl(
                          surveyId,
                          response.id,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
