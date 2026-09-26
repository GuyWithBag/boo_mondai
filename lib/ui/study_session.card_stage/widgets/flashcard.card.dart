import 'package:boo_mondai/core/core.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        FlashcardTemplate,
        StudyCard,
        StudySessionCardStageController,
        FlashcardFrontSide,
        FlashcardBackSide,
        PhysicalCard,
        PhysicalCardController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FlashcardCard extends HookWidget {
  const FlashcardCard({
    super.key,
    required this.template,
    required this.studyCard,
    this.cardStageController,
    this.isRevealed = false,
    this.showRevealButton = true,
    this.maxWidth,
    this.contentScale = 1,
    this.controller,
  });

  final FlashcardTemplate template;
  final StudyCard studyCard;
  final StudySessionCardStageController? cardStageController;
  final bool isRevealed;
  final bool showRevealButton;
  final double? maxWidth;
  final double contentScale;
  final PhysicalCardController? controller;

  @override
  Widget build(BuildContext context) {
    final fallbackPhysicalCardController = usePhysicalCardController(
      context,
      width: maxWidth,
      perspective: 0.001,
    );
    final physicalCardController = controller ?? fallbackPhysicalCardController;
    final effectiveIsRevealed =
        isRevealed || cardStageController?.isRevealed.value == true;

    useEffect(() {
      physicalCardController.showBack(
        effectiveIsRevealed,
        animated: cardStageController != null,
      );
      return null;
    }, [physicalCardController, effectiveIsRevealed, cardStageController]);

    void reveal() {
      final cardStageController = this.cardStageController;
      if (cardStageController == null) {
        return;
      }
      cardStageController.reveal();
    }

    return PhysicalCard(
      controller: physicalCardController,
      padding: EdgeInsets.zero,
      onTap: cardStageController == null ? null : reveal,
      front: FlashcardFrontSide(
        template: template,
        studyCard: studyCard,
        showRevealButton: showRevealButton && cardStageController != null,
        contentScale: contentScale,
        onReveal: reveal,
      ),
      back: FlashcardBackSide(
        template: template,
        studyCard: studyCard,
        contentScale: contentScale,
      ),
    );
  }
}
