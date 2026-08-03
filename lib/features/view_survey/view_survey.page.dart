import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        BottomNavBar,
        Button,
        ButtonColor,
        ErrorText,
        LoadingIndicator,
        MarkdownText,
        MarkdownTextMode,
        ProgressBar,
        Scaffold,
        ViewSurveyController,
        SurveyBlockField;
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewSurveyPage extends HookWidget {
  const ViewSurveyPage({super.key, required this.assignmentId});

  final String assignmentId;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(ViewSurveyController.new);
    final tokens = context.themeTokens<AppTokens>();

    useEffect(() {
      controller.load(assignmentId);
      return controller.dispose;
    }, [assignmentId]);

    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<ViewSurveyController>(
        builder: (context, controller, _) {
          final survey = controller.survey;
          final page = controller.currentPage;

          if (controller.isLoading && survey == null) {
            return const Scaffold(body: Center(child: LoadingIndicator()));
          }

          if (controller.error != null) {
            return Scaffold(
              appBar: const AppBar(title: 'Survey'),
              body: Center(child: ErrorText(controller.error!)),
            );
          }

          if (survey == null || page == null) {
            return const Scaffold(
              appBar: AppBar(title: 'Survey'),
              body: Center(child: Text('Survey is empty.')),
            );
          }

          if (controller.isSubmitted) {
            return Scaffold(
              appBar: AppBar(title: survey.title),
              bottomNavBar: BottomNavBar(
                child: Button(
                  onPressed: () => context.go('/'),
                  variants: const [ButtonColor.primary],
                  child: const Text('Done'),
                ),
              ),
              inheritMainBottomNavBarHeight: false,
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Submitted',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: tokens.spaceLayoutGapMd),
                    const Text(
                      'Your response has been recorded.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: survey.title,
              child: ProgressBar(value: controller.progress),
            ),
            bottomNavBar: BottomNavBar(
              child: Row(
                spacing: tokens.spaceLayoutGapSm,
                children: [
                  Expanded(
                    child: Button(
                      onPressed: controller.canGoBack ? controller.back : null,
                      child: const Text('Back'),
                    ),
                  ),
                  Expanded(
                    child: Button(
                      onPressed: controller.isLoading
                          ? null
                          : controller.isLastPage
                          ? controller.submit
                          : controller.next,
                      variants: const [ButtonColor.primary],
                      child: Text(controller.isLastPage ? 'Submit' : 'Next'),
                    ),
                  ),
                ],
              ),
            ),
            inheritMainBottomNavBarHeight: false,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: tokens.spaceLayoutGapLg,
              children: [
                if (page.page.title != null)
                  Text(
                    page.page.title!,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                if (survey.description.isNotEmpty && controller.pageIndex == 0)
                  MarkdownText(
                    data: survey.description,
                    mode: MarkdownTextMode.previewSelectable,
                    defaultMarkdownAlignment: WrapAlignment.start,
                  ),
                for (final block in page.blocks) SurveyBlockField(block: block),
                if (controller.error != null) ErrorText(controller.error!),
              ],
            ),
          );
        },
      ),
    );
  }
}
