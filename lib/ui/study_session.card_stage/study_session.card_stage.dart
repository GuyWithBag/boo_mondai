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

    useEffect(() {
      showSubmitHint.value = false;
      if (stepId == null || isRevealed) return null;

      final timer = Timer(const Duration(seconds: 3), () {
        showSubmitHint.value = true;
      });

      return timer.cancel;
    }, [stepId, isRevealed]);

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
        final hasSubmitHint = showSubmitHint.value && !isRevealed;
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : tokens.studyCardWidth;
        final hintReserve = hasSubmitHint ? 56.0 : 0.0;
        final availableCardHeight = constraints.maxHeight.isFinite
            ? math.max(
                1.0,
                constraints.maxHeight - tokens.spaceLayoutGapSm - hintReserve,
              )
            : double.infinity;
        final maxWidthFromHeight = availableCardHeight.isFinite
            ? availableCardHeight * PhysicalCardController.defaultAspectRatio
            : tokens.studyCardWidth;
        final cardMaxWidth = math.min(
          math.min(tokens.studyCardWidth, availableWidth),
          maxWidthFromHeight,
        );

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: tokens.spaceLayoutGapSm,
            children: [
              buildCard(cardMaxWidth),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: hasSubmitHint
                    ? Text(
                        "Don't know this one? Submit an incorrect answer and try again.",
                        key: const ValueKey('submit-hint'),
                        textAlign: TextAlign.center,
                        style: textStyle.resolve(tokens, const [
                          TextSize.labelSmall,
                          TextWeight.strong,
                          TextColor.error,
                        ]),
                      )
                    : const SizedBox.shrink(key: ValueKey('submit-hint-empty')),
              ),
            ],
          ),
        );
      },
    );
  }
}
