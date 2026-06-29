import 'package:boo_mondai/core/core.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        FlashcardTemplate,
        StudyCard,
        StudySessionCardStageController,
        StudySessionController,
        FlashcardFrontSide,
        FlashcardBackSide,
        PhysicalCardController,
        PhysicalCard;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlashcardCard extends HookWidget {
  const FlashcardCard({
    super.key,
    required this.template,
    required this.studyCard,
    required this.interactionsController,
    required this.studySessionController,
  });

  final FlashcardTemplate template;
  final StudyCard studyCard;
  final StudySessionCardStageController interactionsController;
  final StudySessionController studySessionController;

  @override
  Widget build(BuildContext context) {
    final physicalCardController = usePhysicalCardController(
      context,
      width: 300.w,
    );

    useEffect(() {
      physicalCardController.showBack(
        interactionsController.isRevealed,
        animated: true,
      );
      return null;
    }, [physicalCardController, interactionsController.isRevealed]);

    useEffect(() => physicalCardController.dispose, [physicalCardController]);

    return PhysicalCard(
      controller: physicalCardController,
      onTap: () => interactionsController.reveal(studySessionController),
      front: FlashcardFrontSide(
        template: template,
        studyCard: studyCard,
        onReveal: () => interactionsController.reveal(studySessionController),
      ),
      back: FlashcardBackSide(template: template, studyCard: studyCard),
    );
  }
}
