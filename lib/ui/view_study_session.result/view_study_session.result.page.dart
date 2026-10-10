// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_result_page.dart
// PURPOSE: Display quiz results with score animation and FSRS review prompt
// HOOKS: useAnimationController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/core.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AnswerResultTile,
        AppBar,
        AppTokens,
        BottomNavBar,
        Scaffold,
        StudyRatingBreakdown,
        ViewStudySessionResultController,
        Button,
        ButtonColor;
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart'
    show useAnimationController, useEffect, useMemoized;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewStudySessionResultPage extends SignalHookWidget {
  const ViewStudySessionResultPage({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(
      () => ViewStudySessionResultController(sessionId: sessionId),
      [sessionId],
    );
    useEffect(() => controller.dispose, [controller]);
    final tokens = context.themeTokens<AppTokens>();
    final hasPrimaryAction = controller.hasPrimaryAction.value;
    final cardAnswers = controller.cardAnswers.value;

    final scoreAnim = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );

    useEffect(() {
      scoreAnim.forward();
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: 'Results'),
      bottomNavBar: BottomNavBar(
        child: Row(
          spacing: tokens.spaceLayoutGapSm,
          children: [
            Button(
              variants: controller.backButtonVariants.value,
              onPressed: () => controller.onBackPressed(context),
              child: Text(controller.backButtonLabel.value),
            ),
            if (hasPrimaryAction)
              Expanded(
                child: Tooltip(
                  message: controller.primaryActionTooltip.value,
                  child: Button(
                    onPressed: () => controller.primaryAction(context),
                    variants: [ButtonColor.primary],
                    child: Text(controller.primaryActionLabel.value),
                  ),
                ),
              ),
          ],
        ),
      ),
      body: Column(
        spacing: tokens.spaceLayoutGapMd,
        children: [
          StudyRatingBreakdown(
            animation: scoreAnim,
            breakdown: controller.breakdown.value,
            total: controller.totalCards.value,
          ),

          // The list of individual answers
          if (cardAnswers.isNotEmpty)
            ListingStatesWrapper.list(
              items: cardAnswers,
              useParentScroll: true,
              separatorHeight: tokens.spaceLayoutGapSm,
              itemBuilder: (context, _, answer) {
                return AnswerResultTile(
                  answerValue: answer.answerValue,
                  type: answer.type,
                  isEjected: false,
                );
              },
            )
          else
            Text('No answers recorded'),
        ],
      ),
    );
  }
}
