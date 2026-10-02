import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        BottomNavBar,
        ProgressBar,
        Scaffold,
        SessionException,
        SessionRatingStatsBlock,
        SessionRatingStatsBlockController,
        SessionRatingStatsMode,
        SessionMode,
        StatusLayoutState,
        StudySessionCardStage,
        StudySessionMessageStep,
        TextColor,
        TextSize,
        TextWeight,
        ViewMessageSessionStepPage,
        ViewStudySessionController,
        textStyle;
import 'package:boo_mondai/ui/view_study_session/view_study_session.bottom_nav_bar_body.dart';
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewStudySessionPage extends SignalHookWidget {
  const ViewStudySessionPage({
    super.key,
    required this.deckId,
    required this.mode,
  });

  final String? deckId;
  final SessionMode mode;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(
      () => ViewStudySessionController(
        context: context,
        deckId: deckId,
        mode: mode,
      ),
      [deckId, mode],
    );

    useEffect(() => controller.dispose, [controller]);
    final ratingStatsController = useMemoized(
      () => SessionRatingStatsBlockController(
        initialMode: SessionRatingStatsMode.ratingStats,
        showText: true,
      ),
      [controller],
    );
    useEffect(() => ratingStatsController.dispose, [ratingStatsController]);

    final tokens = context.themeTokens<AppTokens>();
    final studySessionController = controller.sessionController;
    final step = studySessionController.currentStep.value;
    final template = studySessionController.currentTemplate.value;
    final studyCard = studySessionController.currentStudyCard.value;
    final cardStageController = controller.cardStageController;
    final reviewStats = controller.reviewStats.value;

    // if (studySessionController.error.value != null) {
    //   return StatusLayoutState.exception(
    //     exception: studySessionController.error.value,
    //   );
    // }

    if (step is StudySessionMessageStep) {
      return ViewMessageSessionStepPage(
        step: step,
        controller: studySessionController,
        studySessionPageController: controller,
      );
    }

    Widget getBody() {
      if (studySessionController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.isCompleting.value ||
          studySessionController.isFinished.value == true) {
        return const StatusLayoutState(
          leading: CircularProgressIndicator(),
          title: 'Saving results...',
          message: '',
        );
      }
      if (template == null || studyCard == null) {
        return StatusLayoutState.exception(
          exception: SessionException(
            'Active card is missing.',
            code: 'SESSION_CARD_MISSING',
          ),
        );
      }
      return StudySessionCardStage(
        studySessionController: studySessionController,
        cardStageController: cardStageController,
      );
    }

    return Scaffold(
      scrollable: false,
      appBar: AppBar(
        onPop: () => controller.onPop(context),
        title: controller.title.value,
        preferredHeaderHeight: 30,
        header: Padding(
          padding: EdgeInsets.only(top: tokens.spaceLayoutGapSm),
          child: Row(
            spacing: tokens.spaceLayoutGapMd,
            children: [
              Expanded(
                child: ProgressBar(
                  value: studySessionController.stepProgressPercentage.value,
                ),
              ),
              Text(
                '${studySessionController.currentStepIndex.value + 1} / ${studySessionController.totalStepCount.value}',
                style: textStyle.resolve(tokens, [
                  TextSize.labelSmall,
                  TextWeight.heavy,
                  TextColor.muted,
                ]),
              ),
            ],
          ),
        ),
        child: (mode == SessionMode.review && reviewStats != null)
            ? SizedBox(
                width: 120,
                child: SessionRatingStatsBlock(
                  stats: reviewStats,
                  controller: ratingStatsController,
                ),
              )
            : null,
      ),
      bottomNavBar: !controller.isBottomNavBarHidden.value
          ? BottomNavBar(
              preferredHeight: ViewStudySessionBottomNavBarBody.preferredHeight(
                template: template,
                controller: controller,
              ),
              child: ViewStudySessionBottomNavBarBody(controller: controller),
            )
          : null,
      inheritMainBottomNavBarHeight: false,
      body: getBody(),
    );
  }
}
