import 'dart:async';

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppMediaPack,
        Deck,
        DeckDueStats,
        DeckRatingStats,
        DeckReviewStats,
        DueFilterThreshold,
        FlashcardTemplate,
        appMediaPackStore,
        MatchingTypeTemplate,
        MediaAsset,
        MediaSelector,
        SessionException,
        SessionMode,
        StreakController,
        StudySessionAnswer,
        StudySessionCardStageController,
        StudySessionConfig,
        StudySessionController,
        StudyRating,
        StudyRatingHelper,
        StudySessionHelper,
        UiSoundsService,
        WordScrambleController,
        WordScrambleTemplate,
        showModal,
        ModalAction,
        ButtonColor,
        CasingHelper;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:provider/provider.dart' show ReadContext;
import 'package:signals/signals_flutter.dart';

enum SubmissionStyle { showAnswer, submitAnswer, none }

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

    studySessionCompleteSound = appMediaPackStore.resolve(
      (media) => media.studySessionCompleteSound,
    );
    cardStageController = StudySessionCardStageController(
      template: null,
      canReveal: false,
    );

    controllerEffect = effect(() {
      resetCardStageForStep();
      handleCompletion();
    });

    startSession();
  }

  final BuildContext context;
  final Signal<String?> deckId;
  final Signal<SessionMode> mode;
  final StudySessionController sessionController;
  final currentStepId = signal<String?>(null);

  late final MediaAsset studySessionCompleteSound;
  late final StudySessionCardStageController cardStageController;
  late final EffectCleanup controllerEffect;
  final isCompleting = signal(false);

  late final title = computed(() => CasingHelper.toTitleCase(mode.value.name));
  late final isBottomNavBarHidden = computed(() {
    final template = sessionController.currentTemplate.value;
    return template is MatchingTypeTemplate &&
        !cardStageController.isRevealed.value;
  });
  late final reviewStats = computed<DeckReviewStats?>(() {
    final session = sessionController.session.value;
    if (session == null || session.mode != SessionMode.review) return null;

    var again = 0;
    var hard = 0;
    var good = 0;
    var easy = 0;
    for (final snapshot in session.history) {
      switch (snapshot.rating) {
        case StudyRating.again:
        case StudyRating.incorrect:
          again++;
        case StudyRating.hard:
          hard++;
        case StudyRating.good:
          good++;
        case StudyRating.easy:
          easy++;
        case null:
          break;
      }
    }

    final total = session.steps.length;
    final remaining = (total - session.history.length).clamp(0, total).toInt();
    final now = DateTime.now();

    return DeckReviewStats(
      deck: Deck(
        id: session.deckId ?? session.id,
        profileId: session.profileId,
        title: 'Review',
        createdAt: session.startedAt,
        updatedAt: now,
      ),
      due: DeckDueStats(dueReview: remaining),
      ratingStats: DeckRatingStats(
        again: again,
        hard: hard,
        good: good,
        easy: easy,
      ),
    );
  });

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

  SubmissionStyle get submissionStyle {
    final template = sessionController.currentTemplate.value;
    if (template == null) return SubmissionStyle.none;
    return StudySessionHelper.getSubmissionStyle(template);
  }

  void resetCardStageForStep() {
    final step = sessionController.currentStep.value;
    final stepId = step?.id;

    if (currentStepId.value == stepId) return;

    final template = sessionController.currentTemplate.value;
    final studyCard = sessionController.currentStudyCard.value;

    untracked(() {
      currentStepId.value = stepId;
      cardStageController.reset(
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
    });
  }

  void playStudySessionSound(MediaSelector<AppMediaPack> sound) {
    unawaited(UiSoundsService.playIfEnabled(appMediaPackStore.resolve(sound)));
  }

  void submitCurrentAnswer() {
    final template = sessionController.currentTemplate.value;
    if (template == null || !cardStageController.canReveal.value) return;

    final answer = cardStageController.answer.value;
    if (answer != null && StudySessionHelper.isAutoGraded(template)) {
      if (!template.checkAnswer(answer)) {
        playStudySessionSound(
          StudyRatingHelper.getSound(StudyRating.incorrect),
        );
        cardStageController.reveal(
          pendingRating: sessionController.config.autoRateIncorrectAnswers
              ? StudyRating.incorrect
              : null,
        );
        return;
      }

      playStudySessionSound((media) => media.studySessionCorrectSound);
      cardStageController.reveal();
      return;
    }

    playStudySessionSound((media) => media.studySessionRevealSound);
    cardStageController.reveal();
  }

  void continuePendingRating() {
    if (sessionController.isSubmitting.value) return;
    final answer = cardStageController.answer.value;
    final pendingRating = cardStageController.pendingRating.value;
    if (answer == null || pendingRating == null) return;

    playStudySessionSound((media) => media.studySessionContinueSound);
    unawaited(
      sessionController
          .submitAnswer(answer, pendingRating)
          .catchError((Object _, StackTrace _) {}),
    );
  }

  void rateCurrentAnswer(StudyRating type, {bool playSound = true}) {
    if (sessionController.isSubmitting.value) return;
    final template = sessionController.currentTemplate.value;
    final answer = cardStageController.answer.value;
    if (template == null || answer == null) return;

    final effectiveType =
        StudySessionHelper.isAutoGraded(template) &&
            !template.checkAnswer(answer) &&
            sessionController.config.autoRateIncorrectAnswers
        ? StudyRating.incorrect
        : type;

    if (playSound) {
      playStudySessionSound(StudyRatingHelper.getSound(effectiveType));
    }
    unawaited(
      sessionController
          .submitAnswer(answer, effectiveType)
          .catchError((Object _, StackTrace _) {}),
    );
  }

  void handleCompletion() {
    final isComplete = sessionController.isComplete.value;
    final sessionId = sessionController.session.value?.id;

    if (!isComplete || sessionId == null || isCompleting.value) {
      return;
    }
    isCompleting.value = true;

    unawaited(UiSoundsService.playIfEnabled(studySessionCompleteSound));

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
    cardStageController.dispose();
    currentStepId.dispose();
    isBottomNavBarHidden.dispose();
    reviewStats.dispose();
    isCompleting.dispose();
    sessionController.dispose();
    mode.dispose();
    deckId.dispose();
  }
}
