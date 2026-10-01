import 'dart:async';

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppMediaPack,
        CardTemplateController,
        DueFilterThreshold,
        FlashcardTemplate,
        NotificationsController,
        SessionException,
        SessionMode,
        SettingPath,
        SettingsStore,
        StreakController,
        StudySessionAnswer,
        StudySessionCardStageController,
        StudySessionConfig,
        StudySessionController,
        UiSoundsService,
        WordScrambleController,
        WordScrambleTemplate,
        showModal,
        ModalAction,
        ButtonColor;
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
         config: switch (mode) {
           SessionMode.drill => const StudySessionConfig.drill(),
           SessionMode.review => const StudySessionConfig.spacedRepitition(
             requeueAgainWhenIntervalLessThan: Duration(minutes: 10),
           ),
         },
       ) {
    if (this.deckId.value == null && this.mode.value == SessionMode.drill) {
      throw SessionException(
        'A deck is required for drill.',
        code: 'DRILL_DECK_MISSING',
      );
    }

    studySessionCompleteSound = context
        .mediaPackController<AppMediaPack>()
        .resolve((media) => media.studySessionCompleteSound);
    cardStageController = signal(
      StudySessionCardStageController<CardTemplateController>(
        template: null,
        canReveal: false,
      ),
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

  final SettingsStore settingsStore = SettingsStore.instance;
  late final MediaAsset studySessionCompleteSound;
  late final Signal<StudySessionCardStageController<CardTemplateController>>
  cardStageController;
  late final EffectCleanup controllerEffect;
  final isCompleting = signal(false);

  late final title = computed(() => mode.name);

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
    final nextController =
        StudySessionCardStageController<CardTemplateController>(
          template: template,
          canReveal: template is FlashcardTemplate,
          answer: template is FlashcardTemplate && studyCard != null
              ? StudySessionAnswer(
                  value: template.getAnswer(isReversed: studyCard.isReversed),
                )
              : null,
          createCardController: template is WordScrambleTemplate
              ? (stage) => WordScrambleController(
                  template: template,
                  answer: stage.answer,
                  canReveal: stage.canReveal,
                  isRevealed: stage.isRevealed,
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
        settingsStore: settingsStore,
        enabledSetting: SettingPath.uiSoundsEnabled,
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

  Future<void> onPop(BuildContext context) async {
    final res = await showModal(
      context: context,
      leading: Icon(Icons.dangerous),
      title: 'Exit Session?',
      subtitle: 'Exiting will discard your current progress.',
      actionsMainAxisAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        ModalAction(label: 'Go Back', value: false),
        ModalAction(label: 'Exit', value: true, color: ButtonColor.primary),
      ],
    );
    if (res != true) {
      return;
    }
    if (!context.mounted) return;
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
