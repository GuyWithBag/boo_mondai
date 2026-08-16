import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        ErrorText,
        FilteredSearchBar,
        LoadingIndicator,
        Pages,
        ResearcherDashboardController,
        ResearcherSurveyFilter,
        ResearcherSurveyFilterCodec,
        ResearcherSurveySearchResults,
        ResearcherSurveySummary,
        ResearcherSurveyTile,
        Scaffold;
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class ResearcherDashboardPage extends HookWidget {
  const ResearcherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(ResearcherDashboardController.new);
    final visibleSummaries = useState<List<ResearcherSurveySummary>>(const []);
    final tokens = context.themeTokens<AppTokens>();

    useEffect(() {
      controller.load();
      return controller.dispose;
    }, [controller]);

    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<ResearcherDashboardController>(
        builder: (context, controller, _) {
          if (controller.isLoading && controller.surveys.isEmpty) {
            return const Scaffold(
              appBar: AppBar(title: 'Researcher Dashboard'),
              body: Center(child: LoadingIndicator()),
            );
          }

          final summaries = controller.summaries;

          return Scaffold(
            appBar: const AppBar(title: 'Researcher Dashboard'),
            body: Column(
              spacing: tokens.spaceLayoutGapMd,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilteredSearchBar<
                  ResearcherSurveySummary,
                  ResearcherSurveyFilter
                >(
                  filterCodec: const ResearcherSurveyFilterCodec(),
                  searchResults: const ResearcherSurveySearchResults(),
                  items: summaries,
                  placeholder: 'Search surveys',
                  showFilterButton: false,
                  onResultsChanged: (results) =>
                      visibleSummaries.value = results,
                  resultLabelBuilder: (summary) => summary.title,
                  onResultSelected: (summary) =>
                      context.push(Pages.researcherSurveyUrl(summary.id)),
                ),
                if (controller.error != null)
                  ErrorText.exception(controller.error!),
                for (final summary
                    in visibleSummaries.value.isEmpty
                        ? summaries
                        : visibleSummaries.value)
                  ResearcherSurveyTile(
                    summary: summary,
                    onPressed: () =>
                        context.push(Pages.researcherSurveyUrl(summary.id)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
