import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        BottomNavBar,
        ProgressBar,
        RatingArea,
        Scaffold,
        SessionException,
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

    final tokens = context.themeTokens<AppTokens>();
    final studySessionController = controller.sessionController;
    final step = studySessionController.currentStep.value;
    final template = studySessionController.currentTemplate.value;
    final studyCard = studySessionController.currentStudyCard.value;
    final cardStageController = controller.cardStageController.value;

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
        onPop: controller.onSessionPop,
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
      bottomNavBar: BottomNavBar(
        preferredHeight: 130,
        child: RatingArea(
          studySessionController: studySessionController,
          cardStageController: cardStageController,
          isCompleting: controller.isCompleting.value,
        ),
      ),
      inheritMainBottomNavBarHeight: false,
      body: getBody(),
    );
  }
}
