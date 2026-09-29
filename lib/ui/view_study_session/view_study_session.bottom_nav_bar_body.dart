import 'package:boo_mondai/features/app_theme/bottom_nav_bar.dart'
    show BottomNavBar;
import 'package:boo_mondai/features/cards/models/card.template.dto.dart';
import 'package:boo_mondai/features/cards/models/word_scramble.template.dart';
import 'package:boo_mondai/features/study_session/study_session.controller.dart';
import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:boo_mondai/ui/study_session.card_stage/study_session.card_stage.controller.dart';
import 'package:boo_mondai/ui/study_session.card_stage/widgets/rating_area.dart';
import 'package:boo_mondai/ui/study_session.card_stage/widgets/word_bank.dart';
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewStudySessionBottomNavBarBody extends SignalHookWidget {
  const ViewStudySessionBottomNavBarBody({
    required this.template,
    required this.studySessionController,
    required this.cardStageController,
    required this.isCompleting,
    super.key,
  });

  final CardTemplate? template;
  final StudySessionController studySessionController;
  final StudySessionCardStageController cardStageController;
  final bool isCompleting;

  static double preferredHeight({
    required CardTemplate? template,
    required StudySessionCardStageController cardStageController,
  }) {
    if (_shouldShowWordBank(template, cardStageController)) {
      return WordBank.preferredHeight + RatingArea.preferredHeight;
    }
    return RatingArea.preferredHeight;
  }

  @override
  Widget build(BuildContext context) {
    final wordController = cardStageController.wordScrambleController;
    final tokens = context.themeTokens<AppTokens>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: tokens.spaceLayoutGapSm,
      children: [
        if (_shouldShowWordBank(template, cardStageController) &&
            wordController != null)
          WordBank(controller: wordController),
        RatingArea(
          studySessionController: studySessionController,
          cardStageController: cardStageController,
          isCompleting: isCompleting,
        ),
      ],
    );
  }

  static bool _shouldShowWordBank(
    CardTemplate? template,
    StudySessionCardStageController cardStageController,
  ) {
    return template is WordScrambleTemplate &&
        !cardStageController.isRevealed.value;
  }
}
