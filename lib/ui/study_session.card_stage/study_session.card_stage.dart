import 'dart:async';
import 'dart:math' as math;

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        StudySessionController,
        FlashcardTemplate,
        IdentificationTemplate,
        StudySessionCardStageController,
        PhysicalCardController,
        CardTemplate,
        MultipleChoiceTemplate,
        FillInTheBlanksTemplate,
        MatchingTypeTemplate,
        WordScrambleTemplate,
        FlashcardCard,
        MultipleChoiceCard,
        FillInTheBlanksCard,
        MatchingTypeCard,
        IdentificationCard,
        WordScrambleCard,
        TextColor,
        TextSize,
        TextWeight,
        textStyle;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class StudySessionCardStage extends SignalHookWidget {
  const StudySessionCardStage({
    required this.studySessionController,
    required this.cardStageController,
    super.key,
  });

  final StudySessionController studySessionController;
  final StudySessionCardStageController cardStageController;

  // Temporary helper
  static bool isImplemented(CardTemplate template) {
    return template is FlashcardTemplate ||
        template is MultipleChoiceTemplate ||
        template is IdentificationTemplate ||
        template is FillInTheBlanksTemplate ||
        template is MatchingTypeTemplate ||
        template is WordScrambleTemplate;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final template = studySessionController.currentTemplate.value;
    final studyCard = studySessionController.currentStudyCard.value;
    final stepId = studySessionController.currentStep.value?.id;
    final isRevealed = cardStageController.isRevealed.value;
    final showSubmitHint = useState(false);
    final submitHint = template == null ? null : submitHintFor(template);

    useEffect(() {
      showSubmitHint.value = false;
      if (stepId == null || isRevealed || submitHint == null) return null;

      final timer = Timer(submitHint.delay, () {
        showSubmitHint.value = true;
      });

      return timer.cancel;
    }, [stepId, isRevealed, submitHint]);

    if (template == null || studyCard == null) {
      return const Center(child: Text('No card available'));
    }

    Widget buildCard(double maxWidth) {
      return switch (template) {
        FlashcardTemplate f => FlashcardCard(
          template: f,
          studyCard: studyCard,
          cardStageController: cardStageController,
          maxWidth: maxWidth,
        ),
        MultipleChoiceTemplate m => MultipleChoiceCard(
          template: m,
          cardStageController: cardStageController,
          maxWidth: maxWidth,
        ),
        IdentificationTemplate i => IdentificationCard(
          template: i,
          cardStageController: cardStageController,
          maxWidth: maxWidth,
        ),
        FillInTheBlanksTemplate fb => FillInTheBlanksCard(
          template: fb,
          cardStageController: cardStageController,
          maxWidth: maxWidth,
        ),
        MatchingTypeTemplate mm => MatchingTypeCard(
          template: mm,
          cardStageController: cardStageController,
          maxWidth: maxWidth,
        ),
        WordScrambleTemplate ws => WordScrambleCard(
          template: ws,
          cardStageController: cardStageController,
          maxWidth: maxWidth,
        ),
        _ => Center(
          // Replace with error text
          child: Text(
            'Unsupported card type: ${template.runtimeType}',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      };
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasSubmitHint =
            showSubmitHint.value && !isRevealed && submitHint != null;

        return Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, cardConstraints) {
                  final availableWidth = cardConstraints.maxWidth.isFinite
                      ? cardConstraints.maxWidth
                      : tokens.studyCardWidth;
                  final availableHeight = cardConstraints.maxHeight.isFinite
                      ? cardConstraints.maxHeight
                      : double.infinity;
                  final maxWidthFromHeight = availableHeight.isFinite
                      ? availableHeight *
                            PhysicalCardController.defaultAspectRatio
                      : tokens.studyCardWidth;
                  final cardMaxWidth = math.min(
                    math.min(tokens.studyCardWidth, availableWidth),
                    maxWidthFromHeight,
                  );

                  return Center(child: buildCard(cardMaxWidth));
                },
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: hasSubmitHint
                  ? Padding(
                      key: const ValueKey('submit-hint'),
                      padding: EdgeInsets.only(top: tokens.spaceLayoutGapSm),
                      child: Text(
                        submitHint.message,
                        textAlign: TextAlign.center,
                        style: textStyle.resolve(tokens, const [
                          TextSize.labelSmall,
                          TextWeight.strong,
                          TextColor.error,
                        ]),
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('submit-hint-empty')),
            ),
          ],
        );
      },
    );
  }

  ({Duration delay, String message}) submitHintFor(CardTemplate template) {
    return switch (template) {
      FlashcardTemplate() => (
        delay: const Duration(seconds: 15),
        message: 'Don\'t know this one? Show the answer and rate "Again".',
      ),
      FillInTheBlanksTemplate() || IdentificationTemplate() => (
        delay: const Duration(seconds: 8),
        message:
            'Don\'t know this one? Submit an incorrect answer, then rate "Again".',
      ),
      MultipleChoiceTemplate() ||
      WordScrambleTemplate() ||
      MatchingTypeTemplate() => (
        delay: const Duration(seconds: 10),
        message: 'Don\'t know this one? Get it incorrect, then rate "Again".',
      ),
      _ => (
        delay: const Duration(seconds: 10),
        message: 'Don\'t know this one? Get it incorrect, then rate "Again".',
      ),
    };
  }
}
