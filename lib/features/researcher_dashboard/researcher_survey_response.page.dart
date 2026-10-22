import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        ErrorText,
        LoadingIndicator,
        ResearcherDashboardController,
        ResearcherSurveyPreview,
        Scaffold;
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class ResearcherSurveyResponsePage extends HookWidget {
  const ResearcherSurveyResponsePage({
    required this.surveyId,
    required this.responseId,
    super.key,
  });

  final String surveyId;
  final String responseId;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(ResearcherDashboardController.new);

    useEffect(() {
      controller.load();
      return controller.dispose;
    }, [controller]);

    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<ResearcherDashboardController>(
        builder: (context, controller, _) {
          final summary = controller.summaryBySurveyId(surveyId);
          final response = summary?.responses
              .where((response) => response.id == responseId)
              .firstOrNull;

          if (controller.isLoading && summary == null) {
            return const Scaffold(
              appBar: AppBar(title: 'Survey Response'),
              body: Center(child: LoadingIndicator()),
            );
          }

          if (controller.error != null) {
            return Scaffold(
              appBar: const AppBar(title: 'Survey Response'),
              body: Center(child: ErrorText.exception(controller.error!)),
            );
          }

          if (summary == null || response == null) {
            return const Scaffold(
              appBar: AppBar(title: 'Survey Response'),
              body: Center(child: Text('Response not found.')),
            );
          }

          return Scaffold(
            appBar: AppBar(title: summary.title),
            body: ResearcherSurveyPreview(
              definition: summary.definition,
              response: response,
            ),
          );
        },
      ),
    );
  }
}
