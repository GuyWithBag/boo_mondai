import 'package:boo_mondai/features/cards/models/card.template.dto.dart';
import 'package:boo_mondai/features/cards/models/word_scramble.template.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ViewStudySessionController, WordScrambleController;
import 'package:boo_mondai/ui/study_session.card_stage/widgets/rating_area.dart';
import 'package:boo_mondai/ui/study_session.card_stage/widgets/word_bank.dart';
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewStudySessionBottomNavBarBody extends SignalHookWidget {
  const ViewStudySessionBottomNavBarBody({required this.controller, super.key});

  final ViewStudySessionController controller;

  static double preferredHeight({
    required CardTemplate? template,
    required ViewStudySessionController controller,
  }) {
    if (_shouldShowWordBank(template, controller)) {
      return WordBank.preferredHeight + RatingArea.preferredHeight;
    }
    return RatingArea.preferredHeight;
  }

  @override
  Widget build(BuildContext context) {
    final template = controller.sessionController.currentTemplate.value;
    final cardStageController = controller.cardStageController;
    final wordController =
        cardStageController.cardController is WordScrambleController
        ? cardStageController.cardController! as WordScrambleController
        : null;
    final tokens = context.themeTokens<AppTokens>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: tokens.spaceLayoutGapSm,
      children: [
        if (_shouldShowWordBank(template, controller) && wordController != null)
          WordBank(controller: wordController),
        RatingArea(controller: controller),
      ],
    );
  }

  static bool _shouldShowWordBank(
    CardTemplate? template,
    ViewStudySessionController controller,
  ) {
    return template is WordScrambleTemplate &&
        !controller.cardStageController.isRevealed.value;
  }
}
