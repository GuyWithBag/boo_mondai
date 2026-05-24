import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/hooks/hooks.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FlashcardCard extends HookWidget {
  const FlashcardCard({
    super.key,
    required this.template,
    required this.reviewCard,
    required this.interactionsController,
    required this.studySessionController,
  });

  final FlashcardTemplate template;
  final ReviewCard reviewCard;
  final StudySessionCardStageController interactionsController;
  final StudySessionController studySessionController;

  @override
  Widget build(BuildContext context) {
    final physicalCardController = useCubeController(
      width: 460,
      height: 644,
      depth: 10,
      perspective: 0.001,
    );

    useEffect(() {
      physicalCardController.showBack(
        interactionsController.isRevealed,
        animated: true,
      );
      return null;
    }, [interactionsController.isRevealed]);

    return PhysicalCard(
      controller: physicalCardController,
      onTap: () => interactionsController.reveal(studySessionController),
      front: FlashcardFrontSide(
        template: template,
        reviewCard: reviewCard,
        onReveal: () => interactionsController.reveal(studySessionController),
      ),
      back: FlashcardBackSide(template: template, reviewCard: reviewCard),
    );
  }
}
