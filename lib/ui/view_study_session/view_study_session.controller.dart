import 'dart:async';

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppMediaPack,
        DueFilterThreshold,
        FlashcardTemplate,
        NotificationsController,
        SessionException,
        SessionMode,
        SettingsController,
        SettingsService,
        StreakController,
        StudySessionAnswer,
        StudySessionCardStageController,
        StudySessionController,
        UiSoundsService;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:media_variants/media_variants.dart';
import 'package:provider/provider.dart' show ReadContext;
import 'package:signals/signals_flutter.dart';

final class ViewStudySessionController {
  ViewStudySessionController({
    required this.context,
    required String? deckId,
    required SessionMode mode,
  }) : deckId = signal(deckId),
       mode = signal(mode),
       sessionController = StudySessionController(
         mode: mode,
         notificationsController: mode == SessionMode.drill
             ? context.read<NotificationsController>()
             : null,
       ) {
    if (this.deckId.value == null && this.mode.value == SessionMode.drill) {
      throw SessionException(
        'A deck is required for drill.',
        code: 'DRILL_DECK_MISSING',
      );
    }

    settingsController = context.read<SettingsController>();
    studySessionCompleteSound = context
        .mediaPackController<AppMediaPack>()
        .resolve((media) => media.studySessionCompleteSound);
    cardStageController = signal(
      StudySessionCardStageController(canReveal: false),
    );

    controllerEffect = effect(() {
      syncCardStageController();
      handleCompletion();
    });

    startSession();
  }

  final BuildContext context;
  final Signal<String?> deckId;
  final Signal<SessionMode> mode;
  final StudySessionController sessionController;
  final currentStepId = signal<String?>(null);

  late final SettingsController settingsController;
  late final MediaAsset studySessionCompleteSound;
  late final Signal<StudySessionCardStageController> cardStageController;
  late final EffectCleanup controllerEffect;
  final isCompleting = signal(false);

  void startSession() {
    unawaited(
      sessionController
          .startSession(
            deckId: deckId.value,
            // ToDo: look into
            filter: DueFilterThreshold.lookAheadOneDay,
          )
          .catchError((Object _, StackTrace _) {}),
    );
  }

  void syncCardStageController() {
    final step = sessionController.currentStep.value;
    final stepId = step?.id;

    if (currentStepId.value == stepId) return;

    final template = sessionController.currentTemplate.value;
    final studyCard = sessionController.currentStudyCard.value;
    final nextController = StudySessionCardStageController(
      canReveal: template is FlashcardTemplate,
      answer: template is FlashcardTemplate && studyCard != null
          ? StudySessionAnswer(
              value: template.getAnswer(isReversed: studyCard.isReversed),
            )
          : null,
    );

    final previousController = untracked(() => cardStageController.value);
    untracked(() {
      currentStepId.value = stepId;
      cardStageController.value = nextController;
    });
    previousController.dispose();
  }

  void handleCompletion() {
    final isComplete = sessionController.isComplete.value;
    final sessionId = sessionController.session.value?.id;

    if (!isComplete || sessionId == null || isCompleting.value) {
      return;
    }
    isCompleting.value = true;

    unawaited(
      UiSoundsService.playIfEnabled(
        studySessionCompleteSound,
        settingsController: settingsController,
        enabledSetting: SettingsService.uiSoundsEnabled,
      ),
    );

    unawaited(() async {
      try {
        await sessionController.completeSession();
      } catch (_) {
        isCompleting.value = false;
        return;
      }

      if (!context.mounted) return;

      if (mode.value == SessionMode.review) {
        context.read<StreakController>().recordActivity(DateTime.now());
        context.go('/review/$sessionId/result');
        return;
      }

      if (mode.value == SessionMode.drill) {
        context.go('/drill/$sessionId/result');
      }
    }());
  }

  void onSessionPop() {
    context.pop();
  }

  void onReviewCompletePressed() {
    sessionController.reset();
    context.pop();
  }

  void dispose() {
    controllerEffect();
    cardStageController.value.dispose();
    cardStageController.dispose();
    currentStepId.dispose();
    isCompleting.dispose();
    sessionController.dispose();
    mode.dispose();
    deckId.dispose();
  }
}
