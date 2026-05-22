import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';

class FlashcardCard extends StatelessWidget {
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
    return GestureDetector(
      onTap: () => interactionsController.reveal(studySessionController),
      child: AnimatedFlip(
        showBack: interactionsController.isRevealed,
        front: FlashcardFrontSide(
          template: template,
          reviewCard: reviewCard,
          onReveal: () => interactionsController.reveal(studySessionController),
        ),
        back: FlashcardBackSide(template: template, reviewCard: reviewCard),
      ),
    );
  }
}
